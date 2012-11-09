Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab2KIK63 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 05:58:29 -0500
Received: from gir.skynet.ie ([193.1.99.77]:56431 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab2KIK62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 05:58:28 -0500
Date: Fri, 9 Nov 2012 10:58:18 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
cc: linux-kernel@vger.kernel.org
Subject: [git pull] drm vmwgfx
Message-ID: <alpine.DEB.2.00.1211091056420.1180@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

dropped the ball on a vmware patch, so two more fixes for vmwgfx are here,
one for hibernate issue, one for a BUG trigger.

Dave.

The following changes since commit 4a48ed2334b7ae61dd11bb114fa35bd4ebdc1ca0:

  Merge branch 'drm-nouveau-fixes' of git://anongit.freedesktop.org/git/nouveau/linux-2.6 into drm-fixes (2012-11-09 14:57:02 +1000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to afcc87aa6a233e52df73552dc1dc9ae3881b7cc8:

  drm/vmwgfx: Fix a case where the code would BUG when trying to pin GMR memory (2012-11-09 20:49:06 +1000)

----------------------------------------------------------------
Thomas Hellstrom (2):
      drm/vmwgfx: Fix hibernation device reset
      drm/vmwgfx: Fix a case where the code would BUG when trying to pin GMR memory

 drivers/gpu/drm/vmwgfx/vmwgfx_dmabuf.c | 2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c    | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)
