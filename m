Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760961Ab0J0O5C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:57:02 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:53366
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013Ab0J0O47 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:56:59 -0400
X-SpamScore: -33
X-BigFish: VS-33(zzbb2dK542N1432N98dN4015L9371Pzz1202hzzz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ARM: imx: Add some core definitions for MX53
Date: Wed, 27 Oct 2010 07:57:11 -0700
Message-ID: <86A0E76937111F4C92FABEC0A2098851051D6523@az33exm21>
In-Reply-To: <20101027135642.GM6017@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ARM: imx: Add some core definitions for MX53
Thread-Index: Act13uJlhZWJvl4jRUivqUXTy+5IZwAB5gJw
References: <1288119235-7036-1-git-send-email-Dinh.Nguyen@freescale.com> <20101027082958.GA6797@angua.secretlab.ca> <20101027090921.GB8554@pengutronix.de> <20101027102253.GA7822@angua.secretlab.ca> <20101027132213.GJ6017@pengutronix.de> <4CC82A13.8000909@eukrea.com> <20101027135642.GM6017@pengutronix.de>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>,
        =?iso-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
CC: Grant Likely <grant.likely@secretlab.ca>, <amit.kucheria@canonical.com>,
        <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <daniel@caiaq.de>,
        =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        <valentin.longchamp@epfl.ch>
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>-----Original Message-----
>From: Sascha Hauer [mailto:s.hauer@pengutronix.de]
>Sent: Wednesday, October 27, 2010 8:57 AM
>To: Eric Bénard
>Cc: Grant Likely; amit.kucheria@canonical.com; linux@arm.linux.org.uk; Nguyen Dinh-R00091; linux-
>kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; daniel@caiaq.de; Uwe Kleine-König;
>valentin.longchamp@epfl.ch
>Subject: Re: [PATCH] ARM: imx: Add some core definitions for MX53
>
>On Wed, Oct 27, 2010 at 03:33:07PM +0200, Eric Bénard wrote:
>> Hi,
>>
>> Le 27/10/2010 15:22, Sascha Hauer a écrit :
>> > That's a way we can go but only if the common name is not MX5 or MX5x.
>> > We've done it with the mx21/27 and it failed when the mx25 came out
>> > which was completely incompatible. Since then everybody looking at
>> > the code must know that mx2x is mx21/27 but not mx25. I suggest
>> > something like MX513 instead.
>> >
>> MX513 is the partnumber of a member of the i.MX51 family so that's maybe
>> not the best choice.
>
>Yes, I know. Is MX5_1_3 better? Any other suggestions?

Not sure why we can't do something like this?

In mx5x.h, 
MX51_PERIP_1 /* Address specific to mx51 */
MX53_PERIP_1 /* Address specific to mx53 */
MX5_PERIP_2 /* Address that is shared to mx51, mx53, and any later mx5X chips */
Then if something like mx57 comes, you can add to mx5x.h the differences with MX57_PERIP_1.

>
>--
>Pengutronix e.K.                           |                             |
>Industrial Linux Solutions                 | http://www.pengutronix.de/  |
>Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
>Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

Thanks,
Dinh

