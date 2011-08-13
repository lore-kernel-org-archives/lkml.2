Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1HMCMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 22:12:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56595 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab1HMCMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 22:12:13 -0400
Subject: [linux-next] ASoC: build failure with make eseries_pxa_defconfig
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 10:12:01 +0800
Message-ID: <1313201521.12790.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Mark,
In the case of build with "make eseries_pxa_defconfig;make",
both i2c and spi support are not configured.
Thus CONFIG_REGMAP is default to disable.

Then I got below build error:

ERROR: "regmap_raw_write" [sound/soc/snd-soc-core.ko] undefined!
ERROR: "regmap_read" [sound/soc/snd-soc-core.ko] undefined!
ERROR: "regmap_write" [sound/soc/snd-soc-core.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

Regards,
Axel


