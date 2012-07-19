Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2GSBrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 21:47:20 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:17762 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab2GSBrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 21:47:18 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-127.messagelabs.com!1342662437!9009286!2
X-Originating-IP: [216.166.12.98]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 50/90] staging: comedi: cb_pcimdas: cleanup the private data
Date: Wed, 18 Jul 2012 18:47:11 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181847.11958.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the unused variables from the private data.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/cb_pcimdas.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcimdas.c b/drivers/staging/comedi/drivers/cb_pcimdas.c
index 3400067..9e4bac1 100644
--- a/drivers/staging/comedi/drivers/cb_pcimdas.c
+++ b/drivers/staging/comedi/drivers/cb_pcimdas.c
@@ -134,8 +134,6 @@ static const struct cb_pcimdas_board cb_pcimdas_boards[] = {
  * struct.
  */
 struct cb_pcimdas_private {
-	int data;
-
 	/*  would be useful for a PCI device */
 	struct pci_dev *pci_dev;
 
@@ -148,13 +146,6 @@ struct cb_pcimdas_private {
 
 	/* Used for AO readback */
 	unsigned int ao_readback[2];
-
-	/*  Used for DIO */
-	unsigned short int port_a;	/*  copy of BADR4+0 */
-	unsigned short int port_b;	/*  copy of BADR4+1 */
-	unsigned short int port_c;	/*  copy of BADR4+2 */
-	unsigned short int dio_mode;	/*  copy of BADR4+3 */
-
 };
 
 /*
-- 
1.7.11

