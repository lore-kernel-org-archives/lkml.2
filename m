Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab1LGKs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 05:48:59 -0500
Received: from gir.skynet.ie ([193.1.99.77]:54908 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab1LGKs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 05:48:58 -0500
Date: Wed, 7 Dec 2011 10:51:43 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes the reduced version
Message-ID: <alpine.DEB.2.00.1112071049560.14889@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Okay the 2 non-kexec fixes + one of the calloc changes as by looking at 
it, there was nothing stopping userspace for abusing the integer overflow 
on these ioctls. The other calloc changes either were kernel internal or 
had other things stopping userspace from exploiting them.

Dave.

The following changes since commit 45e713efe2fa574b6662e7fb63fae9497c5e03d4:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2011-12-05 16:54:15 -0800)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms: fix return type for radeon_encoder_get_dp_bridge_encoder_id

Daniel Vetter (1):
      drm/i915: fix infinite recursion on unbind due to ilk vt-d w/a

Thomas Meyer (1):
      vmwgfx: Use kcalloc instead of kzalloc to allocate array

 drivers/gpu/drm/i915/i915_gem.c          |    7 ++++++-
 drivers/gpu/drm/radeon/radeon_encoders.c |    7 +++----
 drivers/gpu/drm/vmwgfx/vmwgfx_ioctl.c    |    4 ++--
 3 files changed, 11 insertions(+), 7 deletions(-)
