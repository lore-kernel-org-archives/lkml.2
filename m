Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031774Ab2CPNi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 09:38:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37244 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab2CPNiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 09:38:21 -0400
From: Sourav Poddar <sourav.poddar@ti.com>
To: <dmitry.torokhov@gmail.com>, <linux-input@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <balbi@ti.com>
Subject: [PATCH 0/2] Omap keypad cleanup and omap5 support
Date: Fri, 16 Mar 2012 19:09:17 +0530
Message-ID: <1331905159-11255-1-git-send-email-sourav.poddar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The series consists of two patches.
Patch1 of the series makes omap4 keypad independent of the
architecture by moving platform_data to <linux/platform_data>

Patch2 add support for omap5 onchip keypad.

Tested on omap4430sdp using 3.3-rc6.
Tested on omap5 board using 3.1 custom kernel. 

Felipe Balbi (1):
  input: keypad: move platform_data to <linux/platform_data>

G, Manjunath Kondaiah (1):
  Input: omap-keypad: dynamically handle register offsets

 arch/arm/mach-omap2/board-4430sdp.c            |    1 +
 arch/arm/mach-omap2/devices.c                  |    1 +
 arch/arm/plat-omap/include/plat/omap4-keypad.h |    9 --
 drivers/input/keyboard/Kconfig                 |    7 +-
 drivers/input/keyboard/omap4-keypad.c          |  124 +++++++++++++++++++-----
 include/linux/platform_data/omap4-keypad.h     |   13 +++
 6 files changed, 118 insertions(+), 37 deletions(-)
 create mode 100644 include/linux/platform_data/omap4-keypad.h

