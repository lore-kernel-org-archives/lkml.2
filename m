Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab2JaEgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 00:36:39 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55994 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab2JaEgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 00:36:38 -0400
Date: Wed, 31 Oct 2012 04:36:28 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm nouveau fixes
Message-ID: <alpine.DEB.2.00.1210310434400.23793@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just a nouveau set, since we have a couple of reports on lkml/dri-devel of 
regressions that this should fix I sent it along on its own.

Dave.

The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Ben Skeggs (6):
      drm/nouveau: silence modesetting spam on pre-gf8 chipsets
      drm/nouveau/i2c: fix typo when checking nvio i2c port validity
      drm/nouveau: allow creation of zero-sized mm
      drm/nv50/fb: prevent oops on chipsets without compression tags
      drm/nouveau: resurrect headless mode since rework
      drm/nouveau: headless mode by default if pci class != vga display

Dave Airlie (1):
      Merge branch 'drm-nouveau-fixes' of git://people.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

 drivers/gpu/drm/nouveau/core/core/mm.c         |    9 ++++--
 drivers/gpu/drm/nouveau/core/include/core/mm.h |    1 -
 drivers/gpu/drm/nouveau/core/subdev/fb/nv50.c  |   10 ++----
 drivers/gpu/drm/nouveau/core/subdev/i2c/base.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_display.c      |   36 ++++++++++++++----------
 drivers/gpu/drm/nouveau/nouveau_drm.c          |   36 ++++++++++++++----------
 drivers/gpu/drm/nouveau/nouveau_drm.h          |    2 +
 drivers/gpu/drm/nouveau/nouveau_irq.c          |   16 ++++++----
 drivers/gpu/drm/nouveau/nv04_dac.c             |   16 +++++-----
 drivers/gpu/drm/nouveau/nv04_dfp.c             |   14 ++++----
 drivers/gpu/drm/nouveau/nv04_tv.c              |    9 ++---
 11 files changed, 83 insertions(+), 68 deletions(-)
