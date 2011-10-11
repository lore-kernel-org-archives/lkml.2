Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1JKW5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 18:57:37 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59168 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab1JKW5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 18:57:36 -0400
Subject: [PATCH] ASoC: Delete ads117x.h
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 06:57:25 +0800
Message-ID: <1318373845.6115.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not required after multi-component patch.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 sound/soc/codecs/ads117x.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)
 delete mode 100644 sound/soc/codecs/ads117x.h

diff --git a/sound/soc/codecs/ads117x.h b/sound/soc/codecs/ads117x.h
deleted file mode 100644
index 3ce0286..0000000
--- a/sound/soc/codecs/ads117x.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/*
- * ads117x.h  --  Driver for ads1174/8 ADC chips
- *
- * Copyright 2009 ShotSpotter Inc.
- * Author: Graeme Gregory <gg@slimlogic.co.uk>
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- */
-extern struct snd_soc_dai_driver ads117x_dai;
-extern struct snd_soc_codec_driver soc_codec_dev_ads117x;
-- 
1.7.4.1



