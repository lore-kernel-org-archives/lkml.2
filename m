Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab1HWM3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 08:29:05 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42451 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab1HWM25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 08:28:57 -0400
Date: Tue, 23 Aug 2011 13:29:46 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1108231328530.15283@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1692824240-1314102586=:15283"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1692824240-1314102586=:15283
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


Hi Linus,

Nothing two major, two regressions fixes in nouveau s/r support, alpha 
radeon support,  and some radeon fixes.

Dave.

The following changes since commit 3210d190dcb717c328d74f8c3f69ec717d665b40:

  Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6 (2011-08-21 18:13:19 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Ben Skeggs (2):
      drm/ttm: unbind ttm before destroying node in accel move cleanup
      drm/ttm: ensure ttm for new node is bound before calling move_notify()

Jay Estabrook (1):
      drm/radeon/alpha: Add Alpha support to Radeon DRM code

Marcin Slusarz (1):
      drm/ttm: fix ttm_bo_add_ttm(user) failure path

Michel Dänzer (3):
      drm/radeon: Take IH ring into account for test size calculation.
      drm/radeon: Explicitly print GTT/VRAM offsets on test failure.
      drm/radeon: Make vramlimit parameter actually work.

Thomas Reim (1):
      drm/radeon: Extended DDC Probing for Toshiba L300D Radeon Mobility X1100 HDMI-A Connector

 drivers/gpu/drm/radeon/radeon_connectors.c |   10 ++++++++
 drivers/gpu/drm/radeon/radeon_device.c     |    2 +
 drivers/gpu/drm/radeon/radeon_test.c       |   34 ++++++++++++++++++++-------
 drivers/gpu/drm/radeon/radeon_ttm.c        |   23 +++++++++++++++++++
 drivers/gpu/drm/ttm/ttm_bo.c               |   14 +++++++----
 drivers/gpu/drm/ttm/ttm_bo_util.c          |    2 +-
 6 files changed, 70 insertions(+), 15 deletions(-)
--29444707-1692824240-1314102586=:15283--
