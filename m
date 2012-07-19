Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab2GSCE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:04:27 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:25917 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab2GSCEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:04:25 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-132.messagelabs.com!1342663464!14764524!1
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 85/90] staging: comedi: rtd520: remove the debug print of the pci addresses
Date: Wed, 18 Jul 2012 19:04:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181904.18840.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just noise.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/rtd520.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 9998d6b..02be4dd 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1676,10 +1676,6 @@ static int rtd_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (!devpriv->las0 || !devpriv->las1 || !devpriv->lcfg)
 		return -ENOMEM;
 
-
-	DPRINTK("%s: LAS0=%llx, LAS1=%llx, CFG=%llx.\n", dev->board_name,
-		(unsigned long long)physLas0, (unsigned long long)physLas1,
-		(unsigned long long)physLcfg);
 	{			/* The RTD driver does this */
 		unsigned char pci_latency;
 		u16 revision;
-- 
1.7.11

