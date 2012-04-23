Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab2DWTkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 15:40:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49801 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754199Ab2DWTkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 15:40:37 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 24 Apr 2012 07:40:16 +1200
Message-ID: <CAKgNAkjJ2Uk6QcwBJG=44VEYXh1FfZbpuYnTOA2q4+fchZDk-A@mail.gmail.com>
Subject: man-pages-3.39 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.39.tar.gz - man pages for Linux.

Tarball download:
   http://www.kernel.org/doc/man-pages/download.html
Git repository:
   http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
   http://man7.org/linux/man-pages/changelog.html#release_3.39

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2012/04/man-pages-339-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.39 ====================

New and rewritten pages
-----------------------

malloc_trim.3
    Michael Kerrisk
        New man page for malloc_trim(3)

malloc_usable_size.3
    Michael Kerrisk
        New man page for malloc_usable_size(3)


Newly documented interfaces in existing pages
---------------------------------------------

prctl.2
    Cyrill Gorcunov
        Document PR_SET_MM (new in Linux 3.3)


Changes to individual pages
---------------------------

epoll_wait.2
    Michael Kerrisk  [Armin Rigo]
        Another thread can add to epoll instance while epoll_wait is blocked
            See https://bugzilla.kernel.org/show_bug.cgi?id=43072
    Michael Kerrisk
        Clarify that epoll_pwait() blocks calling *thread*

fchmodat.2
    Michael Kerrisk  [Mike Frysinger]
        Note difference between glibc wrapper and underlying system call
            The wrapper function has a 'flags' argument (which currently
            serves no purpose), while the underlying system call does not.

fcntl.2
    Abhijith Das
        Explain behaviour of F_GETLEASE during lease break

poll.2
    Michael Kerrisk  [Michael Welsh Duggan]
        Document negative value in 'fd' field
    Michael Kerrisk
        Document semantics of passing zero in 'events' field

capabilities.7
    Michael Kerrisk
        Add prctl(PR_SET_MM) to CAP_SYS_RESOURCE

netlink.7
    Jeff Mahoney  [Petr Gajdos]
        Note cases where nonprivileged users can use netlink multicast groups
            See also https://bugzilla.novell.com/show_bug.cgi?id=754611

ld.so.8
    Jonathan Nieder  [Reuben Thomas]
        Document effect of hwcaps on search path
            Wording by Aurelien Jarno from Debian glibc's r4701 (2011-06-04).

            Addresses http://bugs.debian.org/622385


--
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
