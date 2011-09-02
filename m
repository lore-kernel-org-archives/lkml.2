Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab1IBJvs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 05:51:48 -0400
Received: from gir.skynet.ie ([193.1.99.77]:48815 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935Ab1IBJvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 05:51:47 -0400
Date: Fri, 2 Sep 2011 10:53:09 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes from an alternate place
Message-ID: <alpine.DEB.2.00.1109021051530.10356@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

two radeon fixes from my tree on fd.o, not sure you can really do much,
since its not like you can republish it :)

Dave.

The following changes since commit 9e79e3e9dd9672b37ac9412e9a926714306551fe:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2011-08-30 11:28:18 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux.git drm-fixes

Alex Deucher (1):
      drm/radeon/kms: make sure pci max read request size is valid on evergreen+ (v2)

Dave Airlie (1):
      drm/radeon/kms: set a default max_pixel_clock

 drivers/gpu/drm/radeon/evergreen.c     |   27 +++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/ni.c            |    3 +++
 drivers/gpu/drm/radeon/radeon_clocks.c |    3 +++
 3 files changed, 33 insertions(+), 0 deletions(-)
