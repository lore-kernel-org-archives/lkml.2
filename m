Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1GRD1w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 23:27:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46544 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab1GRD1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 23:27:48 -0400
Date: Mon, 18 Jul 2011 04:27:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] more fixes for 3.0
Message-ID: <20110718032747.GX11013@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assorted crap caught by ->d_parent audit (and there's more, unfortunately ;-/)
The stuff Hugh found is not in that pile, BTW.  Please, pull from usual place:

git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (7):
      cifs: build_path_from_dentry() race fix
      ceph analog of cifs build_path_from_dentry() race fix
      fix exofs ->get_parent()
      ufs should use d_splice_alias()
      cramfs: get_cramfs_inode() returns ERR_PTR() on failure
      hppfs: fix dentry leak
      hppfs_lookup(): don't open-code lookup_one_len()

Diffstat:
 fs/ceph/mds_client.c |   19 ++++++++++++++++---
 fs/cifs/dir.c        |   13 ++++++++++++-
 fs/cramfs/inode.c    |   22 ++++++++++++----------
 fs/exofs/super.c     |    2 +-
 fs/hppfs/hppfs.c     |   31 +++++++++----------------------
 fs/ufs/namei.c       |   12 ++++--------
 6 files changed, 54 insertions(+), 45 deletions(-)
