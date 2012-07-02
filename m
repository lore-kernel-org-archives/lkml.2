Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab2GBI65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 04:58:57 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:30259
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932655Ab2GBI6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 04:58:54 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839h93fhd25he5bhf0ah)
Message-ID: <4FF16382.1060505@analog.com>
Date: Mon, 2 Jul 2012 11:01:54 +0200
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: SamuelOrtiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd: adp5520: Guard PM methods with CONFIG_PM_SLEEP
References: <1341219232.5864.1.camel@phoenix>
In-Reply-To: <1341219232.5864.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 10:53 AM, Axel Lin wrote:
> This fixes below build warnings:
>    CC      drivers/mfd/adp5520.o
> drivers/mfd/adp5520.c:324:12: warning: 'adp5520_suspend' defined but not used [-Wunused-function]
> drivers/mfd/adp5520.c:333:12: warning: 'adp5520_resume' defined but not used [-Wunused-function]
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>   drivers/mfd/adp5520.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/mfd/adp5520.c b/drivers/mfd/adp5520.c
> index 8d816cc..ea8b947 100644
> --- a/drivers/mfd/adp5520.c
> +++ b/drivers/mfd/adp5520.c
> @@ -320,7 +320,7 @@ static int __devexit adp5520_remove(struct i2c_client *client)
>   	return 0;
>   }
>   
> -#ifdef CONFIG_PM
> +#ifdef CONFIG_PM_SLEEP
>   static int adp5520_suspend(struct device *dev)
>   {
>   	struct i2c_client *client = to_i2c_client(dev);


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


