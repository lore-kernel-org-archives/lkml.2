Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab2JJGuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 02:50:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53324 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334Ab2JJGuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 02:50:16 -0400
Date: Wed, 10 Oct 2012 07:50:13 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm nouveau fixes
Message-ID: <alpine.DEB.2.00.1210100749140.25802@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just a bunch of nouveau fixes, Ben wants to get some alternate versions 
into stable.

Dave.

The following changes since commit 1f31c69dac71bebc0f00bc8534a6345782045501:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next (2012-10-07 21:13:54 +1000)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to ceb736c395058699dc82e5efdb2a9279a5b29451:

  Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next (2012-10-09 14:48:46 +1000)

----------------------------------------------------------------

Ben Skeggs (1):
      drm/nouveau/bios: fix shadowing of ACPI ROMs larger than 64KiB

Dave Airlie (1):
      Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-next

Marcin Slusarz (2):
      drm/nouveau: remove unused _nouveau_parent_ctor
      drm/nv50/clk: wire up pll_calc hook

Martin Peres (2):
      drm/nouveau/fan: fix a typo in PWM's input clock calculation
      drm/nouveau/timer: bump ptimer's alarm delay from u32 to u64

 drivers/gpu/drm/nouveau/core/core/parent.c         |   17 ----------------
 drivers/gpu/drm/nouveau/core/include/core/parent.h |    3 ---
 .../gpu/drm/nouveau/core/include/subdev/timer.h    |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/bios/base.c    |   21 ++++++++++----------
 drivers/gpu/drm/nouveau/core/subdev/clock/nv50.c   |    1 +
 drivers/gpu/drm/nouveau/core/subdev/therm/nv50.c   |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c   |    2 +-
 7 files changed, 14 insertions(+), 34 deletions(-)
