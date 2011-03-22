Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1CVTZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:25:19 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:39908 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1CVTZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:25:15 -0400
Date: Tue, 22 Mar 2011 21:25:11 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLAB fixes for v2.6.39-rc1
Message-ID: <alpine.DEB.2.00.1103222122150.5166@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a OOM path fix for lockless SLUB fastpath and a small debugging 
statistics improvement (both from Christoph).

                         Pekka

The following changes since commit f741a79e982cf56d7584435bad663553ffe6715f:
   Linus Torvalds (1):
         Merge branch 'for-linus' of git://git.kernel.org/.../mszeredi/fuse

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slab/urgent

Christoph Lameter (2):
       slub: Add missing irq restore for the OOM path
       slub: Add statistics for this_cmpxchg_double failures

  include/linux/slub_def.h |    1 +
  mm/slub.c                |    6 +++++-
  2 files changed, 6 insertions(+), 1 deletions(-)
