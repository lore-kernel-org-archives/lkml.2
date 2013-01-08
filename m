Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab3AHBCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:02:14 -0500
Received: from nasmtp01.atmel.com ([192.199.1.246]:10721 "EHLO
	DVREDG02.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751307Ab3AHBCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:02:13 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Joe Perches <joe@perches.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "Lin, JM" <JM.Lin@atmel.com>
Subject: RE: [v3 PATCH 05/12] spi/atmel_spi: update the dt support
Thread-Topic: [v3 PATCH 05/12] spi/atmel_spi: update the dt support
Thread-Index: AQHN7HpcLSW0zn54FkWfdnBiKjn1qpg8mAQAgAIGVBA=
Date: Tue, 8 Jan 2013 01:02:01 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436413A05704A@penmbx02>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
	 <1357523413-27209-6-git-send-email-wenyou.yang@atmel.com>
 <1357524362.4940.16.camel@joe-AO722>
In-Reply-To: <1357524362.4940.16.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0812HiT029513



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: 2013Äê1ÔÂ7ÈÕ 10:06
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Ferre,
> Nicolas; plagnioj@jcrosoft.com; richard.genoud@gmail.com; Lin, JM
> Subject: Re: [v3 PATCH 05/12] spi/atmel_spi: update the dt support
> 
> On Mon, 2013-01-07 at 09:50 +0800, Wenyou Yang wrote:
> > To meet the different spi IP version of atmel SoC,
> > add more compatible "atmel,at91rm9200-spi", "atmel,at91sam9260-spi"
> > "atmel,at91sam9g45-spi", "atmel,at91sam9x5-spi" with different
> > config and devtype.
> 
> trivial comment:
> 
> > diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> []
> > @@ -230,11 +302,15 @@ struct atmel_spi_device {
> >   * register, but I haven't checked that it exists on all chips, and
> >   * this is cheaper anyway.
> >   */
> > -static bool atmel_spi_is_v2(void)
> > +static bool atmel_spi_is_v2(struct atmel_spi *as)
> 
> There's a comment that needs updating above this now
> 
> >  {
> > -	return !cpu_is_at91rm9200();
> > +	if (as->pdata->version == 2)
> > +		return true;
> > +	else
> > +		return false;
> 
> 	return as->pdata->version == 2;
> 
> is rather more readable to me

Thanks a lot for quick feedback.
I will change it next version.
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
