Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab2AITZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 14:25:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48984 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932942Ab2AITZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 14:25:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/8] char_dev.c: fix up some whitespace errors
Date: Mon,  9 Jan 2012 11:25:00 -0800
Message-Id: <1326137105-9960-3-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1326137105-9960-1-git-send-email-gregkh@suse.de>
References: <20120109190736.GA9440@kroah.com>
 <1326137105-9960-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some minor whitespace errors (2 trailing spaces, and one space
needed for a comma) to make the file checkpatch.pl clean with the
exception of the exports, which is fine for now.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/char_dev.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index dca9e5e..3f152b9 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -272,7 +272,7 @@ int __register_chrdev(unsigned int major, unsigned int baseminor,
 	cd = __register_chrdev_region(major, baseminor, count, name);
 	if (IS_ERR(cd))
 		return PTR_ERR(cd);
-	
+
 	cdev = cdev_alloc();
 	if (!cdev)
 		goto out2;
@@ -280,7 +280,7 @@ int __register_chrdev(unsigned int major, unsigned int baseminor,
 	cdev->owner = fops->owner;
 	cdev->ops = fops;
 	kobject_set_name(&cdev->kobj, "%s", name);
-		
+
 	err = cdev_add(cdev, MKDEV(cd->major, baseminor), count);
 	if (err)
 		goto out;
@@ -405,7 +405,7 @@ static int chrdev_open(struct inode *inode, struct file *filp)
 		goto out_cdev_put;
 
 	if (filp->f_op->open) {
-		ret = filp->f_op->open(inode,filp);
+		ret = filp->f_op->open(inode, filp);
 		if (ret)
 			goto out_cdev_put;
 	}
-- 
1.7.8

