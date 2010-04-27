Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab0D0GQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 02:16:20 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60767 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab0D0GQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 02:16:19 -0400
Date: Tue, 27 Apr 2010 07:16:00 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1004270714090.21411@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

radeon: couple of evergreen support fixes, + pipe fix for r300, sparc 
regression fix
core: another vblank from jbarnes.

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

David Miller (1):
      drm/radeon: Fix sparc regression in r300_scratch()

Jesse Barnes (1):
      drm: make sure vblank interrupts are disabled at DPMS time

Tormod Volden (1):
      drm/radeon: 9800 SE has only one quadpipe

 drivers/gpu/drm/drm_irq.c                |    1 +
 drivers/gpu/drm/radeon/r300.c            |    5 ++---
 drivers/gpu/drm/radeon/r300_cmdbuf.c     |    2 +-
 drivers/gpu/drm/radeon/r420.c            |    6 ++++++
 drivers/gpu/drm/radeon/radeon_cp.c       |    9 +++++++--
 drivers/gpu/drm/radeon/radeon_display.c  |    8 ++++----
 drivers/gpu/drm/radeon/radeon_encoders.c |    2 +-
 drivers/gpu/drm/radeon/radeon_kms.c      |    6 +++---
 8 files changed, 25 insertions(+), 14 deletions(-)
