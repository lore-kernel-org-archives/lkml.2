Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab0IYSdI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 14:33:08 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41084 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab0IYSdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 14:33:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WighR+cIA2pVqFRRDq0B8U8DELhL9ZwGsJAcdPNSQKMW24MB7qfo3xnv27EDD1I7nu
         QWMArK3x1jwlKuYsdWZf5cYQCAGYP4pYfA3RTyYjiktaXa74WTDD8OkUR7ZecJUT3cGP
         wybD9poWZDVB8c+WVQustR3r5gDzdfak6Sgy0=
From: Tracey Dent <tdent48227@gmail.com>
To: tytso@mit.edu
Cc: adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
        sandeen@redhat.com, hch@lst.de, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tracey Dent <Tdent48227@gmail.com>,
        Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 07/10] Fs: ext4: file: fixed indent problem
Date: Sat, 25 Sep 2010 14:31:58 -0400
Message-Id: <1285439521-2557-7-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tracey Dent <Tdent48227@gmail.com>

Fixed indent problem that was detected by checkpatch.pl

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 fs/ext4/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index ee92b66..d75e8e6 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -43,7 +43,7 @@ static int ext4_release_file(struct inode *inode, struct file *filp)
 	/* if we are the last writer on the inode, drop the block reservation */
 	if ((filp->f_mode & FMODE_WRITE) &&
 			(atomic_read(&inode->i_writecount) == 1) &&
-		        !EXT4_I(inode)->i_reserved_data_blocks)
+				!EXT4_I(inode)->i_reserved_data_blocks)
 	{
 		down_write(&EXT4_I(inode)->i_data_sem);
 		ext4_discard_preallocations(inode);
-- 
1.7.3

