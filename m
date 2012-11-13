Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2KMRyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 12:54:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39565 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754864Ab2KMRye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 12:54:34 -0500
Date: Tue, 13 Nov 2012 17:54:28 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 00/31] Latest numa/core patches, v15
Message-ID: <20121113175428.GF8218@suse.de>
References: <1352826834-11774-1-git-send-email-mingo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1352826834-11774-1-git-send-email-mingo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 06:13:23PM +0100, Ingo Molnar wrote:
> Hi,
> 
> This is the latest iteration of our numa/core tree, which
> implements adaptive NUMA affinity balancing.
> 
> Changes in this version:
> 
>     https://lkml.org/lkml/2012/11/12/315
> 
> Performance figures:
> 
>     https://lkml.org/lkml/2012/11/12/330
> 
> Any review feedback, comments and test results are welcome!
> 

For the purposes of review and testing, this is going to be hard to pick
apart and compare. It doesn't apply against 3.7-rc5 and when trying to
resolve the conflicts it quickly becomes obvious that the series depends
on other scheduler patches such as

sched: Add an rq migration call-back to sched_class
sched: Introduce temporary FAIR_GROUP_SCHED dependency for load-tracking

This is not a full list, it was just the first I hit. What are the other
scheduler patches you are depend on? Knowing that will probably help pick
apart some of the massive patches like "sched, numa, mm: Add adaptive
NUMA affinity support" which is a massive monolithic patch I have not even
attempted to read yet but the diffstat for it alone says a lot.

7 files changed, 901 insertions(+), 197 deletions(-)

-- 
Mel Gorman
SUSE Labs
