Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344Ab1EIElS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 00:41:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49737 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab1EIElR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 00:41:17 -0400
Date: Mon, 9 May 2011 05:40:44 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1105090538250.8999@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

One regression fix in the debugfs output, a couple of radeon fixes, and a 
nouveau unload fix. I've got a dirty fix for the DMA_ERROR_CODE dependency 
breaking drm on alpha but waiting for a bit more before you get it, its 
just a workaround until proper fix can happen in 2.6.40 hopefully

Dave.

The following changes since commit 8aeb96f80232e9a701b5c4715504f4c9173978bd:

  drm/radeon/kms: fix gart setup on fusion parts (v2) (2011-05-04 10:16:40 +1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (2):
      drm/radeon/kms: ATPX switcheroo fixes
      drm/radeon/kms: add pci id to acer travelmate quirk for 5730

Daniel Vetter (1):
      drm: mm: fix debug output

Dave Airlie (1):
      Merge remote branch 'nouveau/drm-nouveau-fixes' of /ssd/git/drm-nouveau-next into drm-fixes

Ilija Hadzic (1):
      drm/radeon: fix order of doing things in radeon_crtc_cursor_set

Jimmy Rentz (1):
      drm/nouveau: Fix a crash at card takedown for NV40 and older cards

 drivers/gpu/drm/drm_mm.c                     |    6 ++--
 drivers/gpu/drm/nouveau/nouveau_mem.c        |    2 -
 drivers/gpu/drm/nouveau/nouveau_state.c      |    5 ++++
 drivers/gpu/drm/radeon/radeon_atombios.c     |    4 +-
 drivers/gpu/drm/radeon/radeon_atpx_handler.c |   29 ++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/radeon_cursor.c       |    6 ++--
 include/drm/drm_mm.h                         |    2 +-
 7 files changed, 41 insertions(+), 13 deletions(-)
