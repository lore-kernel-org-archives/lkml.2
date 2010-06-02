Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab0FBD0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 23:26:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:4033 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab0FBD0r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 23:26:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,344,1272870000"; 
   d="scan'208";a="572499102"
From: "Gross, Mark" <mark.gross@intel.com>
To: =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: James Bottomley <James.Bottomley@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, "tytso@mit.edu" <tytso@mit.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       "felipe.balbi@nokia.com" <felipe.balbi@nokia.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alan Stern <stern@rowland.harvard.edu>, Neil Brown <neilb@suse.de>
Date: Tue, 1 Jun 2010 20:26:32 -0700
Subject: RE: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Thread-Topic: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Thread-Index: AcsCAdSxIYdSmgiMSjqvSRctxYQLJQAAWRgw
Message-ID: <CA1BBBBC9359F04AA639128AC0D5D1E9692AAF4F@orsmsx502.amr.corp.intel.com>
References: <20100527232357.6d14fdb2@lxorguk.ukuu.org.uk>
	<20100601135102.GA8098@srcf.ucam.org>
	<1275426085.21962.967.camel@mulgrave.site>	<201006020024.14220.rjw@sisk.pl>
	<1275431816.21962.1108.camel@mulgrave.site>
	<AANLkTikObnAZbyOxeYAhXcEbimO3XTTO-HlC9CD_HH6t@mail.gmail.com>
	<CA1BBBBC9359F04AA639128AC0D5D1E9692AAF29@orsmsx502.amr.corp.intel.com>
 <AANLkTinsgmHh7iLhESPXiTkoW9SL4H8E92-7bARpDxNX@mail.gmail.com>
In-Reply-To: <AANLkTinsgmHh7iLhESPXiTkoW9SL4H8E92-7bARpDxNX@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>-----Original Message-----
>From: Arve Hjønnevåg [mailto:arve@android.com]
>Sent: Tuesday, June 01, 2010 8:15 PM
>To: Gross, Mark
>Cc: James Bottomley; Rafael J. Wysocki; Matthew Garrett; Thomas Gleixner;
>Peter Zijlstra; tytso@mit.edu; LKML; Florian Mickler; Linux PM; Linux OMAP
>Mailing List; felipe.balbi@nokia.com; Alan Cox; Alan Stern; Neil Brown
>Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
>
>2010/6/1 Gross, Mark <mark.gross@intel.com>:
>...
>>>4. It would be useful to change pm_qos_add_request to not allocate
>>>anything so can add constraints from init functions that currently
>>>cannot fail.
>> [mtg: ] I'm not sure how to do this but I agree it would be good.  I
>guess we could have a block of pm_qos requests pre-allocated statically and
>re-use them.  In practice there will not be more than a handful of requests
>ever.  Dynamic allocation does seem like a bit of a waste.
>
>The calling code will have to store a pointer to your structure
>anyway, you may as well have them provide the whole structure.
[mtg: ] duh!  You are right.  Make the caller's hold the structure.  Its been a long day.  That would be easy todo.

--gmross


