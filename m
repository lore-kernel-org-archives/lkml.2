Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030226Ab2CONw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 09:52:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43439 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309Ab2CONwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 09:52:24 -0400
Date: Thu, 15 Mar 2012 13:52:22 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: drm exynos/intel updates
Message-ID: <alpine.DEB.2.00.1203151351110.31797@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

two minor updates from Jesse for Intel SNB fixes, and a few fixes from 
Samsung for exynos. The pull req has Alan's commit in it since Intel based 
their tree on my tree at that time, but it all seems fine wrt merging.

Dave.

The following changes since commit 762ad8a5330325b789cfb6dc896f81cf273ff4e9:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2012-03-13 18:39:28 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alan Cox (1):
      drm/gma500: Fix Cedarview boot failures in 3.3-rc

Dave Airlie (2):
      Merge branch 'drm-intel-fixes' of git://git.kernel.org/.../keithp/linux into drm-fixes
      Merge branch 'exynos-drm-fixes' of git://git.infradead.org/users/kmpark/linux-samsung into drm-fixes

Jesse Barnes (2):
      drm/i915: fix color order for BGR formats on SNB
      drm/i915: support 32 bit BGR formats in sprite planes

Laurent Pinchart (1):
      drm/exynos: Fix fb_videomode <-> drm_mode_modeinfo conversion

Marek Szyprowski (2):
      drm/exynos: use correct 'exynos-drm' name for platform device
      drm/exynos: fix runtime_pm fimd device state on probe

Sascha Hauer (1):
      drm exynos: use drm_fb_helper_set_par directly

 drivers/gpu/drm/exynos/exynos_drm_connector.c |   16 +++++++-------
 drivers/gpu/drm/exynos/exynos_drm_drv.c       |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_fbdev.c     |   28 +------------------------
 drivers/gpu/drm/exynos/exynos_drm_fimd.c      |   17 +++++---------
 drivers/gpu/drm/i915/i915_reg.h               |    2 +-
 drivers/gpu/drm/i915/intel_display.c          |    1 +
 drivers/gpu/drm/i915/intel_sprite.c           |    6 ++--
 7 files changed, 21 insertions(+), 51 deletions(-)
