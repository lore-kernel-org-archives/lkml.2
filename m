Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab0HSMKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 08:10:08 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:62348 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab0HSMKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 08:10:05 -0400
From: "Krogerus Heikki (EXT-Teleca/Helsinki)" 
	<ext-heikki.krogerus@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, dwmw2@infradead.org, cbou@mail.ru,
        felipe.balbi@nokia.com, ameya.palande@nokia.com,
        markus.lehtonen@nokia.com, roger.quadros@nokia.com
Subject: [PATCHv2 0/2] add isp1704 power supply driver
Date: Thu, 19 Aug 2010 15:09:35 +0300
Message-Id: <1282219777-17657-1-git-send-email-ext-heikki.krogerus@nokia.com>
X-Mailer: git-send-email 1.7.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heikki Krogerus <ext-heikki.krogerus@nokia.com>

There are a few modifications in isp1704_charger_work() and in
isp1704_notifier_call() that I would like you guys to check.

Changes since v1:
- No more platform_device registering in the driver
- in Kconfig, only depending on USB_OTG_UTILS
- power_supply_changed() called only when isp->present changed
- cleanups

Heikki Krogerus (2):
  power_supply: add isp1704 charger detection driver
  omap: rx51: add support for USB chargers

 arch/arm/mach-omap2/board-rx51-peripherals.c |    5 +
 drivers/power/Kconfig                        |    7 +
 drivers/power/Makefile                       |    1 +
 drivers/power/isp1704_charger.c              |  370 ++++++++++++++++++++++++++
 4 files changed, 383 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/isp1704_charger.c

