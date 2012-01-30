Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124Ab2A3KDP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 05:03:15 -0500
Received: from gir.skynet.ie ([193.1.99.77]:35731 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751669Ab2A3KDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 05:03:14 -0500
Date: Mon, 30 Jan 2012 10:03:12 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1201301000430.16881@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just some misc fixes that built up over the weekend, nothing too major or 
serious, one revert from Daniel after testing -rc1 on old hw.

Dave.

The following changes since commit 0a9626575400879d1d5e6bc8768188b938d7c501:

  Merge tag 'driver-core-3.3-rc1-bugfixes' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core (2012-01-28 18:20:48 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Chris Wilson (1):
      drm: Pass the real error code back during GEM bo initialisation

Daniel Vetter (1):
      Revert "drm/i810: cleanup reclaim_buffers"

Jean Delvare (1):
      drm/radeon/kms: Fix device tree linkage of i2c buses

Ryan Mallon (1):
      vmwgfx: Fix assignment in vmw_framebuffer_create_handle

 drivers/gpu/drm/drm_gem.c           |    2 +-
 drivers/gpu/drm/i810/i810_dma.c     |   17 ++++++-----------
 drivers/gpu/drm/i810/i810_drv.c     |    1 +
 drivers/gpu/drm/i810/i810_drv.h     |    6 ++++--
 drivers/gpu/drm/radeon/radeon_i2c.c |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |    2 +-
 6 files changed, 14 insertions(+), 15 deletions(-)
