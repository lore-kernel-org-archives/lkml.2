Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982Ab2LCPyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:54:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876Ab2LCPyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:54:24 -0500
Message-ID: <50BCCAA3.6060604@redhat.com>
Date: Mon, 03 Dec 2012 10:52:03 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/52] RFC: Unified NUMA balancing tree, v1
References: <1354473824-19229-1-git-send-email-mingo@kernel.org>
In-Reply-To: <1354473824-19229-1-git-send-email-mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2012 01:42 PM, Ingo Molnar wrote:

> Most of the outstanding objections against numa/core centered around
> Mel and Rik objecting to the PROT_NONE approach Peter implemented in
> numa/core. To settle that question objectively I've performed performance
> testing of those differences, by picking up the minimum number of
> essentials needed to be able to remove the PROT_NONE approach and use
> the PTE_NUMA approach Mel took from the AutoNUMA tree and elsewhere.

For the record, I have no objection to either of
the pte marking approaches.

> Rik van Riel (1):
>    sched, numa, mm: Add credits for NUMA placement

Where did the TLB flush optimizations go? :)

