Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab2CIHVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 02:21:23 -0500
Received: from gir.skynet.ie ([193.1.99.77]:51766 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab2CIHVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 02:21:22 -0500
Date: Fri, 9 Mar 2012 07:21:20 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fixes
Message-ID: <alpine.DEB.2.00.1203090719060.13445@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1274566267-1331277680=:13445"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1274566267-1331277680=:13445
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Just some radeon fixes, one is for an oops where we run out of ioremap 
space on some big hardware systems in 32-bit mode, stuff doesn't work 
properly but at least the machine will boot.

One regression fix, and two bugs, one hw, one blit code.

I think I have some i915 stuff coming from Keith/Jesse yet.

Dave.

The following changes since commit dac12d1f5ef228e132c2457dc214e0703533b016:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-03-06 22:31:08 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms: fix hdmi duallink checks

Christian König (1):
      drm/radeon: fix a semaphore deadlock on pre cayman asics

Dave Airlie (1):
      drm/radeon: deal with errors from framebuffer init path.

Marek Ol¨ák (1):
      drm/radeon/kms: set SX_MISC in the r6xx blit code (v2)

 drivers/gpu/drm/radeon/r600.c              |    3 +++
 drivers/gpu/drm/radeon/r600_blit_shaders.c |    8 ++++++++
 drivers/gpu/drm/radeon/r600d.h             |    1 +
 drivers/gpu/drm/radeon/radeon_connectors.c |    2 +-
 drivers/gpu/drm/radeon/radeon_display.c    |   18 +++++++++++++++---
 drivers/gpu/drm/radeon/radeon_encoders.c   |    6 ++----
 drivers/gpu/drm/radeon/radeon_fb.c         |   11 ++++++++++-
 drivers/gpu/drm/radeon/radeon_mode.h       |    2 +-
 8 files changed, 41 insertions(+), 10 deletions(-)
--29444707-1274566267-1331277680=:13445--
