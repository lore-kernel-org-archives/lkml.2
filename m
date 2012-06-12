Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab2FLPfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:35:54 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42359 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab2FLPfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:35:52 -0400
Date: Tue, 12 Jun 2012 16:35:51 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1206121634140.13373@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus

as per your -rc2 announce, this is small and urgent only,

The radeon one is for a regression in 3.4 so we need this one in your tree 
so we can send the stable one out, code in 3.4 broke some old userspaces.
The max props increase fixes spew being seen on a few machines.
and a ttm regression to fix some accounting issues that affect vmwgfx.

Dave.

The following changes since commit cfaf025112d3856637ff34a767ef785ef5cf2ca9:

  Linux 3.5-rc2 (2012-06-08 18:40:09 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to a393c730ab69617c3291a3b0b2a228c9be2fc28c:

  drm/ttm: Fix buffer object metadata accounting regression v2 (2012-06-12 15:57:47 +0100)

----------------------------------------------------------------
Jerome Glisse (1):
      drm/radeon: fix tiling and command stream checking on evergreen v3

Paulo Zanoni (1):
      drm: increase DRM_OBJECT_MAX_PROPERTY to 24

Thomas Hellstrom (1):
      drm/ttm: Fix buffer object metadata accounting regression v2

 drivers/gpu/drm/radeon/evergreen_cs.c |   49 ++++++++++++++++++++++++++++++---
 drivers/gpu/drm/radeon/radeon_drv.c   |    3 +-
 drivers/gpu/drm/ttm/ttm_bo.c          |   13 ++-------
 include/drm/drm_crtc.h                |    2 +-
 4 files changed, 51 insertions(+), 16 deletions(-)
