Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2KUK6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:58:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45979 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754108Ab2KUK6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:58:44 -0500
Date: Wed, 21 Nov 2012 10:58:37 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 00/27] Latest numa/core release, v16
Message-ID: <20121121105837.GV8218@suse.de>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
 <20121119162909.GL8218@suse.de>
 <20121119191339.GA11701@gmail.com>
 <20121119211804.GM8218@suse.de>
 <20121119223604.GA13470@gmail.com>
 <20121119230034.GO8218@suse.de>
 <50AAD1AC.7090209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <50AAD1AC.7090209@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 07:41:16PM -0500, Rik van Riel wrote:
> On 11/19/2012 06:00 PM, Mel Gorman wrote:
> >On Mon, Nov 19, 2012 at 11:36:04PM +0100, Ingo Molnar wrote:
> >>
> >>* Mel Gorman <mgorman@suse.de> wrote:
> >>
> >>>Ok.
> >>>
> >>>In response to one of your later questions, I found that I had
> >>>in fact disabled THP without properly reporting it. [...]
> >>
> >>Hugepages is a must for most forms of NUMA/HPC.
> >
> >Requiring huge pages to avoid a regression is a mistake.
> 
> Not all architectures support THP.  Not all workloads will end up
> using THP effectively.
> 
> Mel, would you have numa/core profiles from !THP runs, so we can
> find out the cause of the regression?
> 

Unfortunately not. I'll queue up a profile run again when I can but as
the !profile runs are still going it could take a while. It might be the
weekend before they even start.

-- 
Mel Gorman
SUSE Labs
