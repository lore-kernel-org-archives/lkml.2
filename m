Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab1DUCzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:55:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab1DUCzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:55:24 -0400
Subject: [git pull] drm/agp fixes
From: Dave Airlie <airlied@linux.ie>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 12:54:45 +1000
Message-ID: <1303354485.3676.7.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Found an AGP box to at least make sure these fixes still allow it to
boot and run,
along with one I missed from Alex yesterday for big endian support.

Dave.

The following changes since commit
5785e53ffa73f77fb19e378c899027afc07272bc:

  drm/radeon/kms: pll tweaks for r7xx (2011-04-20 09:39:37 +1000)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
drm-fixes

Cédric Cano (1):
      drm/radeon/kms: fix IH writeback on r6xx+ on big endian machines

Vasiliy Kulikov (2):
      agp: fix OOM and buffer overflow
      agp: fix arbitrary kernel memory writes

 drivers/char/agp/generic.c         |   19 +++++++++++++++----
 drivers/gpu/drm/radeon/evergreen.c |    2 +-
 drivers/gpu/drm/radeon/r600.c      |    2 +-
 3 files changed, 17 insertions(+), 6 deletions(-)



