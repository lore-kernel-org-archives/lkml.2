Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab2FTFOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 01:14:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33935 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2FTFO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 01:14:29 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        milo kim <milo.kim@ti.com>, "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH 0/1 v3] leds: Add LED driver for lm3556 chip
Date: Wed, 20 Jun 2012 14:11:27 +0900
Message-Id: <1340169088-4401-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

LM3556 : 
The LM3556 is a 4 MHz fixed-frequency synchronous boost 
converter plus 1.5A constant current driver for a high-current white LED. 
Datasheet: www.national.com/ds/LM/LM3556.pdf 
Tested on OMAP4430 

G.Shark Jeong (1):
  leds: Add LED driver for lm3556 chip

 drivers/leds/Kconfig                      |    7 +
 drivers/leds/Makefile                     |    1 +
 drivers/leds/leds-lm3556.c                |  529 +++++++++++++++++++++++++++++
 include/linux/platform_data/leds-lm3556.h |   50 +++
 4 files changed, 587 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-lm3556.c
 create mode 100644 include/linux/platform_data/leds-lm3556.h

-- 
1.7.5.4

