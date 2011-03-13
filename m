Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab1CMATu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 19:19:50 -0500
Received: from gir.skynet.ie ([193.1.99.77]:50431 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab1CMATu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 19:19:50 -0500
Date: Sun, 13 Mar 2011 00:19:21 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <alpine.DEB.2.00.1103130015210.15497@skynet.skynet.ie>
Message-ID: <alpine.DEB.2.00.1103130018430.15627@skynet.skynet.ie>
References: <alpine.DEB.2.00.1103130015210.15497@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(this time after scping the correct file to my mailserver).

> Hi Linus,
> 
> sent a pull for the first one already, but not sure if you pushed it out,
> 
> the second fix is very urgent, it fixes complete system hangs with certain 
> older radeon GPUs and pageflipping enabled. Nasty to track down, since 
> everything dies hard, when the gpu takes out the PCIE bus.
> 
> Dave.

The following changes since commit 9179746652faf0aba07b8b7f770dcf29892a24c6:

  Merge branch 'media_fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6 (2011-03-10 13:22:10 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Dave Airlie (2):
      drm/radeon: add pageflip hooks for fusion
      drm/radeon: fix page flipping hangs on r300/r400

 drivers/gpu/drm/radeon/r100.c               |   17 -----------------
 drivers/gpu/drm/radeon/radeon_asic.c        |    3 +++
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    3 ++-
 3 files changed, 5 insertions(+), 18 deletions(-)
