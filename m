Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125Ab1HJIhh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:37:37 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:21305 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750839Ab1HJIhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:37:35 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+Rael/mDwXBNxodGUxTc7D
Date: Wed, 10 Aug 2011 01:37:31 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Daniel Morsing <daniel.morsing@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: Build failure: bisected: v3.1-rc1 with config ARCH_OMAP &&
 !ARCH_OMAP4 fails with linker error
Message-ID: <20110810083731.GA1939@atomide.com>
References: <1312819724.14483.29.camel@morsingpad>
 <alpine.DEB.2.00.1108081435340.4764@utopia.booyaka.com>
 <20110809131453.GR1866@atomide.com>
 <alpine.DEB.2.00.1108092102580.12674@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1108092102580.12674@utopia.booyaka.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [110809 20:01]:
> On Tue, 9 Aug 2011, Tony Lindgren wrote:
> 
> > Hmm, there are also these when CONFIG_ARCH_OMAP4 is not selected:
> > 
> > arch/arm/mach-omap2/built-in.o: In function `_enable_module':
> > arch/arm/mach-omap2/omap_hwmod.c:701: undefined reference to `omap4_cminst_module_enable'
> > arch/arm/mach-omap2/built-in.o: In function `_disable_module':
> > arch/arm/mach-omap2/omap_hwmod.c:726: undefined reference to `omap4_cminst_module_disable'
> > arch/arm/mach-omap2/built-in.o: In function `_wait_target_disable':
> > arch/arm/mach-omap2/omap_hwmod.c:1179: undefined reference to `omap4_cminst_wait_module_idle'
> > distcc[27594] ERROR: compile (null) on localhost failed
> > make: *** [.tmp_vmlinux1] Error 1
> > 
> > Care to take a look?
> 
> Weird, those don't show up on my n800 config (below) with CodeSourcery 
> 2010.09-50.  Looks like something isn't removing the dead code.  will post 
> a patch for this.
> 
> If you post which compiler you're using, I'll add it to my build tests 
> too...

Happens at least with this one:

gcc version 4.3.3 (Sourcery G++ Lite 2009q1-203)

Tony
