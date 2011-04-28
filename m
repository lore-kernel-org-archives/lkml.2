Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1D1E0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 00:26:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54193 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1D1E0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 00:26:03 -0400
Date: Thu, 28 Apr 2011 05:25:30 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1104280523220.5457@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nothing major, everyone must be on Easter holidays, the i915 one is 
actually a fix for dual-gpu laptops where i915 caused radeon to do 
something bad, the Kconfig one is because I see distros don't enable this 
and its really needed for dual-gpu functionality to work at all.

Otherwise, just a couple of minor updates from Alex.

Dave.

The following changes since commit 8e10cd74342c7f5ce259cceca36f6eba084f5d58:

  Linux 2.6.39-rc5 (2011-04-26 20:48:50 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (2):
      drm/radeon/kms: add missing safe regs for 6xx/7xx
      drm/radeon/kms: add info query for tile pipes

Dave Airlie (2):
      drm: select FRAMEBUFFER_CONSOLE_PRIMARY if we have FRAMEBUFFER_CONSOLE
      drm/i915: restore only the mode of this driver on lastclose (v2)

 drivers/gpu/drm/Kconfig              |    1 +
 drivers/gpu/drm/drm_fb_helper.c      |   27 ++++++++++++++++++++-------
 drivers/gpu/drm/i915/i915_dma.c      |    2 +-
 drivers/gpu/drm/i915/intel_drv.h     |    1 +
 drivers/gpu/drm/i915/intel_fb.c      |   10 ++++++++++
 drivers/gpu/drm/radeon/radeon_kms.c  |   13 +++++++++++++
 drivers/gpu/drm/radeon/reg_srcs/r600 |    1 +
 include/drm/drm_fb_helper.h          |    1 +
 include/drm/radeon_drm.h             |    1 +
 9 files changed, 49 insertions(+), 8 deletions(-)
