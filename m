Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab2DZKCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:02:54 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:61410 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab2DZKCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:02:52 -0400
From: Ravishankar Karkala Mallikarjunayya <ravishankarkm32@gmail.com>
To: gregkh@linuxfoundation.org, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar Karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 2/4] Staging: comedi: fix line over 80 character issue in daqboard2000.c
Date: Thu, 26 Apr 2012 15:32:18 +0530
Message-Id: <1335434540-13286-3-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335434540-13286-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1335434540-13286-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the daqboard2000.c file that fixes up a
line over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/daqboard2000.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/daqboard2000.c b/drivers/staging/comedi/drivers/daqboard2000.c
index 9958bd5..0061f12 100644
--- a/drivers/staging/comedi/drivers/daqboard2000.c
+++ b/drivers/staging/comedi/drivers/daqboard2000.c
@@ -412,9 +412,12 @@ static int daqboard2000_ai_insn_read(struct comedi_device *dev,
 	    DAQBOARD2000_AcqResetScanListFifo |
 	    DAQBOARD2000_AcqResetResultsFifo | DAQBOARD2000_AcqResetConfigPipe;
 
-	/* If pacer clock is not set to some high value (> 10 us), we
-	   risk multiple samples to be put into the result FIFO. */
-	fpga->acqPacerClockDivLow = 1000000;	/* 1 second, should be long enough */
+	/*
+	 * If pacer clock is not set to some high value (> 10 us), we
+	 * risk multiple samples to be put into the result FIFO.
+	 */
+	/* 1 second, should be long enough */
+	fpga->acqPacerClockDivLow = 1000000;
 	fpga->acqPacerClockDivHigh = 0;
 
 	gain = CR_RANGE(insn->chanspec);
-- 
1.7.0.4

