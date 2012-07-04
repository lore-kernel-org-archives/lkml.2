Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab2GDFKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:10:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54629 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab2GDFK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:10:28 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/25] leds: convert all kzalloc() to devm_kzalloc()
Date: Wed,  4 Jul 2012 13:09:52 +0800
Message-Id: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This convertion will simply the error handling in drivers.

Bryan Wu (25):
  leds: convert Big Networks LED driver to devm_kzalloc()
  leds: convert HTC ASIC3 LED driver to devm_kzalloc() and cleanup
    error exit path
  leds: convert Atmel PWM LED driver to devm_kzalloc()
  leds: convert LP3944 LED driver to devm_kzalloc()
  leds: convert DA9030/DA9034 LED driver to devm_kzalloc() and cleanup
    error exit path
  leds: convert LP5521 LED driver to devm_kzalloc() and cleanup error
    exit path
  leds: convert BD2802 RGB LED driver to devm_kzalloc() and cleanup
    error exit path
  leds: convert PCA9633 LED driver to devm_kzalloc()
  leds: convert LP5523 LED driver to devm_kzalloc() and cleanup error
    exit path
  leds: convert Renesas TPU LED driver to devm_kzalloc() and cleanup
    error exit path
  leds: convert LT3593 LED driver to devm_kzalloc()
  leds: convert PCA9532 LED driver to devm_kzalloc()
  leds: convert Sun Fire LED driver to devm_kzalloc() and cleanup error
    exit path
  leds: convert PCA955x LED driver to devm_kzalloc() and cleanup error
    exit path
  leds: convert ADP5520 LED driver to devm_kzalloc() and cleanup error
    exit path
  leds: convert Freescale MC13783 LED driver to devm_kzalloc() and
    cleanup error exit path
  leds: convert TCA6507 LED driver to devm_kzalloc()
  leds: convert LM3530 LED driver to devm_kzalloc() and cleanup error
    exit path
  leds: convert DAC124S085 LED driver to devm_kzalloc()
  leds: convert Network Space v2 LED driver to devm_kzalloc() and
    cleanup error exit path
  leds: convert transient LED trigger driver to devm_kzalloc()
  leds: convert GPIO LED trigger driver to devm_kzalloc() and cleanup
    error exit path
  leds: convert Backlight emulation LED trigger driver to
    devm_kzalloc() and cleanup error exit path
  leds: convert Heartbeat LED trigger driver to devm_kzalloc()
  leds: convert One-shot LED trigger driver to devm_kzalloc() and
    cleanup error exit path

 drivers/leds/leds-adp5520.c      |    8 +++-----
 drivers/leds/leds-asic3.c        |   16 ++++++----------
 drivers/leds/leds-atmel-pwm.c    |    5 ++---
 drivers/leds/leds-bd2802.c       |    8 ++------
 drivers/leds/leds-da903x.c       |    9 ++-------
 drivers/leds/leds-dac124s085.c   |    4 +---
 drivers/leds/leds-lm3530.c       |   24 ++++++++----------------
 drivers/leds/leds-lp3944.c       |    9 +++------
 drivers/leds/leds-lp5521.c       |   18 +++++++-----------
 drivers/leds/leds-lp5523.c       |   24 ++++++++++--------------
 drivers/leds/leds-lt3593.c       |    9 +++------
 drivers/leds/leds-mc13783.c      |    8 +++-----
 drivers/leds/leds-netxbig.c      |   10 +++-------
 drivers/leds/leds-ns2.c          |   19 ++++++-------------
 drivers/leds/leds-pca9532.c      |   10 ++--------
 drivers/leds/leds-pca955x.c      |   18 +++++-------------
 drivers/leds/leds-pca9633.c      |    6 +-----
 drivers/leds/leds-renesas-tpu.c  |   23 +++++++++--------------
 drivers/leds/leds-sunfire.c      |   21 ++++++---------------
 drivers/leds/leds-tca6507.c      |    4 +---
 drivers/leds/ledtrig-backlight.c |   10 +++-------
 drivers/leds/ledtrig-gpio.c      |    8 ++------
 drivers/leds/ledtrig-heartbeat.c |    4 ++--
 drivers/leds/ledtrig-oneshot.c   |    8 +++-----
 drivers/leds/ledtrig-transient.c |    5 ++---
 25 files changed, 95 insertions(+), 193 deletions(-)

-- 
1.7.10.4

