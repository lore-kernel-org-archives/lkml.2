Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030582Ab2CBUhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 15:37:09 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:60269 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759230Ab2CBUhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 15:37:08 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX193qi5V8Lt3Arag5/yLG+TMoEduQc7UPUZlUJ4b05
	+JE/q3XlPqDrF8
Message-ID: <4F512F59.9080901@gmx.de>
Date: Fri, 02 Mar 2012 20:36:41 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: [GIT PULL] fbdev fixes#2 for 3.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull these fixes for OMAP and viafb.


Thanks,

Florian Tobias Schandinat


The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:

  git://github.com/schandinat/linux-2.6.git fbdev-fixes-for-3.3-2

for you to fetch changes up to a3d0e4aecaa32001e02d5ce860d38f14095d06d2:

  OMAPDSS: APPLY: make ovl_enable/disable synchronous (2012-02-29 22:42:28 +0000)

----------------------------------------------------------------
fbdev fixes for 3.3

It includes:
- two fixes for OMAP HDMI
- one fix to make new OMAP functions behave as they are supposed to
- one Kconfig dependency fix
- two fixes for viafb for modesetting on VX900 hardware

----------------------------------------------------------------
Archit Taneja (1):
      OMAPDSS: HACK: Ensure DSS clock domain gets out of idle when HDMI is enabled

Florian Tobias Schandinat (3):
      Merge branch 'for-3.3-rc' of git://gitorious.org/linux-omap-dss2/linux
into fbdev-for-linus
      viafb: select HW scaling on VX900 for IGA2
      viafb: fix IGA1 modesetting on VX900

Rob Clark (1):
      OMAPDSS: HDMI: hot plug detect fix

Tomi Valkeinen (2):
      OMAPDSS: panel-dvi: Add Kconfig dependency on I2C
      OMAPDSS: APPLY: make ovl_enable/disable synchronous

 drivers/video/omap2/displays/Kconfig      |    2 +-
 drivers/video/omap2/dss/apply.c           |    6 ++++++
 drivers/video/omap2/dss/hdmi.c            |   24 +++++++++++++++++++++++-
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c |    9 +--------
 drivers/video/via/hw.c                    |    4 ++++
 5 files changed, 35 insertions(+), 10 deletions(-)
