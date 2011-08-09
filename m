Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab1HISle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:41:34 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39979 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1HISlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:41:32 -0400
Date: Tue, 9 Aug 2011 21:41:23 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tiger
To: torvalds@linux-foundation.org
cc: cl@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [GIT PULL] SLUB fixes for v3.1-rc1
Message-ID: <alpine.DEB.2.00.1108092140360.678@tiger>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's one more fix for SLUB debugging code. I didn't send it as part of the
previous batch because Dave Jones didn't indicate that it was needed to fix the
corruption issue. It was, however, included in Xiaotian Feng's testing so it's
best to include it in mainline as well and the problem is pretty obvious when
reading the code.

I've tested the patch lightly on x86-64 SMP machine by compiling the kernel
with SLUB debugging and list debugging enabled.

                         Pekka

The following changes since commit e6a99d312687a42c077a9b8cb5e757f186edb1b9:
   Linus Torvalds (1):
         Merge branch 'slab/urgent' of git://git.kernel.org/.../penberg/slab-2.6

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6.git slab/urgent

Christoph Lameter (1):
       slub: Fix partial count comparison confusion

  mm/slub.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)
