Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445Ab1KMS7v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 13:59:51 -0500
Received: from gir.skynet.ie ([193.1.99.77]:41475 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab1KMS7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 13:59:50 -0500
Date: Sun, 13 Nov 2011 19:01:17 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] one drm fix
Message-ID: <alpine.DEB.2.00.1111131900280.8973@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Just a radeon fix for the older cards to catch up with the pm changes for 
the newer ones.

Dave.

The following changes since commit 8f3f1c9a22a6420e28c2d3eff59b832893bc8efc:

  drm/radeon/kms/pm: switch to dynamically allocating clock mode array (2011-11-11 14:16:05 +0000)

are available in the git repository at:
  git://people.freedesktop.org/~airlied/linux drm-fixes

Alex Deucher (1):
      drm/radeon/kms/combios: fix dynamic allocation of PM clock modes

 drivers/gpu/drm/radeon/radeon_combios.c |   27 +++++++++++++++++++--------
 1 files changed, 19 insertions(+), 8 deletions(-)
