Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1DJONS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 10:13:18 -0400
Received: from mail-iy0-f194.google.com ([209.85.210.194]:49406 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab1DJONJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 10:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q0Wl0qW/Z4ToLOCK9DnbWmf4oLc3+9Qbq1c8X2SQCHQlmdxKNTn5tcOYl3Vny0hws0
         iCGB49oy0ySutpesv82OJPqEZUNR6QkzqFJF7aB5TQzugEXrgIwpdUQSwej1empuXfWh
         b7EQH4hx/gPy9P1bMXUvuMZQHpwtp9FcDg+Gs=
From: wanlong.gao@gmail.com
To: broonie@opensource.wolfsonmicro.com, geert@linux-m68k.org,
        starvik@axis.com, jesper.nilsson@axis.com, sameo@linux.intel.com,
        ian@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, James.Bottomley@suse.de, aelder@sgi.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 5/5] xfs:removed the unused variable
Date: Sun, 10 Apr 2011 22:10:29 +0800
Message-Id: <1302444629-17043-5-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1302444629-17043-1-git-send-email-wanlong.gao@gmail.com>
References: <1302444629-17043-1-git-send-email-wanlong.gao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

removed the unused variable "bdi" of xfs_buf.c .

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 5ea4020..a125b32 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -657,8 +657,6 @@ xfs_buf_readahead(
 	xfs_off_t		ioff,
 	size_t			isize)
 {
-	struct backing_dev_info *bdi;
-
 	if (bdi_read_congested(target->bt_bdi))
 		return;
 
-- 
1.7.3

