Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab1GFKMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 06:12:52 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:46849 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1GFKMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 06:12:51 -0400
Date: Wed, 6 Jul 2011 14:12:45 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Brian Gerst <brgerst@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/3] x86: drop unnecessary kernel_eflags variable from 64
 bit.
Message-ID: <20110706101245.GL4060@sun>
References: <20110705111525.GR17941@sun>
 <1309870814-14181-1-git-send-email-ian.campbell@citrix.com>
 <20110705132825.GA3900@sun>
 <1309944329.634.161.camel@zakaz.uk.xensource.com>
 <20110706094602.GJ4060@sun>
 <1309946225.634.165.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309946225.634.165.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 10:57:05AM +0100, Ian Campbell wrote:
> On Wed, 2011-07-06 at 10:46 +0100, Cyrill Gorcunov wrote:
> > On Wed, Jul 06, 2011 at 10:25:29AM +0100, Ian Campbell wrote:
> > ...
> > > > 
> > > > The whole series looks good to me, thanks Ian! I hope I don't
> > > > miss anything, so lets wait for more feedback ;)
> > > 
> > > Thanks. Actually I missed the extern declaration in asm/processor.h so
> > > this updated patch should be used instead:
> > > 
> > 
> > Great, thanks Ian. Have you a chance to run this series? ;)
> 
> Yeah I booted it before I posted it. I figured that the initscripts etc
> would be a sufficient test of fork() and that if it were wrong it would
> fall over pretty quickly and obviously.
> 
> Ian.
> 

OK, thanks!

	Cyrill
