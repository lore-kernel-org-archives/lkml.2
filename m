Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615Ab0JWIGh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 04:06:37 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:55140 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753611Ab0JWIGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 04:06:35 -0400
Message-ID: <4CC2977D.8060409@eukrea.com>
Date: Sat, 23 Oct 2010 10:06:21 +0200
From: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Dinh.Nguyen@freescale.com
CC: linux-kernel@vger.kernel.org, amit.kucheria@canonical.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org,
        daniel@caiaq.de, u.kleine-koenig@pengutronix.de,
        valentin.longchamp@epfl.ch
Subject: Re: [PATCHv6 1/3] ARM: imx: Add gpio-keys to plat-mxc
References: <1287801976-5324-1-git-send-email-Dinh.Nguyen@freescale.com>
In-Reply-To: <1287801976-5324-1-git-send-email-Dinh.Nguyen@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10915881072637619583
X-Ovh-Remote: 82.233.81.124 (tal33-3-82-233-81-124.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

Le 23/10/2010 04:46, Dinh.Nguyen@freescale.com a écrit :
> +struct platform_device *__init imx_add_gpio_keys(
> +		const struct gpio_keys_platform_data *pdata)
> +{
> +	return imx_add_platform_device("gpio-keys", -1, NULL,
> +		 0, pdata, sizeof(*pdata));
> +}

What is the added value of this ?
gpio-keys is not i.MX specific so why should that land in plat-mxc ?

Eric
