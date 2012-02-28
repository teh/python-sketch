from libc.stdint cimport uint32_t
import numpy as np
cimport numpy as np

ctypedef np.int_t DTYPE_t

cdef extern from *:
    cdef extern void c_hashlittle2 "hashlittle2" (void *key, size_t length, uint32_t *pc, uint32_t *pb)

def hashlittle2(char* key, int seed1, int seed2):
    cdef uint32_t pc = seed1
    cdef uint32_t pb = seed2
    c_hashlittle2(<void*>key, len(key), &pc, &pb)
    return pc, pb

cdef class Sketch:
    cdef int bitmask
    cdef readonly np.ndarray data
    cdef readonly np.ndarray seeds
    cdef readonly int num_buckets
    cdef readonly int num_hash

    cdef np.uint32_t* direct_data
    cdef np.uint32_t* direct_seeds
    cdef uint32_t uint32_max

    def __cinit__(self, int num_hash, int num_buckets):
        assert bin(num_buckets).count('1') == 1, "num_buckets needs to be a power of 2"
        self.num_buckets = num_buckets
        self.num_hash = num_hash
        self.bitmask = num_buckets - 1
        
        self.data = np.zeros((num_hash, num_buckets), dtype=np.uint32)
        ii = np.iinfo(np.uint32)
        self.seeds = np.random.randint(ii.min, ii.max, num_hash)
        self.uint32_max = ii.max

        assert self.data.flags['C_CONTIGUOUS'], "Invalid data format."
        self.direct_data = <np.uint32_t*>self.data.data
        assert self.seeds.flags['C_CONTIGUOUS'], "Invalid seed format."
        self.direct_seeds = <np.uint32_t*>self.seeds.data

    def update(self, char* key, int value):
        cdef int i
        cdef uint32_t pc
        cdef uint32_t pb
        cdef uint32_t minimum = self.uint32_max

        for i in range(self.num_hash):
            pc = self.direct_seeds[i]
            pb = self.direct_seeds[i]
            c_hashlittle2(<void*>key, len(key), &pc, &pb)

            pc = pc & self.bitmask
            
            self.direct_data[i * self.num_buckets + pc] += value
            if self.direct_data[i * self.num_buckets + pc] < minimum:
                minimum = self.direct_data[i * self.num_buckets + pc]
        return minimum
        
