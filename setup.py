from setuptools import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(
    name='sketch',
    version='0.1',
    license='BSD',
    author='Thomas Huger',
    author_email='tehunger@gmail.com',
    description='Tools to build statistical sketches.',
    packages=['sketch'],

    cmdclass={'build_ext': build_ext},
    ext_modules=[Extension("_sketch", ['sketch/lookup3.c', 'sketch/sketch.pyx'])],
)
