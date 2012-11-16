Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2KPQWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:22:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255Ab2KPQWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:22:36 -0500
Message-ID: <50A66834.7010809@redhat.com>
Date: Fri, 16 Nov 2012 11:22:12 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/43] mm: mempolicy: Hide MPOL_NOOP and MPOL_MF_LAZY
 from userspace for now
References: <1353064973-26082-1-git-send-email-mgorman@suse.de> <1353064973-26082-17-git-send-email-mgorman@suse.de>
In-Reply-To: <1353064973-26082-17-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2012 06:22 AM, Mel Gorman wrote:
> The use of MPOL_NOOP and MPOL_MF_LAZY to allow an application to
> explicitly request lazy migration is a good idea but the actual
> API has not been well reviewed and once released we have to support it.
> For now this patch prevents an application using the services. This
> will need to be revisited.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Reviewed-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed
