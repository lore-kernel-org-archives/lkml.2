Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab1JSOrP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:47:15 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:35325 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab1JSOrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:47:10 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Cc: linus.ml.walleij@gmail.com, zdevai@gmail.com, linux@arm.linux.org.uk,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        lm-sensors@lm-sensors.org, guenter.roeck@ericsson.com,
        khali@linux-fr.org, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 2/6] IIO:ADC:max1363 add datasheet_name entries.
Date: Wed, 19 Oct 2011 15:47:04 +0100
Message-Id: <1319035628-32580-3-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1319035628-32580-1-git-send-email-jic23@cam.ac.uk>
References: <1319035628-32580-1-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kind of obvious for this device but useful
for testing purposes.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/iio/adc/max1363_core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/iio/adc/max1363_core.c b/drivers/iio/adc/max1363_core.c
index ee06d48..e035df9 100644
--- a/drivers/iio/adc/max1363_core.c
+++ b/drivers/iio/adc/max1363_core.c
@@ -251,7 +251,8 @@ static const enum max1363_modes max1363_mode_list[] = {
 		.indexed = 1,						\
 		.channel = num,						\
 		.address = addr,					\
-		.info_mask = MAX1363_INFO_MASK				\
+		.info_mask = MAX1363_INFO_MASK,				\
+		.datasheet_name = "AIN"#num				\
 	}								\
 
 /* bipolar channel */
@@ -264,6 +265,7 @@ static const enum max1363_modes max1363_mode_list[] = {
 		.channel2 = num2,					\
 		.address = addr,					\
 		.info_mask = MAX1363_INFO_MASK,				\
+		.datasheet_name = "AIN"#num"-AIN"#num2			\
 	}
 #define MAX1363_INFO_MASK (1 << IIO_CHAN_INFO_SCALE_SHARED)
 
-- 
1.7.7

