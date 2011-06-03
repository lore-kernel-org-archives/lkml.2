Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1FCJ3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 05:29:14 -0400
Received: from mail.perches.com ([173.55.12.10]:2454 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753194Ab1FCJ3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 05:29:13 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>, drbd-dev@lists.linbit.com,
        dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        devel@driverdev.osuosl.org, alsa-devel@alsa-project.org
Subject: [Trivial PATCH 0/5] treewide: Use angle brackets for system includes
Date: Fri,  3 Jun 2011 02:28:45 -0700
Message-Id: <cover.1307092588.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just neatening.

Joe Perches (5):
  drbd: Use angle brackets for system includes
  drm: Use angle brackets for system includes
  aix94xx: Use angle brackets for system includes
  ALSA: asihpi: Use angle brackets for system includes
  staging: msm: Use angle brackets for system includes

 drivers/block/drbd/drbd_int.h                 |    2 +-
 drivers/block/drbd/drbd_nl.c                  |    4 ++--
 drivers/gpu/drm/drm_ioctl.c                   |    2 +-
 drivers/gpu/drm/i915/i915_gem_tiling.c        |    4 ++--
 drivers/gpu/drm/nouveau/nouveau_drv.h         |   10 +++++-----
 drivers/gpu/drm/ttm/ttm_agp_backend.c         |    6 +++---
 drivers/gpu/drm/ttm/ttm_bo.c                  |    6 +++---
 drivers/gpu/drm/ttm/ttm_bo_manager.c          |    6 +++---
 drivers/gpu/drm/ttm/ttm_bo_util.c             |    4 ++--
 drivers/gpu/drm/ttm/ttm_execbuf_util.c        |    6 +++---
 drivers/gpu/drm/ttm/ttm_lock.c                |    4 ++--
 drivers/gpu/drm/ttm/ttm_memory.c              |    6 +++---
 drivers/gpu/drm/ttm/ttm_module.c              |    2 +-
 drivers/gpu/drm/ttm/ttm_object.c              |    4 ++--
 drivers/gpu/drm/ttm/ttm_page_alloc.c          |    4 ++--
 drivers/gpu/drm/ttm/ttm_tt.c                  |    8 ++++----
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c        |    4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c           |    8 ++++----
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h           |   12 ++++++------
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c       |    4 ++--
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c            |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c          |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmr.c           |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c |    6 +++---
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c       |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c      |    4 ++--
 drivers/scsi/aic94xx/aic94xx_dump.c           |    2 +-
 drivers/staging/msm/ebi2_l2f.c                |    2 +-
 drivers/staging/msm/ebi2_tmd20.c              |    2 +-
 drivers/staging/msm/mddihost.h                |    2 +-
 drivers/staging/msm/mdp_ppp.c                 |    2 +-
 drivers/staging/msm/mdp_ppp_v20.c             |    2 +-
 drivers/staging/msm/mdp_ppp_v31.c             |    2 +-
 drivers/staging/msm/msm_fb.h                  |    2 +-
 include/drm/ttm/ttm_bo_driver.h               |   12 ++++++------
 include/drm/ttm/ttm_execbuf_util.h            |    2 +-
 include/drm/ttm/ttm_lock.h                    |    2 +-
 include/linux/drbd_tag_magic.h                |    2 +-
 sound/pci/asihpi/hpidspcd.c                   |    2 +-
 39 files changed, 80 insertions(+), 80 deletions(-)

-- 
1.7.5.rc3.dirty

