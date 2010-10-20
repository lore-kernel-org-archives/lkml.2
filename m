Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0JTNPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:15:42 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:9652 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0JTNPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:15:41 -0400
X-SpamScore: -27
X-BigFish: VS-27(zcb8kz542N1432N98dN4015L9371Pzz1202hzz8275bhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ARM: imx: change mx51.h into mx5x.h
Date: Wed, 20 Oct 2010 06:15:53 -0700
Message-ID: <86A0E76937111F4C92FABEC0A2098851051D5B0F@az33exm21>
In-Reply-To: <20101020130903.GA19834@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ARM: imx: change mx51.h into mx5x.h
Thread-Index: ActwWAmXV+CtUtlzRfiqE9il1IyMCAAAIqhA
References: <1287525423-22329-1-git-send-email-Dinh.Nguyen@freescale.com> <20101020090122.GH28166@pengutronix.de> <20101020113550.GL2562@matterhorn.lan> <20101020130903.GA19834@pengutronix.de>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <s.hauer@pengutronix.de>, <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <daniel@caiaq.de>,
        Zhang Lily-R58066 <R58066@freescale.com>, <valentin.longchamp@epfl.ch>
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Uwe,

>-----Original Message-----
>From: Uwe Kleine-König [mailto:u.kleine-koenig@pengutronix.de]
>Sent: Wednesday, October 20, 2010 8:09 AM
>To: Nguyen Dinh-R00091; linux-kernel@vger.kernel.org; linux@arm.linux.org.uk; s.hauer@pengutronix.de;
>grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org; daniel@caiaq.de; Zhang Lily-R58066;
>valentin.longchamp@epfl.ch
>Subject: Re: [PATCH] ARM: imx: change mx51.h into mx5x.h
>
>Hello Amit,
>
>On Wed, Oct 20, 2010 at 02:35:50PM +0300, Amit Kucheria wrote:
>> On 10 Oct 20, Uwe Kleine-König wrote:
>> > Hello Dinh,
>> >
>> > On Tue, Oct 19, 2010 at 04:57:03PM -0500, Dinh.Nguyen@freescale.com wrote:
>> > > From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>> > >
>> > > In preparation for submitting i.MX53 support, change mx51.h to
>> > > mx5x.h so that mx5x.h can contain MX53 information as well.
>> > Last time I found time to clean up the imx ports I worked hard that e.g.
>> > mx27 machines only used MX27_ prefixed symbols, not the MX2x_ ones.  (I
>> > don't remember off-hand if I was done, so there might be a few users
>> > left.)
>> >
>> > I'd prefer to just add an mx53.h instead.
>>
>> Perhaps this is a good time to ask the question - Why?
>>
>> mx53.h will duplicate (almost) everything in mx51.h. And any fixes made to
>> mx51.h won't make it to mx53.h
>Yep, that's the pro side of having a single header file for both mx51
>and mx53.  On the negative side we have:
>
> - When changing mx5x.h you always have to check (now) two reference
>   manuals, later maybe more.
> - When Freescale decides to create a (say) mx56 that is totally
>   different, you can be happy not to have constants starting with MX5X.
>   (This happened to the MX2X constants when Freescale created mx25, not
>   to mention mx23 and mx28.)
>
>I admit that *now* it would be easier to just rename mx51.h to mx5x.h,
>but for the long run keeping mx51.h is better, I'm sure.
>
>Best regards
>Uwe

I guess I should also ask this question now. I was planning to add support for mx53 kernel that will be binary compatible with mx51. I'm guessing that you are not in support of that idea?

>
>--
>Pengutronix e.K.                           | Uwe Kleine-König            |
>Industrial Linux Solutions                 | http://www.pengutronix.de/  |

Thanks,
Dinh

