Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751279Ab2HMEha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 00:37:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2HMEh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 00:37:28 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH 0/1] backlight: add new lm3630 backlight driver
Date: Mon, 13 Aug 2012 13:34:30 +0900
Message-Id: <1344832471-13568-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

This driver is a general version for LM3630 backlgiht driver chip of TI. 

LM3630 :
The LM3630 is a current mode boost converter which supplies the power
and controls the current in two strings of up to 10 LEDs per string.
Programming is done over an I2C compatible interface.
www.ti.com

G.Shark Jeong (1):
  backlight: Add Backlight driver for lm3630 chip

 drivers/video/backlight/Kconfig         |    7 +
 drivers/video/backlight/Makefile        |    1 +
 drivers/video/backlight/lm3630_bl.c     |  476 +++++++++++++++++++++++++++++++
 include/linux/platform_data/lm3630_bl.h |   57 ++++
 4 files changed, 541 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/backlight/lm3630_bl.c
 create mode 100644 include/linux/platform_data/lm3630_bl.h

-- 
1.7.5.4

