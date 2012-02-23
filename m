Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab2BWG6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 01:58:13 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:19537
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab2BWG57 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 01:57:59 -0500
X-SpamScore: -12
X-BigFish: VS-12(zzbb2dI9371I542M1432N98dKzz1202hzz8275eha1495iz2dh2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Huang Changming-R66093 <r66093@freescale.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Guenter Roeck <guenter.roeck@ericsson.com>,
        Tabi Timur-B04825 <B04825@freescale.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sun york-R58495 <R58495@freescale.com>,
        Durai Kumar-R34055 <r34055@freescale.com>
Subject: RE: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Topic: [PATCH] i2c/busses: (mpc) Add support for SMBUS_READ_BLOCK_DATA
Thread-Index: AQHMtLHxMJIM+eu7NUKF2bvKM6UbMpZKh1Bw
Date: Thu, 23 Feb 2012 06:57:54 +0000
Message-ID: <110EED8CC96DFC488B7E717A2027A27C02C64E@039-SN1MPN1-002.039d.mgd.msft.net>
References: <ECEE0D23-8F53-402C-A97F-4DB0F0E9C79B@freescale.com>
	<1321464509.7847.41.camel@oslab-l1>
	<1321464968.2309.384.camel@groeck-laptop>
	<1321466135.7847.55.camel@oslab-l1>
	<20111116190954.67c846fc@endymion.delvare>
	<1321467638.7847.73.camel@oslab-l1>
	<20111116201048.4b7877dd@endymion.delvare>
	<1321470915.7847.122.camel@oslab-l1>
	<20111116201847.6b11dc7f@endymion.delvare>
	<3C06C26914DACA4BB3A368F78CA0B3A7134583@039-SN1MPN1-004.039d.mgd.msft.net>
	<20111207032000.GA17575@ericsson.com>
	<3C06C26914DACA4BB3A368F78CA0B3A71345F2@039-SN1MPN1-004.039d.mgd.msft.net>
 <20111207082924.2f88bd5d@endymion.delvare>
In-Reply-To: <20111207082924.2f88bd5d@endymion.delvare>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.193.20.39]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have sent the v2 since 12/12/2011, could you have any comment about it?
http://marc.info/?l=linux-i2c&m=132368362506671&w=2


Thanks
Jerry Huang


> -----Original Message-----
> From: Jean Delvare [mailto:khali@linux-fr.org]
> Sent: Wednesday, December 07, 2011 3:29 PM
> To: Tang Yuantian-B29983
> Cc: Guenter Roeck; Tabi Timur-B04825; linux-i2c@vger.kernel.org; linux-
> kernel@vger.kernel.org; sun york-R58495; Durai Kumar-R34055; Huang
> Changming-R66093
> Subject: Re: [PATCH] i2c/busses: (mpc) Add support for
> SMBUS_READ_BLOCK_DATA
> 
> Hi Yuantian,
> 
> Please don't top-post.
> 
> On Wed, 7 Dec 2011 05:25:49 +0000, Tang Yuantian-B29983 wrote:
> > Hi Guenter,
> >
> > I thought you were bore of discussion.
> > Do you mind if I post similar patch?
> 
> I have no objection, as long as you give proper credit to the original
> author.
> 
> Note that ultimately you'll have to get Ben Dooks to apply the patch. I
> helped with the review but the i2c-mpc driver doesn't actually fall in my
> jurisdiction.
> 
> --
> Jean Delvare


