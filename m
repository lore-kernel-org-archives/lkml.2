Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab0IJW61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 18:58:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:51430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab0IJW60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 18:58:26 -0400
Message-Id: <8u3s8d$jhq56n@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,348,1280732400"; 
   d="scan'208";a="656217303"
Date: Fri, 10 Sep 2010 23:58:22 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] i915 regression fixes
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git drm-intel-fixes

which contains the following regression fixes:

Chris Wilson (4):
      Revert "drm/i915: Enable RC6 on Ironlake."
      Revert "drm/i915: Allow LVDS on pipe A on gen4+"
      Revert "drm/i915: Warn if we run out of FIFO space for a mode"
      drm/i915: Double check that the wait_request is not pending before warning

Jesse Barnes (1):
      drm/i915: don't enable self-refresh on Ironlake

 drivers/gpu/drm/i915/i915_irq.c      |   22 +++++++++++++++-------
 drivers/gpu/drm/i915/i915_reg.h      |    8 ++++++++
 drivers/gpu/drm/i915/intel_display.c |   23 ++++++++---------------
 drivers/gpu/drm/i915/intel_lvds.c    |    2 --
 4 files changed, 31 insertions(+), 24 deletions(-)

Thanks,
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
