Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab0KJMsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 07:48:24 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5393 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab0KJMsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 07:48:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6162"; a="61338751"
From: Trilok Soni <tsoni@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: linux-input@vger.kernel.org, rtc-linux@googlegroups.com,
        linux-arm-msm@vger.kernel.org, Trilok Soni <tsoni@codeaurora.org>
Subject: [RFC v1 PATCH 0/6] Qualcomm PMIC8058 sub-device drivers
Date: Wed, 10 Nov 2010 18:17:55 +0530
Message-Id: <1289393281-4459-1-git-send-email-tsoni@codeaurora.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains sub-device drivers for Qualcomm PMIC8058.
It is submitted here as RFC, due the dependent drivers like PMIC8058 core
driver and SSBI bus driver are not yet merged into the mainline. So we
are sending these patches early to get the feedback from the community.

If you want to refer the PMIC8058 core and SSBI driver then they are
here:

PMIC8058 core driver:
https://www.codeaurora.org/gitweb/quic/la/?p=kernel/msm.git;a=blob;f=drivers/mfd/pmic8058.c;h=dc561988c474721d76178ab1a2f82a3a4d1b03a1;hb=refs/heads/msm-2.6.35

SSBI driver:
https://www.codeaurora.org/gitweb/quic/la/?p=kernel/msm.git;a=blob;f=drivers/i2c/busses/i2c-ssbi.c;h=5bfcf3cb96f0c2e0f1a6b7f789458d2faf67f260;hb=refs/heads/msm-2.6.35

Anirudh Ghayal (2):
  input: pmic8058-othc: Add support for PM8058 based OTHC
  drivers: rtc: Add support for Qualcomm PMIC8058 RTC

Trilok Soni (4):
  matrix_keypad: Increase the max limit of rows and columns
  input: pm8058_keypad: Qualcomm PMIC8058 keypad controller driver
  led: pmic8058: Add PMIC8058 leds driver
  input: pmic8058_pwrkey: Add support for power key

 drivers/input/keyboard/Kconfig           |   11 +
 drivers/input/keyboard/Makefile          |    1 +
 drivers/input/keyboard/pmic8058-keypad.c |  769 ++++++++++++++++++++++++++++++
 drivers/input/misc/Kconfig               |   21 +
 drivers/input/misc/Makefile              |    2 +
 drivers/input/misc/pmic8058-othc.c       |  544 +++++++++++++++++++++
 drivers/input/misc/pmic8058-pwrkey.c     |  322 +++++++++++++
 drivers/leds/Kconfig                     |   11 +
 drivers/leds/Makefile                    |    1 +
 drivers/leds/leds-pmic8058.c             |  405 ++++++++++++++++
 drivers/rtc/Kconfig                      |    9 +
 drivers/rtc/Makefile                     |    1 +
 drivers/rtc/rtc-pm8058.c                 |  487 +++++++++++++++++++
 include/linux/input/matrix_keypad.h      |    8 +-
 include/linux/input/pmic8058-keypad.h    |   58 +++
 include/linux/input/pmic8058-othc.h      |  117 +++++
 include/linux/input/pmic8058-pwrkey.h    |   37 ++
 include/linux/leds-pmic8058.h            |   63 +++
 include/linux/rtc/rtc-pm8058.h           |   29 ++
 19 files changed, 2892 insertions(+), 4 deletions(-)
 create mode 100644 drivers/input/keyboard/pmic8058-keypad.c
 create mode 100644 drivers/input/misc/pmic8058-othc.c
 create mode 100644 drivers/input/misc/pmic8058-pwrkey.c
 create mode 100644 drivers/leds/leds-pmic8058.c
 create mode 100644 drivers/rtc/rtc-pm8058.c
 create mode 100644 include/linux/input/pmic8058-keypad.h
 create mode 100644 include/linux/input/pmic8058-othc.h
 create mode 100644 include/linux/input/pmic8058-pwrkey.h
 create mode 100644 include/linux/leds-pmic8058.h
 create mode 100644 include/linux/rtc/rtc-pm8058.h

