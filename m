Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab2FAGU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 02:20:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51102 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308Ab2FAGU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 02:20:57 -0400
Date: Fri, 1 Jun 2012 09:20:49 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB changes for v3.5-rc0
Message-ID: <alpine.LFD.2.02.1206010920340.2163@tux.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

It contains bunch of SLUB fixes from Joonsoo Kim.

			Pekka

------------------>
The following changes since commit 731a7378b81c2f5fa88ca1ae20b83d548d5613dc:

  Merge branch 'x86-trampoline-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2012-05-29 20:14:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

Joonsoo Kim (5):
      slub: fix incorrect return type of get_any_partial()
      slub: fix a possible memory leak
      slub: remove unused argument of init_kmem_cache_node()
      slub: fix a memory leak in get_partial_node()
      slub: use __SetPageSlab function to set PG_slab flag

majianpeng (1):
      Documentations: Fix slabinfo.c directory in vm/slub.txt

 Documentation/vm/slub.txt |    2 +-
 mm/slub.c                 |   23 +++++++++++++----------
 2 files changed, 14 insertions(+), 11 deletions(-)
