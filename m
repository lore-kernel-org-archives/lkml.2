Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2HRBGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 21:06:33 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:64547 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab2HRBGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 21:06:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1345251982!7762353!1
X-Originating-IP: [216.166.12.31]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/20] staging: comedi: adv_pci1710: remove '0' and 'NULL' boardinfo data
Date: Fri, 17 Aug 2012 18:06:19 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208171806.19696.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all the boardinfo data that is set to '0' or 'NULL'.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/adv_pci1710.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 58de025..5bea385 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -247,7 +247,6 @@ static const struct boardtype boardtypes[] = {
 		.have_irq	= 1,
 		.cardtype	= TYPE_PCI171X,
 		.n_aichan	= 16,
-		.n_aichand	= 0,
 		.n_aochan	= 2,
 		.n_dichan	= 16,
 		.n_dochan	= 16,
@@ -267,36 +266,19 @@ static const struct boardtype boardtypes[] = {
 		.cardtype	= TYPE_PCI1713,
 		.n_aichan	= 32,
 		.n_aichand	= 16,
-		.n_aochan	= 0,
-		.n_dichan	= 0,
-		.n_dochan	= 0,
-		.n_counter	= 0,
 		.ai_maxdata	= 0x0fff,
-		.ao_maxdata	= 0x0000,
 		.rangelist_ai	= &range_pci1710_3,
 		.rangecode_ai	= range_codes_pci1710_3,
-		.rangelist_ao	= NULL,
 		.ai_ns_min	= 10000,
 		.fifo_half_size	= 2048,
 	}, {
 		.name		= "pci1720",
 		.device_id	= 0x1720,
 		.iorange	= IORANGE_1720,
-		.have_irq	= 0,
 		.cardtype	= TYPE_PCI1720,
-		.n_aichan	= 0,
-		.n_aichand	= 0,
 		.n_aochan	= 4,
-		.n_dichan	= 0,
-		.n_dochan	= 0,
-		.n_counter	= 0,
-		.ai_maxdata	= 0x0000,
 		.ao_maxdata	= 0x0fff,
-		.rangelist_ai	= NULL,
-		.rangecode_ai	= NULL,
 		.rangelist_ao	= &range_pci1720,
-		.ai_ns_min	= 0,
-		.fifo_half_size	= 0,
 	}, {
 		.name		= "pci1731",
 		.device_id	= 0x1731,
@@ -304,16 +286,11 @@ static const struct boardtype boardtypes[] = {
 		.have_irq	= 1,
 		.cardtype	= TYPE_PCI171X,
 		.n_aichan	= 16,
-		.n_aichand	= 0,
-		.n_aochan	= 0,
 		.n_dichan	= 16,
 		.n_dochan	= 16,
-		.n_counter	= 0,
 		.ai_maxdata	= 0x0fff,
-		.ao_maxdata	= 0x0000,
 		.rangelist_ai	= &range_pci17x1,
 		.rangecode_ai	= range_codes_pci17x1,
-		.rangelist_ao	= NULL,
 		.ai_ns_min	= 10000,
 		.fifo_half_size	= 512,
 	}, {
-- 
1.7.11

