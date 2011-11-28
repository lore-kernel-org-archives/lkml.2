Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab1K1O1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:27:14 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50065 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189Ab1K1O1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:27:12 -0500
Date: Mon, 28 Nov 2011 14:29:28 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm exynos fixes
Message-ID: <alpine.DEB.2.00.1111281427290.14982@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

These are just an on-send of the exynos changes from Samsung, just keeping 
them separate since they are ARM based and its a brand new driver for this 
kernel.

Dave.

The following changes since commit caca6a03d365883564885f2c1da3e88dcf65d139:

  Linux 3.2-rc3 (2011-11-23 20:20:28 -0800)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Dave Airlie (1):
      Merge branch 'exynos-drm' of git://git.infradead.org/users/kmpark/linux-samsung into drm-fixes

Inki Dae (7):
      drm/exynos: added manager object to connector
      drm/exynos: changed exynos_drm_display to exynos_drm_display_ops
      drm/exynos: use gem create function generically
      drm/exynos: removed unnecessary variable.
      drm/exynos: changed buffer structure.
      drm/exynos: fix vblank bug.
      drm/exynos: include linux/module.h

Joonyoung Shim (3):
      drm/exynos: restored kernel_fb_list when reiniting fb_helper
      drm/exynos: added crtc dpms for disable crtc
      drm/exynos: Add disable of manager

Seung-Woo Kim (6):
      drm/exynos: added kms poll for handling hpd event
      drm/exynos: fixed connector flag with hpd and interlace scan for hdmi
      drm/exynos: fixed converting between display mode and timing
      drm/exynos: removed meaningless parameter from fbdev update
      drm/exynos: checked for null pointer
      drm/exynos: fixed wrong err ptr usage and destroy call in exeception

 drivers/gpu/drm/exynos/exynos_drm_buf.c       |   62 +++++++++--------
 drivers/gpu/drm/exynos/exynos_drm_buf.h       |   21 +-----
 drivers/gpu/drm/exynos/exynos_drm_connector.c |   78 ++++++++++++++++------
 drivers/gpu/drm/exynos/exynos_drm_crtc.c      |   76 +++++++++++----------
 drivers/gpu/drm/exynos/exynos_drm_crtc.h      |   25 +++++++
 drivers/gpu/drm/exynos/exynos_drm_drv.c       |    5 ++
 drivers/gpu/drm/exynos/exynos_drm_drv.h       |   13 ++--
 drivers/gpu/drm/exynos/exynos_drm_encoder.c   |   83 ++++++++++++++++++++---
 drivers/gpu/drm/exynos/exynos_drm_encoder.h   |    1 +
 drivers/gpu/drm/exynos/exynos_drm_fb.c        |   66 +++++++++++--------
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c     |   44 ++++++++-----
 drivers/gpu/drm/exynos/exynos_drm_fimd.c      |   71 +++++++++++++++-----
 drivers/gpu/drm/exynos/exynos_drm_gem.c       |   89 ++++++++++++++----------
 drivers/gpu/drm/exynos/exynos_drm_gem.h       |   28 ++++++--
 include/drm/exynos_drm.h                      |    9 +--
 15 files changed, 440 insertions(+), 231 deletions(-)
