Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab0DWGgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 02:36:01 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53250 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755412Ab0DWGgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 02:36:00 -0400
Date: Fri, 23 Apr 2010 07:35:40 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fixes
Message-ID: <alpine.DEB.2.00.1004230734480.14446@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some minor fixes to the radeon KMS driver three evergreen related one for 
earlier cards.

The following changes since commit b78315f051de8d207bead90470aa216c0617572b:
  Jesse Barnes (1):
        drm: delay vblank cleanup until after driver unload

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Alex Deucher (2):
      drm/radeon/kms/evergreen: fix LUT setup
      drm/radeon/kms/evergreen: No EnableYUV table

Dave Airlie (1):
      drm/radeon/kms: don't print error for legal crtcs.

Tormod Volden (1):
      drm/radeon: 9800 SE has only one quadpipe

 drivers/gpu/drm/radeon/r300.c            |    5 ++---
 drivers/gpu/drm/radeon/r420.c            |    6 ++++++
 drivers/gpu/drm/radeon/radeon_cp.c       |    9 +++++++--
 drivers/gpu/drm/radeon/radeon_display.c  |    8 ++++----
 drivers/gpu/drm/radeon/radeon_encoders.c |    2 +-
 drivers/gpu/drm/radeon/radeon_kms.c      |    6 +++---
 6 files changed, 23 insertions(+), 13 deletions(-)
