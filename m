Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab0KOGZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 01:25:53 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39301 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab0KOGZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 01:25:49 -0500
Date: Mon, 15 Nov 2010 15:25:17 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] fbdev updates for 2.6.37-rc2
Message-ID: <20101115062516.GA24960@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This marks the first batch of fixes from the newly created fbdev git
tree. As noted on the list and to the driver tree owners, I'll be looking
after this for the forseeable future. This will hopefully ease some of
the pressure on -mm in addition to weaning off the various fb driver
trees from merging directly in lieu of a proper subsystem tree to go
through. This tree is now what it is also pulled in to -next, both fixes
and development branches.

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/fbdev-2.6.git fbdev-fixes-for-linus

Which contains:

Aaro Koskinen (1):
      sisfb: limit POST memory test according to PCI resource length

Guennadi Liakhovetski (3):
      fbdev: sh_mobile_hdmi: properly clean up modedb on monitor unplug
      fbdev: sh_mobile_lcdc: use the standard CEA-861 720p timing
      fbdev: sh_mobile_lcdc: use correct number of modes, when using the default

Mike Frysinger (1):
      fsl-diu-fb: drop dead ioctl define

Paul Mundt (1):
      MAINTAINERS: Add an fbdev git tree entry.

Tomi Valkeinen (3):
      OMAP: VRAM: improve VRAM error prints
      OMAP: VRAM: Fix boot-time memory allocation
      OMAP: DSS: Fix documentation regarding 'vram' kernel parameter

 Documentation/arm/OMAP/DSS       |    7 ++++---
 MAINTAINERS                      |    1 +
 drivers/video/omap2/vram.c       |   17 +++++++++++++----
 drivers/video/sh_mobile_hdmi.c   |    5 ++++-
 drivers/video/sh_mobile_lcdcfb.c |   21 ++++++++++++---------
 drivers/video/sis/sis_main.c     |    8 ++++++--
 include/linux/fsl-diu-fb.h       |    1 -
 7 files changed, 40 insertions(+), 20 deletions(-)
