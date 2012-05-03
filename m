Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2ECIge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 04:36:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34530 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab2ECIgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 04:36:31 -0400
Date: Thu, 3 May 2012 09:36:30 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm nouveau fixes
Message-ID: <alpine.DEB.2.00.1205030935350.4416@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just some regression fixes from Ben along with a variable that gcc failed 
to spot is uninitialised.

Dave.

The following changes since commit 655861e328cea83320190f4a57b3656ee952388c:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm (2012-04-30 15:34:41 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Ben Skeggs (3):
      drm/nouveau/bios: fix regression on some nv4x board
      drm/nouveau/hdmi: use correct hdmi regs for nvaa/nvac
      drm/nv10/gpio: fix thinko in mask for gpio lines 2-9

Christoph Bumiller (1):
      nvc0/fb: shut up PMFB interrupt after the first occurrence

Dave Airlie (2):
      Merge branch 'drm-nouveau-fixes' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes
      nouveau: initialise has_optimus variable.

 drivers/gpu/drm/nouveau/nouveau_acpi.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_bios.c |   10 +++++++---
 drivers/gpu/drm/nouveau/nouveau_hdmi.c |    4 +++-
 drivers/gpu/drm/nouveau/nv10_gpio.c    |    2 +-
 drivers/gpu/drm/nouveau/nvc0_fb.c      |    5 +++++
 5 files changed, 17 insertions(+), 6 deletions(-)
