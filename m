Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928Ab2AKTUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 14:20:17 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:60537 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933339Ab2AKTUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 14:20:14 -0500
Date: Wed, 11 Jan 2012 21:20:02 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB changes for v3.x
Message-ID: <alpine.LFD.2.02.1201112119230.6396@tux.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

There's nothing terribly exciting there - it's mostly fixes from Christoph,
Eric, and David to fallout from SLUB lockless patches.

 			Pekka

------------------>
The following changes since commit e4e11180dfa545233e5145919b75b7fac88638df:

   Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2012-01-09 17:37:37 -0800)

are available in the git repository at:

   git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

Christoph Lameter (2):
       slub: Switch per cpu partial page support off for debugging
       slub: Extract get_freelist from __slab_alloc

Dave Jones (2):
       slub: add taint flag outputting to debug paths
       slab: add taint flag outputting to debug paths.

David Rientjes (3):
       slab: rename slab_break_gfp_order to slab_max_order
       slab: introduce slab_max_order kernel parameter
       slub: disallow changing cpu_partial from userspace for debug caches

Eric Dumazet (2):
       slub: fix slub_max_order Documentation
       slub: fix a possible memleak in __slab_alloc()

Pekka Enberg (2):
       Merge branch 'slab/urgent' into slab/next
       Merge branch 'slab/urgent' into slab/for-linus

Shaohua Li (2):
       slub: add missed accounting
       slub: add missed accounting

  Documentation/kernel-parameters.txt |    6 +++
  Documentation/vm/slub.txt           |    2 +-
  mm/slab.c                           |   39 ++++++++++++-----
  mm/slub.c                           |   77 ++++++++++++++++++++++-------------
  4 files changed, 82 insertions(+), 42 deletions(-)
