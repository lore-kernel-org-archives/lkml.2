Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab0FADXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:23:37 -0400
Received: from mail.perches.com ([173.55.12.10]:2492 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847Ab0FADXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:33 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 17/21] drivers/usb/storage/isd200.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:19 -0700
Message-Id: <75c229f6bedef9b1924ef1d7daaf4df383e06fa7.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/storage/isd200.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index e9cbc14..6b9982c 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -1456,8 +1456,7 @@ static int isd200_init_info(struct us_data *us)
 	int retStatus = ISD200_GOOD;
 	struct isd200_info *info;
 
-	info = (struct isd200_info *)
-			kzalloc(sizeof(struct isd200_info), GFP_KERNEL);
+	info = kzalloc(sizeof(struct isd200_info), GFP_KERNEL);
 	if (!info)
 		retStatus = ISD200_ERROR;
 	else {
-- 
1.7.0.3.311.g6a6955

