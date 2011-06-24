Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216Ab1FXD1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 23:27:18 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56846 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005Ab1FXD1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 23:27:17 -0400
Date: Fri, 24 Jun 2011 04:26:34 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fixes
Message-ID: <alpine.DEB.2.00.1106240425290.6492@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two fixes from Alex, one fixes a possible hang on boot on some cards, the 
other fixes a fusion bug.

Dave.

The following changes since commit bccaeafd7c117acee36e90d37c7e05c19be9e7bf:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6 (2011-06-22 21:49:07 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (2):
      drm/radeon/kms: fix num_banks tiling config for fusion
      drm/radeon/kms: handle special cases for vddc

 drivers/gpu/drm/radeon/evergreen.c       |    4 +-
 drivers/gpu/drm/radeon/radeon.h          |    1 +
 drivers/gpu/drm/radeon/radeon_atombios.c |   36 ++++++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 2 deletions(-)
