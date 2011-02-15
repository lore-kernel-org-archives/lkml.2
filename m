Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab1BOLjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 06:39:04 -0500
Received: from smtp.nokia.com ([147.243.1.48]:63683 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab1BOLjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 06:39:01 -0500
From: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, cloos@jhcloos.com
Cc: "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: [PATCH] NFC: Add full form of the NFC acronym.
Date: Tue, 15 Feb 2011 13:38:00 +0200
Message-Id: <1297769880-6541-1-git-send-email-matti.j.aaltonen@nokia.com>
X-Mailer: git-send-email 1.6.1.3
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spell out the NFC acronym when it's shown for the
first time.

Signed-off-by: Matti J. Aaltonen <matti.j.aaltonen@nokia.com>
---
 drivers/nfc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/nfc/Kconfig b/drivers/nfc/Kconfig
index ffedfd4..ea15800 100644
--- a/drivers/nfc/Kconfig
+++ b/drivers/nfc/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menuconfig NFC_DEVICES
-	bool "NFC devices"
+	bool "Near Field Communication (NFC) devices"
 	default n
 	---help---
 	  You'll have to say Y if your computer contains an NFC device that
-- 
1.6.1.3

