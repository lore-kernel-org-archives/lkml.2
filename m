Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab1HEJXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:23:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45622 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1HEJWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:22:47 -0400
Date: Fri, 5 Aug 2011 10:22:08 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull drm fixes
Message-ID: <alpine.DEB.2.00.1108051019200.14655@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-739591997-1312536128=:14655"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-739591997-1312536128=:14655
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


Hi Linus,

Intel modesetting fixes a lot of them, Keith, Jesse and ajax have been 
focusing on a lot of the corner cases and display port and hdmi stuff.

misc radeon fixes, the main one being for certain machines where EDID 
returns what looks like misc noise when connectors aren't populated on 
certain boards.

and some misc trivial type fixes.

Dave.

The following changes since commit 288d5abec8314ae50fe6692f324b0444acae8486:

  Boot up with usermodehelper disabled (2011-08-03 22:03:29 -1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Adam Jackson (10):
      drm/i915/dp: Zero the DPCD data before connection probe
      drm/i915/dp: Move DPCD dump to common code instead of PCH-only
      drm/i915/dp: Read more DPCD registers on connection probe
      drm/i915/dp: Better hexdump of DPCD
      drm/i915/dp: Retry DPCD fetch on G4X too
      drm/i915/dp: Explicitly request 8/10 channel coding
      drm/i915/pch: Fix integer math bugs in panel fitting
      drm/i915/dp: Explicitly disable symbol scrambling while training
      drm/i915/dp: Don't turn CPT DP ports on too early
      drm/i915/pch: Save/restore PCH_PORT_HOTPLUG across suspend

Alex Deucher (2):
      drm/radeon/kms: fix version comment due to merge timing
      drm/radeon/kms: add thermal chip quirk for asus 9600xt

Bojan Prtvar (1):
      drm/radeon: fix potential NULL dereference in drivers/gpu/drm/radeon/atom.c

Dan Carpenter (1):
      drm/radeon: off by one in check_reg() functions

Dave Airlie (1):
      Merge branch 'drm-intel-next' of ssh://master.kernel.org/.../keithp/linux-2.6 into drm-fixes

Emil Velikov (1):
      drm/debugfs: Initialise empty variable

Fernando Luis VÃƒÆ’Ã‚Â¡zquez Cao (1):
      drm/radeon: clean reg header files

Jesse Barnes (15):
      drm/i915: provide more error output when mode sets fail
      drm/i915: load the LUT before pipe enable on ILK+
      drm/i915: apply timing generator bug workaround on CPT and PPT
      drm/i915: flush plane control changes on ILK+ as well
      drm/i915: fix CB tuning check for ILK+
      drm/i915/hdmi: send AVI info frames on ILK+ as well
      drm/i915: add GPU max frequency control file
      drm/i915: provide more error output when mode sets fail
      drm/i915: apply phase pointer override on SNB+ too
      drm/i915: don't use uninitialized EDID bpc values when picking pipe bpp
      drm/i915/dp: wait for previous AUX channel activity to clear
      drm: track CEA version number if present
      drm/i915/hdmi: split infoframe setting from infoframe type code
      drm/i915/hdmi: HDMI source product description infoframe support
      drm/i915: allow cache sharing policy control

Joonyoung Shim (2):
      drm: Fix irq install error handling
      drm: Add NULL check about irq functions

Keith Packard (20):
      drm/i915: Skip GPU wait for scanout pin while wedged
      drm/i915: Initialize RCS ring status page address in intel_render_ring_init_dri
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Hold mode_config->mutex during hotplug processing
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Fixup for 'Hold mode_config->mutex during hotplug'
      drm/i915: Use dp_detect_common in hotplug helper function
      drm/i915: Rename i915_dp_detect_common to intel_dp_get_dpcd
      drm/i915: In intel_dp_init, replace read of DPCD with intel_dp_get_dpcd
      drm/i915: DP_PIPE_ENABLED must check transcoder on CPT
      Revert and fix "drm/i915/dp: remove DPMS mode tracking from DP"
      drm/i915: Set crtc DPMS mode to ON in intel_crtc_mode_set
      drm/i915: Flush other plane register writes
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Ignore GPU wedged errors while pinning scanout buffers
      Merge branch 'drm-intel-fixes' into drm-intel-next
      Revert "drm/i915/dp: Zero the DPCD data before connection probe"
      Merge branch 'drm-intel-fixes' into drm-intel-next
      drm/i915: Try enabling RC6 by default (again)

Michel Alexandre Salim (1):
      drm/i915: Add quirk to disable SSC on Sony Vaio Y2

Ole Henrik Jahren (1):
      drm/i915: Fix typo in DRM_I915_OVERLAY_PUT_IMAGE ioctl define

Pieterjan Camerlynck (1):
      i915: add Dell OptiPlex FX170 to intel_no_lvds

Thomas Reim (4):
      drm: Separate EDID Header Check from EDID Block Check
      drm/radeon: Extended DDC Probing for Connectors with Improperly Wired DDC Lines (here: Asus M2A-VM HDMI)
      drm/radeon: Log Subsystem Vendor and Device Information
      drm/radeon: Extended DDC Probing for ECS A740GM-M DVI-D Connector

 drivers/gpu/drm/drm_debugfs.c              |    4 +-
 drivers/gpu/drm/drm_edid.c                 |   33 ++++-
 drivers/gpu/drm/drm_irq.c                  |   26 +++--
 drivers/gpu/drm/i915/i915_debugfs.c        |  189 ++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/i915_dma.c            |    6 +-
 drivers/gpu/drm/i915/i915_drv.c            |    2 +-
 drivers/gpu/drm/i915/i915_drv.h            |    1 +
 drivers/gpu/drm/i915/i915_gem.c            |    2 +-
 drivers/gpu/drm/i915/i915_irq.c            |    3 +
 drivers/gpu/drm/i915/i915_reg.h            |   36 +++++-
 drivers/gpu/drm/i915/i915_suspend.c        |    2 +
 drivers/gpu/drm/i915/intel_display.c       |  138 ++++++++++++++++-----
 drivers/gpu/drm/i915/intel_dp.c            |  111 ++++++++++------
 drivers/gpu/drm/i915/intel_drv.h           |   23 ++++
 drivers/gpu/drm/i915/intel_hdmi.c          |  158 ++++++++++++++++++++----
 drivers/gpu/drm/i915/intel_lvds.c          |    8 ++
 drivers/gpu/drm/i915/intel_panel.c         |    4 +
 drivers/gpu/drm/i915/intel_ringbuffer.c    |    3 +
 drivers/gpu/drm/radeon/Makefile            |    1 +
 drivers/gpu/drm/radeon/atom.c              |    3 +
 drivers/gpu/drm/radeon/evergreen_cs.c      |    2 +-
 drivers/gpu/drm/radeon/r600_cs.c           |    3 +-
 drivers/gpu/drm/radeon/radeon_combios.c    |   21 +++-
 drivers/gpu/drm/radeon/radeon_connectors.c |   54 ++++++++-
 drivers/gpu/drm/radeon/radeon_device.c     |    5 +-
 drivers/gpu/drm/radeon/radeon_display.c    |    9 ++
 drivers/gpu/drm/radeon/radeon_drv.c        |    4 +-
 drivers/gpu/drm/radeon/radeon_i2c.c        |   32 ++++--
 drivers/gpu/drm/radeon/radeon_mode.h       |    6 +-
 include/drm/drm_crtc.h                     |    3 +
 include/drm/i915_drm.h                     |    2 +-
 31 files changed, 754 insertions(+), 140 deletions(-)
--29444707-739591997-1312536128=:14655--
