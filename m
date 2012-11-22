Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758365Ab2KVWVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:21:44 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64856 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2KVWVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:21:38 -0500
Date: Thu, 22 Nov 2012 01:05:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Alex Shi <lkml.alex@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 36/46] mm: numa: Use a two-stage filter to restrict pages
 being migrated for unlikely task<->node relationships
Message-ID: <20121122000521.GA7859@gmail.com>
References: <1353493312-8069-1-git-send-email-mgorman@suse.de>
 <1353493312-8069-37-git-send-email-mgorman@suse.de>
 <20121121182537.GB29893@gmail.com>
 <20121121191547.GM8218@suse.de>
 <50AD2F86.3090303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AD2F86.3090303@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rik van Riel <riel@redhat.com> wrote:

> On 11/21/2012 02:15 PM, Mel Gorman wrote:
> >On Wed, Nov 21, 2012 at 07:25:37PM +0100, Ingo Molnar wrote:
> 
> >>As mentioned in my other mail, this patch of yours looks very
> >>similar to the numa/core commit attached below, mostly written
> >>by Peter:
> >>
> >>   30f93abc6cb3 sched, numa, mm: Add the scanning page fault machinery
> 
> >Just to compare, this is the wording in "autonuma: memory follows CPU
> >algorithm and task/mm_autonuma stats collection"
> >
> >+/*
> >+ * In this function we build a temporal CPU_node<->page relation by
> >+ * using a two-stage autonuma_last_nid filter to remove short/unlikely
> >+ * relations.
> 
> Looks like the comment came from sched/numa, but the original 
> code came from autonuma:
> 
> https://lkml.org/lkml/2012/8/22/629

Yeah, indeed, good find - thanks for tracking that down - to me 
it came from Peter. I'll add in an explicit credit to Andrea, 
the comment alone deserves one!

Thanks,

	Ingo
