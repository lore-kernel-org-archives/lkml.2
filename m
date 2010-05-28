Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab0E1VAb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:00:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:58458 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758863Ab0E1VAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:00:30 -0400
Date: Fri, 28 May 2010 22:00:11 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [git pull] drm brown paper bag
Message-ID: <alpine.DEB.2.00.1005282158290.12937@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

I messed up this commit in 2.6.34, this is the urgent fix.

Dave.

The following changes since commit 2101d6f7ac791e87a274371a07a408f74e40ec49:
  Jiri Slaby (1):
        agp: amd64, fix pci reference leaks

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Dave Airlie (1):
      drm/radeon: fix the r100/r200 ums block 0 page fix

 drivers/gpu/drm/radeon/radeon_state.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)
