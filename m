Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab1CLVIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 16:08:19 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44490 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755593Ab1CLVHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 16:07:47 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18tu1IbtDUtl46RV8Am9WxlxprN9H//UgvEPrd+4C
	5TIf9KAnNDeOOw
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/4] viafb: remove unused data_mode and device_type
Date: Sat, 12 Mar 2011 21:22:57 +0000
Message-Id: <1299964979-3391-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1299964979-3391-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1299964979-3391-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a little cleanup for the chip_info structures.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/chip.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index a2f6200..3e8aacd 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -110,16 +110,13 @@
 struct tmds_chip_information {
 	int tmds_chip_name;
 	int tmds_chip_slave_addr;
-	int data_mode;
 	int output_interface;
 	int i2c_port;
-	int device_type;
 };
 
 struct lvds_chip_information {
 	int lvds_chip_name;
 	int lvds_chip_slave_addr;
-	int data_mode;
 	int output_interface;
 	int i2c_port;
 };
-- 
1.6.3.2

