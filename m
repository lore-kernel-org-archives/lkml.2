Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2I0IDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:03:32 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48528 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755765Ab2I0IDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:03:14 -0400
Date: Thu, 27 Sep 2012 09:03:11 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1209270901250.23614@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus

the three nouveau fixes quiten unneeded dmesg spam that people are 
seeing and pondering, 
the udl fix stops it from trying to driver monitors that are too big, 
where we get a black screen.
and vmware memory alloc problem.

Dave.

The following changes since commit 6f0f9b6b3fcfe5e156f20d4f804f0d505c750b3c:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-09-25 14:20:29 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to d638163099c86f65984d85aab7ddf2cf78fa3a16:

  Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes (2012-09-27 17:58:53 +1000)

----------------------------------------------------------------

Ben Skeggs (3):
      drm/nouveau: silence a debug message triggered by newer userspace
      drm/nvc0/ltcg: mask off intr 0x10
      drm/nvc0/fifo: ignore bits in PFIFO_INTR that aren't set in PFIFO_INTR_EN

Dan Carpenter (1):
      vmwgfx: corruption in vmw_event_fence_action_create()

Dave Airlie (3):
      Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      drm/udl: limit modes to the sku pixel limits.
      Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

 drivers/gpu/drm/nouveau/nouveau_abi16.c | 2 +-
 drivers/gpu/drm/nouveau/nvc0_fb.c       | 1 +
 drivers/gpu/drm/nouveau/nvc0_fifo.c     | 3 ++-
 drivers/gpu/drm/nouveau/nve0_fifo.c     | 3 ++-
 drivers/gpu/drm/udl/udl_connector.c     | 7 +++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c   | 2 +-
 6 files changed, 14 insertions(+), 4 deletions(-)
