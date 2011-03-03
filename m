Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab1CCDMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 22:12:30 -0500
Received: from gir.skynet.ie ([193.1.99.77]:60394 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab1CCDM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 22:12:29 -0500
Date: Thu, 3 Mar 2011 03:12:01 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1103030311260.2738@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just an intel fix for some chipsets with > 4GB RAM.

Dave.

The following changes since commit dd9c1549edef02290edced639f67b54a25abbe0e:

  Linux 2.6.38-rc7 (2011-03-01 13:55:12 -0800)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Dave Airlie (1):
      Merge remote branch 'intel/drm-intel-fixes' of /ssd/git/drm-next into drm-fixes

Jan Niehusmann (1):
      drm/i915: fix memory corruption with GM965 and >4GB RAM

 drivers/gpu/drm/i915/i915_dma.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)
