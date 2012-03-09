Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456Ab2CIR2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:28:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43400 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab2CIR2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:28:13 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sat, 10 Mar 2012 06:27:53 +1300
Message-ID: <CAKgNAkhiHKHSJofXNjCx-NTajzZ5L5Ak_y3YereSJn8dwE=npA@mail.gmail.com>
Subject: man-pages-3.37 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.37.tar.gz - man pages for Linux.

Now that I've sorted out kernel.org access, many of the release
artifacts are in the traditional locations, but there are a few
changes that are likely permanent as well. Details below.

Tarball download:
   http://www.kernel.org/pub/linux/docs/man-pages/
Git repository:
   http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
   http://man7.org/linux/man-pages/changelog.html#release_3.37

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2012/03/man-pages-337-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.37 ====================

New and rewritten pages
-----------------------

getent.1
    Mark R. Bannister
        New page to document 'getent' binary provided by glibc


Changes to individual pages
---------------------------

bdflush.2
    Michael Kerrisk
        Note that bdflush() is deprecated, and does nothing

nfsservctl.2
    Michael Kerrisk
        Note that this system call was removed in Linux 3.1

ptrace.2
    Denys Vlasenko  [Oleg Nesterov, Tejun Heo]
        add extended description of various ptrace quirks
            Changes include:

            s/parent/tracer/g, s/child/tracee/g - ptrace interface now
            is sufficiently cleaned up to not treat tracing process
            as parent.

            Deleted several outright false statements:
            - pid 1 can be traced
            - tracer is not shown as parent in ps output
            - PTRACE_ATTACH is not "the same behavior as if tracee had done
              a PTRACE_TRACEME": PTRACE_ATTACH delivers a SIGSTOP.
            - SIGSTOP _can_ be injected.
            - Removed mentions of SunOS and Solaris as irrelevant.
            - Added a few more known bugs.

            Added a large block of text in DESCRIPTION which doesn't focus
            on mechanical description of each flag and operation, but rather
            tries to describe a bigger picture. The targeted audience is
            a person which is reasonably knowledgeable in Unix but did not
            spend years working with ptrace, and thus may be unaware of its
            quirks. This text went through several iterations of review by
            Oleg Nesterov and Tejun Heo.
            This block of text intentionally uses as little markup as possible,
            otherwise future modifications to it will be very hard to make.
    Michael Kerrisk
        Global clean-up of page
            * Wording and formatting fixes to existing text and
              Denys Vlasenko's new text.
            * Various technical amendments and improvements to
              Denys Vlasenko's new text.
            * Added FIXME for various problems with the current text.
    Michael Kerrisk
        Integrated changes after further review from Denys Vlasenko

syscalls.2
    Michael Kerrisk
        Note that nfsservctl(2) was removed in Linux 3.1
        Note that bdflush(2) is deprecated

capabilities.7
    Michael Kerrisk
        Add CAP_WAKE_ALARM
    Michael Kerrisk
        Add various operations under CAP_SYS_ADMIN
        Add perf_event_open(2) to CAP_SYS_ADMIN
        Add VM86_REQUEST_IRQ vm86(2) command to CAP_SYS_ADMIN
        Update CAP_NET_ADMIN with notes from include/linux/capability.h
        Add nfsservctl(2) to CAP_SYS_ADMIN
    Michael Kerrisk
        Add ioctl(FIBMAP) under CAP_SYS_RAWIO
    Michael Kerrisk
        Add virtual terminal ioctl()s under CAP_SYS_TTY_CONFIG
    Michael Kerrisk
        Update CAP_NET_RAW with notes from include/linux/capability.h
    Michael Kerrisk
        Add F_SETPIPE_SZ case to CAP_SYS_RESOURCE
        Add POSIX messages queues queues_max case to CAP_SYS_RESOURCE
        Update CAP_SYS_RESOURCE with notes from include/linux/capability.h
    Michael Kerrisk
        SEE ALSO: Add libcap(3)

ld.so.8
    Michael Kerrisk
        Add --audit command-line option


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
