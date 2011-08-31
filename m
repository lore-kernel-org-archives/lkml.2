Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab1HaOiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:38:08 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38710 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1HaOiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:38:04 -0400
From: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>,
        Ravishankar K Mallikarjunayya 
	<ravishankar.km@greenturtles.in.com>
Subject: [PATCH v1 2/2] Staging: comedi: fix line over 80 charcter issue in cb_pcidda.c
Date: Wed, 31 Aug 2011 20:07:51 +0530
Message-Id: <1314801471-3821-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH V1 2/2]Staging: comedi: fix line over 80 character issue in cb_pcidda.c>
References: <[PATCH V1 2/2]Staging: comedi: fix line over 80 character issue in cb_pcidda.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidda.c file that fixes up a line over 80 charcter warning found by the checkpatch.pl tool

Signed-off-by: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in.com>
---
 long (multi-line)comments is fixed.
 drivers/staging/comedi/drivers/cb_pcidda.c |   38 +++++++++++++++++++++------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidda.c b/drivers/staging/comedi/drivers/cb_pcidda.c
index 49102b3..44e797d 100644
--- a/drivers/staging/comedi/drivers/cb_pcidda.c
+++ b/drivers/staging/comedi/drivers/cb_pcidda.c
@@ -212,9 +212,11 @@ MODULE_DEVICE_TABLE(pci, cb_pcidda_pci_table);
  */
 #define thisboard ((const struct cb_pcidda_board *)dev->board_ptr)
 
-/* this structure is for data unique to this hardware driver.  If
-   several hardware drivers keep similar information in this structure,
-   feel free to suggest moving the variable to the struct comedi_device struct.  */
+/*
+ * this structure is for data unique to this hardware driver. If
+ * several hardware drivers keep similar information in this structure,
+ * feel free to suggest moving the variable to the struct comedi_device struct.
+ */
 struct cb_pcidda_private {
 	int data;
 
@@ -241,13 +243,23 @@ struct cb_pcidda_private {
 static int cb_pcidda_attach(struct comedi_device *dev,
 			    struct comedi_devconfig *it);
 static int cb_pcidda_detach(struct comedi_device *dev);
-/* static int cb_pcidda_ai_rinsn(struct comedi_device *dev,struct comedi_subdevice *s,struct comedi_insn *insn,unsigned int *data); */
+/*
+ * static int cb_pcidda_ai_rinsn(struct comedi_device *dev,
+ * struct comedi_subdevice *s, struct comedi_insn *insn,
+ * unsigned int *data);
+ */
 static int cb_pcidda_ao_winsn(struct comedi_device *dev,
 			      struct comedi_subdevice *s,
 			      struct comedi_insn *insn, unsigned int *data);
 
-/* static int cb_pcidda_ai_cmd(struct comedi_device *dev, struct *comedi_subdevice *s);*/
-/* static int cb_pcidda_ai_cmdtest(struct comedi_device *dev, struct comedi_subdevice *s, struct comedi_cmd *cmd); */
+/*
+ * static int cb_pcidda_ai_cmd(struct comedi_device *dev,
+ * struct *comedi_subdevice *s);
+ */
+/*
+ * static int cb_pcidda_ai_cmdtest(struct comedi_device *dev,
+ * struct comedi_subdevice *s, struct comedi_cmd *cmd);
+ */
 /* static int cb_pcidda_ns_to_timer(unsigned int *ns,int *round); */
 
 static unsigned int cb_pcidda_serial_in(struct comedi_device *dev);
@@ -796,14 +808,20 @@ static unsigned int offset_eeprom_address(unsigned int ao_channel,
 	return 0x7 + 2 * range + 12 * ao_channel;
 }
 
-/* returns eeprom address that provides gain calibration for given ao channel and range */
+/*
+ * returns eeprom address that provides gain calibration
+ * for given ao channel and range
+ */
 static unsigned int gain_eeprom_address(unsigned int ao_channel,
 					unsigned int range)
 {
 	return 0x8 + 2 * range + 12 * ao_channel;
 }
 
-/* returns upper byte of eeprom entry, which gives the coarse adjustment values */
+/*
+ * returns upper byte of eeprom entry, which gives the coarse
+ * adjustment values
+ */
 static unsigned int eeprom_coarse_byte(unsigned int word)
 {
 	return (word >> 8) & 0xff;
@@ -821,7 +839,9 @@ static void cb_pcidda_calibrate(struct comedi_device *dev, unsigned int channel,
 {
 	unsigned int coarse_offset, fine_offset, coarse_gain, fine_gain;
 
-	/*  remember range so we can tell when we need to readjust calibration */
+	/*
+	 * remember range so we can tell when we need to readjust calibration
+	 */
 	devpriv->ao_range[channel] = range;
 
 	/*  get values from eeprom data */
-- 
1.6.5.2

