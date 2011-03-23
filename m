Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1CWETY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 00:19:24 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33677 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab1CWETX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 00:19:23 -0400
Date: Wed, 23 Mar 2011 04:18:52 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1103230417270.29019@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

One radeon, 2 core fixes, and an interface update to allow for > 2 crtcs 
in vblank.

hopefully the Intel guys can give me some updates on the s/r issue 
tomorrow.

Dave.

The following changes since commit c87a8d8dcd2587c203f3dd8a3c5c15d1e128ec0d:

  drm/radeon: fixup refcounts in radeon dumb create ioctl. (2011-03-17 13:58:34 +1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (1):
      drm/radeon/kms: prefer legacy pll algo for tv-out

Chris Wilson (1):
      drm: Fix use-after-free in drm_gem_vm_close()

Dave Airlie (1):
      drm: check for modesetting on modeset ioctls

Ilija Hadzic (1):
      drm/kernel: vblank wait on crtc > 1

 drivers/gpu/drm/drm_crtc.c             |   51 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_gem.c              |    5 ++-
 drivers/gpu/drm/drm_ioctl.c            |    3 ++
 drivers/gpu/drm/drm_irq.c              |   15 ++++++---
 drivers/gpu/drm/radeon/atombios_crtc.c |    6 +++-
 include/drm/drm.h                      |    3 ++
 6 files changed, 75 insertions(+), 8 deletions(-)
