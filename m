Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab2DICDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:03:31 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:50377 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab2DICDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:03:30 -0400
From: Geon Si Jeong <gshark.jeong@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Geon Si Jeong <gshark.jeong@gmail.com>
Subject: [PATCH 0/1 v1] leds: Add LED driver for lm3556 chip
Date: Mon,  9 Apr 2012 11:00:54 +0900
Message-Id: <1333936855-8807-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a simple driver for LM3556 Chip(Texas Instruments)
LM3556 :
The LM3556 is a 4 MHz fixed-frequency synchronous boost
converter plus 1.5A constant current driver for a high-current white LED.
Datasheet: www.national.com/ds/LM/LM3556.pdf

Tested on OMAP4430

Geon Si Jeong (1):
  leds: Add LED driver for lm3556 chip

 drivers/leds/Kconfig        |    9 +
 drivers/leds/Makefile       |    2 +-
 drivers/leds/leds-lm3556.c  |  471 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds-lm3556.h |  242 ++++++++++++++++++++++
 4 files changed, 723 insertions(+), 1 deletions(-)
 create mode 100644 drivers/leds/leds-lm3556.c
 create mode 100644 include/linux/leds-lm3556.h

-- 
1.7.5.4

