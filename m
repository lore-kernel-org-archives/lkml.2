Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab1FNDSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 23:18:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40711 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab1FNDSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 23:18:50 -0400
Date: Tue, 14 Jun 2011 04:18:11 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1106140415100.14714@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1901876393-1308021491=:14714"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1901876393-1308021491=:14714
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

nothing too interesting here, a couple of unusual ones for my tree, the 
x86/uv/x2apic change was due to change in the VGA ARB in my -rc1 pull, 
Ingo and Jesse agreed it should go via the same tree that broke it. I've 
picked up one i915 change due to Keith being away, the rest are fairly 
scattered with fix for savage DRI (drm core map change) that is a few 
kernels old now and a couple of alpha changes.

Dave.

The following changes since commit 06e86849cf4019945a106913adb9ff0abcc01770:

  Merge branch 'pm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6 (2011-06-08 15:58:51 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (2):
      drm/radeon/kms: check modes against max pixel clock
      drm/radeon/kms: fix mac g5 quirk

Dave Airlie (1):
      x86/uv/x2apic: update for change in pci bridge handling.

Greg Dietsche (1):
      savage: remove unnecessary if statement

Ilija Hadzic (1):
      drm/radeon: fix GUI idle IH debug statements

Jay Estabrook (2):
      alpha/drm: Cleanup Alpha support in DRM generic code
      alpha, drm: Remove obsolete Alpha support in MGA DRM code

Jesper Juhl (1):
      drm/i915: Don't leak in i915_gem_shmem_pread_slow()

Marek Ol¨ák (1):
      drm/radeon/kms: do bounds checking for 3D_LOAD_VBPNTR and bump array limit

Sascha Hauer (1):
      drm: fix fbs in DRM_IOCTL_MODE_GETRESOURCES ioctl

Tormod Volden (1):
      drm: Compare only lower 32 bits of framebuffer map offsets

 arch/x86/kernel/apic/x2apic_uv_x.c         |    8 ++++----
 drivers/gpu/drm/drm_bufs.c                 |   17 +++++++++--------
 drivers/gpu/drm/drm_crtc.c                 |    2 +-
 drivers/gpu/drm/drm_vm.c                   |    2 +-
 drivers/gpu/drm/i915/i915_gem.c            |    6 ++++--
 drivers/gpu/drm/mga/mga_drv.h              |   19 -------------------
 drivers/gpu/drm/radeon/evergreen.c         |    2 +-
 drivers/gpu/drm/radeon/r100_track.h        |    8 +++++++-
 drivers/gpu/drm/radeon/r600.c              |    2 +-
 drivers/gpu/drm/radeon/radeon.h            |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c   |    4 ++++
 drivers/gpu/drm/radeon/radeon_clocks.c     |    8 +++++---
 drivers/gpu/drm/radeon/radeon_combios.c    |   10 +++++++---
 drivers/gpu/drm/radeon/radeon_connectors.c |   13 ++++++++++++-
 drivers/gpu/drm/savage/savage_bci.c        |    3 ---
 drivers/pci/pci.c                          |    4 ++--
 16 files changed, 59 insertions(+), 50 deletions(-)
--29444707-1901876393-1308021491=:14714--
