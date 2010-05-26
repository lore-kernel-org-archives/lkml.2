Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934295Ab0EZL3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:29:40 -0400
Received: from smtp.nokia.com ([192.100.122.230]:33375 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934024Ab0EZL3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:29:38 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] leds: drivers for lp5521 and lp5523 chips
Date: Wed, 26 May 2010 14:29:12 +0300
Message-Id: <1274873354-1432-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 26 May 2010 11:29:14.0821 (UTC) FILETIME=[ABB8A750:01CAFCC6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LP5521 and LP5523 are LED driver chips from National Semiconductor.
Chips have many similarities but also quite many differences.
It is clearer to have separate driver for both of the chip types.
LP5521 is a 3 channel chip with 3 programmable micro engines.
LP5523 is a 9 channel chip with 3 programmable micro engines

Documentation contains short instructions about the driver and also
examples of the platform data and engine control.

Samu Onkalo (2):
  leds: driver for LP5521 and LP5523 chips from National Semiconductor
  Documentation: Short documentation for LP5521 and LP553 LED chips

 Documentation/leds-lp5521.txt |   77 ++++
 Documentation/leds-lp5523.txt |   73 +++
 drivers/leds/Kconfig          |   16 +
 drivers/leds/Makefile         |    2 +
 drivers/leds/leds-lp5521.c    |  774 +++++++++++++++++++++++++++++++
 drivers/leds/leds-lp5523.c    | 1005 +++++++++++++++++++++++++++++++++++++++++
 include/linux/leds-lp5521.h   |   23 +
 include/linux/leds-lp5523.h   |   23 +
 8 files changed, 1993 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/leds-lp5521.txt
 create mode 100644 Documentation/leds-lp5523.txt
 create mode 100644 drivers/leds/leds-lp5521.c
 create mode 100644 drivers/leds/leds-lp5523.c
 create mode 100644 include/linux/leds-lp5521.h
 create mode 100644 include/linux/leds-lp5523.h

