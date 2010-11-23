Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0KWJ7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 04:59:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54262 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab0KWJ7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 04:59:33 -0500
Date: Tue, 23 Nov 2010 10:59:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Arnd Hannemann <arnd@arndnet.de>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Message-ID: <20101123095917.GA28998@elte.hu>
References: <C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
 <4CEAA151.7050404@arndnet.de>
 <20101123063200.GA23907@elte.hu>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
 <20101122233654.117eef93.akpm@linux-foundation.org>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED75C@irsmsx504.ger.corp.intel.com>
 <20101123075742.GA28714@elte.hu>
 <20101123000232.e51b99b7.akpm@linux-foundation.org>
 <20101123091756.GA22530@elte.hu>
 <C5C86A19469DAE48AAAD0E5F3716E44501D41ED81C@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C5C86A19469DAE48AAAD0E5F3716E44501D41ED81C@irsmsx504.ger.corp.intel.com>
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

> > It fails to build on x86 64-bit allmodconfig:
> > 
> > drivers/leds/led-triggers.c:39:20: error: ‘TRIG_NAME_MAX’ undeclared
> > (first use in this function)
> 
> Grr. I give up on the modular thing ...
> 
> There are a whole bunch of ifdefs on TRIGGERS, which need to be
> || modular, but the easier thing is to remove the bool->tristate
> changes from my patch.

Please post a patch that does so.

Thanks,

	Ingo
