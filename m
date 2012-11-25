Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab2KYXkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 18:40:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428Ab2KYXkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 18:40:09 -0500
Date: Sun, 25 Nov 2012 23:40:05 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: Re: Comparison between three trees (was: Latest numa/core release,
 v17)
Message-ID: <20121125234005.GE8218@suse.de>
References: <1353624594-1118-1-git-send-email-mingo@kernel.org>
 <20121123173205.GZ8218@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121123173205.GZ8218@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 05:32:05PM +0000, Mel Gorman wrote:

> <SNIP>
> SPECJBB: Single JVMs (one per node, 4 nodes), THP is enabled
> 
> <SNIP>
> SPECJBB: Single JVMs (one per node, 4 nodes), THP is disabled

Just to clarify, the "JVMs (one per node, 4 nodes)" was a cut&paste
error. Single JVM meant that there was just one JVM running and it was
configured to use 80% of available RAM.

-- 
Mel Gorman
SUSE Labs
