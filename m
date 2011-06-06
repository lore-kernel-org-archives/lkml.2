Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1FFLUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:20:20 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39571 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab1FFLUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:20:18 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] fatfs-2.6 patches
Date: Mon, 06 Jun 2011 20:20:14 +0900
Message-ID: <8739jnyzo1.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is bug fix patch.

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git master

to get these changes:

OGAWA Hirofumi (1):
      fat: Fix corrupt inode flags when remove ATTR_SYS flag

 fs/fat/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
