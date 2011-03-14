Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab1CNE3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 00:29:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51775 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab1CNE3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 00:29:18 -0400
Date: Mon, 14 Mar 2011 04:28:48 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm final final final fixes
Message-ID: <alpine.DEB.2.00.1103140426200.2738@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Okay another radeon regression showed up in the late stages, and I've 
pushed a fix for a 3rd problem, again reported on fusion systems which 
currently none of the devs have access to.

This is on top of the last req, which contains the other fusion fix and 
the complete system hang fixes.

Dave.

The following changes since commit 9179746652faf0aba07b8b7f770dcf29892a24c6:

  Merge branch 'media_fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6 (2011-03-10 13:22:10 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Dave Airlie (3):
      drm/radeon: add pageflip hooks for fusion
      drm/radeon: fix page flipping hangs on r300/r400
      drm/radeon: fix problem with changing active VRAM size. (v2)

 drivers/gpu/drm/radeon/evergreen.c          |    3 +--
 drivers/gpu/drm/radeon/evergreen_blit_kms.c |    4 ++--
 drivers/gpu/drm/radeon/r100.c               |   22 ++--------------------
 drivers/gpu/drm/radeon/r600.c               |    3 +--
 drivers/gpu/drm/radeon/r600_blit_kms.c      |    4 ++--
 drivers/gpu/drm/radeon/radeon.h             |    2 +-
 drivers/gpu/drm/radeon/radeon_asic.c        |    3 +++
 drivers/gpu/drm/radeon/radeon_gem.c         |    5 ++++-
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    3 ++-
 drivers/gpu/drm/radeon/radeon_ttm.c         |   14 ++++++++++++++
 drivers/gpu/drm/radeon/rs600.c              |    1 -
 drivers/gpu/drm/radeon/rs690.c              |    1 -
 drivers/gpu/drm/radeon/rv770.c              |    3 +--
 13 files changed, 33 insertions(+), 35 deletions(-)
