Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab1JDR2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 13:28:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50066 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab1JDR2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 13:28:06 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 4 Oct 2011 19:27:45 +0200
Message-ID: <CAKgNAkgYsuwbZdR1T8Guc_nrTk17ROpeYqa2g2q2LRFFPNHGAw@mail.gmail.com>
Subject: man-pages-3.35 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.35.tar.gz - man pages for Linux.

For the moment, the release artifacts remain in different locations
than usual (and some of these changes may become permanent):

This release tarball is available for download at:

  http://man7.org/linux/man-pages/download/

The online changelog is available at
http://man7.org/linux/man-pages/changelog.html#release_3.35 (blogged at
http://linux-man-pages.blogspot.com/2011/10/man-pages-335-is-released.html
) and the current version of the pages is browsable at
http://man7.org/linux/man-pages/

A git repository for man-pages can be found on github. You can clone
the repository with the command:

  git clone https://github.com/mkerrisk/man-pages.git

A few changes in this release that may be of interest to readers of
this list are listed below.

Cheers,

Michael

==================== Changes in man-pages-3.35 ====================

Released: 2011-10-04, Munich


New and rewritten pages
-----------------------

recvmmsg.2
    Andi Kleen, Michael Kerrisk
        New man page for recvmmsg(2)

setns.2
    Eric W. Biederman
        New manual page for setns(2)
    Michael Kerrisk
        Various improvements


Changes to individual pages
---------------------------

sigwaitinfo.2
    Michael Kerrisk
        Note that attempts to wait for SIGKILL and SIGSTOP are silently ignored

stat.2
    Michael Kerrisk
        Note POSIX.1-2001 and POSIX.1-2008 requirements for lstat()

proc.5
    Eric W. Biederman
        Document /proc/[pid]/ns/

capabilities.7
    Michael Kerrisk
        List setns(2) as an operation allowed by CAP_SYS_ADMIN

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
