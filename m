Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab2HAMKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:10:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63932 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab2HAMKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:10:02 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH 0/1]  leds: Add LED driver for lm355x chips
Date: Wed,  1 Aug 2012 21:05:55 +0900
Message-Id: <1343822756-3373-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

LM3554 and LM3556 have similar functions but very different register map.
This driver is a general version for LM355x,lm3554 and lm3556,led chips of TI.
lm3556 driver can be replaced by this driver.

LM3554 :
The LM3554 is a 2 MHz fixed-frequency synchronous boost
converter with 1.2A dual high side led drivers.
Datasheet: www.ti.com/lit/ds/symlink/lm3554.pdf

LM3556 :
The LM3556 is a 4 MHz fixed-frequency synchronous boost
converter plus 1.5A constant current driver for a high-current white LED.
Datasheet: www.national.com/ds/LM/LM3556.pdf

G.Shark Jeong (1):
  leds: Add LED driver for lm355x chips

 drivers/leds/Kconfig                      |    8 +-
 drivers/leds/Makefile                     |    2 +-
 drivers/leds/leds-lm355x.c                |  529 +++++++++++++++++++++++++++++
 include/linux/platform_data/leds-lm355x.h |   66 ++++
 4 files changed, 600 insertions(+), 5 deletions(-)
 create mode 100644 drivers/leds/leds-lm355x.c
 create mode 100644 include/linux/platform_data/leds-lm355x.h

-- 
1.7.5.4

