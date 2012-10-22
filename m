Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab2JVMCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 08:02:55 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:58483 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab2JVMCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 08:02:54 -0400
MIME-Version: 1.0
Date: Mon, 22 Oct 2012 09:02:53 -0300
Message-ID: <CALF0-+U+=P4x3TMrKaXeVQ=Z87kzazoUbJMeCkGW97PyY9CH1g@mail.gmail.com>
Subject: [PATCH 0/2] mm/slob: Some more cleanups
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>,
        Glauber Costa <glommer@parallels.com>,
        Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple more slob patches brought to you by the CELF project:

"Kernel dynamic memory allocation tracking and reduction" [1].

The first replaces put_page by __free_pages and it's analogous
to a recent change made at slub.
The other sets zone state to obtain slab information at /proc/meminfo.

If you feel this changes is against the minimalistic spirit of SLOB,
let me know. Any other feedback or flames, are as always welcome.

These patches apply cleanly to Pekka's slab/next or slab/for-linus.

Ezequiel Garcia (2):
 mm/slob: Use free_page instead of put_page for page-size kmalloc allocations
 mm/slob: Mark zone page state to get slab usage at /proc/meminfo

 mm/slob.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

Thanks!

    Ezequiel

[1] http://elinux.org/Kernel_dynamic_memory_allocation_tracking_and_reduction
