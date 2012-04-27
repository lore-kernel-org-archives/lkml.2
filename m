Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759850Ab2D0IoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 04:44:17 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57873 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759691Ab2D0IoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 04:44:15 -0400
Date: Fri, 27 Apr 2012 09:44:13 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1204270942520.32761@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

For your Friday pull request stack, nothing astounding or shattering this 
week some exynos, some intel, some radeon fixes. One intel fix for a 
regression somwehere back in 2.6.35 land.

Dave.

The following changes since commit af3a3ab2966112c0d0a44df7eeb1e95fe32d4495:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes (2012-04-24 08:22:25 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms: use frac fb div on APUs

Daniel Vetter (2):
      drm/i915: fixup load-detect on enabled, but not active pipe
      drm/i915: handle input/output sdvo timings separately in mode_set

Dave Airlie (2):
      Merge branch 'exynos-drm-fixes' of git://git.infradead.org/users/kmpark/linux-2.6-samsung into drm-fixes
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Ilija Hadzic (1):
      drm/radeon: add a missing entry to encoder_names

Inki Dae (3):
      drm/exynos: fixed duplicatd memory allocation bug.
      drm/exynos: fixed exynos_drm_gem_map_pages bug.
      drm/exynos: added missed vm area region mapping type.

Xi Wang (2):
      drm/i915: fix integer overflow in i915_gem_execbuffer2()
      drm/i915: fix integer overflow in i915_gem_do_execbuffer()

 drivers/gpu/drm/exynos/exynos_drm_gem.c    |   30 ++++--------------------
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    8 +++++-
 drivers/gpu/drm/i915/intel_crt.c           |   29 +++++++++--------------
 drivers/gpu/drm/i915/intel_sdvo.c          |   34 ++++++++++++++-------------
 drivers/gpu/drm/radeon/atombios_crtc.c     |    3 ++
 drivers/gpu/drm/radeon/radeon_display.c    |    3 +-
 6 files changed, 46 insertions(+), 61 deletions(-)
