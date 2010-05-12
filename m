Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab0ELApR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:45:17 -0400
Received: from blue-ld-261.synserver.de ([217.119.54.83]:46174 "EHLO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754008Ab0ELApM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:45:12 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 1517
From: Lars-Peter Clausen <lars@metafoo.de>
To: rpurdie@rpsys.net
Cc: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/3] Add pcf50633 backlight driver
Date: Wed, 12 May 2010 02:44:31 +0200
Message-Id: <1273625074-15312-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This patch series adds a backlight driver for the pcf50633.
The first patch adds the backlight driver, the second patch registers the
backlight driver in the pcf50633 core driver and the third patch replaces the
platform backlight driver in mach-gta02 with the pcf50633 backlight driver.

- Lars

Lars-Peter Clausen (3):
  backlight/mfd: Add pcf50633 backlight driver
  pcf50633: Register a pcf50633-backlight device in pcf50633 core
    driver.
  gta02: Use pcf50633 backlight driver instead of platform backlight
    driver.

 arch/arm/mach-s3c2440/mach-gta02.c           |   76 ++---------
 drivers/mfd/pcf50633-core.c                  |    3 +
 drivers/video/backlight/Kconfig              |    7 +
 drivers/video/backlight/Makefile             |    1 +
 drivers/video/backlight/pcf50633-backlight.c |  190 ++++++++++++++++++++++++++
 include/linux/mfd/pcf50633/backlight.h       |   51 +++++++
 include/linux/mfd/pcf50633/core.h            |    4 +
 7 files changed, 265 insertions(+), 67 deletions(-)
 create mode 100644 drivers/video/backlight/pcf50633-backlight.c
 create mode 100644 include/linux/mfd/pcf50633/backlight.h

