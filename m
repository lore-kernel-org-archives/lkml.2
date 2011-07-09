Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab1GIGzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:55:50 -0400
Received: from gir.skynet.ie ([193.1.99.77]:46412 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab1GIGzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:55:49 -0400
Date: Sat, 9 Jul 2011 07:55:06 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: [git pull] drm radeon fix
Message-ID: <alpine.DEB.2.00.1107090753450.19120@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

just a single patch from Alex, We were accessing a bunch of registers that 
weren't guaranteed to be there causing long latency timeouts in page flipping code paths.

Dave.


The following changes since commit 902daf6580cffe04721250fb71b5527a98718b11:

  Merge branch 'gpio/merge' of git://git.secretlab.ca/git/linux-2.6 (2011-07-08 09:01:11 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Alex Deucher (1):
      drm/radeon/kms: clean up multiple crtc handling for evergreen+ (v2)

 drivers/gpu/drm/radeon/evergreen.c |  159 ++++++++++++++++++++++--------------
 1 files changed, 98 insertions(+), 61 deletions(-)
