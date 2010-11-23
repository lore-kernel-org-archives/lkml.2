Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0KWHnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:43:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60343 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab0KWHnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:43:00 -0500
Date: Tue, 23 Nov 2010 08:42:45 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: Arnd Hannemann <arnd@arndnet.de>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Message-ID: <20101123074245.GA26319@elte.hu>
References: <20101116142027.GC19247@tiehlicka.suse.cz>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
 <20101118082454.GC15928@tiehlicka.suse.cz>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
 <4CEAA151.7050404@arndnet.de>
 <20101123063200.GA23907@elte.hu>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
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


* Berg, Johannes <johannes.berg@intel.com> wrote:

> 
> > > I also ran into this today.
> > > Any updates or pointer to the patch?
> > 
> > Same here - i'm running into this build bug frequently as well, as of
> > 2.6.37-rc3.
> > Please guys at minimum post the pending fix for this.
> 
> Hmm. For some reason I thought this patch had made it into -mm,
> but I never double-checked and then went travelling ...
> 
> http://lkml.org/lkml/2010/10/26/79

Sigh, guys, this build bug has been known for 1.5 months and it's been upstream for 
weeks!

	Ingo
