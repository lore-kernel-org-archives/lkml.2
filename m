Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab2EAGZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 02:25:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53700 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab2EAGZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 02:25:43 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 3/5] Staging: comedi: fix line indentation issue in dt9812.c
Date: Tue,  1 May 2012 11:55:08 +0530
Message-Id: <1335853510-29545-4-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335853510-29545-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1335853510-29545-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced the spaces with a tab.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/dt9812.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 32d9c42..21d94ed 100644
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
+	 sizeof(struct dt9812_write_byte))
 
 struct dt9812_write_multi {
 	u8 count;
@@ -224,7 +224,8 @@ struct dt9812_rmw_byte {
 };
 
 #define DT9812_MAX_NUM_MULTI_BYTE_RMWS  \
-    ((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(struct dt9812_rmw_byte))
+	((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / \
+	 sizeof(struct dt9812_rmw_byte))
 
 struct dt9812_rmw_multi {
 	u8 count;
-- 
1.7.0.4

