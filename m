Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758381Ab2EDOek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:34:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:47619 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab2EDOej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:34:39 -0400
Date: Fri, 4 May 2012 15:26:13 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1205041525020.10373@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some minor fixes from Intel and a radeon fix.

I have the nouveau fix for the i2c regression queued for next week,
its mostly a revert and seems to work on the system it was originally
introduced for thanks to some i2c core changes.

Dave.

The following changes since commit addde4ec31456c5f1e9b61aae3edcfeb0f338f87:

  nouveau: initialise has_optimus variable. (2012-05-03 09:30:58 +0100)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon: clarify and extend wb setup on APUs and NI+ asics

Chris Wilson (2):
      drm/i915: Do not read non-existent DPLL registers on PCH hardware
      drm/i915: Only enable IPS polling for gen5

Dave Airlie (1):
      Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes

Marc Gariepy (1):
      fixing dmi match for hp t5745 and hp st5747 thin client

Paulo Zanoni (1):
      drm/i915: enable dip before writing data on gen4

 drivers/gpu/drm/i915/i915_debugfs.c    |    3 +++
 drivers/gpu/drm/i915/i915_dma.c        |   15 ++++++++++-----
 drivers/gpu/drm/i915/intel_display.c   |    9 +++++----
 drivers/gpu/drm/i915/intel_hdmi.c      |    2 +-
 drivers/gpu/drm/i915/intel_lvds.c      |    4 ++--
 drivers/gpu/drm/radeon/radeon_device.c |    4 ++--
 6 files changed, 23 insertions(+), 14 deletions(-)
