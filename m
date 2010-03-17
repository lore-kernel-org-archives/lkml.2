Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab0CQKMR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 06:12:17 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:61826 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0CQKMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 06:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Q6PH01u2IySsPtlR1Q27i7R2otEguUOdSrY4cyeVwNzZBN+18Oqv4z+EXlCGIcnBZt
         NOlBaa/TMF81nmd2bKJ4LaodzqxU4bGpZRbl7rHc/XZc+tkFFo0SX1Voi1/Fx0A2xdXi
         /Ldsenzxt4PHWwSkxoXCfZtvk4nVmarymDAL4=
MIME-Version: 1.0
Date: Wed, 17 Mar 2010 18:12:14 +0800
Message-ID: <bd0d95d71003170312s10fd8680xcbea67cc8d681296@mail.gmail.com>
Subject: [PATCH] ext4: Fix coding style in fs/ext4/move_extent.c
From: Steven Liu <lingjiujianke@gmail.com>
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu, adilger@sun.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix a code style in fs/ext4/move_extent.c

Signed-off-by: LiuQi <lingjiujianke@gmail.com>
---
 fs/ext4/move_extent.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index aa5fe28..b399358 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -481,6 +481,7 @@ mext_leaf_block(handle_t *handle, struct inode *orig_inode,
 	int depth = ext_depth(orig_inode);
 	int ret;

+	start_ext.ee_block = end_ext.ee_block = 0;
 	o_start = o_end = oext = orig_path[depth].p_ext;
 	oext_alen = ext4_ext_get_actual_len(oext);
 	start_ext.ee_len = end_ext.ee_len = 0;
-- 
1.6.0.3
