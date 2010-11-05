Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab0KEVdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 17:33:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60375 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0KEVdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 17:33:06 -0400
Date: Fri, 5 Nov 2010 22:32:48 +0100
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Borislav Petkov <bp@amd64.org>, Thomas Gleixner <tglx@linutronix.de>,
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
Message-ID: <20101105213248.GB28493@aftab>
References: <20101029102713.GA21125@aftab>
 <alpine.LFD.2.00.1010291411150.2692@localhost6.localdomain6>
 <20101029170040.GJ21125@aftab>
 <20101029172631.GA23546@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1011011904280.2566@localhost6.localdomain6>
 <20101101184512.GA1589@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1011021626160.9357@localhost6.localdomain6>
 <20101105160919.GC25704@aftab>
 <20101105164225.GA1594@arch.trippelsdorf.de>
 <20101105212749.GA1559@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105212749.GA1559@arch.trippelsdorf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 05, 2010 at 05:27:49PM -0400, Markus Trippelsdorf wrote:
> Err, 20==0x14 so it's not that much difference and it's running fine here
> also.
> 
> Feel free to add:
>     Reported-and-tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>

Thanks Markus,

actually your board is not what concerns me, 20 ticks is still ok, more
or less, but there are other machines which contain absurd values in
there like 0x37ee or 0x1000 (a Broadcom chipset). We'll need to give a
change like that a good run before we can be absolutely sure it doesn't
break any machines.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
