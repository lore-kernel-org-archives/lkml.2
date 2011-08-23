Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1HWLqL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 07:46:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51895 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab1HWLqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 07:46:08 -0400
Subject: [linux-next] ASoC: build failure if CONFIG_I2C=m && CONFIG_SPI=y
 && CONFIG_SND_SOC=y
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 19:46:00 +0800
Message-ID: <1314099960.13722.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi,
I got below build failure if CONFIG_I2C=m && CONFIG_SPI=y && CONFIG_SND_SOC=y

  LD      .tmp_vmlinux1
sound/built-in.o: In function `snd_soc_codec_set_cache_io':
last.c:(.text+0x1cb80): undefined reference to `regmap_init_i2c'
make: *** [.tmp_vmlinux1] Error 1

Regards,
Axel



