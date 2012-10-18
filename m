Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2JRWlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:41:53 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:39363 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2JRWlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:41:51 -0400
MIME-Version: 1.0
Date: Thu, 18 Oct 2012 19:41:51 -0300
Message-ID: <CALF0-+XKorADZ7DSp_yDFG4UkYr3W_pXHCA0ZWVzZpd8dJW_Gw@mail.gmail.com>
Subject: [PATCH 0/3] Small slob fixes and some more comon code
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>, Tim Bird <tim.bird@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

A little patchset brought to you by the CELF project:
"Kernel dynamic memory allocation tracking and reduction" [1].

This applies cleanly on top of Pekka's slab/for-linus,
which seems to be the latest branch.
(slab-next is a bit outdated)

Ezequiel Garcia (3):
 mm/sl[aou]b: Move common kmem_cache_size() to slab.h
 mm/slob: Use object_size field in kmem_cache_size()
 mm/slob: Drop usage of page->private for storing page-sized allocations

 include/linux/slab.h |    9 ++++++++-
 mm/slab.c            |    6 ------
 mm/slob.c            |   34 ++++++++++++----------------------
 mm/slub.c            |    9 ---------
 4 files changed, 20 insertions(+), 38 deletions(-)

 Any comments/flames welcome!
Thanks!

    Ezequiel

[1] http://elinux.org/Kernel_dynamic_memory_allocation_tracking_and_reduction
