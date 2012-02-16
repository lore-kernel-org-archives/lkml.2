Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab2BPJjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:39:18 -0500
Received: from gir.skynet.ie ([193.1.99.77]:37545 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611Ab2BPJjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:39:14 -0500
Date: Thu, 16 Feb 2012 09:39:10 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1202160938040.7965@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

3 radeon fixes, I have some exynos fixes to push later but I'll queue them 
separately once I've looked them over a bit.

Dave.

The following changes since commit ce5afed937f0a823d3b00c9459409c3f5f2fbd5d:

  Merge git://git.samba.org/sfrench/cifs-2.6 (2012-02-13 20:34:44 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (2):
      drm/radeon/kms/atom: bios scratch reg handling updates
      drm/radeon/kms: fix MSI re-arm on rv370+

Dave Airlie (1):
      drm/radeon/kms: drop lock in return path of radeon_fence_count_emitted.

 drivers/gpu/drm/radeon/r100.c            |    4 +---
 drivers/gpu/drm/radeon/radeon_atombios.c |   17 +++++++++++++++++
 drivers/gpu/drm/radeon/radeon_fence.c    |    4 +++-
 drivers/gpu/drm/radeon/rs600.c           |    4 +---
 4 files changed, 22 insertions(+), 7 deletions(-)
