Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694Ab2DBJNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:13:33 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46337 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2DBJNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:13:32 -0400
From: Il Han <corone.il.han@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: linux-kernel@vger.kernel.org, Il Han <corone.il.han@gmail.com>
Subject: [PATCH] lirc: wrong data type for a variable.
Date: Mon,  2 Apr 2012 18:08:15 +0900
Message-Id: <1333357695-6519-1-git-send-email-corone.il.han@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data type of the variable sense is int.
Correct it.

Signed-off-by: Il Han <corone.il.han@gmail.com>
---
 drivers/staging/media/lirc/lirc_serial.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 3295ea6..a172c96 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -1292,7 +1292,7 @@ MODULE_PARM_DESC(irq, "Interrupt (4 or 3)");
 module_param(share_irq, bool, S_IRUGO);
 MODULE_PARM_DESC(share_irq, "Share interrupts (0 = off, 1 = on)");
 
-module_param(sense, bool, S_IRUGO);
+module_param(sense, int, S_IRUGO);
 MODULE_PARM_DESC(sense, "Override autodetection of IR receiver circuit"
 		 " (0 = active high, 1 = active low )");
 
-- 
1.7.4.1

