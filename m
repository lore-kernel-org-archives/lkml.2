Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1CQIoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:44:19 -0400
Received: from linux-sh.org ([111.68.239.195]:54061 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab1CQIoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:44:15 -0400
Date: Thu, 17 Mar 2011 17:43:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev updates for 2.6.39-rc1.
Message-ID: <20110317084335.GA20220@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the first round of updates for the fbdev tree. I'm still catching
up after my mail server died, and waiting for some resends, so expect
another batch before the window closes.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git

Which contains:

Alexandre Courbot (1):
      fbdev: sh_mobile_lcdcfb: add backlight support

Damian Hobson-Garcia (1):
      fbdev: sh_mobile_lcdc: Add YUV framebuffer support

Florian Tobias Schandinat (8):
      viafb: kill lcd_panel_id
      viafb: remove unused data_mode and device_type
      viafb: strip some structures
      viafb: factor lcd scaling parameters out
      viafb: remove duplicated clock information
      viafb: always return the best possible clock
      viafb: remove duplicated clock storage
      viafb: split pll configs up

Peter Huewe (1):
      video/via: drop deprecated (and unused) i2c_adapter.id

Stephen Hemminger (2):
      video via: fix iomem access
      video via: make local variables static

 drivers/video/Kconfig             |    1 +
 drivers/video/sh_mobile_lcdcfb.c  |  222 ++++++++++--
 drivers/video/sh_mobile_lcdcfb.h  |    4 +-
 drivers/video/via/chip.h          |    9 -
 drivers/video/via/dvi.c           |    4 +-
 drivers/video/via/hw.c            |  772 ++++++++++++++++++-------------------
 drivers/video/via/hw.h            |    2 -
 drivers/video/via/lcd.c           |   83 +---
 drivers/video/via/share.h         |  141 -------
 drivers/video/via/tblDPASetting.c |   23 --
 drivers/video/via/tblDPASetting.h |    2 -
 drivers/video/via/via_i2c.c       |    3 +-
 drivers/video/via/viafbdev.c      |    6 +-
 drivers/video/via/viamode.c       |  507 ++++++++----------------
 drivers/video/via/viamode.h       |    9 -
 drivers/video/via/vt1636.c        |   43 +--
 include/video/sh_mobile_lcdc.h    |   10 +
 17 files changed, 787 insertions(+), 1054 deletions(-)
