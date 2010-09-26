Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab0IZWLg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 18:11:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:51316 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757592Ab0IZWLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 18:11:36 -0400
Message-Id: <89k83a$9plvtg@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,240,1283756400"; 
   d="scan'208";a="328925104"
Date: Sun, 26 Sep 2010 23:11:31 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] i915 regression fixes
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
From: Chris Wilson <chris@chris-wilson.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, a couple of fixes for some recent regressions.

The following changes since commit 32163f4b2cef28a5aab8b226ffecfc6379a53786:

  alpha: fix usp value in multithreaded coredumps (2010-09-25 14:38:13 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel.git drm-intel-fixes

Chris Wilson (3):
      drm/i915: Fix 945GM regression in e259befd
      drm/i915/sdvo: Cleanup connector on error path
      drm/i915/sdvo: Handle unsupported GET_SUPPORTED_ENHANCEMENTS gracefully

 drivers/gpu/drm/i915/i915_gem.c   |    2 +-
 drivers/gpu/drm/i915/intel_sdvo.c |   15 ++++++---------
 2 files changed, 7 insertions(+), 10 deletions(-)
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
