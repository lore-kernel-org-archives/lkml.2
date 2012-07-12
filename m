Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab2GLKJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:09:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41488 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366Ab2GLKJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:09:09 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        =?UTF-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 0/7] Add support for Freescale's mc34708 to mc13xxx driver
Date: Thu, 12 Jul 2012 11:57:46 +0200
Message-Id: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series was tested on a Phytec pcm038 (mc13783 on spi) using
traditional boot (i.e. not dt) and on a i.MX53 based machine (mc34708 on
i2c) using dt boot.

Philippe's patches are already in next, they are just included here for
those who want to test the patches. The 'mfd/mc13xxx: drop modifying
driver's id_table in probe' was already sent out yesterday and is
included here because the last patch depends on it.

Best regards
Uwe

Philippe Rétornaz (2):
  MFD: Fix mc13xxx SPI regmap
  MFD: mc13xxx workaround SPI hardware bug on i.Mx

Uwe Kleine-König (5):
  rtc/mc13xxx: use MODULE_DEVICE_TABLE instead of MODULE_ALIAS
  rtc/mc13xxx: add support for the rtc in the mc34708 pmic
  mfd/mc13xxx: drop modifying driver's id_table in probe
  mfd/mc13xxx: change probing details for mc13xxx devices
  mfd/mc13xxx: add support for mc34708

 drivers/mfd/mc13xxx-core.c |   94 ++++++++++++++++++++--------------------
 drivers/mfd/mc13xxx-i2c.c  |   28 ++++++------
 drivers/mfd/mc13xxx-spi.c  |  102 +++++++++++++++++++++++++++++++++++---------
 drivers/mfd/mc13xxx.h      |   18 +++++---
 drivers/rtc/rtc-mc13xxx.c  |    6 ++-
 5 files changed, 159 insertions(+), 89 deletions(-)

-- 
1.7.10.4

