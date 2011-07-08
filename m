Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab1GHHUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 03:20:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56984 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106Ab1GHHUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 03:20:11 -0400
Date: Fri, 8 Jul 2011 08:19:31 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1107080818240.26034@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

keep it conservative due to my disconnectedness, Just some typos, a radeon 
unload fix, and a drm core change to allow empty output groups.

Dave.

The following changes since commit 4dd1b49c6d215dc41ce50c80b4868388b93f31a3:

  Merge branch 'gpio/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-07-06 18:36:53 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (2):
      drm/radeon/kms: fix typo in IH_CNTL swap bitfield
      drm/radeon/kms: fix typo in evergreen disp int status register

Ben Skeggs (1):
      drm/kms: allow drm_mode_group with no objects

Jerome Glisse (1):
      drm/radeon/kms: free ib pool on module unloading

 drivers/gpu/drm/drm_crtc.c          |    3 ---
 drivers/gpu/drm/radeon/evergreen.c  |    1 +
 drivers/gpu/drm/radeon/evergreend.h |    4 ++--
 drivers/gpu/drm/radeon/ni.c         |    1 +
 drivers/gpu/drm/radeon/r600.c       |    1 +
 drivers/gpu/drm/radeon/r600d.h      |    2 +-
 drivers/gpu/drm/radeon/rv770.c      |    1 +
 7 files changed, 7 insertions(+), 6 deletions(-)
