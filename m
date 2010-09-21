Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab0IUKIJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 06:08:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:63912 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756582Ab0IUKII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 06:08:08 -0400
Message-Id: <89k83a$9np2i3@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,398,1280732400"; 
   d="scan'208";a="326928963"
Date: Tue, 21 Sep 2010 11:08:03 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] i915 regression fixes
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, a bit later than intended due to travel, but here a few more
fixes for the recently reported regressions.

The following changes since commit b30a3f6257ed2105259b404d419b4964e363928c:

  Linux 2.6.36-rc5 (2010-09-20 16:56:53 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git drm-intel-fixes

Chris Wilson (7):
      drm/i915: Ensure that the crtcinfo is populated during mode_fixup()
      Merge remote branch 'linus' into drm-intel-fixes
      drm/i915/crt: Downgrade warnings for hotplug failures
      drm/i915: Fix Sandybridge fence registers
      drm/i915,agp/intel: Add second set of PCI-IDs for B43
      drm/i915: Hold a reference to the object whilst unbinding the eviction list
      Merge remote branch 'linus' into drm-intel-fixes

 drivers/char/agp/intel-agp.c          |    2 +
 drivers/char/agp/intel-agp.h          |    2 +
 drivers/gpu/drm/i915/i915_drv.c       |    1 +
 drivers/gpu/drm/i915/i915_gem.c       |   37 +++++++++++++++++++++-----------
 drivers/gpu/drm/i915/i915_gem_evict.c |    9 ++++++-
 drivers/gpu/drm/i915/i915_suspend.c   |   36 ++++++++++++++++++++++++--------
 drivers/gpu/drm/i915/intel_crt.c      |    4 +-
 drivers/gpu/drm/i915/intel_display.c  |    8 +++++++
 8 files changed, 73 insertions(+), 26 deletions(-)

-- 
Chris Wilson, Intel Open Source Technology Centre
