Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab2IDW2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 18:28:48 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:48590 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565Ab2IDW2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 18:28:47 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1346797723!6805210!13
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.3; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] staging: comedi: addi_apci_all.c: remove unused file
Date: Tue, 4 Sep 2012 15:28:26 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201209041528.27061.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Makefile for the comedi subsystem does not compile this file
for any .config selection. This file would allow building one big
driver to support all the addi-data cards.

The addi-data drivers are a big enough mess as-is. Just remove this
file.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Iam Abbott <abbotti@mev.co.uk>
Cc: Greg-Kroah Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/addi_apci_all.c | 18 ------------------
 1 file changed, 18 deletions(-)
 delete mode 100644 drivers/staging/comedi/drivers/addi_apci_all.c

diff --git a/drivers/staging/comedi/drivers/addi_apci_all.c b/drivers/staging/comedi/drivers/addi_apci_all.c
deleted file mode 100644
index aeb1b26..0000000
--- a/drivers/staging/comedi/drivers/addi_apci_all.c
+++ /dev/null
@@ -1,18 +0,0 @@
-#define CONFIG_APCI_035  1
-#define CONFIG_APCI_1032 1
-#define CONFIG_APCI_1500 1
-#define CONFIG_APCI_1516 1
-#define CONFIG_APCI_1564 1
-#define CONFIG_APCI_16XX 1
-#define CONFIG_APCI_1710 1
-#define CONFIG_APCI_2016 1
-#define CONFIG_APCI_2032 1
-#define CONFIG_APCI_2200 1
-#define CONFIG_APCI_3001 1
-#define CONFIG_APCI_3120 1
-#define CONFIG_APCI_3200 1
-#define CONFIG_APCI_3300 1
-#define CONFIG_APCI_3501 1
-#define CONFIG_APCI_3XXX 1
-
-#include "addi-data/addi_common.c"
-- 
1.7.11

