Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934748Ab0HDUUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:20:51 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:29945 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934298Ab0HDUUp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:20:45 -0400
From: "Mingarelli, Thomas" <Thomas.Mingarelli@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>,
        "Frazier, Daniel Kent (ProLiant Linux)" <daniel_frazier@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 4 Aug 2010 20:18:22 +0000
Subject: RE: [PATCH 09/15] Despecificate driver from iLO2
Thread-Topic: [PATCH 09/15] Despecificate driver from iLO2
Thread-Index: Acs0EZKzeQBJceNgQCyBTxRtPjzDcAAAInqQ
Message-ID: <183C1D5A376DE343AA8F94FC2A1EC1497B49F88E0B@GVW1091EXB.americas.hpqcorp.net>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
 <1280274663-9160-10-git-send-email-dannf@hp.com>
 <20100804201341.GC30740@infomag.iguana.be>
In-Reply-To: <20100804201341.GC30740@infomag.iguana.be>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I like that suggestion Wim. Sure would make future iLO releases easier to include.


Tom

> -----Original Message-----
> From: Wim Van Sebroeck [mailto:wim@iguana.be]
> Sent: Wednesday, August 04, 2010 3:14 PM
> To: Frazier, Daniel Kent (ProLiant Linux)
> Cc: linux-kernel@vger.kernel.org; Mingarelli, Thomas
> Subject: Re: [PATCH 09/15] Despecificate driver from iLO2
> 
> Hi Dan,
> 
> > This driver supports both iLO2 and iLO3, but our user-visible strings
> > currently only reference iLO2. Let's just call it "iLO" to avoid having
> > to update strings for each iLO generation. This driver doesn't support
> > iLO ASICs prior to iLO2, but that is sufficiently explained in Kconfig.
> 
> Just a thought: Wouldn't it be more consistent if it's called iLO2+
> everywhere?
> 
> > -	tristate "HP Proliant iLO 2 Hardware Watchdog Timer"
> > +	tristate "HP Proliant iLO Hardware Watchdog Timer"
> 
> would be: tristate "HP Proliant iLO2+ Hardware Watchdog Timer"
> 
> > -	.identity = "HP iLO2 HW Watchdog Timer",
> > +	.identity = "HP iLO HW Watchdog Timer",
> 
> and: .identity = "HP iLO2+ HW Watchdog Timer",
> 
> > -	 * First let's find out if we are on an iLO2 server. We will
> > +	 * First let's find out if we are on an iLO2+ server. We will
> 
> > -		dev_warn(&dev->dev,
> > -			"This server does not have an iLO2 ASIC.\n");
> > +		dev_warn(&dev->dev, "This server does not have an iLO ASIC"
> > +			 " version 2 or greater.\n");
> 
> dev_warn(&dev->dev,
> 	"This server does not have an iLO2+ ASIC.\n");
> 
> > -			"Unable to detect the iLO2 server memory.\n");
> > +			"Unable to detect the iLO server memory.\n");
> 
> "Unable to detect the iLO2+ server memory.\n");
> 
> For the rest I'm still reviewing the code.
> 
> Kind regards,
> Wim.

