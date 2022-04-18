# Copyright (c) 2016 - 2021 Advanced Micro Devices, Inc. All Rights Reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


ROCM_PATH?= $(wildcard /opt/rocm/)
HIP_PATH?= $(wildcard $(ROCM_PATH)/hip)
ifeq (,$(HIP_PATH))
	USE_HIP=false
	CXX=nvcc
else
	USE_HIP=true
	HIP_PLATFORM=$(shell $(HIP_PATH)/bin/hipconfig --platform)
	HIPCC=$(HIP_PATH)/bin/hipcc
	CXX=$(HIPCC)
endif

ifeq (${USE_HIP}, false)
	SOURCES=square.cu
else ifeq (${HIP_PLATFORM}, nvidia)
	SOURCES=square.cu
else
	SOURCES=square.cpp
endif

all: square.out

# Step
square.cpp: square.cu
	$(HIP_PATH)/bin/hipify-perl square.cu > square.cpp

square.out: $(SOURCES)
	$(CXX) $(CXXFLAGS) $(SOURCES) -o $@

clean:
	rm -f *.o *.out square.cpp
