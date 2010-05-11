Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051Ab0EKGk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:40:57 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33752 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354Ab0EKGkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:40:55 -0400
Date: Tue, 11 May 2010 07:40:36 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: [git pull] drm regression fix
Message-ID: <alpine.DEB.2.00.1005110738530.28472@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just one patch from Jean to fix some regressions in the buffer code 
rework. Thanks to Jean for tracking this down.

The following changes since commit 8cfe92d683a0041ac8e016a0b0a487c99a78f6c1:
  Thomas Hellstrom (1):
        drm/ttm: Remove the ttm_bo_block_reservation() function.

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Jean Delvare (1):
      drm/radeon: Fix 3 regressions - since buffer rework

 drivers/gpu/drm/radeon/radeon_state.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)
