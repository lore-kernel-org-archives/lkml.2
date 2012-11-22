Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab2KVUQF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:16:05 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:55363 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab2KVUQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:16:02 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com
Cc: broonie@opensource.wolfsonmicro.com, patches@linaro.org
Subject: [PATCH 00/10] ASoC: codec: devm_ related modifications
Date: Thu, 22 Nov 2012 09:38:32 +0530
Message-Id: <1353557322-25353-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes devm_ related modifications for sound codecs.

First 2 patches fix warning for freeing of devm_ allocated data.
The next patch introduces usage of devm_kzalloc() in wm8995 codec.
Following 7 patches introduce usage of devm_regmap_init_xxx() in
remaining codecs.

Tushar Behera (10):
  ASoC: wm8510: remove invalid free of devm_ allocated data
  ASoC: wm8753: remove invalid free of devm_ allocated data
  ASoC: wm8995: Convert to use devm_kzalloc()
  ASoC: ak4104: Convert to use devm_regmap_init_spi()
  ASoC: wm8741: Convert to use devm_regmap_init_{spi,i2c}()
  ASoC: wm8753: Convert to use devm_regmap_init_{spi,i2c}()
  ASoC: wm8804: Convert to use devm_regmap_init_{spi,i2c}()
  ASoC: wm8985: Convert to use devm_regmap_init_{spi,i2c}()
  ASoC: wm8988: Convert to use devm_regmap_init_{spi,i2c}()
  ASoC: wm8995: Convert to use devm_regmap_init_{spi,i2c}()

 sound/soc/codecs/ak4104.c |   19 ++++---------------
 sound/soc/codecs/wm8510.c |    3 ---
 sound/soc/codecs/wm8741.c |    4 ++--
 sound/soc/codecs/wm8753.c |   33 ++++++---------------------------
 sound/soc/codecs/wm8804.c |   17 ++---------------
 sound/soc/codecs/wm8985.c |   30 ++++--------------------------
 sound/soc/codecs/wm8988.c |   14 ++------------
 sound/soc/codecs/wm8995.c |   40 +++++++---------------------------------
 8 files changed, 27 insertions(+), 133 deletions(-)

-- 
1.7.4.1

