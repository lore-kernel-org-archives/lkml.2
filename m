Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab2F0V4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:56:54 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:65127 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155Ab2F0V4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:56:53 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-209.messagelabs.com!1340834212!7117485!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/19] staging: comedi: adl_pci6208: document the register map of the device
Date: Wed, 27 Jun 2012 14:56:43 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206271456.44218.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add defines for the register map of the device. These will be
used to clarify the code.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adl_pci6208.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index f949d20..b6a8439 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -53,6 +53,18 @@ References:
  */
 #include "../comedidev.h"
 
+/*
+ * PCI-6208/6216-GL register map
+ */
+#define PCI6208_AO_CONTROL(x)		(0x00 + (2 * (x)))
+#define PCI6208_AO_STATUS		0x00
+#define PCI6208_AO_STATUS_DATA_SEND	(1 << 0)
+#define PCI6208_DIO			0x40
+#define PCI6208_DIO_DO_MASK		(0x0f)
+#define PCI6208_DIO_DO_SHIFT		(0)
+#define PCI6208_DIO_DI_MASK		(0xf0)
+#define PCI6208_DIO_DI_SHIFT		(4)
+
 /* Board descriptions */
 struct pci6208_board {
 	const char *name;
-- 
1.7.11

