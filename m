Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab2F1MXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 08:23:03 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54995 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473Ab2F1MXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 08:23:02 -0400
Date: Thu, 28 Jun 2012 13:23:00 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1206281322001.10648@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Nearly all intel, one missing license header in nouveau, nothing majorly
earth shattering.

Dave.


The following changes since commit d1346a6cbabf6d377d753f1adc16cb0b305830cc:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2012-06-26 11:26:50 -0700)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 2266b058d3ab9dfc545305d68e754ad9c9a639a0:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2012-06-27 19:56:20 +0100)

----------------------------------------------------------------

Daniel Vetter (2):
      drm/i915: rip out the PM_IIR WARN
      Revert "drm/i915: allow PCH PWM override on IVB"

Dave Airlie (2):
      drm/nouveau: add license header to prime.
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Takashi Iwai (1):
      drm/i915: Fix eDP blank screen after S3 resume on HP desktops

 drivers/gpu/drm/i915/i915_irq.c         |    1 -
 drivers/gpu/drm/i915/i915_suspend.c     |    5 ++++-
 drivers/gpu/drm/i915/intel_display.c    |   16 ----------------
 drivers/gpu/drm/nouveau/nouveau_prime.c |   23 +++++++++++++++++++++++
 4 files changed, 27 insertions(+), 18 deletions(-)
