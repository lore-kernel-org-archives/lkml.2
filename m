Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760977Ab2DKTeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:34:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64596 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab2DKTeW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:34:22 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Thu, 12 Apr 2012 07:34:01 +1200
Message-ID: <CAKgNAki8ftSyd8CwDNXxujQzvTYUUvaaBaxFzQJ7DLriFdeV3A@mail.gmail.com>
Subject: man-pages-3.38 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.38.tar.gz - man pages for Linux.

Tarball download:
    http://www.kernel.org/doc/man-pages/download.html
Git repository:
    http://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
Online changelog:
    http://man7.org/linux/man-pages/changelog.html#release_3.38

A short summary of the release is blogged at:
http://linux-man-pages.blogspot.com/2012/03/man-pages-338-is-released.html

The current version of the pages is browsable at:
http://man7.org/linux/man-pages/

A few changes in this release that may be of interest to readers of
this list are given below.

Cheers,

Michael


==================== Changes in man-pages-3.38 ====================

New and rewritten pages
-----------------------

get_nprocs_conf.3
    Beňas Petr
        New page documenting get_nprocs_conf(3) and get_nprocs(3)

malloc_get_state.3
    Michael Kerrisk
        New page documenting malloc_get_state(3) and malloc_set_state(3)

mallopt.3
    Michael Kerrisk
        New man page for mallopt(3)

mtrace.3
    Michael Kerrisk
        Complete rewrite of page, adding much more detail

scandirat.3
    Mark R Bannister
        New page for scandirat(3) (new in glibc 2.15)


Changes to individual pages
---------------------------

malloc.3
    Michael Kerrisk
        NOTES: Add a short discussion of arenas

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
