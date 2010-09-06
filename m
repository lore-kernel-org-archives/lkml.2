Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab0IFGzf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 02:55:35 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:42582 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750890Ab0IFGze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 02:55:34 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <sameo@linux.intel.com>, <riku.voipio@iki.fi>, <mike@compulab.co.il>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>
Subject: [PATCHv3 0/1] u8500: led and backlight driver
Date: Mon, 6 Sep 2010 12:24:51 +0530
Message-ID: <1283756092-31473-1-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a generic pwm driver that makes use of the existing generic led
and backlight driver based on pwm(drivers/leds/leds-pwm.c and
drivers/video/backlight/pwm_bl.c ).

Implemented comments from Mike Rapoport.

Arun Murthy (1):
  u8500: ab8500-pwm: Add pwm driver

 drivers/mfd/ab8500-core.c |   13 +++-
 drivers/misc/Kconfig      |    9 +++
 drivers/misc/Makefile     |    1 +
 drivers/misc/ab8500-pwm.c |  174 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 196 insertions(+), 1 deletions(-)
 create mode 100644 drivers/misc/ab8500-pwm.c

-- 
1.7.2.dirty

