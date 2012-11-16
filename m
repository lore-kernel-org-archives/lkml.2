Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751075Ab2KPFC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 00:02:58 -0500
Received: from gir.skynet.ie ([193.1.99.77]:45629 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab2KPFC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 00:02:57 -0500
Date: Fri, 16 Nov 2012 05:02:47 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1211160501420.29024@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

all pretty normal, one TTM oops fix, one radeon, a few intel and a vmwgfx 
fix.

Dave.

The following changes since commit 77b67063bb6bce6d475e910d3b886a606d0d91f7:

  Linux 3.7-rc5 (2012-11-11 13:44:33 +0100)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 6f755116c93ca35f496ccf1910dcd28cd16713e3:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2012-11-16 10:00:43 +1000)

----------------------------------------------------------------

Akinobu Mita (1):
      drm/ttm: remove unneeded preempt_disable/enable

Alex Deucher (1):
      drm/radeon: fix logic error in atombios_encoders.c

Dan Carpenter (1):
      vmwgfx: return an -EFAULT if copy_to_user() fails

Dave Airlie (2):
      Merge branch 'drm-fixes-3.7' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Jani Nikula (3):
      drm/i915/crt: fix DPMS standby and suspend mode handling
      drm/i915/sdvo: clean up connectors on intel_sdvo_init() failures
      drm/i915: do not ignore eDP bpc settings from vbt

Zhao Yakui (1):
      ttm: Clear the ttm page allocated from high memory zone correctly

 drivers/gpu/drm/i915/intel_crt.c           |  2 +-
 drivers/gpu/drm/i915/intel_display.c       | 11 +++++++++++
 drivers/gpu/drm/i915/intel_sdvo.c          | 22 +++++++++++++++++++---
 drivers/gpu/drm/radeon/atombios_encoders.c |  2 +-
 drivers/gpu/drm/ttm/ttm_page_alloc.c       |  5 ++++-
 drivers/gpu/drm/ttm/ttm_tt.c               |  4 ----
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c      |  2 ++
 7 files changed, 38 insertions(+), 10 deletions(-)
