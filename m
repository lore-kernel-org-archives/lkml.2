Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2C0F77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 01:59:59 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53764 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756079Ab2C0F75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 01:59:57 -0400
Date: Tue, 27 Mar 2012 08:59:42 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB changes for v3.4-rc0
Message-ID: <alpine.LFD.2.02.1203270859170.2826@tux.localdomain>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

There's the new kmalloc_array() API, minor fixes and performance improvements,
but quite honestly, nothing terribly exciting.

			Pekka

------------------>
The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/for-linus

Alex Shi (1):
      slub: per cpu partial statistics change

Christoph Lameter (2):
      slub: Do not hold slub_lock when calling sysfs_slab_add()
      slub: include include for prefetch

Eric Dumazet (1):
      slub: prefetch next freelist pointer in slab_alloc()

Rafael Aquini (1):
      mm: SLAB Out-of-memory diagnostics

Xi Wang (1):
      slab: introduce kmalloc_array()

Zhao Jin (1):
      slab, cleanup: remove unneeded return

 include/linux/slab.h     |   17 +++++++++++--
 include/linux/slub_def.h |    6 +++-
 mm/slab.c                |   56 ++++++++++++++++++++++++++++++++++++++++++---
 mm/slub.c                |   26 +++++++++++++++++----
 4 files changed, 91 insertions(+), 14 deletions(-)
