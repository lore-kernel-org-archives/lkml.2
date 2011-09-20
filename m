Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1ITKtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 06:49:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60519 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602Ab1ITKti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 06:49:38 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 20 Sep 2011 12:49:18 +0200
Message-ID: <CAKgNAkiQ9SPaqcA3F=cQpfLucdvOyzM-5N2W3jWkbQmXzHfZxw@mail.gmail.com>
Subject: man-pages-3.33 is released
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gidday,

I've released man-pages-3.33.tar.gz - man pages for Linux

Because of the kernel.org problems, the release artifacts are in
different locations than usual (and some of these changes may become
permanent):

This release tarball is available for download at:

    http://man7.org/linux/man-pages/download/man-pages-3.33.tar.gz

The online changelog is available at
http://man7.org/linux/man-pages/changelog.html#release_3.33 (blogged at
http://linux-man-pages.blogspot.com/2011/09/man-pages-333-is-released.html
) and the current version of the pages is browsable at
http://man7.org/linux/man-pages/

A git repository for man-pages can be found on github. You can clone
the repository with the command:

    git clone git@github.com:mkerrisk/man-pages.git

A few changes in this release that may be of interest to readers of this
list are listed below.

Cheers,

Michael


==================== Changes in man-pages-3.33 ====================

Newly documented interfaces in existing pages
---------------------------------------------

sync.2
    Michael Kerrisk
        Added new syncfs() system call
            syncfs() was added in Linux 2.6.39.


Changes to individual pages
---------------------------

clone.2
    Michael Kerrisk
        Note that CLONE_STOPPED was removed in 2.6.38

sendfile.2
    Akira Fujita
        Since 2.6.33, 'out_fd' can refer to any file type
            Linux kernel commit cc56f7de7f00d188c7c4da1e9861581853b9e92f
            meant sendfile(2) can work with any output file.

syslog.2
    Michael Kerrisk  [Serge E. Hallyn]
        Update for kernel 2.6.37 changes
            Document /proc/sys/kernel/dmesg_restrict.
            Document CAP_SYSLOG.

capabilities.7
    Michael Kerrisk  [Serge E. Hallyn]
        Document CAP_SYSLOG and related changes in Linux 2.6.37
    Michael Kerrisk
        File capabilities are no longer optional
            Starting with Linux 2.6.33, the CONFIG_SECURITY_FILE_CAPABILITIES
            has been removed, and file capabilities are always part of the
            kernel.



-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
