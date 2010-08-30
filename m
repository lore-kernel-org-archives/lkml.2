Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0H3LGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 07:06:45 -0400
Received: from eu1sys200aog103.obsmtp.com ([207.126.144.115]:48655 "EHLO
	eu1sys200aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753033Ab0H3LGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 07:06:44 -0400
From: Arun Murthy <arun.murthy@stericsson.com>
To: <sameo@linux.intel.com>, <riku.voipio@iki.fi>, <mike@compulab.co.il>
Cc: <linux-kernel@vger.kernel.org>, <STEricsson_nomadik_linux@list.st.com>,
        <arun.murthy@stericsson.com>
Subject: [PATCH v2] u8500: led and backlight driver
Date: Mon, 30 Aug 2010 16:36:26 +0530
Message-ID: <1283166387-19296-1-git-send-email-arun.murthy@stericsson.com>
X-Mailer: git-send-email 1.7.2.dirty
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a generic pwm driver that makes use of the existing generic led
and backlight driver based on pwm(drivers/leds/leds-pwm.c and
drivers/video/backlight/pwm_bl.c ).

Arun Murthy (1):
  u8500: ab8500-pwm: Add pwm driver

 drivers/misc/Kconfig      |    9 ++
 drivers/misc/Makefile     |    1 +
 drivers/misc/ab8500-pwm.c |  195 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 205 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/ab8500-pwm.c

-- 
1.7.2.dirty

