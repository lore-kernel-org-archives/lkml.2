Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1K2IuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 03:50:19 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:41051 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1K2IuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 03:50:16 -0500
X-AuditID: cbfee61a-b7b62ae0000030b0-03-4ed49cc2b7c1
From: Donggeun Kim <dg77.kim@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, rpurdie@rpsys.net,
        broonie@opensource.wolfsonmicro.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, dg77.kim@samsung.com
Subject: [PATCH 0/2] leds: add MAX8997-LED driver
Date: Tue, 29 Nov 2011 17:49:57 +0900
Message-id: <1322556599-28616-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX8997 integrates serveral features in a single chip.
It includes PMIC (Power Management IC), RTC, charger, fuel gauge,
LED driver, and so on.
This patchset supports unimplemented LED driver of MAX8997.

Donggeun Kim (2):
  MFD: MAX8997: add platform data and devices for LED control
  leds: add suuport for MAX8997-LED driver

 drivers/leds/Kconfig        |    7 +
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-max8997.c |  373 +++++++++++++++++++++++++++++++++++++++++++
 drivers/mfd/max8997.c       |    2 +
 include/linux/mfd/max8997.h |   25 +++-
 5 files changed, 407 insertions(+), 1 deletions(-)
 create mode 100644 drivers/leds/leds-max8997.c

-- 
1.7.4.1

