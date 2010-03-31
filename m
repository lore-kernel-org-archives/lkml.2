Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640Ab0CaS7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:59:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36450 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab0CaS7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:59:45 -0400
Date: Wed, 31 Mar 2010 20:59:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
Message-ID: <20100331185916.GA12306@elte.hu>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
 <4BB2EB1B.8090303@zytor.com>
 <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Morris <jmorris@namei.org> wrote:

> On Tue, 30 Mar 2010, H. Peter Anvin wrote:
> 
> > On 03/30/2010 09:49 PM, James Morris wrote:
> > >
> > > Please make NO_BOOTMEM default to n, at least for amd64, where I've found 
> > > that it leads to all kinds of strange, undebuggable boot hangs and errors 
> > > (with relatively current Fedora development userland).
> > 
> > Have you tested it with the latest fixes that are now in Linus' tree (-rc3)?
> 
> Yes, it was happening with -rc3.

Could you please send the bootlog that Yinghai asked for, plus also one that 
you get with NO_BOOTMEM turned off (for comparison)?

Also, when did you first hit this bug? This code has been upstream for almost 
a month, and it was in linux-next before that - so you should have hit this 
much sooner. A rough timeframe would suffice. I suppose you were booting 
upstream kernels during the merge window as well?

We can flip the default around if there's no fix available based on the 
bootlogs. (Plus the help text should definitely be improved.)

Thanks,

	Ingo
