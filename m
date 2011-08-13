Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022Ab1HMEAu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 00:00:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59020 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1HMEAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 00:00:49 -0400
Subject: [linux-next] ASoC: sound/soc/samsung/i2s.c build failure
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 12:00:43 +0800
Message-ID: <1313208043.29596.11.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  CC      sound/soc/samsung/i2s.o
sound/soc/samsung/i2s.c:24:18: error: idma.h: No such file or directory
sound/soc/samsung/i2s.c: In function 'samsung_i2s_dai_probe':
sound/soc/samsung/i2s.c:883: error: implicit declaration of function 'idma_reg_addr_init'
make[3]: *** [sound/soc/samsung/i2s.o] Error 1
make[2]: *** [sound/soc/samsung] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2

It is caused by commit a0c27ab2421c47dc7c53f797fffcc0d17cdb122c
ASoC: Revert "ASoC: SAMSUNG: Add I2S0 internal dma driver"

To fix the build error, I think we also need to revert
commit 61100f405de5c16a0866de7843ed442090436e6a
"ASoC: SAMSUNG: Modify I2S driver to support idma".


Regards,
Axel

