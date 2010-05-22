Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab0EVSWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 14:22:13 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:33908 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077Ab0EVSWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 14:22:09 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] fatfs-2.6 patches
Date: Sun, 23 May 2010 03:22:04 +0900
Message-ID: <87fx1jbxv7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git master

to get these changes:

Andy Shevchenko (1):
      fat: use pack_hex_byte() instead of custom one

Arnd Bergmann (1):
      fat: convert to unlocked_ioctl

OGAWA Hirofumi (1):
      fat: Cleanup nls_unload() usage

 fs/fat/dir.c   |   28 ++++++++++++----------------
 fs/fat/fat.h   |    4 ++--
 fs/fat/file.c  |   19 ++++++++++++++++---
 fs/fat/inode.c |    6 ++----
 4 files changed, 32 insertions(+), 25 deletions(-)

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
