Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab1GLGjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 02:39:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58364 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755037Ab1GLGjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 02:39:16 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 19/19] Staging: comedi: fix space issue in dt9812.c
Date: Tue, 12 Jul 2011 12:21:58 +0530
Message-Id: <1310453518-17592-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix space issue in dt9812.c>
References: <[PATCH]Staging: comedi: fix space issue in dt9812.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the dt9812.c file that fixes up a space warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>

---

Earlier there was space now it is replaced with tabs.
---
 drivers/staging/comedi/drivers/dt9812.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 32d9c42..8ec32e2 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -196,7 +196,7 @@ struct dt9812_flash_data {
 };
 
 #define DT9812_MAX_NUM_MULTI_BYTE_RDS  \
-    ((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(u8))
+	((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(u8))
 
 struct dt9812_read_multi {
 	u8 count;
@@ -209,8 +209,8 @@ struct dt9812_write_byte {
 };
 
 #define DT9812_MAX_NUM_MULTI_BYTE_WRTS  \
-    ((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / \
-      sizeof(struct dt9812_write_byte))
+	((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / \
+	sizeof(struct dt9812_write_byte))
 
 struct dt9812_write_multi {
 	u8 count;
@@ -224,7 +224,8 @@ struct dt9812_rmw_byte {
 };
 
 #define DT9812_MAX_NUM_MULTI_BYTE_RMWS  \
-    ((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(struct dt9812_rmw_byte))
+	((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / \
+	sizeof(struct dt9812_rmw_byte))
 
 struct dt9812_rmw_multi {
 	u8 count;
-- 
1.6.5.2

