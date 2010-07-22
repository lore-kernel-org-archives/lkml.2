Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0GVIiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:38:50 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54976 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072Ab0GVIis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:38:48 -0400
Date: Thu, 22 Jul 2010 09:38:32 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes - some more
Message-ID: <alpine.DEB.2.00.1007220936490.23551@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Looks like I didn't build on IA64 (who knew), fix from Tony and a few more 
radeon fixes one for a regression since the output probing.

The following changes since commit c42750b0261274107ae85c894c088e618a3e38b9:

  drm/r600: fix possible NULL pointer derefernce (2010-07-21 10:29:32 +1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (3):
      drm/radeon/kms: fix legacy LVDS dpms sequence
      drm/radeon/kms: fix RADEON_INFO_CRTC_FROM_ID info ioctl
      drm/radeon/kms: add quirk to make HP DV5000 laptop resume

Dave Airlie (1):
      drm/radeon/kms: drop taking lock around crtc lookup.

Tony Luck (1):
      Fix ttm_page_alloc.c build breakage

 drivers/gpu/drm/radeon/evergreen_cs.c           |    2 --
 drivers/gpu/drm/radeon/r100.c                   |    2 --
 drivers/gpu/drm/radeon/r600_cs.c                |    3 +--
 drivers/gpu/drm/radeon/radeon_combios.c         |    8 ++++++++
 drivers/gpu/drm/radeon/radeon_kms.c             |    3 ++-
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    1 +
 drivers/gpu/drm/ttm/ttm_page_alloc.c            |    6 +++---
 7 files changed, 15 insertions(+), 10 deletions(-)
