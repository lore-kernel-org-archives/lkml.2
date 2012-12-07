Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2LGLn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 06:43:27 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58329 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099Ab2LGLn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 06:43:26 -0500
From: Afzal Mohammed <afzal@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Vaibhav Hiremath <hvaibhav@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/10] video: da8xx-fb: runtime timing configuration and cleanup
Date: Fri, 7 Dec 2012 17:13:18 +0530
Message-ID: <cover.1354874432.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series makes da8xx-fb driver (device found on DaVinci and AM335x)
capable of handling runtime timing configuration by adding fb_set_par.

The last change adds actual fb_set_par support. Other preceeding
changes makes the way clear for it as well as does certain cleanup's
on the way.

This has been tested on DA850 EVM.

Not sure whether Florian or Tomi would be handling fbdev patches after
the coming merge window, as Tomi is queueing fbdev patches currently,
these changes has been made over Tomi Valkeinen's for-next branch.

Regards
Afzal

Afzal Mohammed (10):
  video: da8xx-fb: fb_check_var enhancement
  video: da8xx-fb: simplify lcd_reset
  video: da8xx-fb: use modedb helper to update var
  video: da8xx-fb: remove unneeded "var" initialization
  video: da8xx-fb: store current display information
  video: da8xx-fb: store clk rate even if !CPUFREQ
  video: da8xx-fb: pix clk and clk div handling cleanup
  video: da8xx-fb: store struct device *
  video: da8xx-fb: report correct pixclock
  video: da8xx-fb: fb_set_par support

 drivers/video/da8xx-fb.c | 181 +++++++++++++++++++++++++++--------------------
 1 file changed, 105 insertions(+), 76 deletions(-)

-- 
1.7.12

