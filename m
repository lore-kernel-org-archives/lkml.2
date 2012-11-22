Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889Ab2KVWxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 17:53:48 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62879 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab2KVWxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 17:53:44 -0500
Date: Thu, 22 Nov 2012 23:53:38 +0100
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
Subject: Re: [PATCH 00/33] Latest numa/core release, v17
Message-ID: <20121122225338.GA1226@gmail.com>
References: <1353624594-1118-1-git-send-email-mingo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353624594-1118-1-git-send-email-mingo@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



* Ingo Molnar <mingo@kernel.org> wrote:

> This release mainly addresses one of the regressions Linus
> (rightfully) complained about: the "4x JVM" SPECjbb run.
> 
> [ Note to testers: if possible please still run with
>   CONFIG_TRANSPARENT_HUGEPAGES=y enabled, to avoid the
>   !THP regression that is still not fully fixed.
>   It will be fixed next. ]

I forgot to include the Git link:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git master

Thanks,

	Ingo
