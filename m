Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab2HXHyb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 03:54:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50899 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab2HXHy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 03:54:28 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 24 Aug 2012 09:54:08 +0200
Message-ID: <CAKgNAkiKUkwj0s-D4n85CCkbPvjShV=ptK269jkdANpgbD9BnQ@mail.gmail.com>
Subject: man-pages-3.42 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.42.tar.gz - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.42

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2012/08/man-pages-342-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael

==================== Changes in man-pages-3.42 ====================


Changes to individual pages
---------------------------

ldd.1
    Michael Kerrisk
        Add security note on untrusted executables
            See also http://www.catonmat.net/blog/ldd-arbitrary-code-execution/
            and
            http://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html

clone.2
    Michael Kerrisk
        Rewrite discussion of sys_clone

ioprio_set.2
    Colin McCabe
        Clarify the multithreaded behavior of ioprio_set(2)
    Michael Kerrisk  [Марк Коренберг, Kalle Olavi Niemitalo]
        Document who==0 for IOPRIO_WHO_PROCESS and IOPRIO_WHO_PGRP
            For IOPRIO_WHO_PROCESS, who==0 means operate on the caller.
            For IOPRIO_WHO_PGRP, who==0 means operate on the caller's
            process group.

            See http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=652443

migrate_pages.2
    Michael Kerrisk  [Christoph Lameter, JoonSoo Kim]
        Fix description of return value

ptrace.2
    Denys Vlasenko
        Explain WNOHANG behavior and EINTR bug

capabilities.7
    Michael Kerrisk
        Document CAP_BLOCK_SUSPEND

socket.7
    Martin H
        Document SO_MARK socket option


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
