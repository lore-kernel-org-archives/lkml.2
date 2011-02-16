Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab1BPIlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:41:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36406 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab1BPIlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:41:15 -0500
Date: Wed, 16 Feb 2011 09:41:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, brgerst@gmail.com, gorcunov@gmail.com,
        shaohui.zheng@intel.com, rientjes@google.com, hpa@linux.intel.com
Subject: Re: [PATCH 15/26] x86-64, NUMA: Unify the rest of memblk registration
Message-ID: <20110216084105.GG16529@elte.hu>
References: <AANLkTim8vaDDbdAK3Q2+LNOcYsH+VbpG+XUdD6wggNfL@mail.gmail.com>
 <20110214162247.GX18742@htj.dyndns.org>
 <AANLkTi=1xKqmedFqHPgDR32OrmNXg-T34NFo8qEnymfp@mail.gmail.com>
 <20110214182718.GB18742@htj.dyndns.org>
 <4D597D56.5060408@kernel.org>
 <20110214193050.GC18742@htj.dyndns.org>
 <4D5983EA.4020103@kernel.org>
 <20110215091103.GC3160@htj.dyndns.org>
 <20110215094327.GA1387@elte.hu>
 <20110215164920.GR3160@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110215164920.GR3160@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> On Tue, Feb 15, 2011 at 10:43:27AM +0100, Ingo Molnar wrote:
> > Would be nice to have a version against the latest tip:x86/numa
> > tree, the current one conflicts in arch/x86/mm/numa_64.c with your
> > tree. Also, i suspect you want to propagate Yinghai's Acked-by's
> > into the commits?
> 
> Acked-by added and rebased on top of the current x86/numa.  Only one
> patch needed to be updated and the udpated version was just posted.
> The updated git branches are available at
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-unify
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify
> 
> The latter one is superset of the former.
> 
> If you want the whole series reposted, please let me know.

No need if the patches did not change - but a diffstat is generally nice with pull 
requests, so that mismatches between intention on your side and action on my side 
can be detected sooner. Anyway, pulled it - thanks Tejun!

	Ingo
