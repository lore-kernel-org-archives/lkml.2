Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692Ab1GHQbN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 12:31:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35580 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab1GHQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 12:31:09 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 8/8] Staging: comedi: fix warning  issue in dt9812.c
Date: Fri,  8 Jul 2011 22:13:36 +0530
Message-Id: <1310143416-15721-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH]Staging: comedi: fix warning issue in dt9812.c>
References: <[PATCH]Staging: comedi: fix warning issue in dt9812.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the dt9812.c file that fixes up a  warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>

---

Replace the space with tab.
---
 drivers/staging/comedi/drivers/dt9812.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 6629622..e546efc 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -196,7 +196,7 @@ struct dt9812_flash_data {
 };
 
 #define DT9812_MAX_NUM_MULTI_BYTE_RDS  \
-((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(u8))
+	((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(u8))
 
 struct dt9812_read_multi {
 	u8 count;
@@ -209,8 +209,7 @@ struct dt9812_write_byte {
 };
 
 #define DT9812_MAX_NUM_MULTI_BYTE_WRTS  \
-((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / \
-sizeof(struct dt9812_write_byte))
+((DT9812_MAX_WRITE_CMD_PIPE_SIZE - 4 - 1) / sizeof(struct dt9812_write_byte))
 
 struct dt9812_write_multi {
 	u8 count;
-- 
1.6.5.2

