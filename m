Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006Ab1CKF0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 00:26:54 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43521 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab1CKF0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 00:26:53 -0500
Date: Fri, 11 Mar 2011 05:26:24 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm single fix
Message-ID: <alpine.DEB.2.00.1103110525380.2738@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Fixes an oops caused by the intersection of two new features being empty.

The following changes since commit 9179746652faf0aba07b8b7f770dcf29892a24c6:

  Merge branch 'media_fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6 (2011-03-10 13:22:10 -0800)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Dave Airlie (1):
      drm/radeon: add pageflip hooks for fusion

 drivers/gpu/drm/radeon/radeon_asic.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
