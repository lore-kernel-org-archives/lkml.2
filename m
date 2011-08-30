Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab1H3ES0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 00:18:26 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49060 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab1H3ESV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 00:18:21 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ilya Gorskin <Revent82@gmail.com>,
        Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v3 05/18] Staging: cx25821: Fix wrong brace placement in cx25821-cards.c
Date: Tue, 30 Aug 2011 12:17:00 +0800
Message-Id: <1314677833-4689-6-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
References: <1314677833-4689-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix wrong brace placement in cx25821-cards.c

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 drivers/staging/cx25821/cx25821-cards.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-cards.c b/drivers/staging/cx25821/cx25821-cards.c
index 94e8d68..876345a 100644
--- a/drivers/staging/cx25821/cx25821-cards.c
+++ b/drivers/staging/cx25821/cx25821-cards.c
@@ -39,14 +39,14 @@ struct cx25821_board cx25821_boards[] = {
 			   .name = "UNKNOWN/GENERIC",
 			   /* Ensure safe default for unknown boards */
 			   .clk_freq = 0,
-			   },
+	},
 
 	[CX25821_BOARD] = {
 			   .name = "CX25821",
 			   .portb = CX25821_RAW,
 			   .portc = CX25821_264,
 			   .input[0].type = CX25821_VMUX_COMPOSITE,
-			   },
+	},
 
 };
 
@@ -57,7 +57,7 @@ struct cx25821_subid cx25821_subids[] = {
 	 .subvendor = 0x14f1,
 	 .subdevice = 0x0920,
 	 .card = CX25821_BOARD,
-	 },
+	},
 };
 
 void cx25821_card_setup(struct cx25821_dev *dev)
-- 
1.7.0.4

