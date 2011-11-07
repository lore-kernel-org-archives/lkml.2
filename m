Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1KGPos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:44:48 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43058 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1KGPoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:44:44 -0500
From: Jonathan Cameron <jic23@kernel.org>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: guenter.roeck@ericsson.com, khali@linux-fr.org, dmitry.torokhov@gmail.com,
        broonie@opensource.wolfsonmicro.com, gregkh@suse.de,
        alan@lxorguk.ukuu.org.uk, arnd@arndb.de, linus.walleij@linaro.org,
        lars@metafoo.de, maxime.ripard@free-electrons.com,
        lm-sensors@lm-sensors.org, thomas.petazzoni@free-electrons.com,
        zdevai@gmail.com, Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 2/5] IIO:ADC:max1363 add datasheet_name entries.
Date: Mon,  7 Nov 2011 15:44:38 +0000
Message-Id: <1320680681-5635-3-git-send-email-jic23@kernel.org>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1320680681-5635-1-git-send-email-jic23@kernel.org>
References: <1320680681-5635-1-git-send-email-jic23@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

Kind of obvious for this device but useful
for testing purposes.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/iio/adc/max1363_core.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/iio/adc/max1363_core.c b/drivers/iio/adc/max1363_core.c
index f21ec63..603969b 100644
--- a/drivers/iio/adc/max1363_core.c
+++ b/drivers/iio/adc/max1363_core.c
@@ -252,6 +252,7 @@ static const enum max1363_modes max1363_mode_list[] = {
 		.channel = num,						\
 		.address = addr,					\
 		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,		\
+		.datasheet_name = "AIN"#num				\
 	}								\
 
 /* bipolar channel */
@@ -264,6 +265,7 @@ static const enum max1363_modes max1363_mode_list[] = {
 		.channel2 = num2,					\
 		.address = addr,					\
 		.info_mask = IIO_CHAN_INFO_SCALE_SHARED_BIT,		\
+		.datasheet_name = "AIN"#num"-AIN"#num2			\
 	}
 
 
-- 
1.7.7.2

