Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab1EXBJc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:09:32 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:46563 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757834Ab1EXBJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:09:29 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] fatfs-2.6 patches
Date: Tue, 24 May 2011 10:09:24 +0900
Message-ID: <871uzolxa3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Those are cleanup and fixes patches.

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git master

to get these changes:

Alexey Fisher (3):
      fat: Convert fat_fs_error to use %pV
      fat: Add fat_msg() function for preformated FAT messages
      fat: Replace all printk with fat_msg()

OGAWA Hirofumi (3):
      fat: use new setup() for ->dir_ops too
      fat: Fix possible null deref in fat_cache_add()
      fat: Fix statfs->f_namelen

 fs/fat/cache.c       |    7 +++++
 fs/fat/dir.c         |   32 +++++++++++----------
 fs/fat/fat.h         |   15 +++++-----
 fs/fat/fatent.c      |    4 +-
 fs/fat/inode.c       |   74 ++++++++++++++++++++++++-------------------------
 fs/fat/misc.c        |   44 ++++++++++++++++++++---------
 fs/fat/namei_msdos.c |    4 +-
 fs/fat/namei_vfat.c  |    4 +-
 8 files changed, 104 insertions(+), 80 deletions(-)

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
