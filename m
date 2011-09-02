Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179Ab1IBD5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:57:53 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52001 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1IBD5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:57:48 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v4 06/19] Staging: cx25821: Fix wrong statement indent in cx25821-cards.c
Date: Fri,  2 Sep 2011 11:55:34 +0800
Message-Id: <1314935747-6881-7-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix wrong brace placement and statement indent in cx25821-cards.c

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-cards.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-cards.c b/drivers/staging/cx25821/cx25821-cards.c
index 94e8d68..6ace603 100644
--- a/drivers/staging/cx25821/cx25821-cards.c
+++ b/drivers/staging/cx25821/cx25821-cards.c
@@ -36,17 +36,17 @@
 
 struct cx25821_board cx25821_boards[] = {
 	[UNKNOWN_BOARD] = {
-			   .name = "UNKNOWN/GENERIC",
-			   /* Ensure safe default for unknown boards */
-			   .clk_freq = 0,
-			   },
+		.name = "UNKNOWN/GENERIC",
+		/* Ensure safe default for unknown boards */
+		.clk_freq = 0,
+	},
 
 	[CX25821_BOARD] = {
-			   .name = "CX25821",
-			   .portb = CX25821_RAW,
-			   .portc = CX25821_264,
-			   .input[0].type = CX25821_VMUX_COMPOSITE,
-			   },
+		.name = "CX25821",
+		.portb = CX25821_RAW,
+		.portc = CX25821_264,
+		.input[0].type = CX25821_VMUX_COMPOSITE,
+	},
 
 };
 
@@ -54,10 +54,10 @@ const unsigned int cx25821_bcount = ARRAY_SIZE(cx25821_boards);
 
 struct cx25821_subid cx25821_subids[] = {
 	{
-	 .subvendor = 0x14f1,
-	 .subdevice = 0x0920,
-	 .card = CX25821_BOARD,
-	 },
+		.subvendor = 0x14f1,
+		.subdevice = 0x0920,
+		.card = CX25821_BOARD,
+	},
 };
 
 void cx25821_card_setup(struct cx25821_dev *dev)
-- 
1.7.0.4

