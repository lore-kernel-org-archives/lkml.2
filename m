Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab0K3LZn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:25:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44351 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab0K3LZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:25:42 -0500
Date: Tue, 30 Nov 2010 12:25:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Arnd Hannemann <arnd@arndnet.de>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Message-ID: <20101130112525.GA9639@elte.hu>
References: <4CEAA151.7050404@arndnet.de>
 <20101123063200.GA23907@elte.hu>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
 <20101122233654.117eef93.akpm@linux-foundation.org>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED75C@irsmsx504.ger.corp.intel.com>
 <20101123075742.GA28714@elte.hu>
 <20101123000232.e51b99b7.akpm@linux-foundation.org>
 <20101123091756.GA22530@elte.hu>
 <1290505290.3674.4.camel@jlt3.sipsolutions.net>
 <20101129150323.a03a09bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129150323.a03a09bf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 23 Nov 2010 10:41:30 +0100
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > On Tue, 2010-11-23 at 09:17 +0000, Ingo Molnar wrote:
> > 
> > > It fails to build on x86 64-bit allmodconfig:
> > 
> > Let's not modify them to tristate then, too many ifdefs.
> > 
> > johannes
> > 
> > 
> > Subject: leds: fix up dependencies
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > It's not useful to build LED triggers when
> > there's no LEDs that can be triggered by
> > them. Therefore, fix up the dependencies
> > so that this cannot happen, and fix a few
> > users that select triggers to depend on
> > LEDS_CLASS as well (there is also one user
> > that also selects LEDS_CLASS, which is OK).
> 
> Ingo, Randy: does this work for you?

Yes, it does, havent seen a leds build failure for some time.

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
