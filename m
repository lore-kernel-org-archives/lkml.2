Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab1FMThc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 15:37:32 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:39786 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1FMThb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 15:37:31 -0400
Date: Mon, 13 Jun 2011 22:37:30 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Subject: [GIT PULL] SLAB fixes
Message-ID: <alpine.DEB.2.00.1106132237110.5454@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's fixes to both SLUB and SLAB. The first fix is needed to fix boot
problems on some non-x86 architectures and the latter fixes caller tracking in
SLAB debugging code.

                         Pekka

The following changes since commit cb0a02ecf95e5f47d92e7d4c513cc1f7aeb40cda:
   Linus Torvalds (1):
         Merge branch 'irq-urgent-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

Chris Metcalf (1):
       slub: always align cpu_slab to honor cmpxchg_double requirement

Suleiman Souhlal (1):
       SLAB: Record actual last user of freed objects.

  include/linux/percpu.h |    3 +++
  mm/slab.c              |    9 +++++----
  mm/slub.c              |   12 ++++--------
  3 files changed, 12 insertions(+), 12 deletions(-)
