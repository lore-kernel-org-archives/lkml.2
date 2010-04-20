Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab0DTEfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 00:35:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:52661 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab0DTEfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 00:35:22 -0400
Date: Tue, 20 Apr 2010 05:35:02 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [git pull] drm single fix
Message-ID: <alpine.DEB.2.00.1004200534060.30237@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This change kept falling down the cracks somehow, finally make unload i915 
easy.


The following changes since commit 79b9517a33a283c5d9db875c263670ed1e055f7e:
  Dave Airlie (1):
        drm/radeon/kms: add FireMV 2400 PCI ID.

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-linus

Jesse Barnes (1):
      drm: delay vblank cleanup until after driver unload

 drivers/gpu/drm/drm_stub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

