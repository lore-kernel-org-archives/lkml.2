Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2GNNdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 09:33:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64005 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab2GNNdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:33:32 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>, Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH 0/1 v1] leds: Add LED driver for lm3554 chip
Date: Sat, 14 Jul 2012 22:30:49 +0900
Message-Id: <1342272650-5304-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

LM3554 :
The LM3554 is a 2 MHz fixed-frequency synchronous boost
converter with 1.2A dual high side led drivers.
Datasheet: www.ti.com

G.Shark Jeong (1):
  leds: Add LED driver for lm3554 chip

 drivers/leds/Kconfig                      |    8 +
 drivers/leds/Makefile                     |    1 +
 drivers/leds/leds-lm3554.c                |  324 +++++++++++++++++++++++++++++
 include/linux/platform_data/leds-lm3554.h |   66 ++++++
 4 files changed, 399 insertions(+), 0 deletions(-)
 create mode 100644 drivers/leds/leds-lm3554.c
 create mode 100644 include/linux/platform_data/leds-lm3554.h

-- 
1.7.5.4

