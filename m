Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0IXFd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:33:59 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38446 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab0IXFd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:33:58 -0400
Date: Fri, 24 Sep 2010 06:33:45 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm- fixes
Message-ID: <alpine.DEB.2.00.1009240631250.3738@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus

Pretty trivial, one idr log spam in nouveau, the radeon fix is only for 
people with switchable, and a ttm fix.

Dave.

The following changes since commit 1ce1e41c1b61a992077bd1c45c6c3fd6a8b10c02:

  Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-09-21 13:22:10 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Ben Skeggs (1):
      drm/nouveau: fix panels using straps-based mode detection

Daniel J Blueman (4):
      drm: ttm sparse fixes.
      drm: fix trivial coding errors
      drm: radeon cleanup fixes...
      vgaarb: trivial fix

Dave Airlie (1):
      drm/radeon: don't allow device to be opened if powered down

Francisco Jerez (1):
      drm/ttm: Clear the ghost cpu_writers flag on ttm_buffer_object_transfer.

 drivers/gpu/drm/drm_buffer.c                |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    6 ++++--
 drivers/gpu/drm/radeon/atombios.h           |    2 +-
 drivers/gpu/drm/radeon/r600.c               |    2 +-
 drivers/gpu/drm/radeon/radeon_kms.c         |    4 ++++
 drivers/gpu/drm/ttm/ttm_bo_util.c           |    1 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c        |    8 ++++----
 drivers/gpu/vga/vgaarb.c                    |    2 +-
 8 files changed, 19 insertions(+), 12 deletions(-)
