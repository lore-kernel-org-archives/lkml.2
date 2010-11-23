Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0KWIKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 03:10:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:23028 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751199Ab0KWIKB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 03:10:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,241,1288594800"; 
   d="scan'208";a="629449347"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
CC: Arnd Hannemann <arnd@arndnet.de>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@linux.intel.com>
Date: Tue, 23 Nov 2010 08:09:39 +0000
Subject: RE: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Thread-Topic: 5ada28bf76752 causes compilation error if !CONFIG_LEDS_CLASS
Thread-Index: AcuK5WfKZlpTYLivQSGqZ9Yg3qLZFQAAEtsA
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501D41ED77D@irsmsx504.ger.corp.intel.com>
References: <20101116142027.GC19247@tiehlicka.suse.cz>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41A7DC2@irsmsx504.ger.corp.intel.com>
	<20101118082454.GC15928@tiehlicka.suse.cz>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ECB46@irsmsx504.ger.corp.intel.com>
	<4CEAA151.7050404@arndnet.de>	<20101123063200.GA23907@elte.hu>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ED756@irsmsx504.ger.corp.intel.com>
	<20101122233654.117eef93.akpm@linux-foundation.org>
	<C5C86A19469DAE48AAAD0E5F3716E44501D41ED75C@irsmsx504.ger.corp.intel.com>
	<20101123075742.GA28714@elte.hu>
 <20101123000232.e51b99b7.akpm@linux-foundation.org>
In-Reply-To: <20101123000232.e51b99b7.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: Bqxi CluS GVK7 NJ75 Ry/P R+9p aE+z es8d ggjt lDYC m+5T
 ABKxcA== ABqBIA== ACUlQw== ACce1g==
 ACwmkQ==;6;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGEAcgBuAGQAQABhAHIAbgBkAG4AZQB0AC4AZABlADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG0AaABvAGMAawBvAEAAcwB1AHMAZQAuAGMAegA7AG0AaQBuAGcAbwBAAGUAbAB0AGUALgBoAHUAOwByAHAAdQByAGQAaQBlAEAAbABpAG4AdQB4AC4AaQBuAHQAZQBsAC4AYwBvAG0A;Sosha1_v1;7;{E4B8C437-D177-49CE-A8A3-159E7A083510};agBvAGgAYQBuAG4AZQBzAC4AYgBlAHIAZwBAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Tue,
 23 Nov 2010 08:09:39
 GMT;UgBFADoAIAA1AGEAZABhADIAOABiAGYANwA2ADcANQAyACAAYwBhAHUAcwBlAHMAIABjAG8AbQBwAGkAbABhAHQAaQBvAG4AIABlAHIAcgBvAHIAIABpAGYAIAAhAEMATwBOAEYASQBHAF8ATABFAEQAUwBfAEMATABBAFMAUwA=
x-cr-puzzleid: {E4B8C437-D177-49CE-A8A3-159E7A083510}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > It applied with a fuzz here so something changed in that file since
> you made the
> > patch. I did a quick review of drivers/leds/Kconfig and your patch
> seems complete to
> > me.
> 
> It looks complete to me as well.  It already fixes LEDS_NETXBIG.

Yeah, looks like I got confused -- or more likely my local version
didn't quite match the one I'd posted for some reason.

Thanks for checking.

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

