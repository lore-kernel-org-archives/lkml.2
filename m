Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab2AZOJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:09:08 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:37433
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751277Ab2AZOJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:09:07 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] INPUT: Fix typo in Kconfig
Date: Thu, 26 Jan 2012 23:08:39 +0900
Message-Id: <1327586919-1725-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "connetced" to "connected" in
drivers/input/misc/Kconfig

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/input/misc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index 7b46781..c528dea 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -415,7 +415,7 @@ config INPUT_PCF8574
 	tristate "PCF8574 Keypad input device"
 	depends on I2C && EXPERIMENTAL
 	help
-	  Say Y here if you want to support a keypad connetced via I2C
+	  Say Y here if you want to support a keypad connected via I2C
 	  with a PCF8574.
 
 	  To compile this driver as a module, choose M here: the
-- 
1.7.6.5

