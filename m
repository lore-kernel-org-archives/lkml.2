Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab1KUEKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 23:10:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:53992 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1KUEJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 23:09:58 -0500
Date: Mon, 21 Nov 2011 04:09:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] few more missed bits from the last cycle
Message-ID: <20111121040957.GG2203@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few patches from back in August that fell through the cracks.  The most
interesting story here is dealing with minixfs statfs() oopsen... Please,
pull from
git://git.kernel.org:/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (1):
      minixfs: kill manual hweight(), simplify

David Howells (1):
      VFS: Log the fact that we've given ELOOP rather than creating a loop

Josh Boyer (1):
      fs/minix: Verify bitmap block counts before mounting

Diffstat:
 fs/dcache.c       |   11 +++++++++-
 fs/minix/bitmap.c |   55 +++++++++++++++++++++++-----------------------------
 fs/minix/inode.c  |   25 ++++++++++++++++++++++-
 fs/minix/minix.h  |   11 +++++++--
 4 files changed, 65 insertions(+), 37 deletions(-)
