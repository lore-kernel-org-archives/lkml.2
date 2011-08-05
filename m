Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab1HEGiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 02:38:25 -0400
Received: from nm11.bullet.mail.bf1.yahoo.com ([98.139.212.170]:44609 "HELO
	nm11.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751644Ab1HEGiX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 02:38:23 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 903332.64313.bm@omp1041.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=IVPPR5nm8TzhcLI23y42NuJEYhHPfQFrx5oqrwb0ZP5RY+iFqWSXLgzYsMIX4WAkMD2yQ+6/SMkrjI1f4G0DWk7ofXkjbQ+2AA7tYa64IkrhogMIP9zIJcAratJTmx3j/pudy6kmEGvGWq4ycFFEIMFMZA3o7WqcSmMXZewqo6g=;
X-YMail-OSG: 0nnx540VM1mNGq6Xb7wcZJldGXGNOGxa4hrwaN59xzgCUMr
 gHoTWvKGTvUgzWoN1DTtWakRgn5lbqaR1t.EjUTr3xGVhwFqeiX4BaGM99mw
 FyjnyNzMF_pnfOnWIA8NcTeUyekmAerA23ty0t1Xk_u1AlQltxxQSnSF3kwO
 M3TT5zCxMF_sghHD6DOTh2j1k3dEYHFfzqunWzdaXIC0SUZhHUzrfYK.iTRs
 GY64yUYF6xQEwlTyTT.totkcoU8LBbvUB3Q7SGpS.SOLxD8IVMLLNPaamUBo
 o.cKk.5jJE4JtYwitPbgbK6zEn9WNsNmJdbZDFcLU6Y_u9FUBO3OigpPwfLq
 1FZj4.ia5ar4LrtNfYm_rPwnsFDwV78gJYwvAwV9L2VcnaligJidEtehziYs
 7ITN.hoW4FcCbEJPXnKpgM9v.YD2Oit3EyJNx3aiOmPVsWiTU2IXdgqYSSf8
 D9OyYMGDHIMs8TI2ZlGwaYrfk9TXxNjE7EnDjdAq4bE9K3V7klG7fvUW6fSy
 p0bhfYnRUDzEQOCFFfj2oUosamcORHNT7pTVKwNoOhN3nxPh98Z37is_mz9Z
 UNW9J8TY4grxU8sIeXLIg5mohLQnNgGRQQzGlSeX6xPlWYgq9yJA_s05plgG
 pa838LYwdFg4Re2srORV7iA3I.62X8JLF6fk6RRcr6AO2wQFSPCiTLUyGCVg
 5Iv7f1ZsaTyhpfeacMQe_VbYzIWDduAk9P_pCAAYbrZ9jKUq0nbhyRrC8fvw
 1irU5CWLGycFB4Y4avr8iZTjEQ6z9WsWuCUfU3pX4FWKbMU5TcnvuttqT.2f
 9QgvwXnTxR7vkXipi.ujUe_HdAQubmrvGnuxtgPPgy7rtZ4RNdbiCfhT5wnF
 W7NpHZkIyPIShQ93EnZMVMMKi1ku.B0paeIBg_DEip5HZAl6v4zGEUBsHmxB
 wbO0VTU5qAjNGiSTu3QHNZBw09t.dd6GH35JL4JQ-
X-Mailer: YahooMailWebService/0.8.113.313619
References: <20110804143844.GQ19099@suse.de>
Message-ID: <1312526302.37390.YahooMailNeo@web162009.mail.bf1.yahoo.com>
Date: Thu, 4 Aug 2011 23:38:22 -0700 (PDT)
From: Pintu Agarwal <pintu_agarwal@yahoo.com>
Reply-To: Pintu Agarwal <pintu_agarwal@yahoo.com>
Subject: Re: MMTests 0.01
To: Mel Gorman <mgorman@suse.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110804143844.GQ19099@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mel Gorman,
 
Thank you very much for this MMTest. 
It will be very helpful for me for all my needs.
I was looking forward for these kind of mm test utilities.
 
Just wanted to know, if any of these utilities also covers anti-fragmentation represent of the various page state in the form of jpeg image?
I am specifically looking for this one.
 
 
 
Thanks,
Pintu Kumar
 
 
From: Mel Gorman <mgorman@suse.de>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Sent: Thursday, 4 August 2011 8:08 PM
Subject: MMTests 0.01

At LSF/MM at some point a request was made that a series of tests be
identified that were of interest to MM developers and that could be
used for testing the Linux memory management subsystem. At the time,
I was occasionally posting tarballs of whatever scripts I happened to
be using at the time but they were not generally usable and tended to
be specific to a set of patches. I promised I would produce something
usable by others but never got around to it. Over the last four months,
I needed a better framework when testing against both distribution
kernels and mainline so without further ado

http://www.csn.ul.ie/~mel/projects/mmtests/
http://www.csn.ul.ie/~mel/projects/mmtests/mmtests-0.01-mmtests-0.01.tar.gz

I am not claiming that this is comprehensive in any way but it is
almost always what I start with when testing patch sets. In preparation
for identifying problems with backports, I also ran a series of tests
against mainline kernels over the course of two months when machines
were otherwise idle. I have not actually had a chance to go through
all the results and identify each problem but I needed to have the
raw data available for my own reference so might as well share.

http://www.csn.ul.ie/~mel/projects/mmtests/results/SLES11sp1/
http://www.csn.ul.ie/~mel/projects/mmtests/results/openSUSE11.4/

The directories refer to the distribution used but not the
kernel which is downloaded from kernel.org. Directory structure is
distro/config/machine/comparison.html. For example a set of benchmarks
used for evaluating the page and slab allocators on a test machine
called "hydra" is located at

http://www.csn.ul.ie/~mel/projects/mmtests/results/SLES11sp1/global-dhp__pagealloc-performance/hydra/comparison.html

I know the report structure looks crude but I was not interested
in making them pretty. Due to the fact that some of the scripts
are extremely old, the quality and coding styles vary considerably.
This may get cleaned up over time but in the meantime, try and keep
the contents of your stomach down if you are reading the scripts.

The documentation is not great and so some of the capabilities such
as being able to reconfigure swap for a benchmark is not mentioned.
For my own series, I'll relase the mmtests tarball I used if asked.
If someone wants to use the tarball for their own testing but cannot
configure it, complain on the linux-mm list and if I can, I'll offer
suggestions.

==== MMTests README ====

MMTests is a configurable test suite that runs a number of common
workloads of interest to MM developers. Ideally this would have been
to integrated with LTP, xfstests or Phoronix Test or implemented
with autotest.  Unfortunately, large portions of these tests are
cobbled together over a number of years with varying degrees of
quality before decent test frameworks were common.  The refactoring
effort to integrate with another framework is significant.

Organisation
============

The top-level directory has a single driver script called
run-mmtests.sh which reads a config file that describes how the
benchmarks should be run, configures the system and runs the requested
tests. config also has some per-test configuration items that can be
set depending on the test. The driver script takes the name of the
test as a parameter. Generally, this would be a symbolic name naming
the kernel being tested.

Each test is driven by a run-single-test.sh script which reads
the relevant driver-TESTNAME.sh script. High level items such as
profiling are configured from the top-level script while the driver
scripts typically convert the config parameters into switches for a
"shellpack". A shellpack is a pair of benchmark and install scripts
that are all stored in shellpacks/ .

Monitors can be optionally configured. A full list is in monitors/
. Care should be taken with monitors as there is a possibility that
they introduce overhead of their own.  Hence, for some performance
sensitive tests it is preferable to have no monitoring.

Many of the tests download external benchmarks. An attempt will be
made to download from a mirror . To get an idea where the mirror
should be located, grep for MIRROR_LOCATION= in shellpacks/.

A basic invocation of the suite is

<pre>
$ cp config-global-dhp__pagealloc-performance config
$ ./run-mmtests.sh --no-monitor 3.0-nomonitor
$ ./run-mmtests.sh --run-monitor 3.0-runmonitor
</pre>

Configuration
=============

The config file used is always called "config". A number of other
sample configuration files are provided that have a given theme. Some
important points of variability are;

MMTESTS is a list of what tests will be run

WEBROOT is the location where a number of tarballs are mirrored. For example,
    kernbench tries to download
    $WEBROOT/kernbench/linux-2.6.30.tar.gz . If this is not available,
    it is downloaded from the internet. This can add delays in testing
    and consumes bandwidth so is worth configuring.

LINUX_GIT is the location of a git repo of the kernel. At the moment it's only
    used during report generation

SKIP_*PROFILE
    These parameters determine what profiling runs are done. Even with
    profiling enabled, a non-profile run can be used to ensure that
    the profile and non-profile runs are comparable.

SWAP_CONFIGURATION
SWAP_PARTITIONS
SWAP_SWAPFILE_SIZEMB
    It's possible to use a different swap configuration than what is
    provided by default.

TESTDISK_RAID_PARTITIONS
TESTDISK_RAID_DEVICE
TESTDISK_RAID_OFFSET
TESTDISK_RAID_SIZE
TESTDISK_RAID_TYPE
    If the target machine has partitions suitable for configuring RAID,
    they can be specified here. This RAID partition is then used for
    all the tests

TESTDISK_PARTITION
    Use this partition for all tests

TESTDISK_FILESYSTEM
TESTDISK_MKFS_PARAM
TESTDISK_MOUNT_ARGS
    The filesystem, mkfs parameters and mount arguments for the test
    partitions

Available tests
===============

Note the ones that are marked untested. These have been ported from other
test suites but no guarantee they actually work correctly here. If you want
to run these tests and run into a problem, report a bug.

kernbench
    Builds a kernel 5 times recording the time taken to completion.
    An average time is stored. This is sensitive to the overall
    performance of the system as it hits a number of subsystems.

multibuild
    Similar to kernbench except it runs a number of kernel compiles
    in parallel. Can be useful for stressing the system and seeing
    how well it deals with simple fork-based parallelism.

aim9
    Runs a short version of aim9 by default. Each test runs for 60
    seconds. This is a micro-benchmark of a number of VM operations. It's
    sensitive to changes in the allocator paths for example.

vmr-stream
    Runs the STREAM benchmark a number of times for varying sizes. An
    average is recorded. This can be used to measure approximate memory
    throughput or the average cost of a number of basic operations. It is
    sensitive to cache layout used for page faults.

vmr-cacheeffects (untested)
    Performs linear and random walks on nodes of different sizes stored in
    a large amount of memory. Sensitive to cache footprint and layout.

vmr-createdelete (untested)
    A micro-benchmark that measures the time taken to create and delete
    file or anonymous mappings of increasing sizes. Sensitive to changes
    in the page fault path performance.

iozone
    A basic filesystem benchmark.

fsmark
    This tests write workloads varying the number of files and directory
    depth.

hackbench-*
    Hackbench is generally a scheduler benchmark but is also sensitive to
    overhead in the allocators and to a lesser extent the fault paths.
    Can be run for either sockets or pipes.

largecopy
    This is a simple single-threaded benchmark that downloads a large
    tar file, expands it a number of times, creates a new tar and
    expands it again. Each operation is timed and is aimed at shaking
    out stall-related bugs when copying large amounts of data

largedd
    Similar to largecopy except it uses dd instead of cp.

libreofficebuild
    This downloads and builds libreoffice. It is a more aggressive
    compile-orientated test. This is a very download-intensive
    benchmark and was only created as a reproduction case for
    a bug.

nas-*
    The NAS Parallel Benchmarks for the serial and openmp versions of
    the test.

netperf-*
    Runs the netperf benchmark for *_STREAM on the local machine.
    Sensitive to cache usage and allocator costs. To test for cache line
    bouncing, the test can be configured to bind to certain processors.

postmark
    Run the postmark benchmark. Optionally a program can be run in
    the background that consumes anonymous memory. The background
    program is vary rarely needed except when trying to identify
    desktop stalls during heavy IO.

speccpu (untested)
    SPECcpu, what else can be said. A restriction is that you must have
    a mirrored copy of the tarball as it is not publicly available.

specjvm (untested)
    SPECjvm. Same story as speccpu

specomp (untested)
    SPEComp. Same story as speccpu

sysbench
    Runs the complex workload for sysbench backed by postgres. Running
    this test requires a significant build environment on the test
    machine. It can run either read-only or read/write tests.

simple-writeback
    This is a simple writeback test based on dd. It's meant to be
    easy to understand and quick to run. Useful for measuring page
    writeback changes.

ltp (untested)
    The LTP benchmark. What it is testing depends on exactly which of the
    suite is configured to run.

ltp-pounder (untested)
    ltp pounder is a non-default test that exists in LTP. It's used by
    IBM for hardware certification to hammer a machine for a configured
    number of hours. Typically, they expect it to run for 72 hours
    without major errors.  Useful for testing general VM stability in
    high-pressure low-memory situations.

stress-highalloc
    This test requires that the system not have too much memory and
    that systemtap is available. Typically, it's tested with 3GB of
    RAM. It builds a number of kernels in parallel such that total
    memory usage is 1.5 times physical memory. When this is running
    for 5 minutes, it tries to allocate a large percentage of memory
    (e.g. 95%) as huge pages recording the latency of each operation as it
    goes. It does this twice. It then cancels the kernel compiles, cleans
    the system and tries to allocate huge pages at rest again. It's a
    basic test for fragmentation avoidance and the performance of huge
    page allocation.

xfstests (untested)
    This is still at prototype level and aimed at running testcase 180
    initially to reproduce some figures provided by the filesystems people.

Reporting
=========

For reporting, there is a basic compare-kernels.sh script. It must be updated
with a list of kernels you want to compare and in what order. It generates a
table for each test, operation and kernel showing the relative performance
of each. The test reporting scripts are in subreports/. compare-kernel.sh
should be run from the path storing the test logs. By default this is
work/log. If you are automating tests from an external source, work/log is
what you should be capturing after a set of tests complete.

If monitors are configured such as ftrace, there are additional
processing scripts. They can be activated by setting FTRACE_ANALYSERS in
compare-kernels.sh. A basic post-process script is mmtests-duration which
simply reports how long an individual test took and what its CPU usage was.

There are a limited number of graphing scripts included in report/

TODO
====

o Add option to test on filesystem loopback device stored on tmpfs
o Add volanomark
o Create config-* set suitable for testing scheduler to isolate situations
  where the scheduler was the main cause of a regression

-- 
Mel Gorman
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>    
