Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2EGKdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 06:33:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40958 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab2EGKdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 06:33:09 -0400
Date: Mon, 7 May 2012 11:33:07 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1205071132140.1558@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two fixes from Intel, one a regression, one because I merged an early 
version of a fix.

Also the nouveau revert of the i2c code that was tested on the list.

Dave.

The following changes since commit febb72a6e4cc6c8cffcc1ea649a3fb364f1ea432:

  IA32 emulation: Fix build problem for modular ia32 a.out support (2012-05-06 18:26:20 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Ben Skeggs (1):
      drm/nouveau/i2c: resume use of i2c-algo-bit, rather than custom stack

Daniel Vetter (2):
      drm/i915: disable sdvo hotplug on i945g/gm
      drm/i915: Do no set Stencil Cache eviction LRA w/a on gen7+

Dave Airlie (1):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

 drivers/gpu/drm/i915/intel_ringbuffer.c |    9 +-
 drivers/gpu/drm/i915/intel_sdvo.c       |    6 +
 drivers/gpu/drm/nouveau/nouveau_i2c.c   |  199 ++++---------------------------
 drivers/gpu/drm/nouveau/nouveau_i2c.h   |    1 +
 4 files changed, 34 insertions(+), 181 deletions(-)
