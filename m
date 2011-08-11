Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160Ab1HKOT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:19:28 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51898 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab1HKOT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:19:26 -0400
Subject: [PATCH] ASoC: sgtl5000: fix module device table type for
 sgtl5000_dt_ids
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shawn Guo <shawn.guo@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 22:19:16 +0800
Message-ID: <1313072356.9215.0.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module device table for of_device_id should use "of" type.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/sgtl5000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 666fae6..91130fb 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1441,7 +1441,7 @@ static const struct of_device_id sgtl5000_dt_ids[] = {
 	{ .compatible = "fsl,sgtl5000", },
 	{ /* sentinel */ }
 };
-MODULE_DEVICE_TABLE(i2c, sgtl5000_dt_ids);
+MODULE_DEVICE_TABLE(of, sgtl5000_dt_ids);
 
 static struct i2c_driver sgtl5000_i2c_driver = {
 	.driver = {
-- 
1.7.4.1



