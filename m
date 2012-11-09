Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540Ab2KIFgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 00:36:46 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52253 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab2KIFgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 00:36:44 -0500
Date: Fri, 9 Nov 2012 05:36:34 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon + nouveau fixes
Message-ID: <alpine.DEB.2.00.1211090534320.1180@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just radeon and nouveau, mostly regressions fixers, and a couple of radeon 
register checker fixes.

Dave.

The following changes since commit 695ddeb457584a602f2ba117d08ce37cf6ec1589:

  drm/radeon: fix typo in evergreen_mc_resume() (2012-11-07 10:53:49 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 4a48ed2334b7ae61dd11bb114fa35bd4ebdc1ca0:

  Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes (2012-11-09 14:57:02 +1000)

----------------------------------------------------------------

Alex Deucher (3):
      drm/radeon/dce3: switch back to old pll allocation order for discrete
      drm/radeon/cayman: add some missing regs to the VM reg checker
      drm/radeon/si: add some missing regs to the VM reg checker

Dave Airlie (2):
      Merge branch 'drm-fixes-3.7' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
      Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Kelly Doran (1):
      drm/nvc0/disp: fix regression in vblank semaphore release

Maarten Lankhorst (1):
      drm/nouveau: fix acpi edid retrieval

Marcin Slusarz (3):
      drm/nv41/vm: fix typo in type name
      drm/nv40/graph: fix typo in type names
      drm/nv40/mpeg: fix context handling

 drivers/gpu/drm/nouveau/core/engine/disp/nv50.c  | 20 +++++----
 drivers/gpu/drm/nouveau/core/engine/graph/nv40.c |  4 +-
 drivers/gpu/drm/nouveau/core/engine/mpeg/nv40.c  |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/vm/nv41.c    |  2 +-
 drivers/gpu/drm/nouveau/nouveau_connector.c      |  2 +-
 drivers/gpu/drm/radeon/atombios_crtc.c           | 54 ++++++++++++++----------
 drivers/gpu/drm/radeon/evergreen_cs.c            |  3 ++
 drivers/gpu/drm/radeon/evergreend.h              |  4 ++
 drivers/gpu/drm/radeon/si.c                      |  1 +
 drivers/gpu/drm/radeon/sid.h                     |  1 +
 10 files changed, 57 insertions(+), 36 deletions(-)
