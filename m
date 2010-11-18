Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0KRIF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 03:05:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40180 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab0KRIF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 03:05:26 -0500
Date: Thu, 18 Nov 2010 09:05:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
Message-ID: <20101118080516.GJ32621@elte.hu>
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com>
 <4CDD579F.80009@windriver.com>
 <20101112154231.GN4823@redhat.com>
 <4CDD6389.2080206@windriver.com>
 <20101112161144.GP4823@redhat.com>
 <4CDD6CAD.30303@windriver.com>
 <20101112172755.GR4823@redhat.com>
 <20101116184325.GB4823@redhat.com>
 <4CE2E3C3.6060800@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CE2E3C3.6060800@windriver.com>
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


* Jason Wessel <jason.wessel@windriver.com> wrote:

> On 11/16/2010 12:43 PM, Don Zickus wrote:
> > On Fri, Nov 12, 2010 at 12:27:55PM -0500, Don Zickus wrote:
> >
> > Hi Jason,
> >
> >   
> >>> I tested 2.6.35 and it does not hard hang, but suffered from a different
> >>> problem with a perf API change.   The kgdb tests appear to loop and loop
> >>> emitting endless streams of output in 2.6.35 and I already have that
> >>> problem patched.
> >>>       
> >
> > I keep getting the following stack trace which is different than your
> > hang.  Is this looping I am seeing something with the NMI or kgdb?
> >
> >   
> 
> That was also a regression due to changes in the perf API for which I
> have a patch pending.
> 
> I can send you the patch which Frederic has already tested OR you can
> turn off CONFIG_DEBUG_RODATA in the kernel config, which is the source
> of that particular problem.  

Would be nice to know that Don's series does not introduce a regression for kgdb 
before i can apply the patches.

Thanks,

	Ingo
