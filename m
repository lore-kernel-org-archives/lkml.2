Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab1GMGwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 02:52:32 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60250 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758044Ab1GMGwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 02:52:31 -0400
Date: Wed, 13 Jul 2011 07:51:49 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1107130751040.4922@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Minor set of fixes from Alex including one hotplug regression and one 
intel AGP fix.

Dave.

The following changes since commit 620917de59eeb934b9f8cf35cc2d95c1ac8ed0fc:

  Linux 3.0-rc7 (2011-07-11 16:51:52 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (5):
      drm/radeon/kms: fix regression in hotplug
      drm/radeon/kms: fix backend map typo on juniper
      drm/radeon/kms: use correct BUS_CNTL reg on rs600
      drm/radeon/kms: fix typo in read_disabled vbios code
      drm/radeon/kms/evergreen: emit SQ_LDS_RESOURCE_MGMT for blits

Chris Wilson (1):
      agp/intel: Fix typo in G4x_GMCH_SIZE_VT_2M

 drivers/char/agp/intel-agp.h                |    7 ++++---
 drivers/gpu/drm/radeon/evergreen.c          |    2 +-
 drivers/gpu/drm/radeon/evergreen_blit_kms.c |    9 +++++++--
 drivers/gpu/drm/radeon/radeon_bios.c        |   21 +++++++++++++++------
 drivers/gpu/drm/radeon/radeon_connectors.c  |    6 ++++++
 drivers/gpu/drm/radeon/radeon_reg.h         |    2 ++
 drivers/gpu/drm/radeon/rs600.c              |    6 +++---
 7 files changed, 38 insertions(+), 15 deletions(-)
