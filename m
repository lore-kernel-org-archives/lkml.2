Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab1BPRaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 12:30:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53377 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab1BPRaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 12:30:10 -0500
Date: Wed, 16 Feb 2011 18:29:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com, ankita@in.ibm.com
Subject: Re: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA
 config/emulation
Message-ID: <20110216172954.GA28054@elte.hu>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
 <20110216125249.GA18113@elte.hu>
 <20110216141757.GG19830@htj.dyndns.org>
 <20110216155314.GA22855@elte.hu>
 <20110216162329.GI19830@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216162329.GI19830@htj.dyndns.org>
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

> On Wed, Feb 16, 2011 at 04:53:14PM +0100, Ingo Molnar wrote:
> > >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify
> > > 
> > > The new HEAD is 6e3019a9bf55000694b0d7058b39a1eebdf9877a.
> > 
> > Now the build fails on allyes32config:
> > 
> > drivers/acpi/numa.c:293: error: 'NR_NODE_MEMBLKS' undeclared (first use in this function)
> > drivers/acpi/numa.c:293: error: (Each undeclared identifier is reported only once
> > drivers/acpi/numa.c:293: error: for each function it appears in.)
> 
> Okay, updated again.  I'm trying to build all combinations of the
> several affected configurations now.  I'll let you know how it turns
> out.

It's looking good here now.

Thanks,

	Ingo
