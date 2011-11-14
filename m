Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab1KNRhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:37:32 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:59634
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751406Ab1KNRhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:37:31 -0500
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dK9371K1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4EC151D5.3040900@freescale.com>
Date: Mon, 14 Nov 2011 11:37:25 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Liu Gang <Gang.Liu@freescale.com>
CC: <r58472@freescale.com>, Kai Jiang <Kai.Jiang@freescale.com>,
        <linux-kernel@vger.kernel.org>, <r61911@freescale.com>,
        <Alexandre.Bounine@idt.com>, <akpm@linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <B11780@freescale.com>
Subject: Re: [PATCH 4/5, v3] powerpc/8xxx: Update device tree bus probe for
 new RapidIO node binding
References: <1321099352-21462-1-git-send-email-Gang.Liu@freescale.com> <1321099352-21462-4-git-send-email-Gang.Liu@freescale.com> <4EC15145.3030001@freescale.com>
In-Reply-To: <4EC15145.3030001@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 11:35 AM, Scott Wood wrote:
> On 11/12/2011 06:02 AM, Liu Gang wrote:
>> From: Kai Jiang <Kai.Jiang@freescale.com>
>>
>> Update of_platform_bus_probe() RapidIO node to be compitable with
>> new RapidIO dts compatible property.
>>
>> Signed-off-by: Kai Jiang <Kai.Jiang@freescale.com>
>> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
>> ---
>>  arch/powerpc/platforms/85xx/corenet_ds.c   |    2 +-
>>  arch/powerpc/platforms/85xx/mpc85xx_mds.c  |    2 +-
>>  arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |    2 +-
>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
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
> fsl,srio is too vague.  We need to identify the specific hardware (or at
> least a concrete programming interface document), not just the bus  that
> the hardware implements.

Never mind, I see that the binding is more specific about what this
string means.

Next time have the binding come first. :-)

-Scott

