Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1BPPxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:53:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51566 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab1BPPx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:53:29 -0500
Date: Wed, 16 Feb 2011 16:53:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, hpa@linux.intel.com, ankita@in.ibm.com
Subject: Re: [PATCHSET x86/numa] x86-64, NUMA: bring sanity to NUMA
 config/emulation
Message-ID: <20110216155314.GA22855@elte.hu>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
 <20110216125249.GA18113@elte.hu>
 <20110216141757.GG19830@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110216141757.GG19830@htj.dyndns.org>
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

> Hello, Ingo.
> 
> On Wed, Feb 16, 2011 at 01:52:49PM +0100, Ingo Molnar wrote:
> > allyes64config fails with:
> > 
> > arch/x86/mm/numa_64.c:1045: error: 'physnid' undeclared (first use in this function)
> > arch/x86/mm/numa_64.c:1045: error: (Each undeclared identifier is reported only once
> > arch/x86/mm/numa_64.c:1045: error: for each function it appears in.)
> 
> Dang, sorry about that.  Updated patch posted and git tree updated.
> One patch in the emulation series is affected.  x86_64-numa-unify
> branch remains the same.  x86_64-numa-emu-unify updated.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git x86_64-numa-emu-unify
> 
> The new HEAD is 6e3019a9bf55000694b0d7058b39a1eebdf9877a.

Now the build fails on allyes32config:

drivers/acpi/numa.c:293: error: 'NR_NODE_MEMBLKS' undeclared (first use in this function)
drivers/acpi/numa.c:293: error: (Each undeclared identifier is reported only once
drivers/acpi/numa.c:293: error: for each function it appears in.)

Thanks,

	Ingo
