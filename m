Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0KXLZx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 06:25:53 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46555 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507Ab0KXLZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 06:25:52 -0500
Date: Wed, 24 Nov 2010 12:25:30 +0100
From: Borislav Petkov <bp@amd64.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
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
Message-ID: <20101124112530.GA6005@kryptos.osrc.amd.com>
References: <alpine.LFD.2.00.1011011904280.2566@localhost6.localdomain6>
 <20101101184512.GA1589@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1011021626160.9357@localhost6.localdomain6>
 <20101105160919.GC25704@aftab>
 <20101105164225.GA1594@arch.trippelsdorf.de>
 <20101105212749.GA1559@arch.trippelsdorf.de>
 <20101105213248.GB28493@aftab>
 <alpine.LFD.2.00.1011091500220.2900@localhost6.localdomain6>
 <20101109143941.GA31121@aftab>
 <20101117232120.GA1575@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117232120.GA1575@arch.trippelsdorf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 12:21:20AM +0100, Markus Trippelsdorf wrote:
> Any update on this issue?
> 
> Borislav's patch solves the mysterious "slowdown" problem and is running
> without problems for the last two weeks here. 
> 
> (And rc2 is already out. So maybe it's time to push this to Linus so
> that more people have a chance to test it?)

Yep, we definitely need some kind of fix for this. It just triggered on
me on -rc3 (system became sluggish, everything advanced only after a
keypress along with the already familiar clocksource unstable message in
dmesg).

Thomas, want me to rebase the patch ontop of tip:master?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
