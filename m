Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab2HMFk0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 01:40:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43495 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab2HMFkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 01:40:25 -0400
From: "G.Shark Jeong" <gshark.jeong@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Daniel Jeong <daniel.jeong@ti.com>, <linux-kernel@vger.kernel.org>,
        "G.Shark Jeong" <gshark.jeong@gmail.com>
Subject: [PATCH 0/1]  backlight: add new lm3639 backlight driver
Date: Mon, 13 Aug 2012 14:37:59 +0900
Message-Id: <1344836280-15838-1-git-send-email-gshark.jeong@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "G.Shark Jeong" <gshark.jeong@gmail.com>

This driver is a general version for LM3639 backlgiht + flash driver chip of TI.

LM3639 :
The LM3639 is a single chip LCD Display Backlight driver + white LED Camera driver.
Programming is done over an I2C compatible interface.
www.ti.com

G.Shark Jeong (1):
  backlight: add new lm3639 backlight driver

 drivers/video/backlight/Kconfig         |    7 +
 drivers/video/backlight/Makefile        |    1 +
 drivers/video/backlight/lm3639_bl.c     |  436 +++++++++++++++++++++++++++++++
 include/linux/platform_data/lm3639_bl.h |   69 +++++
 4 files changed, 513 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/backlight/lm3639_bl.c
 create mode 100644 include/linux/platform_data/lm3639_bl.h

-- 
1.7.5.4

