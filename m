Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab3AHBCw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:02:52 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:59840 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab3AHBCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:02:51 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Joe Perches <joe@perches.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Subject: RE: [v3 PATCH 06/12] spi/atmel_spi: add dmaengine support
Thread-Topic: [v3 PATCH 06/12] spi/atmel_spi: add dmaengine support
Thread-Index: AQHN7HpgHdqMbxRgrE2fl3Nl5ZLKLZg8mTKAgAIFdJA=
Date: Tue, 8 Jan 2013 01:02:38 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436413A057056@penmbx02>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
	 <1357523413-27209-7-git-send-email-wenyou.yang@atmel.com>
 <1357524615.4940.19.camel@joe-AO722>
In-Reply-To: <1357524615.4940.19.camel@joe-AO722>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0812qtF029517



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: 2013Äê1ÔÂ7ÈÕ 10:10
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Ferre,
> Nicolas; plagnioj@jcrosoft.com; richard.genoud@gmail.com; Lin, JM;
> grant.likely@secretlab.ca; spi-devel-general@lists.sourceforge.net
> Subject: Re: [v3 PATCH 06/12] spi/atmel_spi: add dmaengine support
> 
> On Mon, 2013-01-07 at 09:50 +0800, Wenyou Yang wrote:
> > From: Nicolas Ferre <nicolas.ferre@atmel.com>
> []
> > diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
> []
> > +static inline bool atmel_spi_use_dma(struct atmel_spi *as,
> > +				struct spi_transfer *xfer)
> > +{
> > +	if ((as->use_dma) && (xfer->len >= DMA_MIN_BYTES))
> > +		return true;
> > +	else
> > +		return false;
> > +}
> 
> Same unnecessary form.
> 
> 	return as->use_dma && xfer->len >= DMA_MIN_BYTES;
> 
> > +static inline bool atmel_spi_use_pdc(struct atmel_spi *as)
> > +{
> > +	if (as->use_pdc)
> > +		return true;
> > +	else
> > +		return false;
> > +}
> 
> Does this function really need to exist at all?
> 
Thanks a lot for your advice.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
