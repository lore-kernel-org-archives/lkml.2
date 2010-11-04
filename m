Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab0KDVXk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 17:23:40 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:23561
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752982Ab0KDVXi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 17:23:38 -0400
X-SpamScore: -19
X-BigFish: VS-19(zzbb2dK542N1432N9371P8c03lzz1202hzz8275dhz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2/2] ARM: imx: Add mx53 support to common msl functions.
Date: Thu, 4 Nov 2010 14:24:10 -0700
Message-ID: <86A0E76937111F4C92FABEC0A20988510523CF03@az33exm21>
In-Reply-To: <4CD317E2.9090504@eukrea.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/2] ARM: imx: Add mx53 support to common msl functions.
Thread-Index: Act8X1EMvWOsHbbNTI+yt7/BgHEM2QABt+RQ
References: <1288736227-800-1-git-send-email-Dinh.Nguyen@freescale.com> <1288736227-800-2-git-send-email-Dinh.Nguyen@freescale.com> <4CD12833.8060204@eukrea.com> <86A0E76937111F4C92FABEC0A20988510523CEC2@az33exm21> <4CD317E2.9090504@eukrea.com>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: =?iso-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
CC: <linux-kernel@vger.kernel.org>, <amit.kucheria@canonical.com>,
        <linux@arm.linux.org.uk>, <s.hauer@pengutronix.de>,
        <grant.likely@secretlab.ca>, <linux-arm-kernel@lists.infradead.org>,
        <daniel@caiaq.de>, <u.kleine-koenig@pengutronix.de>,
        Zhang Lily-R58066 <R58066@freescale.com>, <valentin.longchamp@epfl.ch>
X-Reverse-DNS: az33egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Eric
>Bénard
>Sent: Thursday, November 04, 2010 3:30 PM
>To: Nguyen Dinh-R00091
>Cc: linux-kernel@vger.kernel.org; amit.kucheria@canonical.com; linux@arm.linux.org.uk;
>s.hauer@pengutronix.de; grant.likely@secretlab.ca; linux-arm-kernel@lists.infradead.org;
>daniel@caiaq.de; u.kleine-koenig@pengutronix.de; Zhang Lily-R58066; valentin.longchamp@epfl.ch
>Subject: Re: [PATCH 2/2] ARM: imx: Add mx53 support to common msl functions.
>
>Hi Dinh,
>
>Le 04/11/2010 20:21, Nguyen Dinh-R00091 a écrit :
>> Reading the ROM code is probably the most reliable way to get the correct
>> silicon revision. Because the ROM that is on the chip is "most likely"
>> up-to-date with the silicon. "Most likely" means that 95% of the time, when
>> you get a new silicon, the ROM code will get updated. There is still a
>> chance that a new silicon will not require a ROM update.
>>
>> Also the other reason is that sometimes the fuses that identify the silicon
>> revision that are used by the IIM are sometimes not blown to reflect the
>> correct revision in pre-production parts. MX51 is a post production part,
>> so in theory, the fuses are blown correctly. But since we made MX51 boards
>> available prior to going into production, reading from the IIM is not as
>> reliable as reading the ROM.
>>
>Don't you think we should use the documented register which (if we believe the
>documentation) should be 100% reliable for production CPU instead of this
>undocumented method which from what you say is 95% reliable and here to handle
>the case of pre production CPU ?
>
>The same problem occured on i.MX35 silicon 2.1 which where not correctly
>detected using the ROM code.
>

Would you agree to this approach? Read the IIM register and the ROM code, if the IIM and ROM agree, then no issue. But if ROM and IIM disagree, we would go with whatever is the latest Revision? 

>Eric
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


