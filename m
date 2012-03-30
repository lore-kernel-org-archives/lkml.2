Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012Ab2C3Nr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 09:47:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51896 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932832Ab2C3Nrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 09:47:52 -0400
Date: Fri, 30 Mar 2012 14:47:50 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm dma-buf prime support
Message-ID: <alpine.DEB.2.00.1203301445190.24298@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

This isn't a majorly urgent thing to have, but we'd like to set the stage 
for working on dma-buf support in the drm drivers for the next merge 
window, so I'd like to push in the initial submission now so people have
something that we can build on top of. The code just introduces the user
interface and internal helper functions for drivers to use.

We have driver support under development for i915, nouveau, udl on x86 and 
exynos, omapdrm on arm, which we would be aiming for the next merge 
window.

Dave.

The following changes since commit f52b69f86e27903d6896ed5fa7cd280fec8de532:

  Merge tag 'sh-for-linus' of git://github.com/pmundt/linux-sh (2012-03-30 00:09:17 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-prime-dmabuf-initial

Dave Airlie (1):
      drm: base prime/dma-buf support (v5)

 drivers/gpu/drm/Kconfig     |    1 +
 drivers/gpu/drm/Makefile    |    2 +-
 drivers/gpu/drm/drm_drv.c   |    4 +
 drivers/gpu/drm/drm_fops.c  |    7 +
 drivers/gpu/drm/drm_gem.c   |    9 ++
 drivers/gpu/drm/drm_prime.c |  304 +++++++++++++++++++++++++++++++++++++++++++
 include/drm/drm.h           |   14 ++-
 include/drm/drmP.h          |   62 +++++++++
 8 files changed, 401 insertions(+), 2 deletions(-)
 create mode 100644 drivers/gpu/drm/drm_prime.c
