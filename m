Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750874Ab2LCFJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 00:09:45 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:34656 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab2LCFJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 00:09:43 -0500
Date: Mon, 3 Dec 2012 06:09:37 +0100
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
Subject: Re: [PATCH 00/52] RFC: Unified NUMA balancing tree, v1
Message-ID: <20121203050937.GA26629@gmail.com>
References: <1354473824-19229-1-git-send-email-mingo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354473824-19229-1-git-send-email-mingo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The unified NUMA Git tree can be found in the -tip numa/base 
branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git numa/base

The PROT_NONE -v18 numa/core tree can be found in tip:master:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master

Thanks,

	Ingo
