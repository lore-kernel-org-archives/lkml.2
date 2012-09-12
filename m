Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab2ILMGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:06:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64801 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab2ILMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:06:14 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH 0/1] leds: Add new LED driver for lm3642 chips
Date: Wed, 12 Sep 2012 21:05:49 +0900
Message-Id: <1347451550-7785-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

This driver is a general version for LM642 led chip of TI.

LM3642 :
The LM3642 is a 4MHz fixed-frequency synchronous boost
converter plus 1.5A constant current driver for a high-current
white LED.
The LM3642 is controlled via an I2C-compatible interface.

G.Shark Jeong (1):
  leds: Add new LED driver for lm3642 chips

 drivers/leds/Kconfig                      |   11 +
 drivers/leds/Makefile                     |    1 +
 drivers/leds/leds-lm3642.c                |  471 +++++++++++++++++++++++++++++
 include/linux/platform_data/leds-lm3642.h |   38 +++
 4 files changed, 521 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-lm3642.c
 create mode 100644 include/linux/platform_data/leds-lm3642.h

-- 
1.7.5.4

