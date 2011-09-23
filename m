Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1IWNGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 09:06:50 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39248 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946Ab1IWNGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 09:06:49 -0400
Date: Fri, 23 Sep 2011 14:09:23 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1109231408260.11737@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

One radeon fix, and one serious radeon revert due to regression.

Dave.

The following changes since commit d942e43b58dc27b36305bcd374a74f7cc15183a3:

  Merge branch 'for-linus' of git://git.selinuxproject.org/~jmorris/linux-security (2011-09-22 19:57:27 -0700)

are available in the git repository at:

  ssh://people.freedesktop.org/~/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms: fix DDIA enable on some rs690 systems

Dave Airlie (1):
      Revert "drm/radeon/kms: fix typo in r100_blit_copy"

 drivers/gpu/drm/radeon/r100.c            |    4 ++--
 drivers/gpu/drm/radeon/radeon_encoders.c |    9 ++++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)
