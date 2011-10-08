Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab1JHHRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 03:17:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52270 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab1JHHRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 03:17:30 -0400
Date: Sat, 8 Oct 2011 08:20:53 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1110080819520.13273@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just some more fixes from Alex for various displayport and llano output 
setup on radeon.

Dave.

The following changes since commit 976d167615b64e14bc1491ca51d424e2ba9a5e84:

  Linux 3.1-rc9 (2011-10-04 18:11:50 -0700)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux.git drm-fixes

Alex Deucher (3):
      drm/radeon/kms: retry aux transactions if there are status flags
      drm/radeon/kms: fix dp_detect handling for DP bridge chips
      drm/radeon/kms: use hardcoded dig encoder to transmitter mapping for DCE4.1

 drivers/gpu/drm/radeon/atombios_dp.c       |   12 +++++++++---
 drivers/gpu/drm/radeon/radeon_connectors.c |   21 ++++++---------------
 drivers/gpu/drm/radeon/radeon_encoders.c   |    9 ++++++---
 3 files changed, 21 insertions(+), 21 deletions(-)
