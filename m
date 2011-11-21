Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab1KUKha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 05:37:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64088 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab1KUKh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:37:28 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 2/8] Staging: comedi: fix brace coding style issue in ni_daq_dio24.c
Date: Mon, 21 Nov 2011 16:07:00 +0530
Message-Id: <1321871826-13581-2-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1321871826-13581-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ni_daq_dio24.c file that fixes up a
brace warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/ni_daq_dio24.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_daq_dio24.c b/drivers/staging/comedi/drivers/ni_daq_dio24.c
index 381ea6c..75b3f9a 100644
--- a/drivers/staging/comedi/drivers/ni_daq_dio24.c
+++ b/drivers/staging/comedi/drivers/ni_daq_dio24.c
@@ -140,9 +140,8 @@ static int dio24_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	printk("comedi%d: ni_daq_dio24: %s, io 0x%lx", dev->minor,
 	       thisboard->name, iobase);
 #ifdef incomplete
-	if (irq) {
+	if (irq)
 		printk(", irq %u", irq);
-	}
 #endif
 
 	printk("\n");
-- 
1.7.0.4

