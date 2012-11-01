Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761524Ab2KAOAe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 10:00:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011Ab2KAOAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 10:00:32 -0400
Date: Thu, 1 Nov 2012 14:00:28 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 21/31] sched, numa, mm: Introduce sched_feat_numa()
Message-ID: <20121101140028.GY3888@suse.de>
References: <20121025121617.617683848@chello.nl>
 <20121025124834.091119747@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121025124834.091119747@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:16:38PM +0200, Peter Zijlstra wrote:
> Avoid a few #ifdef's later on.
> 

It does mean that schednuma cannot be enabled or disabled from the command
line (or similarly easy mechanism) and that debugfs must be mounted to
control it. This would be awkward from an admin perspective if they wanted
to force disable schednuma because it hurt their workload for whatever
reason. Yes, they can disable it with an init script of some sort but
there will be some moaning.

-- 
Mel Gorman
SUSE Labs
