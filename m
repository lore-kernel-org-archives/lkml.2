Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab1CBTly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 14:41:54 -0500
Received: from db3ehsobe002.messaging.microsoft.com ([213.199.154.140]:19367
	"EHLO DB3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754106Ab1CBTlx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 14:41:53 -0500
X-SpamScore: -24
X-BigFish: VS-24(zz542N1432N4015L9371Pzz1202hzz8275bh8275dhz2dh2a8h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        Zhang Lily-R58066 <R58066@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCHv1] ARM: imx: Add support for low power suspend on MX51.
Thread-Topic: [PATCHv1] ARM: imx: Add support for low power suspend on MX51.
Thread-Index: AQHL2REXLrsCMLI5vE2pDCTKUz9lkJQacGUA
Date: Wed, 2 Mar 2011 19:41:45 +0000
Message-ID: <56132A77AB93C141BF06E6B96CA6CFEA18A7C0@039-SN1MPN1-004.039d.mgd.msft.net>
References: <1299086278-12131-1-git-send-email-Dinh.Nguyen@freescale.com>
 <8762s1xqmj.fsf@lebrac.rtp-net.org>
In-Reply-To: <8762s1xqmj.fsf@lebrac.rtp-net.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.68.39]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaud,


>-----Original Message-----
>From: linux-arm-kernel-bounces@lists.infradead.org [mailto:linux-arm-kernel-
>bounces@lists.infradead.org] On Behalf Of Arnaud Patard
>Sent: Wednesday, March 02, 2011 1:35 PM
>To: Nguyen Dinh-R00091
>Cc: linux@arm.linux.org.uk; s.hauer@pengutronix.de; linux-kernel@vger.kernel.org; u.kleine-
>koenig@pengutronix.de; Zhang Lily-R58066; linux-arm-kernel@lists.infradead.org
>Subject: Re: [PATCHv1] ARM: imx: Add support for low power suspend on MX51.
>
><Dinh.Nguyen@freescale.com> writes:
>
>Hi,
>
>> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>>
>> Adds initial low power suspend functionality to MX51.
>> Supports "mem" and "standby" modes.
>
>I've very quickly tried suspend to mem on my system and despite having set
>some irq as wakeup source, it doesn't wake up. Is there some extra step
>to be done in order to test your patch ?
>
>Moreover, the code I've seen for suspend is very different. It's seems
>to handle some cpufreq stuff and seems to be copying some code into some
>special ram. Is all this stuff unneeded ?

I am able to wakeup using gpio-key on my mx51-babbage system if I comment out the most of the drivers except for the gpio-keys driver. Yes, there are additional cpufreq and code that needs to get run in IRAM for mx51, which I will add on to this patch. This is just the initial patch to put the SoC in to suspend and have other developers add to it.

Thanks,

Dinh

>
>Arnaud
>
>_______________________________________________
>linux-arm-kernel mailing list
>linux-arm-kernel@lists.infradead.org
>http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


