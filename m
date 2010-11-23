Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab0KWH5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:57:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:58896 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab0KWH5m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:57:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,241,1288594800"; 
   d="scan'208";a="860465358"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnd Hannemann <arnd@arndnet.de>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Date: Tue, 23 Nov 2010 07:57:18 +0000
Subject: RE: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Thread-Topic: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Thread-Index: AcuK4uQos7PDJyVHQaOjCvPhSkVsJwAAM6Vw
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501D41ED769@irsmsx504.ger.corp.intel.com>
References: <20101116142027.GC19247@tiehlicka.suse.cz>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
	<20101118082454.GC15928@tiehlicka.suse.cz>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
	<4CEAA151.7050404@arndnet.de>	<20101123063200.GA23907@elte.hu>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
	<20101122233654.117eef93.akpm@linux-foundation.org>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ED75C@irsmsx504.ger.corp.intel.com>
 <20101122234407.c710e578.akpm@linux-foundation.org>
In-Reply-To: <20101122234407.c710e578.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > Will do. I suspect it should, unless you took new LED drivers? But
> then
> > again you will now probably want a patch against -rc, not -mm?
> >
> 
> It applied OK(ish) to current mainline.

It seems to need a "depends on LEDS_CLASS" to the new driver
"config LEDS_NETXBIG" in drivers/leds/. Other than that, it
still seems to be complete against current mainline (-rc3).

Do you just want to add the single line to it yourself?

johannes

--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

