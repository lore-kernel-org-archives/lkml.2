Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab2JFKnj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 06:43:39 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55177 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2JFKng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 06:43:36 -0400
Message-ID: <507009C7.6010901@gmail.com>
Date: Sat, 06 Oct 2012 12:36:55 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8]  drop lock/unlock super
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I send again the patch series to remove from kernel the old lock/unlock 
super. Please consider this patch series for merge window of 3.7. The 
patches are against Linus tree.

Thanks.

Marco Stornelli (8):
   exofs: drop lock/unlock super
   ext3: drop lock/unlock super
   ext4: drop lock/unlock super
   fat: drop lock/unlock super
   hpfs: drop lock/unlock super
   sysv: drop lock/unlock super
   ufs: drop lock/unlock super
   vfs: drop lock/unlock super

  fs/exofs/super.c     |    4 ----
  fs/ext3/super.c      |    6 ------
  fs/ext4/super.c      |   11 +----------
  fs/fat/dir.c         |    4 ++--
  fs/fat/fat.h         |    5 +++--
  fs/fat/inode.c       |    5 +++--
  fs/fat/namei_msdos.c |   26 +++++++++++++-------------
  fs/fat/namei_vfat.c  |   30 +++++++++++++++---------------
  fs/hpfs/super.c      |    3 ---
  fs/super.c           |   23 -----------------------
  fs/sysv/balloc.c     |   18 +++++++++---------
  fs/sysv/ialloc.c     |   14 +++++++-------
  fs/sysv/inode.c      |    4 ++--
  fs/sysv/super.c      |    1 +
  fs/sysv/sysv.h       |    1 +
  fs/ufs/balloc.c      |   30 +++++++++++++++---------------
  fs/ufs/ialloc.c      |   16 ++++++++--------
  fs/ufs/super.c       |   21 +++++++++++----------
  fs/ufs/ufs.h         |    1 +
  include/linux/fs.h   |    1 -
  20 files changed, 92 insertions(+), 132 deletions(-)

-- 
1.7.3.4
---

