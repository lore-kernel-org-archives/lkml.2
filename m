Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab1EXShb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 14:37:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45083 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932311Ab1EXSha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 14:37:30 -0400
Date: Tue, 24 May 2011 20:37:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: [GIT PULL] more x86/apic changes for v2.6.40
Message-ID: <20110524183721.GA31824@elte.hu>
References: <20110523193035.GA9170@elte.hu>
 <BANLkTimUr+2k3_RAyncLX5yFYeV5JaJDsQ@mail.gmail.com>
 <20110524060321.GA20904@elte.hu>
 <20110524061525.GA29815@elte.hu>
 <1306259131.7171.7.camel@sbsiddha-MOBL3.sc.intel.com>
 <BANLkTi=bh+P07UPzhv9v=0x78o9+PUrCnw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=bh+P07UPzhv9v=0x78o9+PUrCnw@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, May 24, 2011 at 10:45 AM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> >
> > Patch appended(I am sorry, should have caught this earlier. Looks like
> > my system does keep the ioapic state intact during suspend/resume.)
> 
> Looks likely. My bisect just finished as I got this email, with
> 
> 57a6f74023c7fd943160d7635bbc8d9f66e2ab54 is the first bad commit
> commit 57a6f74023c7fd943160d7635bbc8d9f66e2ab54
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Wed May 18 16:31:36 2011 -0700
> 
>     x86, ioapic: Consolidate ioapic_saved_data[] into 'struct ioapic'
> 
>     Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>     Cc: daniel.blueman@gmail.com
>     Link: http://lkml.kernel.org/r/20110518233157.830697056@sbsiddha-MOBL3.sc.intel.com
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> :040000 040000 0ae77b7536a88d0ce4f789a7c870aa3103ccc1d5
> 3460a9ec2b6a017d91b8fa6465e8d7d7cd8be71d M	arch
> 
> and I'm now going back to top-of-git and applying your patch to verify
> that it fixes it. But it looks rather likely that it does.

Ok, great: i also just sent the pull request with Suresh's fix included so you 
can pull that if the fix works fine.

Thanks,

	Ingo
