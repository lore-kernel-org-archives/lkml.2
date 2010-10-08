Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab0JHPNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 11:13:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:25197 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758721Ab0JHPNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 11:13:48 -0400
Message-Id: <8u3s94$gntt66@orsmga002.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,303,1283756400"; 
   d="scan'208";a="561968326"
Date: Fri, 08 Oct 2010 16:13:45 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] Prevent i915 module unload
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, early in this cycle Daniel Vetter supplied a number of fixes
for memory corruption bugs following module unload of i915.ko. We
postponed these to the next cycle. However, as Thomas Gleixner pointed
out, we should have not left the known memory corruption bugs lie in the
kernel and should have prevented the module unload instead.
-Chris

The following changes since commit 6b0cd00bc396daf5c2dcf17a8d82055335341f46:

  Merge branch 'hwpoison-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-mce-2.6 (2010-10-07 13:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git drm-intel-fixes

Chris Wilson (1):
      drm/i915: Prevent module unload to avoid random memory corruption

 drivers/gpu/drm/i915/i915_dma.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

-- 
Chris Wilson, Intel Open Source Technology Centre
