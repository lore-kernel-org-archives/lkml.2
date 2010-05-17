Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab0EQQxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:53:46 -0400
Received: from smtp3.epfl.ch ([128.178.224.226]:55858 "HELO smtp3.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754606Ab0EQQxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:53:42 -0400
From: =?utf-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
To: s.hauer@pengutronix.de
Cc: u.kleine-koenig@pengutronix.de, maramaopercheseimorto@gmail.com,
       sameo@linux.intel.com, valentin.longchamp@epfl.ch,
       rpurdie@linux.intel.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       =?utf-8?q?Philippe=20R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>
Subject: [PATCH 0/2] mc13783: LED support
Date: Mon, 17 May 2010 18:40:21 +0200
Message-Id: <1274114423-30020-1-git-send-email-philippe.retornaz@epfl.ch>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

This adds led support for the MC13783 PMIC. 
The first patch modify the mc13783 MFD driver to add a led subdevice
and also adds the leds-mc13783 driver.

The second patch adds the RGB leds support on the mx31moboard boards.

I have only tested the RGB led part since I don't have the hardware 
to test with the others leds. 

Regards,
Philippe

Philippe Rétornaz (2):
  mc13783: add LED support
  mx31moboard: Add MC13783 led support

 arch/arm/mach-mx3/mach-mx31moboard.c |   45 ++++-
 drivers/leds/Kconfig                 |    7 +
 drivers/leds/Makefile                |    1 +
 drivers/leds/leds-mc13783.c          |  375 ++++++++++++++++++++++++++++++++++
 drivers/mfd/mc13783-core.c           |    4 +
 include/linux/mfd/mc13783.h          |   68 ++++++
 6 files changed, 499 insertions(+), 1 deletions(-)
 create mode 100644 drivers/leds/leds-mc13783.c

