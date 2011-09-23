Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1IWIQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 04:16:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55976 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab1IWIQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 04:16:57 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Fri, 23 Sep 2011 10:16:36 +0200
Message-ID: <CAKgNAkhR+Httt=S42UEV9TVt6ztcENqSu8fRFZgDjAcy+JynnQ@mail.gmail.com>
Subject: man-pages-3.34 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.34.tar.gz - man pages for Linux

Because of the kernel.org problems, the release artifacts are in
different locations than usual (and some of these changes may become
permanent):

This release tarball is available for download at:

   http://man7.org/linux/man-pages/download/

The online changelog is available at
http://man7.org/linux/man-pages/changelog.html#release_3.34 (blogged at
http://linux-man-pages.blogspot.com/2011/09/man-pages-334-is-released.html
) and the current version of the pages is browsable at
http://man7.org/linux/man-pages/

A git repository for man-pages can be found on github. You can clone
the repository with the command:

   git clone https://github.com/mkerrisk/man-pages.git

A few changes in this release that may be of interest to readers of this
list are listed below.

Cheers,

Michael

==================== Changes in man-pages-3.34 ====================

Released: 2011-09-23, Munich


New and rewritten pages
-----------------------

rt_sigqueueinfo.2
    Michael Kerrisk  [Stephan Mueller]
        New page for rt_sigqueueinfo(2) and rt_tgsigqueueinfo(2)
            This replaces the previous '.so' man page link file for
            rt_sigqueueinfo.2, which linked to this sigqueue() man page.

cciss.4
    Stephen M. Cameron
        New man page for cciss driver
            I obtained the information in this man page as a consequence
            of having worked on the cciss driver for the past several years,
            and having written considerable portions of it.
    Michael Kerrisk
        Copyedit by mtk

hpsa.4
    Stephen M. Cameron
        New man page for the hpsa driver
            I obtained the information in this man page as a consequence
            of being the main author of the hpsa driver.
    Michael Kerrisk
        Copyedits my mtk


Newly documented interfaces in existing pages
---------------------------------------------

fstatat.2
    Michael Kerrisk  [David Howells]
        Document AT_NO_AUTOMOUNT
	    This flag was added in Linux 2.6.38.

lseek.2
    Michael Kerrisk  [Eric Blake, Sunil Mushran]
        Document SEEK_HOLE and SEEK_DATA
            These flags, designed for discovering holes in a file,
            were added in Linux 3.1. Included comments from Eric
            Blake and Sunil Mushran.

madvise.2
    Doug Goldstein
        Add MADV_HUGEPAGE and MADV_NOHUGEPAGE
            Document the MADV_HUGEPAGE and MADV_NOHUGEPAGE flags added to
            madvise() in Linux 2.6.38.


Changes to individual pages
---------------------------

prctl.2
    Paul Pluzhnikov
        PR_SET_DUMPABLE makes process non-ptrace-attachable

readlink.2
    Guillem Jover
        Document using st_size to allocate the buffer

sched_setscheduler.2
    Michael Kerrisk
        Document 2.6.39 changes to rules governing changes from
SCHED_IDLE policy
            Since Linux 2.6.39, unprivileged processes under the
            SCHED_IDLE policy can switch to another nonrealtime
            policy if their nice value falls within the range
            permitted by their RLIMIT_NICE limit.

sigqueue.3
    Michael Kerrisk
        Move this page to section 3
            Now that the underlying system call rt_sigqueueinfo(2) is
            properly documented, move sigqueue() to Section 3, since
            it is really a library function.

feature_test_macros.7
    Michael Kerrisk
        Document _ISOC95_SOURCE
            _ISOC95_SOURCE was added in glibc 2.12 as a means
            to expose C90 Amendment 1 definitions.

ip.7
    Benjamin Poirier  [Neil Horman]
        Improve description of IP_MTU_DISCOVER


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
