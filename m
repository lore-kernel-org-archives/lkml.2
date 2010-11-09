Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0KIODY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:03:24 -0500
Received: from www.tglx.de ([62.245.132.106]:37024 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223Ab0KIODW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:03:22 -0500
Date: Tue, 9 Nov 2010 15:02:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@amd64.org>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Borislav Petkov <bp@alien8.de>, john stultz <johnstul@us.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [bisected] Clocksource tsc unstable git
In-Reply-To: <20101105213248.GB28493@aftab>
Message-ID: <alpine.LFD.2.00.1011091500220.2900@localhost6.localdomain6>
References: <20101029102713.GA21125@aftab> <alpine.LFD.2.00.1010291411150.2692@localhost6.localdomain6> <20101029170040.GJ21125@aftab> <20101029172631.GA23546@arch.trippelsdorf.de> <alpine.LFD.2.00.1011011904280.2566@localhost6.localdomain6>
 <20101101184512.GA1589@arch.trippelsdorf.de> <alpine.LFD.2.00.1011021626160.9357@localhost6.localdomain6> <20101105160919.GC25704@aftab> <20101105164225.GA1594@arch.trippelsdorf.de> <20101105212749.GA1559@arch.trippelsdorf.de>
 <20101105213248.GB28493@aftab>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Nov 2010, Borislav Petkov wrote:
> On Fri, Nov 05, 2010 at 05:27:49PM -0400, Markus Trippelsdorf wrote:
> > Err, 20==0x14 so it's not that much difference and it's running fine here
> > also.
> > 
> > Feel free to add:
> >     Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> 
> Thanks Markus,
> 
> actually your board is not what concerns me, 20 ticks is still ok, more
> or less, but there are other machines which contain absurd values in
> there like 0x37ee or 0x1000 (a Broadcom chipset). We'll need to give a
> change like that a good run before we can be absolutely sure it doesn't
> break any machines.

If the ACPI entry is known to be flaky, shouldn't we simply err out on
the safe side and use 128 ticks in any case, which is not a really big
deal.

Thanks,

	tglx
