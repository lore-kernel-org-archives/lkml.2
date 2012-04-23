Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab2DWXuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:50:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38517 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab2DWXuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:50:50 -0400
Date: Mon, 23 Apr 2012 16:50:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
        Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>
Subject: Re: [PATCH 01/16] mm: Serialize access to min_free_kbytes
In-Reply-To: <1334578624-23257-2-git-send-email-mgorman@suse.de>
Message-ID: <alpine.DEB.2.00.1204231623210.17030@chino.kir.corp.google.com>
References: <1334578624-23257-1-git-send-email-mgorman@suse.de> <1334578624-23257-2-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012, Mel Gorman wrote:

> There is a race between the min_free_kbytes sysctl, memory hotplug
> and transparent hugepage support enablement.  Memory hotplug uses a
> zonelists_mutex to avoid a race when building zonelists. Reuse it to
> serialise watermark updates.
> 
> [a.p.zijlstra@chello.nl: Older patch fixed the race with spinlock]
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Rik van Riel <riel@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>
