Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810Ab2ECVmq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:42:46 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55647 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753382Ab2ECVmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:42:45 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1824BoVDig2HC1aACYYJEULqkTSv/IZb4+/3xg3jt
	eo7VbZ0hIXvK34
From: Peter Huewe <peterhuewe@gmx.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Thomas Winischhofer <thomas@winischhofer.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] video/sis: Remove unused structs SiS_SDRDRAM_TYPE/SiS_DDRDRAM_TYPE/SiS_DRAMType
Date: Thu,  3 May 2012 23:42:39 +0200
Message-Id: <1336081359-5643-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused structs SiS_SDRDRAM_TYPE and SiS_DDRDRAM_TYPE
from init.h

These are not used anywhere so we can delete them.

The SiS_DRAMType is identically defined in sis_main.c and only used
there so we can remove it here.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/video/sis/init.h |   45 ---------------------------------------------
 1 files changed, 0 insertions(+), 45 deletions(-)

diff --git a/drivers/video/sis/init.h b/drivers/video/sis/init.h
index aff7384..85d6738 100644
--- a/drivers/video/sis/init.h
+++ b/drivers/video/sis/init.h
@@ -105,51 +105,6 @@ static const unsigned short ModeIndex_1920x1440[]    = {0x68, 0x69, 0x00, 0x6b};
 static const unsigned short ModeIndex_300_2048x1536[]= {0x6c, 0x6d, 0x00, 0x00};
 static const unsigned short ModeIndex_310_2048x1536[]= {0x6c, 0x6d, 0x00, 0x6e};
 
-static const unsigned short SiS_DRAMType[17][5]={
-	{0x0C,0x0A,0x02,0x40,0x39},
-	{0x0D,0x0A,0x01,0x40,0x48},
-	{0x0C,0x09,0x02,0x20,0x35},
-	{0x0D,0x09,0x01,0x20,0x44},
-	{0x0C,0x08,0x02,0x10,0x31},
-	{0x0D,0x08,0x01,0x10,0x40},
-	{0x0C,0x0A,0x01,0x20,0x34},
-	{0x0C,0x09,0x01,0x08,0x32},
-	{0x0B,0x08,0x02,0x08,0x21},
-	{0x0C,0x08,0x01,0x08,0x30},
-	{0x0A,0x08,0x02,0x04,0x11},
-	{0x0B,0x0A,0x01,0x10,0x28},
-	{0x09,0x08,0x02,0x02,0x01},
-	{0x0B,0x09,0x01,0x08,0x24},
-	{0x0B,0x08,0x01,0x04,0x20},
-	{0x0A,0x08,0x01,0x02,0x10},
-	{0x09,0x08,0x01,0x01,0x00}
-};
-
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

