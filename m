Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1I3NTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 09:19:36 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46656 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab1I3NTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 09:19:31 -0400
From: Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 6/9] Staging: comedi: fix line over 80 character issue in cb_pcidio.c
Date: Fri, 30 Sep 2011 18:48:24 +0530
Message-Id: <1317388707-1980-6-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.6.2
In-Reply-To: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1317388707-1980-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidio.c file that fixes up a line over 80 character warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidio.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidio.c b/drivers/staging/comedi/drivers/cb_pcidio.c
index 85cc78d..40a3eb0 100644
--- a/drivers/staging/comedi/drivers/cb_pcidio.c
+++ b/drivers/staging/comedi/drivers/cb_pcidio.c
@@ -104,9 +104,12 @@ MODULE_DEVICE_TABLE(pci, pcidio_pci_table);
  */
 #define thisboard ((const struct pcidio_board *)dev->board_ptr)
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+/*
+ * this structure is for data unique to this hardware driver.  If
+ * several hardware drivers keep similar information in this structure,
+ * feel free to suggest moving the variable to the struct comedi_device
+ * struct.
+ */
 struct pcidio_private {
 	int data;		/*  currently unused */
 
@@ -114,9 +117,11 @@ struct pcidio_private {
 	struct pci_dev *pci_dev;
 
 	/* used for DO readback, currently unused */
-	unsigned int do_readback[4];	/* up to 4 unsigned int suffice to hold 96 bits for PCI-DIO96 */
+	/* up to 4 unsigned int suffice to hold 96 bits for PCI-DIO96 */
+	unsigned int do_readback[4];
 
-	unsigned long dio_reg_base;	/*  address of port A of the first 8255 chip on board */
+	/* address of port A of the first 8255 chip on board */
+	unsigned long dio_reg_base;
 };
 
 /*
-- 
1.7.6.2

