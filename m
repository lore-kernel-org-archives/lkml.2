Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab1DEAjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 20:39:08 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45193 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1DEAjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 20:39:03 -0400
Date: Tue, 5 Apr 2011 01:38:31 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1104050137040.8684@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Nothing too major, the radeon sanity checks and i915 fixes probably the 
most important.

Dave.

The following changes since commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d:

  Linux 2.6.39-rc1 (2011-03-29 12:09:47 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (3):
      drm/radeon/kms: Add support for tv-out dongle on G5 9600
      drm/radeon/kms: pageflipping cleanup for avivo+
      drm/radeon/kms: add some new ontario pci ids

Ben Skeggs (1):
      drm: export drm_find_cea_extension to drivers

Chris Wilson (3):
      drm/i915/lvds: Always return connected in the absence of better information
      drm/i915: Busy-spin wait_for condition in atomic contexts
      drm/i915: Reset GMBUS controller after NAK

Dave Airlie (1):
      Merge remote branch 'keithp/drm-intel-fixes' of /ssd/git/drm-next into drm-fixes

Jan Engelhardt (1):
      drm: fix "persistant" typo

John Lindgren (1):
      drm/radeon/kms: add some sanity checks to obj info record parsingi (v2)

 drivers/gpu/drm/drm_edid.c               |    3 ++-
 drivers/gpu/drm/i915/intel_drv.h         |    2 +-
 drivers/gpu/drm/i915/intel_i2c.c         |   25 +++++++++++++++++++++----
 drivers/gpu/drm/i915/intel_lvds.c        |   10 ++--------
 drivers/gpu/drm/nouveau/nouveau_gem.c    |    2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c   |   20 ++++++++++++++++++++
 drivers/gpu/drm/radeon/evergreen.c       |   11 -----------
 drivers/gpu/drm/radeon/radeon_atombios.c |   13 +++++++------
 drivers/gpu/drm/radeon/radeon_combios.c  |   13 +++++++++++++
 drivers/gpu/drm/radeon/rs600.c           |   11 -----------
 drivers/gpu/drm/ttm/ttm_bo.c             |   10 +++++-----
 drivers/gpu/drm/ttm/ttm_tt.c             |   16 ++++++++--------
 include/drm/drm_crtc.h                   |    1 +
 include/drm/drm_pciids.h                 |    2 ++
 include/drm/ttm/ttm_bo_api.h             |   18 +++++++++---------
 include/drm/ttm/ttm_bo_driver.h          |    4 ++--
 16 files changed, 94 insertions(+), 67 deletions(-)
