Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0EOLpD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 07:45:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41128 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab0EOLpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 07:45:00 -0400
Date: Sat, 15 May 2010 12:44:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull][vfs].34 fixes
Message-ID: <20100515114458.GD31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Misc fixes; the most serious one is unlink/mount regression.
Please, pull from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (2):
      Fix the regression created by "set S_DEAD on unlink()..." commit
      Fix double-free in logfs

Dan Carpenter (1):
      fs/sysv: dereferencing ERR_PTR()

Jan Blunck (1):
      JFS: Free sbi memory in error path

Diffstat:
 drivers/usb/core/inode.c |    1 +
 fs/configfs/dir.c        |    4 ++++
 fs/jfs/super.c           |   13 ++++++-------
 fs/logfs/super.c         |   14 +++++++-------
 fs/namei.c               |   21 +++++++++++++--------
 fs/namespace.c           |    6 +++---
 fs/sysv/dir.c            |    2 +-
 include/linux/dcache.h   |   14 ++++++++++++++
 8 files changed, 49 insertions(+), 26 deletions(-)

