Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab2LGHP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 02:15:59 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:2474 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab2LGHP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 02:15:57 -0500
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "wim@iguana.be" <wim@iguana.be>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>
Subject: RE: [v2 PATCH 6/8] watchdog/at91sam9_wdt: Use
 module_platform_driver()
Thread-Topic: [v2 PATCH 6/8] watchdog/at91sam9_wdt: Use
 module_platform_driver()
Thread-Index: AQHN0olow+9cdvYrbEuRdCMwtXBTlpgLkFcAgAFfGnA=
Date: Fri, 7 Dec 2012 07:12:54 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436413A01DF81@penmbx01>
References: <1354671267-19277-1-git-send-email-wenyou.yang@atmel.com>
 <1354671267-19277-7-git-send-email-wenyou.yang@atmel.com>
 <50C0E0E8.3020809@mvista.com>
In-Reply-To: <50C0E0E8.3020809@mvista.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qB77G4hA025013

Hi,

> -----Original Message-----
> From: Sergei Shtylyov [mailto:sshtylyov@mvista.com]
> Sent: 2012Äê12ÔÂ7ÈÕ 2:16
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; linux-watchdog@vger.kernel.org; Lin, JM;
> Ferre, Nicolas; linux-kernel@vger.kernel.org; wim@iguana.be;
> plagnioj@jcrosoft.com
> Subject: Re: [v2 PATCH 6/8] watchdog/at91sam9_wdt: Use
> module_platform_driver()
> 
> Hello.
> 
> On 12/05/2012 04:34 AM, Wenyou Yang wrote:
> 
> > Using module_platform_driver() replaces module_init() and module_exit()
> > and makes the code simpler.
> 
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > Cc: wim@iguana.be
> > Cc: linux-watchdog@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/watchdog/at91sam9_wdt.c |   14 ++------------
> >  1 file changed, 2 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
> > index 5afd3fb..a7c0881 100644
> > --- a/drivers/watchdog/at91sam9_wdt.c
> > +++ b/drivers/watchdog/at91sam9_wdt.c
> > @@ -278,6 +278,7 @@ MODULE_DEVICE_TABLE(of, at91_wdt_dt_ids);
> >  #endif
> >
> >  static struct platform_driver at91wdt_driver = {
> > +	.probe		= at91wdt_probe,
> 
>    You also need to remove '__init' annotation from that function since the
> driver becomes hot-plug aware now.
Thanks, I got it.
> 
> WBR, Sergei

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
