Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab1CDHOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 02:14:14 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36112 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1CDHON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 02:14:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=QXq3/XX+wyZKPobqIdvgQ/yCisuHPL1HnYSDqnIk+1D5YxHfFgSaOyIbieq5zEG+0e
         lH9PKA8TgT+OHHexy/E/XBoxFqXvKE7+1zrFOvEzC3281zAYRxGcB2nvVDF4rAVaTjwD
         pNlYlrcMLCcyDrUBDClqtxVVfrFGuF/h7plKE=
Subject: [PATCH 1/2] ASoC: tlv320dac33: add MODULE_DEVICE_TABLE
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain
Date: Fri, 04 Mar 2011 15:18:18 +0800
Message-Id: <1299223098.20907.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device table is required to load modules based on modaliases.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/tlv320dac33.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/sound/soc/codecs/tlv320dac33.c b/sound/soc/codecs/tlv320dac33.c
index 71d7be8..00b6d87 100644
--- a/sound/soc/codecs/tlv320dac33.c
+++ b/sound/soc/codecs/tlv320dac33.c
@@ -1615,6 +1615,7 @@ static const struct i2c_device_id tlv320dac33_i2c_id[] = {
 	},
 	{ },
 };
+MODULE_DEVICE_TABLE(i2c, tlv320dac33_i2c_id);
 
 static struct i2c_driver tlv320dac33_i2c_driver = {
 	.driver = {
-- 
1.7.2



