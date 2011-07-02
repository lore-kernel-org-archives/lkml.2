Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab1GBIYO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 04:24:14 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44873 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab1GBIYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 04:24:09 -0400
Date: Sat, 2 Jul 2011 09:23:28 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon/nouveau fixes
Message-ID: <alpine.DEB.2.00.1107020922170.24693@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Ben was a bit hopeful that NVidia didn't redesign half the gpu for a new 
series, apparantly they did, so the 0xd0 series needs some more work, and 
another couple of minor radeon fixes from Alex.

Dave.

The following changes since commit daf54f1f363a61c618662ef66d4bf09d2b090941:

  drm/radeon/kms: Fix chremap setup on RV770 CE (2011-07-01 07:29:46 +1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (2):
      drm/radeon/kms: use correct reg on fusion when reading back mem config
      drm/radeon/kms: fix typo in cayman reg offset

Ben Skeggs (1):
      Revert "drm/nvc0: recognise 0xdX chipsets as NV_C0"

 drivers/gpu/drm/nouveau/nouveau_state.c |    2 --
 drivers/gpu/drm/radeon/evergreen.c      |    5 ++++-
 drivers/gpu/drm/radeon/nid.h            |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)
