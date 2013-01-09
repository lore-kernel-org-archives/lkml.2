Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3AIBPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 20:15:52 -0500
Received: from nasmtp02.atmel.com ([204.2.163.16]:6186 "EHLO
	nasmtp02.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab3AIBPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 20:15:51 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2013 20:15:51 EST
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [v3 PATCH 9/9] ARM: dts: add the watchdog nodes for
 at91sam9g25ek boards
Thread-Topic: [v3 PATCH 9/9] ARM: dts: add the watchdog nodes for
 at91sam9g25ek boards
Thread-Index: AQHN6u6lqScjQPb6Ekiykle2qRNJEJg/WgOAgADYJVA=
Date: Wed, 9 Jan 2013 01:04:53 +0000
Message-ID: <B256D81BAE5131468A838E5D7A2436413A058680@penmbx02>
References: <1357353529-20901-1-git-send-email-wenyou.yang@atmel.com>
 <1357353529-20901-10-git-send-email-wenyou.yang@atmel.com>
 <20130108200149.GE7360@game.jcrosoft.org>
In-Reply-To: <20130108200149.GE7360@game.jcrosoft.org>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r091Fq71003759



> -----Original Message-----
> From: Jean-Christophe PLAGNIOL-VILLARD [mailto:plagnioj@jcrosoft.com]
> Sent: 2013Äê1ÔÂ9ÈÕ 4:02
> To: Yang, Wenyou
> Cc: linux-arm-kernel@lists.infradead.org; Ferre, Nicolas; Lin, JM;
> linux@arm.linux.org.uk; linux-kernel@vger.kernel.org
> Subject: Re: [v3 PATCH 9/9] ARM: dts: add the watchdog nodes for
> at91sam9g25ek boards
> 
> On 10:38 Sat 05 Jan     , Wenyou Yang wrote:
> > Tested on the at91sam9g25ek boards
> >
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > Cc: linux@arm.linux.org.uk
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/arm/boot/dts/at91sam9x5ek.dtsi |    4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/at91sam9x5ek.dtsi
> b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> > index 8a7cf1d..afddf75 100644
> > --- a/arch/arm/boot/dts/at91sam9x5ek.dtsi
> > +++ b/arch/arm/boot/dts/at91sam9x5ek.dtsi
> > @@ -69,6 +69,10 @@
> >  				status = "okay";
> >  			};
> >
> > +			watchdog@fffffe40 {
> > +				status = "okay";
> > +			};
> > +
> 
> use less today as the watchdog is shutdown at bootstrap level
> 
> and on at91 once shutdown we can not enable it again

Yes, you are right.
But, If you want to use the watchdog, you should not disable the watchdog.
Also in the new version at91bootstrap, it provide this config option.

If the watchdog is disabled in the bootstrap, "the watchdog has been disabled" will display in the dmesg.

> 
> Best Regards,
> J.
> >  			pinctrl@fffff400 {
> >  				mmc0 {
> >  					pinctrl_board_mmc0: mmc0-board {
> > --
> > 1.7.9.5
> >

Best Regards,
Wenyou Yang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
