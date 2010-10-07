Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab0JGAli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 20:41:38 -0400
Received: from gir.skynet.ie ([193.1.99.77]:49866 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932573Ab0JGAlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 20:41:37 -0400
Date: Thu, 7 Oct 2010 01:41:20 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1010070140090.25541@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is the nasty race condition fix from Thomas, I've been running it and 
playing with firefox a lot and haven't seen any side effects of it, we 
have positive feedback on it fixing the actual problem of up 1GB of memory 
leaked in 5-10s of scrolling in the pathalogical cases.

Dave.

The following changes since commit e1d9694cae722d00a94fb58f901aa69c9c324a16:

  Merge branch 'core-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2010-10-05 13:07:43 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Thomas Hellstrom (1):
      drm/ttm: Fix two race conditions + fix busy codepaths

 drivers/gpu/drm/ttm/ttm_bo.c |   83 ++++++++++++++++++++++++++++++++++++------
 include/drm/ttm/ttm_bo_api.h |    4 ++-
 2 files changed, 74 insertions(+), 13 deletions(-)
