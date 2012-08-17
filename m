Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933683Ab2HQCyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 22:54:15 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:28083 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607Ab2HQCyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 22:54:13 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-160.messagelabs.com!1345172050!7152213!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 31/35] staging: comedi: cb_pcimdda: minor cleanup of the private data
Date: Thu, 16 Aug 2012 19:54:05 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208161954.05358.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the cut-and-paste comment from the skel driver and for
aesthetic reasons, move the #define out of the struct.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdda.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdda.c b/drivers/staging/comedi/drivers/cb_pcimdda.c
index 99a6160..a5e055f 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdda.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdda.c
@@ -98,17 +98,10 @@ Configuration Options:
 #define PCIMDDA_DA_CHAN(x)		(0x00 + (x) * 2)
 #define PCIMDDA_8255_BASE_REG		0x0c
 
-/*
- * this structure is for data unique to this hardware driver.  If
- * several hardware drivers keep similar information in this structure,
- * feel free to suggest moving the variable to the struct comedi_device
- * struct.
- */
+#define MAX_AO_READBACK_CHANNELS	6
+
 struct cb_pcimdda_private {
-#define MAX_AO_READBACK_CHANNELS 6
-	/* Used for AO readback */
 	unsigned int ao_readback[MAX_AO_READBACK_CHANNELS];
-
 };
 
 static int cb_pcimdda_ao_winsn(struct comedi_device *dev,
-- 
1.7.11

