Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1GaPRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 11:17:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33303 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1GaPRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 11:17:41 -0400
Date: Sun, 31 Jul 2011 18:17:33 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLAB updates for 3.1-rc1
Message-ID: <alpine.DEB.2.00.1107311817140.4008@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's two final slab updates. Eric's patch reduces memory usage for slab
internal data structures even mor for high NR_CPU configurations.

                         Pekka

The following changes since commit 250f8e3db646028353a2a737ddb7a894c97a1098:
   Linus Torvalds (1):
         Merge branch 'for-linus' of git://git.kernel.org/.../jikos/trivial

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git for-linus

Andrew Morton (1):
       slab: use NUMA_NO_NODE

Eric Dumazet (1):
       slab: remove one NR_CPUS dependency

  mm/slab.c |    7 ++++---
  1 files changed, 4 insertions(+), 3 deletions(-)
