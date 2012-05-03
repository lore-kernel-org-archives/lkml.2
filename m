Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2ECHPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 03:15:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47826 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab2ECHPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 03:15:36 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 3 May 2012 19:15:14 +1200
Message-ID: <CAKgNAki3kPS1ND5xjT8eN6Ej7mMieJXHMDXAdgzbn=yVPwB=1A@mail.gmail.com>
Subject: man-pages-3.40 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.40.tar.gz - man pages for Linux.

Tarball download:
  http://www.kernel.org/doc/man-pages/download.html
Git repository:
  http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
  http://man7.org/linux/man-pages/changelog.html#release_3.40

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2012/05/man-pages-340-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.40 ====================

New and rewritten pages
-----------------------

process_vm_readv.2
    Mike Frysinger, Christopher Yeoh, Michael Kerrisk
        New page for process_vm_readv(2) and process_vm_writev(2)

mcheck.3
    Michael Kerrisk
        New man page for mcheck(3) and related functions
            Also describes mcheck_check_all(3), mcheck_pedantic(3),
            and mprobe(3)


Changes to individual pages
---------------------------

clock_getres.2
    Michael Kerrisk
        Clarify difference between CLOCK_MONOTONIC and CLOCK_MONOTONIC_RAW
            Note interactions of these two clocks with discontinuous
            adjustments to the system time and NTP/adjtime(2).

gettimeofday.2
    Michael Kerrisk
        gettimeofday() is affected by discontinuous jumps in the system time
            Advise reader to use clock_gettime(2), if they need a
            monotonically increasing time source.

prctl.2
    Michael Kerrisk
        Add PR_TASK_PERF_EVENTS_DISABLE and PR_TASK_PERF_EVENTS_ENABLE
            Add some basic documentation of these operations, with a pointer to
            tools/perf/design.txt for more information.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
