Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074Ab1DNO5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:57:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:32710 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758008Ab1DNO5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:57:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,211,1301900400"; 
   d="scan'208";a="679028376"
From: "Allyn, Mark A" <mark.a.allyn@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Joe Perches <joe@perches.com>, Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "Mangalampalli, Jayant" <jayant.mangalampalli@intel.com>,
        "Gokulrangan, Venkat R" <venkat.r.gokulrangan@intel.com>,
        "Cox, Alan" <alan.cox@intel.com>, "Gross, Mark" <mark.gross@intel.com>,
        "Beare, Bruce J" <bruce.j.beare@intel.com>
Date: Thu, 14 Apr 2011 08:57:33 -0600
Subject: RE: Re-send (What else needs to be done to the sep driver
 (staging/sep))
Thread-Topic: Re-send (What else needs to be done to the sep driver
 (staging/sep))
Thread-Index: Acv6s9M7TP6hmn5GTXSoocAP2qZXzAAACPCw
Message-ID: <8A0E4C92AE2D6D40AF99653191DA32316154CEF1EC@rrsmsx501.amr.corp.intel.com>
References: <alpine.DEB.2.00.1104131427260.31147@allyn-test>
	<1302731811.11415.38.camel@Joe-Laptop>	<20110413222332.GA32013@kroah.com>
	<1302733836.11415.42.camel@Joe-Laptop>	<20110413224621.GA4909@kroah.com>
	<1302736379.11415.57.camel@Joe-Laptop>
	<8A0E4C92AE2D6D40AF99653191DA32316154CEF1CF@rrsmsx501.amr.corp.intel.com>
 <20110414155503.55518951@lxorguk.ukuu.org.uk>
In-Reply-To: <20110414155503.55518951@lxorguk.ukuu.org.uk>
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



-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Thursday, April 14, 2011 7:55 AM
To: Allyn, Mark A
Cc: Joe Perches; Greg KH; linux-kernel@vger.kernel.org; alan@linux.intel.com; Mangalampalli, Jayant; Gokulrangan, Venkat R; Cox, Alan; Gross, Mark; Beare, Bruce J
Subject: Re: Re-send (What else needs to be done to the sep driver (staging/sep))

I think the logging is a distraction. Everyone is I think happy with the
other minor tidying and the move from staging ? If so lets just get it
moved while Greg and Joe throw buns at each other 8)

For the record IMHO custom _dbg wrappers are usually not justified but I
think I agree with Joe on this one because we have some many
&foo->bar->baz it eliminates.

Anyway - that can wait.

Alan

==============================================

I have no problem with Alan's suggestion, however, I think I need to wait
until Greg integrates two patches that are already in the queue; one that I 
submitted yesterday (for device version detection) and the clean-up patch.

Once I see these in the staging, then I plan to try to move to the misc
directory under drivers.

Mark Allyn
