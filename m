Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab1JFMmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 08:42:14 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42806 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758332Ab1JFMmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 08:42:06 -0400
Date: Thu, 6 Oct 2011 14:42:01 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?J=F6rg_R=F6del?= <joerg.roedel@amd.com>
Subject: Re: [GIT PULL] RAS update
Message-ID: <20111006124201.GA22432@aftab>
References: <20110930102034.GB22622@aftab>
 <20111006105535.GA6007@elte.hu>
 <20111006110403.GA31022@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006110403.GA31022@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 07:04:04AM -0400, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Borislav Petkov <bp@amd64.org> wrote:
> > 
> > > Hi Ingo,
> > > 
> > > please pull from the branch below to receive one fix which
> > > causes a very nasty warning on _all_ CPUs when fiddling with
> > > MCE poller interval. Since it is not that important, I'm fine
> > > with it going in during the merge window. Top commit here is
> > > 9aaef96f61d93062556d34e15731f7d5869dd82e.
> > > 
> > > Thanks.
> > > 
> > > The following changes since commit b6fd41e29dea9c6753b1843a77e50433e6123bcb:
> > > 
> > >   Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)
> > > 
> > > are available in the git repository at:
> > >   git://amd64.org/linux/bp.git ras
> > > 
> > > Hidetoshi Seto (1):
> > >       x86, mce: Do not call del_timer_sync() in IRQ context
> > > 
> > >  arch/x86/kernel/cpu/mcheck/mce.c |   20 ++++++++++++++------
> > >  1 files changed, 14 insertions(+), 6 deletions(-)
> > 
> > Pulled, thanks a lot Joerg!
> 
> s/Boris :-)

It doesn't matter - practically, we're almost one and the same guy. :-).

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
