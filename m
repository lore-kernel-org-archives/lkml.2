Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab0I2JKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 05:10:51 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:36174 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab0I2JKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 05:10:49 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: rpurdie@linux.intel.com, akpm@osdl.org
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/4] Led driver support for LP5521 and LP5523 chips
Date: Wed, 29 Sep 2010 12:10:01 +0300
Message-Id: <1285751405-22039-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes in v2 patch set:
- Documentation corrections
- Coding style corrections
- 5521 selftest return value handling changed
- check against illegal channel number value in platform data

Original cover-letter:

Patch set provides support for LP5521 and LP5523 LED driver chips
from National Semicondutor. Both drivers supports programmable engines
and naturally LED class features.

Documentation is provided as a part of the patch set.
I created "leds" sub directory to Documentation.
Perhaps rest of the leds* documentation should be moved
there.

Datasheets are freely available at National Semiconductor www pages.

Tested to work in top of 2.6.36-RC5 kernel.

Samu Onkalo (4):
  leds: driver for National Semiconductor LP5521 chip
  leds: Driver for National Semiconductors LP5523 chip
  leds: Update LP552x support Kconfig and Makefile
  Documentation: led drivers lp5521 and lp5523

 Documentation/leds/leds-lp5521.txt |   88 +++
 Documentation/leds/leds-lp5523.txt |   84 +++
 drivers/leds/Kconfig               |   18 +
 drivers/leds/Makefile              |    2 +
 drivers/leds/leds-lp5521.c         |  821 +++++++++++++++++++++++++++
 drivers/leds/leds-lp5523.c         | 1065 ++++++++++++++++++++++++++++++++++++
 include/linux/leds-lp5521.h        |   48 ++
 include/linux/leds-lp5523.h        |   48 ++
 8 files changed, 2174 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/leds/leds-lp5521.txt
 create mode 100644 Documentation/leds/leds-lp5523.txt
 create mode 100644 drivers/leds/leds-lp5521.c
 create mode 100644 drivers/leds/leds-lp5523.c
 create mode 100644 include/linux/leds-lp5521.h
 create mode 100644 include/linux/leds-lp5523.h

