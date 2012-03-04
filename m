Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab2CDJvU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 04:51:20 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44105 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2CDJvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 04:51:18 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mtk.manpages@gmail.com designates 10.50.207.99 as permitted sender) smtp.mail=mtk.manpages@gmail.com; dkim=pass header.i=mtk.manpages@gmail.com
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sun, 4 Mar 2012 22:50:58 +1300
Message-ID: <CAKgNAki1w3d_CXsF6ZXxKFGnjp3SgyaFDLgFBBOzZUf31wsNkw@mail.gmail.com>
Subject: man-pages-3.36 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.36.tar.gz - man pages for Linux.

Now that I've sorted out kernel.org access, many of the release
artifacts are in the traditional locations, but there are a few
changes that are likely permanent as well. Details below.

Tarball download:
    http://www.kernel.org/pub/linux/docs/man-pages/
Git repository:
    http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.36

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2012/03/man-pages-336-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.36 ====================

New and rewritten pages
-----------------------

sendmmsg.2
    Michael Kerrisk  [Stephan Mueller]
        New page for sendmmsg(2)
            Some pieces inspired by an initial attempt by Stephan Mueller.


Newly documented interfaces in existing pages
---------------------------------------------

fallocate.2
    Lucian Adrian Grijincu
        Document FALLOC_FL_PUNCH_HOLE
            FALLOC_FL_PUNCH_HOLE was added in Linux 2.6.38,
            for punching holes in the allocated space in a file.


Changes to individual pages
---------------------------

fsync.2
    Christoph Hellwig
        Various improvements
            - explain the situation with disk caches better
            - remove the duplicate fdatasync() explanation in the NOTES
              section
            - remove an incorrect note about fsync() generally requiring two
              writes
            - remove an obsolete ext2 example note
            - fsync() works on any file descriptor (doesn't need to be
              writable); correct the EBADF error code explanation

sched_rr_get_interval.2
    Clemens Ladisch
        Update notes on modifying quantum
            Since Linux 2.6.24, it is no longer possible to
            modify the SCHED_RR quantum using setpriority(2).
            (Slight edits to Clemens' patch by mtk.)

vfork.2
    Michael Kerrisk  [starlight@binnacle.cx]
        Clarify what is duplicated in the child
            Add some words to make it clear to the reader that vfork(),
            like fork(), creates duplicates of process attributes
            in the child.
    Michae Kerrisk
        Note clone() flags equivalent to vfork()
        Add some notes on reasons why vfork() still exists
        Clarify that calling *thread* is suspended during vfork()
        CONFORMING TO: Note that POSIX.1-2001 marked vfork() obsolete

core.5
    Michael Kerrisk  [Junjiro Okajima]
        Document %E specifier for core_pattern

feature_test_macros.7
    Michael Kerrisk
        Document _ISOC11_SOURCE

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
