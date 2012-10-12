Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350Ab2JLLeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 07:34:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45187 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758964Ab2JLLeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 07:34:14 -0400
Date: Fri, 12 Oct 2012 14:34:04 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB updates for v3.7-rc0
Message-ID: <alpine.LFD.2.02.1210121433330.10531@tux.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/urgent

It contains a lockdep false positive fix from Jiri Kosina I missed from 
the previous pull request.

			Pekka

------------------>
The following changes since commit 4f1cd91497774488ed16119ec3f54b3daf1561de:

  Merge branch 'v4l_for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media (2012-10-12 12:39:17 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/urgent

Jiri Kosina (1):
      mm, slab: release slab_mutex earlier in kmem_cache_destroy()

 mm/slab_common.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)
