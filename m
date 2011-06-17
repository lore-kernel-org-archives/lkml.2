Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369Ab1FQWi4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 18:38:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34652 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760Ab1FQWiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 18:38:55 -0400
Date: Fri, 17 Jun 2011 23:38:16 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: [drm pull] single intel fix for SNB irqs
Message-ID: <alpine.DEB.2.00.1106172336350.22625@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus

This is a workaround for lost IRQs on the SNB platform that causes 
stalls in rendering, by all reports it actually seems to work, so 
until the hw guys explain things better, we'll go with it.

Dave.


The following changes since commit 95d17b7168eacf1f97f2d1d087ebe7a648c30051:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6 (2011-06-17 10:37:57 -0700)

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Daniel J Blueman (1):
      drm/i915: Fix gen6 (SNB) missed BLT ring interrupts.

 drivers/gpu/drm/i915/i915_irq.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)
