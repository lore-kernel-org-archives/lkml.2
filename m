Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab1EBKSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 06:18:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46153 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756906Ab1EBKSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 06:18:38 -0400
Date: Mon, 2 May 2011 12:18:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [GIT PULL tip:x86/mm] Unify 32 and 64bit NUMA init paths
Message-ID: <20110502101828.GB27072@elte.hu>
References: <20110502091334.GB22117@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502091334.GB22117@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> Please pull from the following branch to receive unification of 32 and
> 64bit NUMA init paths.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
>  ssh://master.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm
> 
> Other than addition of two patches from Yinghai and rebasing on top of
> x86/urgent, nothing has changed from the initial posting[1].
> 
> Please note that the tree is on top of
> 
>   x86/mm	c7a7b814c9dca9ee01b38e63b4a46de87156d3b6
> + x86/numa	993ba1585cbb03fab012e41d1a5d24330a283b31
> + x86/urgent	2be19102b71c1a45d37fec50303791daa1a06869
> 
> x86/urgent was needed for the following two NUMA fix commits.
> 
>  2be19102b7 "x86, NUMA: Fix empty memblk detection in numa_cleanup_meminfo()"
>  765af22da8 "x86-32, NUMA: Fix ACPI NUMA init broken by recent x86-64 change"
> 
> I can regenerate tree such that it's x86/mm + x86/numa + cherry pick
> of the above two patches.  If that's preferred, please let me know.

Yeah, it's fine to me if you do merges, but could you please do a x86/mm tree 
where all your merge commit messages are amended with a 'Merge reason' 
explanation?

See commit a4c98f8bbeafee12c979c90743f6fda94f7515c7 for an example of how Merge 
reason lines look like.

This is what we do for all merge commits in the -tip tree - that way it's clear 
in retrospect why a particular merge was done.

Thanks,

	Ingo
