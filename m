Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935803Ab1JFLFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 07:05:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45430 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935288Ab1JFLFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 07:05:41 -0400
X-Greylist: delayed 500 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Oct 2011 07:05:40 EDT
Date: Thu, 6 Oct 2011 13:04:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL] RAS update
Message-ID: <20111006110403.GA31022@elte.hu>
References: <20110930102034.GB22622@aftab>
 <20111006105535.GA6007@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006105535.GA6007@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > Hi Ingo,
> > 
> > please pull from the branch below to receive one fix which
> > causes a very nasty warning on _all_ CPUs when fiddling with
> > MCE poller interval. Since it is not that important, I'm fine
> > with it going in during the merge window. Top commit here is
> > 9aaef96f61d93062556d34e15731f7d5869dd82e.
> > 
> > Thanks.
> > 
> > The following changes since commit b6fd41e29dea9c6753b1843a77e50433e6123bcb:
> > 
> >   Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)
> > 
> > are available in the git repository at:
> >   git://amd64.org/linux/bp.git ras
> > 
> > Hidetoshi Seto (1):
> >       x86, mce: Do not call del_timer_sync() in IRQ context
> > 
> >  arch/x86/kernel/cpu/mcheck/mce.c |   20 ++++++++++++++------
> >  1 files changed, 14 insertions(+), 6 deletions(-)
> 
> Pulled, thanks a lot Joerg!

s/Boris :-)

Thanks,

	Ingo
