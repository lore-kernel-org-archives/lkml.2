Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab2FPUAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 16:00:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:49799 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755952Ab2FPUAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 16:00:53 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+4QgZBrjC4Hl5Ju+djmWHOUPCSxdFkdDW7Ph+WbC
	BFeToQU1wr8dCc
Message-ID: <4FDCE5F2.8010309@gmx.de>
Date: Sat, 16 Jun 2012 20:00:50 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120506 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the fixes below.


Thanks,

Florian Tobias Schandinat


The following changes since commit c895305e806b4346006d3cfba2b432d52268ecd3:

  video: bfin_adv7393fb: Fix cleanup code (2012-05-29 13:16:45 +0000)

are available in the git repository at:

  git://github.com/schandinat/linux-2.6.git fbdev-fixes-for-3.5-1

for you to fetch changes up to b67989515defba7412acff01162e5bb1f0f5923a:

  video: s3c-fb: fix possible division by zero in s3c_fb_calc_pixclk (2012-06-13 17:34:16 +0000)

----------------------------------------------------------------
fbdev fixes for 3.5

- two fixes for s3c-fb by Jingoo Han
  (including a fix for a potential division by zero)
- a couple of randconfig fixes by Arnd Bergmann
- a cleanup for bfin_adv7393fb by Emil Goode

----------------------------------------------------------------
Archit Taneja (1):
      OMAPDSS: DSI: Fix bug when calculating LP command interleaving parameters

Arnd Bergmann (5):
      drivers/video: use correct __devexit_p annotation
      video/ili9320: do not mark exported functions __devexit
      video/console: automatically select a font
      drivers/savagefb: use mdelay instead of udelay
      drivers/tosa: driver needs I2C and SPI to compile

Emil Goode (1):
      video: bfin_adv7393fb: Convert to kstrtouint_from_user

Florian Tobias Schandinat (1):
      Merge tag 'omapdss-for-3.5-rc2' of git://gitorious.org/linux-omap-dss2/linux into fbdev-for-linus

Jingoo Han (2):
      video: s3c-fb: clear SHADOWCON register when clearing hardware window registers
      video: s3c-fb: fix possible division by zero in s3c_fb_calc_pixclk

Tomi Valkeinen (4):
      OMAPDSS: fix build when DEBUG_FS or DSS_DEBUG_SUPPORT disabled
      OMAPDSS: Taal: fix compilation warning
      OMAPDSS: fix bogus WARN_ON in dss_runtime_put()
      OMAPDSS: fix registration of DPI and SDI devices

 arch/arm/mach-omap2/display.c             |    4 ++--
 drivers/video/backlight/Kconfig           |    2 +-
 drivers/video/backlight/ili9320.c         |    2 +-
 drivers/video/bfin_adv7393fb.c            |    6 ++----
 drivers/video/broadsheetfb.c              |    2 +-
 drivers/video/console/Kconfig             |   14 ++++++++++++++
 drivers/video/mbx/mbxfb.c                 |    2 +-
 drivers/video/omap2/displays/panel-taal.c |    2 +-
 drivers/video/omap2/dss/core.c            |    3 +--
 drivers/video/omap2/dss/dsi.c             |    2 +-
 drivers/video/omap2/dss/dss.c             |    2 +-
 drivers/video/s3c-fb.c                    |   12 +++++++++---
 drivers/video/savage/savagefb_driver.c    |   10 +++++-----
 13 files changed, 40 insertions(+), 23 deletions(-)

