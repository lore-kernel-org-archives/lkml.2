Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933755Ab0J2LkW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 07:40:22 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:60146 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab0J2LkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 07:40:19 -0400
Date: Fri, 29 Oct 2010 13:39:34 +0200
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Borislav Petkov <bp@alien8.de>, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101029113934.GB21125@aftab>
References: <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
 <1288120736.2645.9.camel@localhost>
 <20101027142622.GA1555@arch.trippelsdorf.de>
 <20101027182608.GA1580@arch.trippelsdorf.de>
 <20101029081831.GA7149@liondog.tnic>
 <20101029083013.GA1553@arch.trippelsdorf.de>
 <20101029102713.GA21125@aftab>
 <20101029113433.GB1553@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029113433.GB1553@arch.trippelsdorf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 07:34:33AM -0400, Markus Trippelsdorf wrote:
> > Markus, can you verify this on your system by compiling x86info from
> > git://git.choralone.org/git/x86info and doing
> > 
> > ./lsmsr Int
> 
> 
> x86info v1.28beta.  Dave Jones 2001-2010
> Feedback to <davej@redhat.com>.
> 
> Found 4 CPUs
> --------------------------------------------------------------------------
> CPU #1
> EFamily: 1 EModel: 0 Family: 15 Model: 4 Stepping: 2
> CPU Model: Quad-Core Opteron/Phenom II (RB-C2)

well, x86info doesn't help - there's a lsmsr tool which is being built
too but no need, I can infer the info from your revision: your CPU is
RB-C2 which does SMI initiated C1E.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
