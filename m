Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab1BPMmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:42:25 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:18228
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045Ab1BPMmX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:42:23 -0500
X-Greylist: delayed 905 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Feb 2011 07:42:23 EST
X-SpamScore: -23
X-BigFish: VS-23(zzbb2dK1432N98dN9371Pzz1202hzzz2dh2a8h637h668h)
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
Message-ID: <4D5BC291.1010906@freescale.com>
Date: Wed, 16 Feb 2011 10:26:57 -0200
From: Fabio Estevam <fabio.estevam@freescale.com>
Organization: Freescale Semiconductor
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Andres Salomon <dilinger@queued.net>, Samuel Ortiz <sameo@linux.intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Richard Purdie <rpurdie@rpsys.net>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 16/17] mc13xxx: mfd_cell is now implicitly available to
 drivers
References: <20110211181921.3d561568@queued.net> <20110216094154.GV13279@pengutronix.de>
In-Reply-To: <20110216094154.GV13279@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On 2/16/2011 7:41 AM, Uwe Kleine-König wrote:
...
>>  
>>  /* MC13783 */
>> -static struct mc13783_platform_data mc13783_pdata __initdata = {
> isn't using __initdata here broken already before your patch?  Was
> introduced in c67a3e09.  Fabio?

I followed the same approach as in the mx31_3ds.c file.

> But in general I'd prefer to keep as much __initdata as possible because
> this occupies less memory when using a multi-machine kernel.

So keeping __initdata is OK then? Let me know and I can fix it needed.

Regards,

Fabio Estevam


