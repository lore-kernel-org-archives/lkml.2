Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab1E3LmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 07:42:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38375 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab1E3LmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 07:42:20 -0400
Date: Mon, 30 May 2011 13:42:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Woodhouse <dwmw2@infradead.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix corruption of CONFIG_X86_32 in 'make oldconfig'
Message-ID: <20110530114214.GC22324@elte.hu>
References: <20110530072300.GA9802@elte.hu>
 <1306745835.2029.389.camel@i7.infradead.org>
 <20110530091536.GA2827@elte.hu>
 <1306747629.2029.397.camel@i7.infradead.org>
 <20110530095333.GA8461@elte.hu>
 <1306750004.2029.413.camel@i7.infradead.org>
 <20110530102502.GC17821@elte.hu>
 <1306753314.2029.442.camel@i7.infradead.org>
 <20110530110432.GA21429@elte.hu>
 <1306753958.2029.450.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1306753958.2029.450.camel@i7.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2011-05-30 at 13:04 +0200, Ingo Molnar wrote:
> > 
> > That v2 changelog still seems to have an attitude though about the 
> > ARCH=i386 and ARCH=x86_64 modifiers (thoroughly debunked both by 
> > myself and others), so mind sending a v3 one which correctly and 
> > fairly describes the situation? (or ack my variant which ought to be 
> > pretty close) 
> 
> SIGWENCH; have to run. Back later. Can we make it something like
> 
> "This version preserves the legacy ARCH=i386/ARCH=x86_64 behaviour for
> randconfig/oldconfig/all*config, although I believe that this *ought* to
> be removed in the future, in favour of a generic method of overriding
> config options — one that doesn't work *only* for one particular config
> setting (CONFIG_64BIT), and *only* on one architecture (there's no
> equivalent for mips/powerpc/s390/parisc/sparc to flip CONFIG_64BIT for
> you)."
> 
> It's less of an 'attitude' but I think it clearly states the situation?

Not sure we can actually remove it all that soon - people rely on it 
and seem to like it, me included!

What kind of replacement are you suggesting?

Thanks,

	Ingo
