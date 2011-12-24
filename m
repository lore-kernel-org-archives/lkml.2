Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1LXRnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Dec 2011 12:43:42 -0500
Received: from gir.skynet.ie ([193.1.99.77]:53327 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab1LXRnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Dec 2011 12:43:40 -0500
Date: Sat, 24 Dec 2011 17:43:37 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes
Message-ID: <alpine.DEB.2.00.1112241742500.17632@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Happy Christmas, two fixes, one for radeon, one for vmwgfx.

Dave.

The following changes since commit b9e26dfdad5a4f9cbdaacafac6998614cc9c41bc:

  Merge git://git.infradead.org/mtd-2.6 (2011-12-20 18:39:37 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms: bail on BTC parts if MC ucode is missing

Xi Wang (1):
      vmwgfx: fix incorrect VRAM size check in vmw_kms_fb_create()

 drivers/gpu/drm/radeon/evergreen.c  |   12 ++++++++++++
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c |    6 +++---
 2 files changed, 15 insertions(+), 3 deletions(-)
