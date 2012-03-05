Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2CES5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:57:09 -0500
Received: from gir.skynet.ie ([193.1.99.77]:57674 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab2CES5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:57:08 -0500
Date: Mon, 5 Mar 2012 18:57:00 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [git pull] drm gma500 fix
Message-ID: <alpine.DEB.2.00.1203051856130.31585@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Just a single gma500 fix from Alan.

Dave.

The following changes since commit a5939eefdcacd3ece57d56167a43bcc0d93733bf:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6 (2012-03-04 17:10:06 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alan Cox (1):
      drm/gma500: Fix Cedarview boot failures in 3.3-rc

 drivers/gpu/drm/gma500/cdv_device.c  |    2 ++
 drivers/gpu/drm/gma500/framebuffer.c |    1 -
 drivers/gpu/drm/gma500/gtt.c         |    9 ++++-----
 3 files changed, 6 insertions(+), 6 deletions(-)
