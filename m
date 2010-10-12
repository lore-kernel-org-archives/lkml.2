Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0JLMv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 08:51:29 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58420 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932373Ab0JLMv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 08:51:26 -0400
Date: Tue, 12 Oct 2010 13:51:26 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Robert Richter <robert.richter@amd.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: manual merge of the oprofile tree with the tip tree
Message-ID: <20101012125126.GE12335@console-pimps.org>
References: <20101012131828.5fedf1bf.sfr@canb.auug.org.au> <20101012060327.GA13409@console-pimps.org> <20101012232349.938f83c0.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101012232349.938f83c0.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 11:23:49PM +1100, Stephen Rothwell wrote:
> Hi Matt,
> 
> On Tue, 12 Oct 2010 07:03:27 +0100 Matt Fleming <matt@console-pimps.org> wrote:
> >
> > >  		return 0;
> > >  
> > >  	pevent = perf_event_create_kernel_counter(&counter_config[event].attr,
> > > -						  cpu, -1,
> > > +						  cpu, NULL1,
> > >  						  op_overflow_handler);
> > 
> > Is that a typo? Shouldn't that be NULL, and not NULL1?
> 
> Yes, its a typo in my patch :-( .  I will fix it for tomorrow. Sorry about that.

Not a problem! Thanks
