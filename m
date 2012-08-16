Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2HPFB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 01:01:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42472 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914Ab2HPFBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 01:01:54 -0400
Date: Thu, 16 Aug 2012 06:01:52 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] more drm fixes
Message-ID: <alpine.DEB.2.00.1208160600330.24165@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just some intel and nouveau ones this time, intel has more edp panel fixes 
for macbooks and nouveau has a suspend/resume regression fix in there.

Dave.

The following changes since commit 7bac6b46607f2f44075cb45dd5b0b4d2e7c80695:

  Merge branch 'drm-fixes-3.6' of git://people.freedesktop.org/~agd5f/linux into drm-fixes (2012-08-14 09:25:01 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux.git drm-fixes

for you to fetch changes up to 2e26c73a1e410448fbd2c0fbd34f06d98eaf8e48:

  Merge branch 'drm-nouveau-fixes' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes (2012-08-15 20:31:22 +1000)

----------------------------------------------------------------

Ben Skeggs (2):
      drm/nve0/fifo: add support for the flip completion swmthd
      drm/nouveau/aux: mask off higher bits of auxch index in i2c table entry

Chris Wilson (1):
      drm/i915: Apply post-sync write for pipe control invalidates

Christoph Bumiller (1):
      drm/nvd0/disp: mask off high 16 bit of negative cursor x-coordinate

Daniel Vetter (2):
      drm/i915: ignore eDP bpc settings from vbt
      drm/i915: reorder edp disabling to fix ivb MacBook Air

Dave Airlie (2):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
      Merge branch 'drm-nouveau-fixes' of git://git.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes

Henrik Rydberg (1):
      drm/nouveau: disable copy engine on NVAF

Jani Nikula (1):
      drm/i915: ensure i2c adapter is all set before adding it

Maarten Lankhorst (1):
      nouveau: fixup scanout enable in nvc0_pm

Maxim Levitsky (1):
      drm/nv86/fifo: suspend fix

Takashi Iwai (1):
      drm/i915: Fix blank panel at reopening lid

 drivers/gpu/drm/i915/intel_display.c    |   11 ---------
 drivers/gpu/drm/i915/intel_dp.c         |   14 +++++------
 drivers/gpu/drm/i915/intel_i2c.c        |    7 +++---
 drivers/gpu/drm/i915/intel_panel.c      |   13 +++++++---
 drivers/gpu/drm/i915/intel_ringbuffer.c |   41 +++++++++++++++++--------------
 drivers/gpu/drm/nouveau/nouveau_i2c.c   |    2 +-
 drivers/gpu/drm/nouveau/nouveau_state.c |    1 -
 drivers/gpu/drm/nouveau/nv84_fifo.c     |    9 +++++++
 drivers/gpu/drm/nouveau/nvc0_pm.c       |    2 +-
 drivers/gpu/drm/nouveau/nvd0_display.c  |    2 +-
 drivers/gpu/drm/nouveau/nve0_fifo.c     |   37 +++++++++++++++++++++++++---
 11 files changed, 88 insertions(+), 51 deletions(-)
