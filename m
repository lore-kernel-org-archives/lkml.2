Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1GLOMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 10:12:31 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46722 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab1GLOMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 10:12:30 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH 24/24] Staging: comedi: fix warning: line over 80 character issue in das800.c
Date: Tue, 12 Jul 2011 19:55:03 +0530
Message-Id: <1310480703-29400-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <[PATCH v2]Staging: comedi: fix line over 80 character issue in das800.c>
References: <[PATCH v2]Staging: comedi: fix line over 80 character issue in das800.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the das800.c file that fixes up a  warning: line over 80 character found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>

---
There was a indentation not proper now it's fixed
---
 drivers/staging/comedi/drivers/das800.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 4973ec0..9a739fc 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -396,7 +396,7 @@ static irqreturn_t das800_interrupt(int irq, void *d)
 
 	/*  if hardware conversions are not enabled, then quit */
 	spin_lock_irqsave(&dev->spinlock, irq_flags);
-	 /* select base address + 7 to be STATUS2 register */
+	/* select base address + 7 to be STATUS2 register */
 	outb(CONTROL1, dev->iobase + DAS800_GAIN);
 	status = inb(dev->iobase + DAS800_STATUS2) & STATUS2_HCEN;
 	/* don't release spinlock yet since we want to make sure no one else disables hardware conversions */
-- 
1.6.5.2

