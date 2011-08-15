Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1HOJAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 05:00:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33006 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab1HOJAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 05:00:10 -0400
Date: Mon, 15 Aug 2011 10:00:30 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fixes
Message-ID: <alpine.DEB.2.00.1108150959170.9682@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

nothing too serious here, one regression fix across a couple of card 
families, and some workaround to make things work better on some Apple 
hardware.

Dave.

The following changes since commit 72fa59970f8698023045ab0713d66f3f4f96945c:

  move RLIMIT_NPROC check from set_user() to do_execve_common() (2011-08-11 11:24:42 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (4):
      drm/radeon/kms: don't enable connectors that are off in the hotplug handler
      drm/radeon/kms: fix regression is handling >2 heads on cedar/caicos
      drm/radeon/kms: make some watermark messages debug only
      drm/radeon/kms: don't try to be smart in the hpd handler

Matthew Garrett (2):
      drm/radeon: Allow panel preferred EDID to override BIOS native mode
      drm/radeon: re-POST the asic on Apple hardware when booted via EFI

 drivers/gpu/drm/radeon/atombios_dp.c       |   12 +++++++++++
 drivers/gpu/drm/radeon/evergreen.c         |    2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c |   29 +++++++++++++++++++--------
 drivers/gpu/drm/radeon/radeon_device.c     |    4 +++
 drivers/gpu/drm/radeon/radeon_encoders.c   |    3 ++
 drivers/gpu/drm/radeon/radeon_mode.h       |    1 +
 6 files changed, 41 insertions(+), 10 deletions(-)
