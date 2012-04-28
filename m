Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2D1HMb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 03:12:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40840 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab2D1HMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 03:12:30 -0400
Date: Sat, 28 Apr 2012 08:12:29 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm important driver fixes
Message-ID: <alpine.DEB.2.00.1204280809570.8472@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

As soon as I sent the non-urgent stack, two important fixes come in,

i915: fixes SNB GPU hangs in a number of 3D apps
radeon: initial fix for VGA on LLano system, 3 or 4 of us have spent time 
debugging this, and Jerome finally figured out the magic bit the 
BIOS/fglrx set that we didn't. This at least should get things working, 
there may be future reliability fixes.

Dave.

The following changes since commit c629eaf8392b676b4f83c3dc344e66402bfeec92:

  Merge git://git.samba.org/sfrench/cifs-2.6 (2012-04-27 20:56:54 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms: need to set up ss on DP bridges as well

Kenneth Graunke (1):
      drm/i915: Set the Stencil Cache eviction policy to non-LRA mode.

 drivers/gpu/drm/i915/i915_reg.h         |    1 +
 drivers/gpu/drm/i915/intel_ringbuffer.c |    8 ++++++++
 drivers/gpu/drm/radeon/atombios_crtc.c  |    4 ++--
 3 files changed, 11 insertions(+), 2 deletions(-)
