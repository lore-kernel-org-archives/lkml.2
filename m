Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934128Ab1CXUFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:05:41 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:34494 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847Ab1CXUFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:05:39 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Mar 2011 16:05:39 EDT
Date: Thu, 24 Mar 2011 21:56:15 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mingo@elte.hu
Subject: [GIT PULL] SLAB fixes for v2.6.39-rc1
Message-ID: <alpine.DEB.2.00.1103242154440.16149@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's two urgent fixes to SLUB reported by Ingo:

https://lkml.org/lkml/2011/3/24/245

The first one is boot-time oops on x86 with PREEMPT_NONE and CPUs that 
don't support cmpxch16b. The second one is debugobjects regression caused 
by the lockless fastpaths.

                         Pekka

The following changes since commit 6d1e9a42e7176bbce9348274784b2e5f69223936:
   Linus Torvalds (1):
         Merge branch 'release' of git://git.kernel.org/.../aegl/linux-2.6

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slab/urgent

Christoph Lameter (1):
       SLUB: Write to per cpu data when allocating it

Thomas Gleixner (1):
       slub: Fix debugobjects with lockless fastpath

  mm/slub.c |    6 +++---
  1 files changed, 3 insertions(+), 3 deletions(-)
