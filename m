Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab2BJPvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:51:12 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55380 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab2BJPvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:51:11 -0500
Date: Fri, 10 Feb 2012 15:51:09 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1202101549290.1054@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

all fairly minor stuff, A few intel fixes mainly, a randon mismerge fix, and one core compat ioctl 
fix.

The intel dp fix fixes a bunch of eDP/DP regressions, and it at least lets 
me suspend/resume my laptop panel again.

Dave.

The following changes since commit 6c073a7ee250118b8be3a2379c96fd7f78382b06:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client (2012-02-02 15:47:33 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Chris Wilson (1):
      drm/i915:: Disable FBC on SandyBridge

Daniel Vetter (2):
      drm/i915: fixup interlaced bits clearing in PIPECONF on PCH_SPLIT
      drm/i915: no lvds quirk for AOpen MP45

Dave Airlie (1):
      Merge branch 'drm-intel-fixes' of git://git.kernel.org/.../keithp/linux into drm-fixes

Julia Lawall (1):
      drivers/gpu/drm/drm_ioc32.c: initialize all fields

Keith Packard (2):
      drm/i915: Force explicit bpp selection for intel_dp_link_required
      drm/i915: fixup interlaced bits clearing in PIPECONF on PCH_SPLIT (v2)

Matthijs Kooijman (1):
      drm/radeon: do not continue after error from r600_ib_test

 drivers/gpu/drm/drm_ioc32.c          |    3 ++-
 drivers/gpu/drm/i915/intel_display.c |    8 +++++---
 drivers/gpu/drm/i915/intel_dp.c      |   20 +++++---------------
 drivers/gpu/drm/i915/intel_lvds.c    |    8 ++++++++
 drivers/gpu/drm/radeon/evergreen.c   |    1 +
 5 files changed, 21 insertions(+), 19 deletions(-)
