Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab1F3Afk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 20:35:40 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40301 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab1F3Afe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 20:35:34 -0400
Date: Thu, 30 Jun 2011 01:34:54 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] one radeon fix
Message-ID: <alpine.DEB.2.00.1106300134160.26185@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just a single patch from Alex.

Dave.

The following changes since commit c017d0d1351f916c0ced3f358afc491fdcf490b4:

  Merge branch 'kvm-updates/3.0' of git://git.kernel.org/pub/scm/virt/kvm/kvm (2011-06-29 11:07:20 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (1):
      drm/radeon/kms: increase rom size for atrm method

 drivers/gpu/drm/radeon/radeon_bios.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)
