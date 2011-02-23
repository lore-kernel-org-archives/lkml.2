Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab1BWXRn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:17:43 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53763 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab1BWXRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:17:42 -0500
Date: Wed, 23 Feb 2011 23:17:13 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nothing too major,

Two regression fixers (one revert that got fixes properly elsewhere), some 
timestamp fixes and an agp module reload fix.

Dave.

The following changes since commit d8204a37baf5474d3154eb536c936369be2bd5c0:

  Merge branch 'urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/brodo/pcmcia-2.6 (2011-02-22 09:26:54 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (1):
      Revert "drm/radeon/kms: switch back to min->max pll post divider iteration"

Dave Airlie (2):
      drm/radeon/kms: align height of fb allocation.
      drm/radeon: fix regression with AA resolve checking

Florian Mickler (1):
      amd64-agp: fix crash at second module load

Mario Kleiner (3):
      drm/vblank: Use abs64(diff_ns) for s64 diff_ns instead of abs(diff_ns)
      drm/vblank: Use memory barriers optimized for atomic_t instead of generics.
      drm/vblank: Enable precise vblank timestamps for interlaced and doublescan modes.

Paul Bolle (1):
      drm: drop commented out code and preceding comment

 drivers/char/agp/amd64-agp.c            |    9 +++++++--
 drivers/gpu/drm/drm_irq.c               |   26 ++++++++++++++------------
 drivers/gpu/drm/radeon/r100.c           |    4 +---
 drivers/gpu/drm/radeon/radeon_display.c |    2 +-
 drivers/gpu/drm/radeon/radeon_fb.c      |    5 ++++-
 5 files changed, 27 insertions(+), 19 deletions(-)
