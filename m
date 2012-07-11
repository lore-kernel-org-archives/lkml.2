Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab2GKWla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:41:30 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37878 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751166Ab2GKWl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:41:29 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+iAlkkItGixmDGQ3nJJ/MbJkVGfm6zrTR40PrCFl
	YCmWbunGiKJFFm
Message-ID: <4FFE011C.7020902@gmx.de>
Date: Wed, 11 Jul 2012 22:41:32 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes for 3.5#2
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


The following changes since commit b67989515defba7412acff01162e5bb1f0f5923a:

  video: s3c-fb: fix possible division by zero in s3c_fb_calc_pixclk (2012-06-13 17:34:16 +0000)

are available in the git repository at:

  git://github.com/schandinat/linux-2.6.git fbdev-fixes-for-3.5-2

for you to fetch changes up to 373b43652150c9342168c846a1efbd81438ea241:

  OMAPDSS: fix warnings if CONFIG_PM_RUNTIME=n (2012-07-08 14:00:27 +0000)

----------------------------------------------------------------
fbdev fixes for 3.5

- two fixes for OMAPDSS by Tomi Valkeinen
  one to avoid warnings when runtime PM is not enabled
  one workaround to dependancy issues during suspend/resume

----------------------------------------------------------------
Tomi Valkeinen (2):
      OMAPDSS: Use PM notifiers for system suspend
      OMAPDSS: fix warnings if CONFIG_PM_RUNTIME=n

 drivers/video/omap2/dss/core.c  |   43 ++++++++++++++++++++++++--------------
 drivers/video/omap2/dss/dispc.c |    2 +-
 drivers/video/omap2/dss/dsi.c   |    2 +-
 drivers/video/omap2/dss/dss.c   |    2 +-
 drivers/video/omap2/dss/hdmi.c  |    2 +-
 drivers/video/omap2/dss/rfbi.c  |    2 +-
 drivers/video/omap2/dss/venc.c  |    2 +-
 7 files changed, 33 insertions(+), 22 deletions(-)
