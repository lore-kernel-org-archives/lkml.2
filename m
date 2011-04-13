Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188Ab1DMMZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 08:25:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27540 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535Ab1DMMZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:25:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6314"; a="85536590"
From: Mohan Pallaka <mpallaka@codeaurora.org>
To: dmitry.torokhov@gmail.com
Cc: Mohan Pallaka <mpallaka@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.intradead.org,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: [PATCH 0/2] Support for isa1200 haptic chip
Date: Wed, 13 Apr 2011 17:55:31 +0530
Message-Id: <1302697533-20456-1-git-send-email-mpallaka@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset includes a __weak attributed pwm apis in pwm.h and
a ff-memless based isa1200 driver.

ISA1200 chip can operate in two modes and if the chip has been
configured for pwm-generation mode, which doesn't use pwm standard
apis then it'd encounter compilation errors if the host doesn't
support PWM. This driver is based on Park's isa1200 driver that uses
haptic class.

Kyungmin Park (1):
  input: misc: Add support for isa1200 chip

Mohan Pallaka (1):
  pwm: Add __weak attributed functions for pwm operations

 drivers/input/misc/Kconfig    |   12 +
 drivers/input/misc/Makefile   |    1 +
 drivers/input/misc/isa1200.c  |  442 +++++++++++++++++++++++++++++++++++++++++
 include/linux/input/isa1200.h |   46 +++++
 include/linux/pwm.h           |   21 ++-
 5 files changed, 517 insertions(+), 5 deletions(-)
 create mode 100644 drivers/input/misc/isa1200.c
 create mode 100644 include/linux/input/isa1200.h

