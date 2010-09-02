Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab0IBBiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 21:38:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59290 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab0IBBiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 21:38:12 -0400
Date: Thu, 2 Sep 2010 02:37:58 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.1009020237001.4265@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a bunch of radeon fixes from Alex, one for AGP r700s.

Dave.

The following changes since commit 2bfc96a127bc1cc94d26bfaa40159966064f9c8c:

  Linux 2.6.36-rc3 (2010-08-29 08:36:04 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (6):
      drm/radeon/kms: use tracked values for sclk and mclk
      drm/radeon/kms: fix a regression on r7xx AGP due to the HDP flush fix
      drm/radeon/kms: remove useless clock code
      drm/radeon/kms: force legacy pll algo for RV515 LVDS
      drm/radeon/kms: fix tv module parameter
      drm/radeon/kms: properly set crtc high base on r7xx

 drivers/gpu/drm/radeon/atombios_crtc.c     |   22 ++++++--
 drivers/gpu/drm/radeon/evergreen.c         |    9 ---
 drivers/gpu/drm/radeon/r600.c              |   11 +----
 drivers/gpu/drm/radeon/radeon.h            |    8 ++-
 drivers/gpu/drm/radeon/radeon_asic.c       |   18 ------
 drivers/gpu/drm/radeon/radeon_clocks.c     |   58 +++------------------
 drivers/gpu/drm/radeon/radeon_connectors.c |   78 +++++++++++++++------------
 drivers/gpu/drm/radeon/radeon_device.c     |   28 +++-------
 drivers/gpu/drm/radeon/radeon_i2c.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_mode.h       |    1 -
 drivers/gpu/drm/radeon/rv770.c             |   61 ++++++++++++++++++---
 11 files changed, 138 insertions(+), 158 deletions(-)
