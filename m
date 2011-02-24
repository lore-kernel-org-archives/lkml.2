Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1BXWnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 17:43:49 -0500
Received: from gir.skynet.ie ([193.1.99.77]:38247 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab1BXWns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 17:43:48 -0500
Date: Thu, 24 Feb 2011 22:43:19 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes (intel only)
Message-ID: <alpine.DEB.2.00.1102242241280.5315@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Since Chris missed my last pull I've got a seprate set of fixes for 
Intel, should fix an eDP issue, a couple of 855 problems (tiling and 
buffer coherency),

Dave.

The following changes since commit ef3242859fae47e728b50b7ce3d17b201a71779a:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6 (2011-02-23 16:02:00 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Chris Wilson (3):
      drm/i915: Ignore a hung GPU when flushing the framebuffer prior to a switch
      agp/intel: Experiment with a 855GM GWB bit
      drm/i915: Fix unintended recursion in ironlake_disable_rc6

Daniel Vetter (1):
      drm/i915: fix corruptions on i8xx due to relaxed fencing

Dave Airlie (2):
      Merge branch 'drm-intel-fixes' of git://git.kernel.org/.../ickle/drm-intel into drm-fixes
      Merge branch 'drm-intel-fixes' of git://git.kernel.org/.../ickle/drm-intel into drm-fixes

Jesse Barnes (2):
      drm/i915: don't enable FDI & transcoder interrupts after all
      drm/i915: skip FDI & PCH enabling for DP_A

 drivers/char/agp/intel-agp.h           |    1 +
 drivers/char/agp/intel-gtt.c           |   56 +++++++------------
 drivers/gpu/drm/i915/i915_gem_tiling.c |   16 +++++-
 drivers/gpu/drm/i915/i915_irq.c        |    6 +-
 drivers/gpu/drm/i915/intel_display.c   |   95 +++++++++++++++++++++++++++++---
 5 files changed, 127 insertions(+), 47 deletions(-)
