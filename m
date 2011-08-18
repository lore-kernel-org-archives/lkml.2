Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1HRO6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 10:58:50 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:56504 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab1HRO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 10:58:49 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] fatfs-2.6 patches
Date: Thu, 18 Aug 2011 23:58:44 +0900
Message-ID: <87hb5ehil7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Those are small fixes, and one line change to allow 4GB file size.

Please pull from

    git://git.kernel.org/pub/scm/linux/kernel/git/hirofumi/fatfs-2.6.git master

to get these changes:

Jonas Aberg (1):
      fat: fix build warning

Mihai Moldovan (1):
      fat: fix utf8 iocharset warning message

Namjae Jeon (1):
      fat: fat16 support maximum 4GB file/vol size as WinXP or 7.

 fs/fat/dir.c   |    2 +-
 fs/fat/inode.c |    7 +++----
 2 files changed, 4 insertions(+), 5 deletions(-)

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
