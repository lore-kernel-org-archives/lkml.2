Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab1GOP2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:28:47 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42060 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab1GOP2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:28:46 -0400
Date: Fri, 15 Jul 2011 16:28:06 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm radeon pciids update
Message-ID: <alpine.DEB.2.00.1107151627340.9563@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just some pci ids from AMD.

Dave.

The following changes since commit 5dcd07b9f39ca3e9be5bcc387d193fc0674e1c81:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes (2011-07-14 10:20:42 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (1):
      drm/radeon/kms: add new NI pci ids

 include/drm/drm_pciids.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
