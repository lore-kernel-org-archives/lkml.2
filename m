Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0KIN2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 08:28:15 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:51183 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0KIN2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 08:28:13 -0500
Date: Tue, 9 Nov 2010 14:28:00 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, avi@redhat.com,
        mtosatti@redhat.com
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101109132800.GB8636@osiris.boeblingen.de.ibm.com>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
 <1288120736.2645.9.camel@localhost>
 <20101027142622.GA1555@arch.trippelsdorf.de>
 <20101027182608.GA1580@arch.trippelsdorf.de>
 <1288208215.3673.16.camel@laptop>
 <20101109125842.GA8636@osiris.boeblingen.de.ibm.com>
 <20101109132138.GA3110@arch.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109132138.GA3110@arch.trippelsdorf.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 02:21:38PM +0100, Markus Trippelsdorf wrote:
> > I would guess something like the below would probably fix it.
> > Does that make any sense or did I miss something obvious?
> 
> You've missed the fact that Peter already has a patch that fixes the
> problem, but he never bothered to post it in this thread.
> 
> http://article.gmane.org/gmane.linux.kernel/1058018

Ah, great... wasted my time for something that's already fixed. ;)

Thanks for the pointer!
