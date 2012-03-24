Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab2CXQzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 12:55:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43836 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab2CXQzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 12:55:53 -0400
MIME-Version: 1.0
Date: Sun, 25 Mar 2012 00:55:53 +0800
Message-ID: <CAN628AH-h=G3e7U8-Tmcok0dtAQd1+GBfvTP72ecB5J17vuXcg@mail.gmail.com>
Subject: [PATCH] Add VMUFAT file system support (v2)
From: Adrian McMenamin <lkmladrian@gmail.com>
To: viro@zeniv.linux.org.uk, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Cc: Linux-sh <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sega Dreamcasts come with a "visual memory unit" (VMU) with 128KB of
flash memory in a FAT type filesystem. This patch adds support for
this filesystem to the Linux kernel.

Signed-off-by: Adrian McMenamin <adrianmcmenamin@gmail.com>
---

 Documentation/filesystems/vmufat.txt |   83 ++++
 fs/Kconfig                           |    1 +
 fs/Makefile                          |    1 +
 fs/vmufat/Kconfig                    |   14 +
 fs/vmufat/Makefile                   |    7 +
 fs/vmufat/inode.c                    |  903 ++++++++++++++++++++++++++++++++++
 fs/vmufat/super.c                    |  522 ++++++++++++++++++++
 fs/vmufat/vmufat.h                   |  115 +++++
 include/linux/magic.h                |    1 +
 9 files changed, 1647 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/filesystems/vmufat.txt
 create mode 100644 fs/vmufat/Kconfig
 create mode 100644 fs/vmufat/Makefile
 create mode 100644 fs/vmufat/inode.c
 create mode 100644 fs/vmufat/super.c
 create mode 100644 fs/vmufat/vmufat.h


Patch may be pulled/reviewed at:

https://github.com/mcmenaminadrian/vmufat/commit/47305b24487ce6d6d9264bddf2ccf75e5123c1b1
