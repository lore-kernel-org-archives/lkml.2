Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab2GSCGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 22:06:07 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:54586 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab2GSCGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 22:06:04 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1342663553!8636487!10
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 90/90] staging: comedi: s526: remove unused variables in the private data
Date: Wed, 18 Jul 2012 19:05:55 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207181905.55981.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'data' and 'pci_dev' variables in the private data are not used.
They appear to be cut-and-paste from the skel driver. Remove them.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/s526.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index 358380f..737a194 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -206,15 +206,7 @@ static const struct s526_board s526_boards[] = {
    struct.
 */
 struct s526_private {
-
-	int data;
-
-	/* would be useful for a PCI device */
-	struct pci_dev *pci_dev;
-
-	/* Used for AO readback */
 	unsigned int ao_readback[2];
-
 	struct s526GPCTConfig s526_gpct_config[4];
 	unsigned short s526_ai_config;
 };
-- 
1.7.11

