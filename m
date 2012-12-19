Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758Ab2LSV4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:56:31 -0500
Received: from gir.skynet.ie ([193.1.99.77]:45967 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2LSV4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:56:25 -0500
Date: Wed, 19 Dec 2012 21:56:15 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm urgent fix
Message-ID: <alpine.DEB.2.00.1212192155200.9846@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just a single urgent regression fix, seeing a few wierd behaviours I'd 
like not to persist.

Dave.

The following changes since commit 55bde6b1442fed8af67b92d21acce67db454c9f9:

  Merge branch 'drm-intel-fixes' of git://people.freedesktop.org/~danvet/drm-intel into drm-next (2012-12-16 06:05:03 +0000)

are available in the git repository at:


  git://people.freedesktop.org/~airlied/linux drm-next

for you to fetch changes up to 0953e76e91f4b6206cef50bd680696dc6bf1ef99:

  drm/ttm: fix delayed ttm_bo_cleanup_refs_and_unlock delayed handling (2012-12-20 07:46:20 +1000)

----------------------------------------------------------------
Maarten Lankhorst (1):
      drm/ttm: fix delayed ttm_bo_cleanup_refs_and_unlock delayed handling

 drivers/gpu/drm/ttm/ttm_bo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
