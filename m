Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759042Ab1BPMbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:31:32 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:12101
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755173Ab1BPMb3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:31:29 -0500
X-SpamScore: -17
X-BigFish: VS-17(zzbb2dK98dN9371Pzz1202hzzz2dh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:de01egw01.freescale.net;RD:de01egw01.freescale.net;EFVD:NLI
Message-ID: <4D5BC38E.1060009@freescale.com>
Date: Wed, 16 Feb 2011 10:31:10 -0200
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
>>  /* MC13783 */
>> -static struct mc13783_platform_data mc13783_pdata __initdata = {
> isn't using __initdata here broken already before your patch?  Was
> introduced in c67a3e09.  Fabio?

I followed the same approach as in mx31_3ds.c file.
 
> But in general I'd prefer to keep as much __initdata as possible because
> this occupies less memory when using a multi-machine kernel.

Ok, is the __initdata usage correct then? If not, I can change it. Just let me know.

Regards,

Fabio Estevam


