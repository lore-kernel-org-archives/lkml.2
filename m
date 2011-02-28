Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab1B1VOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 16:14:53 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56315 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544Ab1B1VOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 16:14:52 -0500
Date: Mon, 28 Feb 2011 21:14:24 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1102282112540.17451@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

one security local priv exploit already public in OpenBSD tre, if a user 
has access to the DRI device node,

also a nouveau corruption fix from Ben for a bunch of nvidia gpus.

Dave.

The following changes since commit 3c0556e9673f79e386b27768e27d18b3ce29e40e:

  Merge branch 'drm-intel-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/ickle/drm-intel into drm-fixes (2011-02-25 08:40:26 +1000)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Ben Skeggs (1):
      drm/nv50-nvc0: make sure vma is definitely unmapped when destroying bo

Dave Airlie (2):
      drm: fix unsigned vs signed comparison issue in modeset ctl ioctl.
      Merge remote branch 'nouveau/drm-nouveau-fixes' of /ssd/git/drm-nouveau-next into drm-fixes

 drivers/gpu/drm/drm_irq.c            |    3 ++-
 drivers/gpu/drm/nouveau/nouveau_bo.c |    5 ++++-
 include/drm/drmP.h                   |    2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)
