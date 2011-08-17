Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1HQGzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 02:55:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61541 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab1HQGzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 02:55:07 -0400
From: Ravishankar <ravishankarkm32@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>,
        Ravishankar <ravishankarkm32@gmail.com>
Subject: [PATCH] Staging: comedi: fix line over 80 charcter issue in cb_pcidda.c
Date: Wed, 17 Aug 2011 02:54:45 -0400
Message-Id: <1313564085-2842-1-git-send-email-ravishankarkm32@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <[PATCH]Staging:comedi:fix line over 80 character issue in cb_pcidda.c>
References: <[PATCH]Staging:comedi:fix line over 80 character issue in cb_pcidda.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ravishankar <ravi.shankar@greenturtles.in>

This is a patch to the ni_labpc.c file that fixes up a line over 80 charcter warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidda.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 49102b3..5c7d454 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -227,8 +227,10 @@ struct cb_pcidda_private {
 	/* unsigned long control_status; */
 	/* unsigned long adc_fifo; */
 
-	unsigned int dac_cal1_bits;	/*  bits last written to da calibration register 1 */
-	unsigned int ao_range[MAX_AO_CHANNELS];	/*  current range settings for output channels */
+	/* bits last written to da calibration register 1 */
+	unsigned int dac_cal1_bits;
+	/* current range settings for output channels */
+	unsigned int ao_range[MAX_AO_CHANNELS];
 	u16 eeprom_data[EEPROM_SIZE];	/*  software copy of board's eeprom */
 };
 
-- 
1.7.6

