Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935Ab0EGFdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:33:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:44494 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938Ab0EGFda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:33:30 -0400
Date: Fri, 7 May 2010 06:33:12 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1005070632020.22210@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two ttm cleanups, remove some unused code that we don't want anyone to use 
by accident, and fix a missing hook in the radeon kms driver.

The following changes since commit 68b3adb429e0abf5c0a3deb75d71671436b3af10:
  Alex Deucher (1):
        drm/radeon/kms/legacy: only enable load detection property on DVI-I

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Jerome Glisse (1):
      drm/radeon: async event synchronization for drmWaitVblank

Thomas Hellstrom (2):
      drm/ttm: Remove some leftover debug messages.
      drm/ttm: Remove the ttm_bo_block_reservation() function.

 drivers/gpu/drm/radeon/radeon_drv.c |    2 ++
 drivers/gpu/drm/ttm/ttm_bo.c        |   30 +-----------------------------
 drivers/gpu/drm/ttm/ttm_lock.c      |    5 +----
 include/drm/ttm/ttm_bo_driver.h     |   28 ----------------------------
 4 files changed, 4 insertions(+), 61 deletions(-)
