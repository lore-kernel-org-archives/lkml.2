Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab0KERps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:45:48 -0400
Received: from smtp-out-084.synserver.de ([212.40.180.84]:1055 "HELO
	smtp-out-086.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1753193Ab0KERpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:45:46 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 10007
Date: Fri, 5 Nov 2010 18:45:40 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Borislav Petkov <bp@amd64.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        john stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101105174540.GA1562@arch.trippelsdorf.de>
References: <20101029083013.GA1553@arch.trippelsdorf.de>
 <20101029102713.GA21125@aftab>
 <alpine.LFD.2.00.1010291411150.2692@localhost6.localdomain6>
 <20101029170040.GJ21125@aftab>
 <20101029172631.GA23546@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1011011904280.2566@localhost6.localdomain6>
 <20101101184512.GA1589@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1011021626160.9357@localhost6.localdomain6>
 <20101105160919.GC25704@aftab>
 <20101105164225.GA1594@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105164225.GA1594@arch.trippelsdorf.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 05:42:25PM +0100, Markus Trippelsdorf wrote:
> On Fri, Nov 05, 2010 at 05:09:19PM +0100, Borislav Petkov wrote:
> > On Tue, Nov 02, 2010 at 11:26:54AM -0400, Thomas Gleixner wrote:
> > > Ok, I'm waiting for Boris to get us the confirmation from HW folks.
> > 
> > +++ b/arch/x86/kernel/hpet.c
> > @@ -40,6 +40,7 @@ u8					hpet_msi_disable;
> >  static unsigned long			hpet_num_timers;
> >  #endif
> >  static void __iomem			*hpet_virt_address;
> > +u16					hpet_min_tick = 0x80;
> 
> Wouldn't:
> 
> +u16                                  hpet_min_tick;
> 
> make more sense, if you want to use the value detected in boot.c?

Please scratch that.
-- 
Markus
