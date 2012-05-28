Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2E1Vxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 17:53:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46397 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab2E1Vxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 17:53:47 -0400
From: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
Subject: [PATCH 1/2] staging: comedi: cb_pcidas64: Fixed coding style errors
Date: Tue, 29 May 2012 00:51:44 +0300
Message-Id: <1338241905-24327-1-git-send-email-dimitrios.semitsoglou@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1338229715-2730-1-git-send-email-dimitrios.semitsoglou@gmail.com>
References: <1338229715-2730-1-git-send-email-dimitrios.semitsoglou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a few coding style errors in cb_pcidas64.

Signed-off-by: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 9d0b875..6f7fd99 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -1153,7 +1153,7 @@ static int eeprom_read_insn(struct comedi_device *dev,
 static void check_adc_timing(struct comedi_device *dev, struct comedi_cmd *cmd);
 static unsigned int get_divisor(unsigned int ns, unsigned int flags);
 static void i2c_write(struct comedi_device *dev, unsigned int address,
-		      const uint8_t * data, unsigned int length);
+		      const uint8_t *data, unsigned int length);
 static void caldac_write(struct comedi_device *dev, unsigned int channel,
 			 unsigned int value);
 static int caldac_8800_write(struct comedi_device *dev, unsigned int address,
@@ -1230,7 +1230,7 @@ static unsigned int hw_revision(const struct comedi_device *dev,
 }
 
 static void set_dac_range_bits(struct comedi_device *dev,
-			       volatile uint16_t * bits, unsigned int channel,
+			       volatile uint16_t *bits, unsigned int channel,
 			       unsigned int range)
 {
 	unsigned int code = board(dev)->ao_range_code[range];
@@ -4191,7 +4191,7 @@ static void i2c_stop(struct comedi_device *dev)
 }
 
 static void i2c_write(struct comedi_device *dev, unsigned int address,
-		      const uint8_t * data, unsigned int length)
+		      const uint8_t *data, unsigned int length)
 {
 	unsigned int i;
 	uint8_t bitstream;
-- 
1.7.10.2

