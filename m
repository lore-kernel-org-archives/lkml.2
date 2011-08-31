Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab1HaMCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 08:02:33 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:60683 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab1HaMCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:02:31 -0400
From: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
Subject: [PATCH 2/3] Staging: comedi: fix error issue in cb_pcidas64.c
Date: Wed, 31 Aug 2011 17:32:18 +0530
Message-Id: <1314792138-3016-1-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <[PATCH 2/3]Staging: comedi: fix error issue in cb_pcidas64.c>
References: <[PATCH 2/3]Staging: comedi: fix error issue in cb_pcidas64.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the cb_pcidas64.c file that fixes up a ERROR: "foo * bar" should be "foo *bar" found by the checkpatch.pl tool

Signed-off-by: Ravishankar K Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index a64889b..3a8a8ea 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1194,7 +1194,7 @@ static int eeprom_read_insn(struct comedi_device *dev,
 static void check_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd);
 static unsigned int get_divisor(unsigned int ns, unsigned int flags);
 static void i2c_write(struct comedi_device *dev, unsigned int address,
-		      const uint8_t * data, unsigned int length);
+		      const uint8_t *data, unsigned int length);
 static void caldac_write(struct comedi_device *dev, unsigned int channel,
 			 unsigned int value);
 static int caldac_8800_write(struct comedi_device *dev, unsigned int address,
@@ -1309,8 +1309,8 @@ static unsigned int hw_revision(const struct comedi_device *dev,
 }
 
 static void set_dac_range_bits(struct comedi_device *dev,
-			       volatile uint16_t * bits, unsigned int channel,
-			       unsigned int range)
+		volatile uint16_t *bits, unsigned int channel,
+		unsigned int range)
 {
 	unsigned int code = board(dev)->ao_range_code[range];
 
@@ -4282,7 +4282,7 @@ static void i2c_stop(struct comedi_device *dev)
 }
 
 static void i2c_write(struct comedi_device *dev, unsigned int address,
-		      const uint8_t * data, unsigned int length)
+		const uint8_t *data, unsigned int length)
 {
 	unsigned int i;
 	uint8_t bitstream;
-- 
1.6.5.2

