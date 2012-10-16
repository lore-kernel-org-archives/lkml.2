Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab2JPTOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:14:21 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:59494 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823Ab2JPTOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:14:16 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 08/10] ext4: ioctl: Fixed coding style issue
Date: Wed, 17 Oct 2012 00:43:03 +0530
Message-Id: <1350414785-7848-8-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350414785-7848-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch.pl reported issue

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.7-rc1/fs/ext4/ioctl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/linux-3.7-rc1/fs/ext4/ioctl.c b/linux-3.7-rc1/fs/ext4/ioctl.c
index 5747f52..a534615 100644
--- a/linux-3.7-rc1/fs/ext4/ioctl.c
+++ b/linux-3.7-rc1/fs/ext4/ioctl.c
@@ -194,7 +194,7 @@ setversion_out:
 	}
 	case EXT4_IOC_GROUP_EXTEND: {
 		ext4_fsblk_t n_blocks_count;
-		int err, err2=0;
+		int err, err2 = 0;
 
 		err = ext4_resize_begin(sb);
 		if (err)
@@ -280,7 +280,7 @@ mext_out:
 
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
-		int err, err2=0;
+		int err, err2 = 0;
 
 		err = ext4_resize_begin(sb);
 		if (err)
-- 
1.7.7.3

