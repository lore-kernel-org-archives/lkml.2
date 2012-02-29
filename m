Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030741Ab2B2DfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 22:35:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62389 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965021Ab2B2DfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 22:35:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of oliver.n.baumann@googlemail.com designates 10.14.33.204 as permitted sender) smtp.mail=oliver.n.baumann@googlemail.com; dkim=pass header.i=oliver.n.baumann@googlemail.com
From: "Oliver N. Baumann" <oliver.n.baumann@googlemail.com>
To: sjakub@gmail.com, gregkh@linuxfoundation.org, pq@iki.fi,
        baumanno@cip.ifi.lmu.de, kernel@kenobrien.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: asus_oled: fix checkpatch.pl issue in asus_oled.c
Date: Wed, 29 Feb 2012 04:34:51 +0100
Message-Id: <1330486491-8699-1-git-send-email-baumanno@cip.ifi.lmu.de>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Oliver N. Baumann" <baumanno@cip.ifi.lmu.de>

This is a patch to asus_oled.c that fixes a parenthesis issue detected by checkpatch.pl tool
Signed-off-by: Oliver N. Baumann <baumanno@cip.ifi.lmu.de>
---
 drivers/staging/asus_oled/asus_oled.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/asus_oled/asus_oled.c b/drivers/staging/asus_oled/asus_oled.c
index 1df9586..b77f225 100644
--- a/drivers/staging/asus_oled/asus_oled.c
+++ b/drivers/staging/asus_oled/asus_oled.c
@@ -44,9 +44,9 @@
 
 #define ASUS_OLED_ERROR			"Asus OLED Display Error: "
 
-#define ASUS_OLED_STATIC		's'
-#define ASUS_OLED_ROLL			'r'
-#define ASUS_OLED_FLASH			'f'
+#define ASUS_OLED_STATIC		('s')
+#define ASUS_OLED_ROLL			('r')
+#define ASUS_OLED_FLASH			('f')
 
 #define ASUS_OLED_MAX_WIDTH		1792
 #define ASUS_OLED_DISP_HEIGHT		32
-- 
1.7.5.4

