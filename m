Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1EHSzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 14:55:25 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:46562 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab1EHSzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 14:55:18 -0400
Date: Sun, 8 May 2011 20:44:46 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 14/14] HPFS: Remove unused variable
Message-ID: <alpine.DEB.2.00.1105082031320.7013@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable

Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>

---
 fs/hpfs/namei.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-2.6.39-rc5-fast/fs/hpfs/namei.c
===================================================================
--- linux-2.6.39-rc5-fast.orig/fs/hpfs/namei.c	2011-05-05 01:02:58.000000000 +0200
+++ linux-2.6.39-rc5-fast/fs/hpfs/namei.c	2011-05-05 01:03:03.000000000 +0200
@@ -361,7 +361,6 @@ static int hpfs_unlink(struct inode *dir
 	struct hpfs_dirent *de;
 	struct inode *inode = dentry->d_inode;
 	dnode_secno dno;
-	fnode_secno fno;
 	int r;
 	int rep = 0;
 	int err;
@@ -382,7 +381,6 @@ again:
 	if (de->directory)
 		goto out1;
 
-	fno = le32_to_cpu(de->fnode);
 	r = hpfs_remove_dirent(dir, dno, de, &qbh, 1);
 	switch (r) {
 	case 1:
@@ -440,7 +438,6 @@ static int hpfs_rmdir(struct inode *dir,
 	struct hpfs_dirent *de;
 	struct inode *inode = dentry->d_inode;
 	dnode_secno dno;
-	fnode_secno fno;
 	int n_items = 0;
 	int err;
 	int r;
@@ -465,7 +462,6 @@ static int hpfs_rmdir(struct inode *dir,
 	if (n_items)
 		goto out1;
 
-	fno = le32_to_cpu(de->fnode);
 	r = hpfs_remove_dirent(dir, dno, de, &qbh, 1);
 	switch (r) {
 	case 1:
