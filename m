Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab2FZN4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 09:56:16 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33296 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757060Ab2FZN4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 09:56:15 -0400
Date: Tue, 26 Jun 2012 14:56:13 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm fixes
Message-ID: <alpine.DEB.2.00.1206261455320.18392@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just two changes, one udl endian fix, one nouveau memory corruption on 
some GPUs.

Dave.

The following changes since commit 6b16351acbd415e66ba16bf7d473ece1574cf0bc:

  Linux 3.5-rc4 (2012-06-24 12:53:04 -0700)

are available in the git repository at:

  git://people.freedesktop.org/~airlied/linux drm-fixes

for you to fetch changes up to 9bd0c15fcfb42f6245447c53347d65ad9e72080b:

  drm/nouveau/fbcon: using nv_two_heads is not a good idea (2012-06-26 12:16:43 +0100)

----------------------------------------------------------------
Ben Skeggs (1):
      drm/nouveau/fbcon: using nv_two_heads is not a good idea

Dave Airlie (1):
      drm/udl: Make sure to get correct endian keys from vendor descriptor

 drivers/gpu/drm/nouveau/nouveau_fbcon.c |    2 +-
 drivers/gpu/drm/udl/udl_main.c          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
