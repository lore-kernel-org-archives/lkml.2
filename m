Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab2HQCvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:51:13 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:29310 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933355Ab2HQCvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:51:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-131.messagelabs.com!1345171869!24237215!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/35] staging: comedi: cb_pcimdda: define the register map
Date: Thu, 16 Aug 2012 19:51:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161951.05927.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add defines for the register map of the card.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index bf98af4..765f92c 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -93,6 +93,12 @@ Configuration Options:
 #define PCI_ID_PCIM_DDA06_16		0x0053
 
 /*
+ * Register map, 8-bit access only
+ */
+#define PCIMDDA_DA_CHAN(x)		(0x00 + (x) * 2)
+#define PCIMDDA_8255_BASE_REG		0x0c
+
+/*
  * This is straight from skel.c -- I did this in case this source file
  * will someday support more than 1 board...
  */
-- 
1.7.11

