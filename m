Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab0KWHmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:42:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:48005 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999Ab0KWHmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:42:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,241,1288594800"; 
   d="scan'208";a="680126544"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnd Hannemann <arnd@arndnet.de>,
        Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Date: Tue, 23 Nov 2010 07:41:58 +0000
Subject: RE: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Thread-Topic: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Thread-Index: AcuK4cywdG+pk+v8SIKXV/u69JVCqwAAAeSA
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501D41ED75C@irsmsx504.ger.corp.intel.com>
References: <20101116142027.GC19247@tiehlicka.suse.cz>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
	<20101118082454.GC15928@tiehlicka.suse.cz>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
	<4CEAA151.7050404@arndnet.de>	<20101123063200.GA23907@elte.hu>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
 <20101122233654.117eef93.akpm@linux-foundation.org>
In-Reply-To: <20101122233654.117eef93.akpm@linux-foundation.org>
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

> > Hmm. For some reason I thought this patch had made it into -mm,
> > but I never double-checked and then went travelling ...
> >
> > http://lkml.org/lkml/2010/10/26/79
> 
> oops, I filed it in the wrong drawer, under "non-urgent".  It then got
> buried in new paperwork.  But not lost!
> 
> Gee it's big.  Could you please double-check that it is still complete?

Will do. I suspect it should, unless you took new LED drivers? But then
again you will now probably want a patch against -rc, not -mm?

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

