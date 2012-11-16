Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751495Ab2KPGXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 01:23:06 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37317 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2KPGXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 01:23:04 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 16 Nov 2012 07:22:43 +0100
Message-ID: <CAKgNAki0PdA4XPePEY0xwyGM8CSQg=4+LVbYgt9bD_n1yv3GPA@mail.gmail.com>
Subject: man-pages-3.44 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.44.tar.gz - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.44

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2012/11/man-pages-344-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.44 ====================


New and rewritten pages
-----------------------

delete_module.2
    Michael Kerrisk
        Rewrite to Linux 2.6+ reality

init_module.2
    Michael Kerrisk
        Rewrite to Linux 2.6+ reality

getauxval.3
    Michael Kerrisk
        Document getauxval() function added in glibc 2.16


Changes to individual pages
---------------------------

execve.2
    Michael Kerrisk
        Document treatment of PR_SET_PDEATHSIG on execve()
    Michael Kerrisk
        Document treatment of SECBIT_KEEP_CAPS securebits flag on execve()

fork.2
    Michael Kerrisk
        Note treatment of default timer slack value on fork()

link.2
    Michael Kerrisk
        Add EPERM error triggered by /proc/sys/fs/protected_hardlink

prctl.2
    Kees Cook
        update seccomp sections for mode 2 (BPF)
            This adds a short summary of the arguments used
            for "mode 2" (BPF) seccomp.
    Michael Kerrisk
        Small improvements to PR_SET_SECCOMP discussion
            Note type of 'arg3' for SECCOMP_MODE_FILTER.
            Add pointer to Documentation/prctl/seccomp_filter.txt.
    Michael Kerrisk
        Note 'seccomp' semantics with respect to fork(), execve(), and prctl()
    Michael Kerrisk
        Document PR_SET_TIMERSLACK and PR_GET_TIMERSLACK
    Kees Cook
        document PR_SET_NO_NEW_PRIVS, PR_GET_NO_NEW_PRIVS
            This adds a short description of the no_new_privs bit,
            as described in Documentation/prctl/no_new_privs.txt.

proc.5
    Michael Kerrisk
        Document /proc/meminfo
            Info mostly taken from Documentation/filesystems/proc.txt
            and Documentation/vm/hugetlbpage.txt.
    Michael Kerrisk
        Default for /proc/sys/fs/protected_{hardlinks,symlinks} is now 0
            The default setting of 1 in/proc/sys/fs/protected_hardlinks
            and /proc/sys/fs/protected_symlinks caused one too many
            breakages for Linus's taste, so commit 561ec64ae67e changed
            the default for both files to 0.
        Note system call error yielded by /proc/sys/fs/protected_symlinks
            Note that violating 'protected_symlinks' restrictions
            causes system calls to fail with the error EACCES.

ipv6.7
    Bert Hubert
        Document IPV6_RECVPKTINFO

time.7
    Michael Kerrisk
        Add a subsection on timer slack
