Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1H3KAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 06:00:53 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49232 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1H3KAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 06:00:50 -0400
Date: Tue, 30 Aug 2011 11:02:01 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1108301101160.3211@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

two radeon fixes, one core fix, all pretty trivial.

Dave.

The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:

  Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (1):
      drm/radeon/kms: add s/r quirk for Compaq Presario V5245EU

Jerome Glisse (1):
      drm/radeon/kms: evergreen & ni reset SPI block on CP resume

Joonyoung Shim (1):
      drm: Fix the number of connector and encoder to cleanup functions

 drivers/gpu/drm/drm_crtc.c              |    2 ++
 drivers/gpu/drm/radeon/evergreen.c      |    1 +
 drivers/gpu/drm/radeon/ni.c             |    1 +
 drivers/gpu/drm/radeon/radeon_combios.c |    8 ++++++++
 4 files changed, 12 insertions(+), 0 deletions(-)
