Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab1EBPEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:04:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49556 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760010Ab1EBPEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:04:15 -0400
Date: Mon, 2 May 2011 17:04:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [GIT PULL tip:x86/mm] Unify 32 and 64bit NUMA init paths
Message-ID: <20110502150401.GA21680@elte.hu>
References: <20110502091334.GB22117@htj.dyndns.org>
 <20110502101828.GB27072@elte.hu>
 <20110502122319.GC22117@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110502122319.GC22117@htj.dyndns.org>
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
> On Mon, May 02, 2011 at 12:18:28PM +0200, Ingo Molnar wrote:
> > Yeah, it's fine to me if you do merges, but could you please do a x86/mm tree 
> > where all your merge commit messages are amended with a 'Merge reason' 
> > explanation?
> > 
> > See commit a4c98f8bbeafee12c979c90743f6fda94f7515c7 for an example of how Merge 
> > reason lines look like.
> > 
> > This is what we do for all merge commits in the -tip tree - that way it's clear 
> > in retrospect why a particular merge was done.
> 
> Branches updated as suggested.  The new HEAD is 356aec8b6e "x86, NUMA:
> Trim numa meminfo with max_pfn in a separate loop".
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86-mm

Doesnt build on 32-bit allyesconfig:

  ERROR: "physnode_map" [drivers/net/wan/dscc4.ko] undefined!
  ERROR: "physnode_map" [crypto/tcrypt.ko] undefined!

Thanks,

	Ingo
