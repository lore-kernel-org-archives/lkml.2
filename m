Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab0JWLjH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:39:07 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:52369 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756019Ab0JWLjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:39:04 -0400
Message-ID: <4CC2C94A.9040700@eukrea.com>
Date: Sat, 23 Oct 2010 13:38:50 +0200
From: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Dinh.Nguyen@freescale.com, linux-kernel@vger.kernel.org,
        amit.kucheria@canonical.com, linux@arm.linux.org.uk,
        s.hauer@pengutronix.de, grant.likely@secretlab.ca,
        linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCHv6 1/3] ARM: imx: Add gpio-keys to plat-mxc
References: <1287801976-5324-1-git-send-email-Dinh.Nguyen@freescale.com> <4CC2977D.8060409@eukrea.com> <20101023095049.GC8554@pengutronix.de>
In-Reply-To: <20101023095049.GC8554@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 14504687025585106272
X-Ovh-Remote: 82.233.81.124 (tal33-3-82-233-81-124.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

Le 23/10/2010 11:50, Uwe Kleine-König a écrit :
> On Sat, Oct 23, 2010 at 10:06:21AM +0200, Eric Bénard wrote:
>> Le 23/10/2010 04:46, Dinh.Nguyen@freescale.com a écrit :
>>> +struct platform_device *__init imx_add_gpio_keys(
>>> +		const struct gpio_keys_platform_data *pdata)
>>> +{
>>> +	return imx_add_platform_device("gpio-keys", -1, NULL,
>>> +		 0, pdata, sizeof(*pdata));
>>> +}
>>
>> What is the added value of this ?
> Is is (more or less) in line with the other imx functions that
> dynamically add platform devices.
>
>> gpio-keys is not i.MX specific so why should that land in plat-mxc ?
> I consider it OK for now.  I know Eric does/wants something similar for
> pxa.  If you want to push forward unification here that's great, but
> IMHO this is nothing that should stop this patch which is a good step
> forward.
>
Does that mean that, for example, for cpuimx51 and cpuimx51sd boards, I should 
create : imx_add_gpio_leds, imx_add_serial_8250 and imx_add_i2c_gpio functions 
instead of creating the platform_device structure in the board's files and 
using platform_add_devices to register it ?

Thanks,
Eric
