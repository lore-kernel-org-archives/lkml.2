Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab1AIJNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 04:13:33 -0500
Received: from freeflow.nu ([178.79.134.28]:52549 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020Ab1AIJNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 04:13:31 -0500
Date: Sun, 9 Jan 2011 11:13:29 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLAB changes for v2.6.38
Message-ID: <alpine.DEB.2.00.1101091110520.5270@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

It's been rather quiet for slab allocators this merge cycle. There's only 
few cleanups here. The bug fixes were merged in v2.6.37 already. As they 
were cherry-picked from this branch, they show up in the pull request 
(what's up with that btw).

                         Pekka

The following changes since commit 0c21e3aaf6ae85bee804a325aa29c325209180fd:
   Linus Torvalds (1):
         Merge branch 'for-next' of git://git.kernel.org/.../hch/hfsplus

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

Christoph Lameter (1):
       slub: move slabinfo.c to tools/slub/slabinfo.c

Pavel Emelyanov (1):
       slub: Fix slub_lock down/up imbalance

Pekka Enberg (2):
       slub: Fix build breakage in Documentation/vm
       Merge branch 'slab/next' into for-linus

Richard Kennedy (1):
       slub tracing: move trace calls out of always inlined functions to reduce kernel code size

Steven Rostedt (1):
       tracing/slab: Move kmalloc tracepoint out of inline code

Tero Roponen (1):
       slub: Fix a crash during slabinfo -v

  Documentation/vm/Makefile                   |    2 +-
  include/linux/slab_def.h                    |   33 ++++++----------
  include/linux/slub_def.h                    |   55 +++++++++++++--------------
  mm/slab.c                                   |   38 +++++++++++-------
  mm/slub.c                                   |   30 +++++++++++---
  {Documentation/vm => tools/slub}/slabinfo.c |    6 +-
  6 files changed, 89 insertions(+), 75 deletions(-)
  rename {Documentation/vm => tools/slub}/slabinfo.c (99%)
