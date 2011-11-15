Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab1KODWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 22:22:00 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:21303
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755095Ab1KODV7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 22:21:59 -0500
X-SpamScore: -23
X-BigFish: VS-23(zzbb2dK9371K103dK542M1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Liu Gang-B34182 <B34182@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>
CC: Li Yang-R58472 <r58472@freescale.com>,
        Jiang Kai-B18973 <B18973@freescale.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Zang Roy-R61911 <r61911@freescale.com>,
        "'Alexandre.Bounine@idt.com'" <Alexandre.Bounine@idt.com>,
        "'akpm@linux-foundation.org'" <akpm@linux-foundation.org>,
        "'linuxppc-dev@lists.ozlabs.org'" <linuxppc-dev@lists.ozlabs.org>,
        Gala Kumar-B11780 <B11780@freescale.com>
Subject: RE: [PATCH 4/5, v3] powerpc/8xxx: Update device tree bus probe for
 new RapidIO node binding
Thread-Topic: [PATCH 4/5, v3] powerpc/8xxx: Update device tree bus probe for
 new RapidIO node binding
Thread-Index: AQHMovO+p7uAeSgb9EGoOhQVZxALKZWtBtKAgAA8aiA=
Date: Tue, 15 Nov 2011 03:21:54 +0000
Message-ID: <9A1C2A9ACC704641BC472A1588CE16471417AE@039-SN1MPN1-005.039d.mgd.msft.net>
References: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com>
 <1321099352-21462-4-git-send-email-Gang.Liu@freescale.com>
 <4EC15145.3030001@freescale.com> <4EC151D5.3040900@freescale.com>
In-Reply-To: <4EC151D5.3040900@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.185]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah, send binding first should be better for reviewing entire set of patches.
Thanks!

-----Original Message-----
From: Wood Scott-B07421 
Sent: Tuesday, November 15, 2011 1:37 AM
To: Liu Gang-B34182
Cc: Li Yang-R58472; Jiang Kai-B18973; linux-kernel@vger.kernel.org; Zang Roy-R61911; Alexandre.Bounine@idt.com; akpm@linux-foundation.org; linuxppc-dev@lists.ozlabs.org; Gala Kumar-B11780
Subject: Re: [PATCH 4/5, v3] powerpc/8xxx: Update device tree bus probe for new RapidIO node binding

On 11/14/2011 11:35 AM, Scott Wood wrote:
> On 11/12/2011 06:02 AM, Liu Gang wrote:
>> From: Kai Jiang <Kai.Jiang@freescale.com>
>>
>> Update of_platform_bus_probe() RapidIO node to be compitable with new 
>> RapidIO dts compatible property.
>>
>> Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> ---
>>  arch/powerpc/platforms/85xx/corenet_ds.c   |    2 +-
>>  arch/powerpc/platforms/85xx/mpc85xx_mds.c  |    2 +-
>>  arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |    2 +-
>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c 
>> b/arch/powerpc/platforms/85xx/corenet_ds.c
>> index 802ad11..c48b661 100644
>> --- a/arch/powerpc/platforms/85xx/corenet_ds.c
>> +++ b/arch/powerpc/platforms/85xx/corenet_ds.c
>> @@ -112,7 +112,7 @@ static const struct of_device_id of_device_ids[] __devinitconst = {
>>  		.compatible	= "simple-bus"
>>  	},
>>  	{
>> -		.compatible	= "fsl,rapidio-delta",
>> +		.compatible	= "fsl,srio",
> 
> fsl,srio is too vague.  We need to identify the specific hardware (or 
> at least a concrete programming interface document), not just the bus  
> that the hardware implements.

Never mind, I see that the binding is more specific about what this string means.

Next time have the binding come first. :-)

-Scott

