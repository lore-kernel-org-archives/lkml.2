Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947Ab1FFTVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 15:21:21 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41092 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757855Ab1FFTVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 15:21:16 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18TJDZBXAMTROKWWLV3tZZJp6EN7Ie5oqnddwqztw
	zMntdU9SW2oOEL
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: devel@linuxdriverproject.org
Subject: Re: [PATCH 1/2] staging: iio replaced kmalloc with local variables.
Date: Mon, 6 Jun 2011 21:20:55 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38.6; KDE/4.4.5; x86_64; ; )
Cc: anish <anish198519851985@gmail.com>, gregkh@suse.de, jic23@cam.ac.uk,
        manuel.stahl@iis.fraunhofer.de, lucas.demarchi@profusion.mobi,
        arnd@arndb.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
References: <1307387257.4327.12.camel@anish-desktop>
In-Reply-To: <1307387257.4327.12.camel@anish-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106062120.56224.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 06 Juni 2011, 21:07:37 schrieb anish:
> +++ b/drivers/staging/iio/adc/max1363_core.c
> @@ -207,7 +207,7 @@ static int max1363_write_basic_config(struct i2c_client
> *client, unsigned char d2)
>  {
>  	int ret;
> -	u8 *tx_buf = kmalloc(2, GFP_KERNEL);
> +	u8 tx_buf[2];
> 
>  	if (!tx_buf)
>  		return -ENOMEM;

These last two lines can also be removed ;)

Thanks,
Peter
