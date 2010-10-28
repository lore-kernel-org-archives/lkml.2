Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab0J1Ddk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 23:33:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41135 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757670Ab0J1Ddi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 23:33:38 -0400
Date: Thu, 28 Oct 2010 04:33:25 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1010280432210.11926@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just three fixes from Alex for radeon kms issues, one longstanding bug on 
r200 cards since kms came about.

Dave.

The following changes since commit 135cba0dc399fdd47bd3ae305c1db75fcd77243f:

  vmwgfx: Implement a proper GMR eviction mechanism (2010-10-27 11:07:46 +1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-core-next

Alex Deucher (3):
      drm/radeon/kms: fix handling of tex lookup disable in cs checker on r2xx
      drm/radeon/kms: fix tiled db height calculation on 6xx/7xx
      drm/radeon/kms: enable unmappable vram for evergreen

 drivers/gpu/drm/radeon/evergreen_blit_kms.c |    2 ++
 drivers/gpu/drm/radeon/r100.c               |    3 +++
 drivers/gpu/drm/radeon/r100_track.h         |    1 +
 drivers/gpu/drm/radeon/r200.c               |    2 ++
 drivers/gpu/drm/radeon/r600_cs.c            |   14 ++++++++------
 drivers/gpu/drm/radeon/radeon_reg.h         |    1 +
 6 files changed, 17 insertions(+), 6 deletions(-)
