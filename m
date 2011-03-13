Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1CMARa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 19:17:30 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50392 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab1CMAR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 19:17:29 -0500
Date: Sun, 13 Mar 2011 00:16:59 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1103130015210.15497@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

sent a pull for the first one already, but not sure if you pushed it out,

the second fix is very urgent, it fixes complete system hangs with certain 
older radeon GPUs and pageflipping enabled. Nasty to track down, since 
everything dies hard, when the gpu takes out the PCIE bus.

Dave.

The following changes since commit 9179746652faf0aba07b8b7f770dcf29892a24c6:

  Merge branch 'media_fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6 (2011-03-10 13:22:10 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Dave Airlie (1):
      drm/radeon: add pageflip hooks for fusion

 drivers/gpu/drm/radeon/radeon_asic.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
