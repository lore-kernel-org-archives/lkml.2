Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab0EESPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:15:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56056 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757536Ab0EESPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:15:33 -0400
Date: Wed, 5 May 2010 21:15:32 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLAB fixes for 2.6.34-rc7
Message-ID: <alpine.DEB.2.00.1005052113520.4496@melkki.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a last minute SLUB fix from Yanmin Zhang. The fix itself has been 
cooking in linux-next for over a month but I think we want it in final 
release because it's really a regression introduced by the new per-CPU 
allocator changes.

                         Pekka

The following changes since commit 8777c793d6a24c7f3adf52b1b1086e9706de4589:
   Linus Torvalds (1):
         Merge branch 'for-linus' of git://git.kernel.org/.../tj/wq

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slab-for-linus

Zhang, Yanmin (1):
       slub: Fix bad boundary check in init_kmem_cache_nodes()

  mm/slub.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)
