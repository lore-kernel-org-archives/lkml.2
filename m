Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab2EaIGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:06:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65500 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2EaIGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:06:14 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH 0/1 v2] leds: Add LED driver for lm3556 chip
Date: Thu, 31 May 2012 17:03:48 +0900
Message-Id: <1338451429-16513-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

LM3556 :
The LM3556 is a 4 MHz fixed-frequency synchronous boost
converter plus 1.5A constant current driver for a high-current white LED.
Datasheet: www.national.com/ds/LM/LM3556.pdf
Tested on OMAP4430 and SPC110

G.Shark Jeong (1):
  leds: Add LED driver for lm3556 chip

 drivers/leds/Kconfig        |    7 +
 drivers/leds/Makefile       |    1 +
 drivers/leds/leds-lm3556.c  |  463 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds-lm3556.h |  242 ++++++++++++++++++++++
 4 files changed, 713 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-lm3556.c
 create mode 100644 include/linux/leds-lm3556.h

-- 
1.7.5.4

