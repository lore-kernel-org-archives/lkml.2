Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758943Ab2CSPSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:18:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48182 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab2CSPSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:18:09 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, "Justin P. Mattock" <justinmattock@gmail.com>,
        Willy Tarreau <willy@meta-x.org>
Subject: [PATCH 4/5]NEXT:drivers:staging:panel:panel.c Fix typo in staging:panel
Date: Mon, 19 Mar 2012 08:17:52 -0700
Message-Id: <1332170273-3482-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
References: <1332170273-3482-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes a typo I found while reading.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: Willy Tarreau <willy@meta-x.org>
---
 drivers/staging/panel/panel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 4683d5f..54ed4f2 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -755,7 +755,7 @@ static void lcd_backlight(int on)
 	if (lcd_bl_pin == PIN_NONE)
 		return;
 
-	/* The backlight is activated by seting the AUTOFEED line to +5V  */
+	/* The backlight is activated by setting the AUTOFEED line to +5V  */
 	spin_lock(&pprt_lock);
 	bits.bl = on;
 	panel_set_bits();
-- 
1.7.5.4

