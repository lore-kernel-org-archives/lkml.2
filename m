Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1BQWuv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:50:51 -0500
Received: from gir.skynet.ie ([193.1.99.77]:44501 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab1BQWus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:50:48 -0500
Date: Thu, 17 Feb 2011 22:50:20 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1102172249020.5315@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-698910368-1297983020=:5315"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-698910368-1297983020=:5315
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

nothing major, one regression fix for evergreen radeon laptops, and a 
bunch of nouveau fixes, one for s/r on newer chips.

Dave.

The following changes since commit a2640111d5edb3f4e6dd6089c0dbddc7590110b4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6 (2011-02-16 09:07:00 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (1):
      drm/radeon/kms: add missing frac fb div flag for dce4+

Ben Skeggs (4):
      drm/nouveau: fix non-EDIDful native mode selection
      drm/nv40: fix tiling-related setup for a number of chipsets
      drm/nouveau: flips/flipd need to always set 'evict' for move_accel_cleanup()
      drm/nouveau: fix suspend/resume on GPUs that don't have PM support

Dave Airlie (1):
      Merge remote branch 'nouveau/drm-nouveau-next' of /ssd/git/drm-nouveau-next into drm-fixes

Francisco Jerez (3):
      drm/nv10: Fix crash when allocating a BO larger than half the available VRAM.
      drm/nv04-nv40: Fix NULL dereference when we fail to find an LVDS native mode.
      drm/nouveau: Fix detection of DDC-based LVDS on DCB15 boards.

Marek Ol¨ák (1):
      drm/radeon/kms: do not reject X16 and Y16X16 floating-point formats on r300

 drivers/gpu/drm/nouveau/nouveau_bios.c      |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bo.c        |   13 ++++---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    1 +
 drivers/gpu/drm/nouveau/nouveau_pm.c        |    2 +-
 drivers/gpu/drm/nouveau/nv04_dfp.c          |   12 ++-----
 drivers/gpu/drm/nouveau/nv40_graph.c        |   46 ++++++++++++++++-----------
 drivers/gpu/drm/radeon/atombios_crtc.c      |    4 ++-
 drivers/gpu/drm/radeon/r300.c               |    2 +
 8 files changed, 45 insertions(+), 37 deletions(-)
--29444707-698910368-1297983020=:5315--
