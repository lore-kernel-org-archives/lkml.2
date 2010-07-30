Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab0G3AIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 20:08:50 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43986 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080Ab0G3AIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 20:08:49 -0400
Date: Fri, 30 Jul 2010 01:08:32 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1007300107310.23595@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just two, one edid, the other a radeon pm info reporting fix.

The following changes since commit fc0f5ac8fe693d1b05f5a928cc48135d1c8b7f2e:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs (2010-07-27 14:32:59 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Adam Jackson (1):
      drm/edid: Fix the HDTV hack sync adjustment

Daniel J Blueman (1):
      drm/radeon/kms: fix radeon mid power profile reporting

 drivers/gpu/drm/drm_edid.c         |    4 ++--
 drivers/gpu/drm/radeon/radeon_pm.c |    1 +
 2 files changed, 3 insertions(+), 2 deletions(-)
