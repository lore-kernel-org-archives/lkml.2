Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab1ILTx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 15:53:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41054 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338Ab1ILTx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 15:53:57 -0400
Date: Mon, 12 Sep 2011 20:55:55 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1109122054380.25877@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

more changes from my people.freedesktop.org tree, a major nouveau 
regression fix, along with a radeon DP fix, and a silly core spare line 
removal.

Dave.

The following changes since commit ddf28352b80c86754a6424e3a61e8bdf9213b3c7:

  Linux 3.1-rc5 (2011-09-04 15:45:10 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux.git drm-fixes

Alex Deucher (1):
      drm/radeon/kms: fix DP detect and EDID fetch for DP bridges

Ben Skeggs (1):
      drm/nouveau: fix oops on pre-semaphore hardware

Dave Airlie (1):
      Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-test

Emil Velikov (2):
      drm/nv50/crtc: Bail out if FB is not bound to crtc
      drm/nv04/crtc: Bail out if FB is not bound to crtc

Lin Ming (1):
      drm: Remove duplicate "return" statement

Marcin Slusarz (2):
      drm/nouveau: properly handle allocation failure in nouveau_sgdma_populate
      drm/nouveau: fix nv04_sgdma_bind on non-"4kB pages" archs

 drivers/gpu/drm/drm_fb_helper.c            |    1 -
 drivers/gpu/drm/nouveau/nouveau_fence.c    |    3 +-
 drivers/gpu/drm/nouveau/nouveau_sgdma.c    |    7 ++++-
 drivers/gpu/drm/nouveau/nv04_crtc.c        |   15 ++++++++++-
 drivers/gpu/drm/nouveau/nv50_crtc.c        |   12 +++++++-
 drivers/gpu/drm/radeon/radeon_connectors.c |   37 ++++++++++++++++++----------
 drivers/gpu/drm/radeon/radeon_display.c    |   19 +++++++++-----
 7 files changed, 66 insertions(+), 28 deletions(-)
