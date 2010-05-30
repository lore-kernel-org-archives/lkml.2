Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0E3Tgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 15:36:50 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44399 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753426Ab0E3Tgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 15:36:49 -0400
Date: Sun, 30 May 2010 22:36:47 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLAB fixes for 2.6.35-rc0
Message-ID: <alpine.DEB.2.00.1005302235290.22112@melkki.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's few regression fixes to SLUB. The S390 regression was introduced in 
.33 and the hackbench performance regression in .34.

                         Pekka

The following changes since commit 24010e460454ec0d2f4f0213b667b4349cbdb8e1:
   Linus Torvalds (1):
         Merge branch 'drm-linus' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slub/urgent

Alexander Duyck (1):
       slub: move kmem_cache_node into it's own cacheline

Christoph Lameter (1):
       SLUB: Allow full duplication of kmalloc array for 390

  include/linux/slub_def.h |   11 ++++-------
  mm/slub.c                |   33 +++++++++++----------------------
  2 files changed, 15 insertions(+), 29 deletions(-)
