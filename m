Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab1DCX3e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 19:29:34 -0400
Received: from borg.medozas.de ([188.40.89.202]:42352 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab1DCX3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 19:29:33 -0400
Date: Mon, 4 Apr 2011 01:29:32 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: gregkh@suse.de
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: staging: gma500: fix "persistant" typo
Message-ID: <alpine.LNX.2.01.1104040129110.21333@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

parent b0ef5d4e28cd127eef94b300f27ba0104deb5ad6 (v2.6.39-rc1-186-gb0ef5d4)
commit fdbba80c7a1638bb2041d6349db27762e951a074
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Apr 4 01:28:05 2011 +0200

staging: gma500: fix "persistant" typo

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 drivers/staging/gma500/psb_ttm_placement_user.c |    8 ++++----
 drivers/staging/gma500/psb_ttm_userobj_api.h    |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gma500/psb_ttm_placement_user.c b/drivers/staging/gma500/psb_ttm_placement_user.c
index 272b397..6ce592d 100644
--- a/drivers/staging/gma500/psb_ttm_placement_user.c
+++ b/drivers/staging/gma500/psb_ttm_placement_user.c
@@ -173,7 +173,7 @@ static int ttm_bo_create_private(struct ttm_bo_device *bdev,
 			uint32_t page_alignment,
 			unsigned long buffer_start,
 			bool interruptible,
-			struct file *persistant_swap_storage,
+			struct file *persistent_swap_storage,
 			struct ttm_buffer_object **p_bo)
 {
 	struct ttm_buffer_object *bo;
@@ -195,7 +195,7 @@ static int ttm_bo_create_private(struct ttm_bo_device *bdev,
 
 	ret = ttm_bo_init(bdev, bo, size, type, placement, page_alignment,
 				buffer_start, interruptible,
-				persistant_swap_storage, acc_size, NULL);
+				persistent_swap_storage, acc_size, NULL);
 	if (likely(ret == 0))
 		*p_bo = bo;
 
@@ -235,7 +235,7 @@ int ttm_buffer_object_create(struct ttm_bo_device *bdev,
 			uint32_t page_alignment,
 			unsigned long buffer_start,
 			bool interruptible,
-			struct file *persistant_swap_storage,
+			struct file *persistent_swap_storage,
 			struct ttm_buffer_object **p_bo)
 {
 	struct ttm_placement placement = default_placement;
@@ -254,7 +254,7 @@ int ttm_buffer_object_create(struct ttm_bo_device *bdev,
 			page_alignment,
 			buffer_start,
 			interruptible,
-			persistant_swap_storage,
+			persistent_swap_storage,
 			p_bo);
 
 	return ret;
diff --git a/drivers/staging/gma500/psb_ttm_userobj_api.h b/drivers/staging/gma500/psb_ttm_userobj_api.h
index 6a8f7c4..51d579a 100644
--- a/drivers/staging/gma500/psb_ttm_userobj_api.h
+++ b/drivers/staging/gma500/psb_ttm_userobj_api.h
@@ -77,7 +77,7 @@ extern int ttm_buffer_object_create(struct ttm_bo_device *bdev,
 			uint32_t page_alignment,
 			unsigned long buffer_start,
 			bool interruptible,
-			struct file *persistant_swap_storage,
+			struct file *persistent_swap_storage,
 			struct ttm_buffer_object **p_bo);
 
 extern int psb_ttm_bo_check_placement(struct ttm_buffer_object *bo,
-- 
# Created with git-export-patch

