Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab2LCJZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:25:35 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51102 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab2LCJZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:25:33 -0500
Date: Mon, 3 Dec 2012 10:25:26 +0100
From: Ingo Molnar <mingo@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Subject: [GIT] Unified NUMA balancing tree, v2
Message-ID: <20121203092526.GA14136@gmail.com>
References: <1354473824-19229-1-git-send-email-mingo@kernel.org>
 <20121203050937.GA26629@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203050937.GA26629@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've pushed out a new update into:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git numa/base

which eliminates a few integration kinks/bugs in -v1:

 - I unified the THP migration code
 - there's also an MPOL_BIND bugfix.
 - added the fixed hiwater_rss patch.

Thanks,

	Ingo
