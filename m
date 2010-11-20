Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab0KTN2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 08:28:19 -0500
Received: from fallback1.mail.ru ([94.100.176.18]:58729 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab0KTN2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 08:28:18 -0500
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: alsa-devel@alsa-project.org
Cc: Eric Miao <eric.y.miao@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>,
        Harald Welte <laforge@gnumonks.org>
Subject: [PATCH 0/3] ASoC: add support for audio on iPaq hx4700
Date: Sat, 20 Nov 2010 15:59:21 +0300
Message-Id: <1290257964-17435-1-git-send-email-mad_soft@inbox.ru>
X-Mailer: git-send-email 1.7.0.4
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's three patches adding support for audio on iPaq hx4700 PDA.
AK4641 codec driver was originally written by Harald Welte for 
gnufiish project [1], then Philipp Zabel adapted it to use on hx4700.
I picked Philipp's patches from his git repository[2], updated them to
current kernel and also fixed all the issues I've met while
using these patches on my hx4700 device. So now I would like to submit
these patches for review in hope they could be included in 2.6.38.

This patchset is based on linux-next-20101119

[1] http://gnufiish.org
[2] http://git.linuxtogo.org/?p=ph5/kernel.git;a=summary


Dmitry Artamonow (2):
  ASoC: Asahi Kasei AK4641 codec driver
  ASoC: add iPAQ hx4700 machine driver

Philipp Zabel (1):
  pxa/hx4700: add I2C board info for AK4641 codec

 arch/arm/mach-pxa/hx4700.c              |   18 +
 arch/arm/mach-pxa/include/mach/hx4700.h |    4 +-
 include/sound/ak4641.h                  |   26 ++
 sound/soc/codecs/Kconfig                |    4 +
 sound/soc/codecs/Makefile               |    2 +
 sound/soc/codecs/ak4641.c               |  628 +++++++++++++++++++++++++++++++
 sound/soc/codecs/ak4641.h               |   47 +++
 sound/soc/pxa/Kconfig                   |    9 +
 sound/soc/pxa/Makefile                  |    2 +
 sound/soc/pxa/hx4700.c                  |  253 +++++++++++++
 10 files changed, 991 insertions(+), 2 deletions(-)
 create mode 100644 include/sound/ak4641.h
 create mode 100644 sound/soc/codecs/ak4641.c
 create mode 100644 sound/soc/codecs/ak4641.h
 create mode 100644 sound/soc/pxa/hx4700.c

