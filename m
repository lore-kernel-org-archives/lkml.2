Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2G3FT5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 01:19:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48089 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab2G3FT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 01:19:56 -0400
Date: Mon, 30 Jul 2012 06:19:54 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm exynos pull for -rc1
Message-ID: <alpine.DEB.2.00.1207300618260.5584@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

So I totally missed Inki's pull request for -next, its fully exynos self 
contained.

Regards,
Dave.

The following changes since commit 98c7b42375011ec37251e6fc85a0471cfe499eea:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next (2012-07-26 10:40:31 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux.git drm-next

for you to fetch changes up to e2f895fac1e9fb5f59444e07391bfb3da719716f:

  Merge branch 'exynos-drm-next' of git://git.infradead.org/users/kmpark/linux-samsung into drm-next (2012-07-30 15:16:52 +1000)

----------------------------------------------------------------

Cooper Yuan (1):
      drm/exynos: fix buffer pitch calculation

Dave Airlie (1):
      Merge branch 'exynos-drm-next' of git://git.infradead.org/users/kmpark/linux-samsung into drm-next

Inki Dae (14):
      Merge branch 'drm-next' of ../main_line/linux-drm into dave-drm-next
      Merge branch 'drm-next' of ../main_line/linux-drm into dave-drm-next
      drm/exynos: removed unnecessary declaration.
      drm/exynos: set edid fake data only for test.
      drm/exynos: check if raw edid data is fake or not for test
      drm/exynos: fixed edid data setting at vidi connection request
      drm/exynos: fixed build warning.
      drm/exynos: use alloc_page() to allocate pages.
      drm/exynos: set buffer type from exporter.
      drm/exynos: do not release memory region from exporter.
      drm/exynos: removed unnecessary variable
      drm/exynos: fixed a comment to gem size.
      drm/exynos: use __free_page() to deallocate memory
      drm/exynos: fixed exception to page allocation failure

Joonyoung Shim (11):
      drm/exynos: fix point to call overlay_ops->mode_set
      drm/exynos: fix to set pipe of crtc
      drm/exynos: define to_exynos_plane macro
      drm/exynos: use private plane for crtc
      drm/exynos: update overlay via plane from crtc
      drm/exynos: add property for plane zpos
      drm/exynos: fix dpms operation for mode set
      drm/exynos: remove unnecessary connector dpms control
      drm/exynos: add plane enable/disable
      drm/exynos: add crtc disable function
      drm/exynos: add property for crtc mode

Sachin Kamat (4):
      drm/exynos: Add missing static storage class specifier
      drm/exynos: Use devm_* functions in exynos_drm_fimd.c
      drm/exynos: Use devm_* functions in exynos_hdmi.c
      drm/exynos: Use devm_* functions in exynos_mixer.c

Subash Patel (2):
      drm/exynos: return NULL if exynos_pages_to_sg fails
      drm/exynos: check for null in return value of dma_buf_map_attachment()

 drivers/gpu/drm/exynos/exynos_drm_connector.c |    3 +-
 drivers/gpu/drm/exynos/exynos_drm_core.c      |    5 -
 drivers/gpu/drm/exynos/exynos_drm_crtc.c      |  294 +++++++++++--------------
 drivers/gpu/drm/exynos/exynos_drm_crtc.h      |   31 ---
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c    |   33 ++-
 drivers/gpu/drm/exynos/exynos_drm_drv.c       |    9 +-
 drivers/gpu/drm/exynos/exynos_drm_drv.h       |    4 +
 drivers/gpu/drm/exynos/exynos_drm_encoder.c   |  123 +++++------
 drivers/gpu/drm/exynos/exynos_drm_encoder.h   |   12 +-
 drivers/gpu/drm/exynos/exynos_drm_fimd.c      |   40 +---
 drivers/gpu/drm/exynos/exynos_drm_gem.c       |   49 ++---
 drivers/gpu/drm/exynos/exynos_drm_gem.h       |    3 +-
 drivers/gpu/drm/exynos/exynos_drm_plane.c     |  246 ++++++++++++++-------
 drivers/gpu/drm/exynos/exynos_drm_plane.h     |   12 +-
 drivers/gpu/drm/exynos/exynos_drm_vidi.c      |   53 ++++-
 drivers/gpu/drm/exynos/exynos_hdmi.c          |   36 +--
 drivers/gpu/drm/exynos/exynos_mixer.c         |   48 ++--
 include/drm/exynos_drm.h                      |    9 -
 18 files changed, 493 insertions(+), 517 deletions(-)

