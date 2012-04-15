Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab2DOVKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 17:10:31 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:53882 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751708Ab2DOVKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 17:10:25 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/DhcZatSjDFUU3NVU5kM+muP/Kl3NVxYc8g8Uadk
	Yp9ijWEO/k9F1O
From: Peter Huewe <peterhuewe@gmx.de>
To: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 2/2] video/sis: Remove unused structs SiS_SDRDRAM_TYPE/SiS_DDRDRAM_TYPE
Date: Sun, 15 Apr 2012 23:10:09 +0200
Message-Id: <1334524209-20518-2-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1334524209-20518-1-git-send-email-peterhuewe@gmx.de>
References: <1334524209-20518-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused structs SiS_SDRDRAM_TYPE and SiS_DDRDRAM_TYPE
from init.h

These are not used anywhere so we can delete them.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/video/sis/init.h |   25 -------------------------
 1 files changed, 0 insertions(+), 25 deletions(-)

diff --git a/drivers/video/sis/init.h b/drivers/video/sis/init.h
index 26ffb3e..5c5a96b 100644
--- a/drivers/video/sis/init.h
+++ b/drivers/video/sis/init.h
@@ -125,31 +125,6 @@ static const unsigned short __devinitconst SiS_DRAMType[17][5] = {
 	{0x09,0x08,0x01,0x01,0x00}
 };
 
-static const unsigned short SiS_SDRDRAM_TYPE[13][5] =
-{
-	{ 2,12, 9,64,0x35},
-	{ 1,13, 9,64,0x44},
-	{ 2,12, 8,32,0x31},
-	{ 2,11, 9,32,0x25},
-	{ 1,12, 9,32,0x34},
-	{ 1,13, 8,32,0x40},
-	{ 2,11, 8,16,0x21},
-	{ 1,12, 8,16,0x30},
-	{ 1,11, 9,16,0x24},
-	{ 1,11, 8, 8,0x20},
-	{ 2, 9, 8, 4,0x01},
-	{ 1,10, 8, 4,0x10},
-	{ 1, 9, 8, 2,0x00}
-};
-
-static const unsigned short SiS_DDRDRAM_TYPE[4][5] =
-{
-	{ 2,12, 9,64,0x35},
-	{ 2,12, 8,32,0x31},
-	{ 2,11, 8,16,0x21},
-	{ 2, 9, 8, 4,0x01}
-};
-
 static const unsigned char SiS_MDA_DAC[] =
 {
 	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,
-- 
1.7.3.4

