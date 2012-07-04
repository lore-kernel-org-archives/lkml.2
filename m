Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab2GDGkV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 02:40:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53850 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab2GDGkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 02:40:19 -0400
Date: Tue, 3 Jul 2012 23:40:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan@kernel.org>, Ingo Molnar <mingo@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] mm: fix vmstat and zonestat mismatch
In-Reply-To: <1341363401-19326-1-git-send-email-minchan@kernel.org>
Message-ID: <alpine.DEB.2.00.1207032339030.32556@chino.kir.corp.google.com>
References: <1341363401-19326-1-git-send-email-minchan@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2012, Minchan Kim wrote:

> e975d6ac[1] in linux-next removed NUMA_INTERLEAVE_HIT
> in zone_stat_item but didn't remove it in vmstat_text
> so that cat /proc/vmstat doesn't show right count number.

... for CONFIG_NUMA kernels.

> [1]: mm/mpol: Remove NUMA_INTERLEAVE_HIT
> 

That sha1 is going to become useless very soon.

> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Minchan Kim <minchan@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>

This is for sched/numa, so it should be going to Ingo.
