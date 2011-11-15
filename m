Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab1KOUap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:30:45 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43192 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120Ab1KOUao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:30:44 -0500
Date: Tue, 15 Nov 2011 20:32:17 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm/vgaarb fixes
Message-ID: <alpine.DEB.2.00.1111152030580.25464@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Fix for a vgaarb bridge detect problem I found playing in qemu, a radeon 
oops fix, missing PCI IDs, and a fix from the -rt guys that I've forgotten 
to send 2 or 3 times now.

Dave.

The following changes since commit a7c36fd8c5ee6dcca584137cb81aeefd785a0721:

  drm/radeon/kms/combios: fix dynamic allocation of PM clock modes (2011-11-12 17:46:40 +0000)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (3):
      drm/radeon: add some missing FireMV pci ids
      drm/radeon/kms: fix up gpio i2c mask bits for r4xx
      drm/radeon/kms: fix segfault in pm rework

Dave Airlie (1):
      vgaarb: a NULL bridge is acceptable for root devices.

Thomas Gleixner (1):
      drm: Remove utterly bogus preempt_disable() sections

 drivers/gpu/drm/drm_irq.c                |    9 ------
 drivers/gpu/drm/radeon/radeon_atombios.c |   32 +++++++++++----------
 drivers/gpu/vga/vgaarb.c                 |   44 ++++++++++++++---------------
 include/drm/drm_pciids.h                 |    2 +
 4 files changed, 40 insertions(+), 47 deletions(-)
