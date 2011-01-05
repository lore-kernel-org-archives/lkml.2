Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1AEAy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 19:54:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:56154 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1AEAy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 19:54:27 -0500
Date: Wed, 05 Jan 2011 00:54:25 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH v4 2/3] regulator MAX8998/LP3974: Support DVS-GPIO.
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        =?euc-kr?Q?=BD=C9=C1=D8=BF=B5?= <jy0922.shim@samsung.com>,
        "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20110105004451019@myungjoo.ham
Msgkey: 20110105004451019@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20110105004451019@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <24564862.361211294188865120.JavaMail.weblogic@epml11>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p050saJe014521

On Tue, Jan 04, 2011 at 22:44PM +0900, Mark Brown wrote:
> On Tue, Jan 04, 2011 at 05:16:56PM +0900, MyungJoo Ham wrote:
> > On Tue, Jan 4, 2011 at 4:49 PM, Lukasz Majewski wrote:
> 
> > > Is it desirable to define all four for BUCK1 and two for BUCK2 DVS
> > > voltages in platform code?
> 
> > In case a system with 4 buck1 preset voltages and 2 buck2 preset
> > voltages, it is desirable. :)
> 
> I suspect Lukasz's question is more why this would be useful; I can
> imagine that the main reason would be performance and in any case I
> don't see it hurting to have the option.
>

Yes, it is supposed to be faster to set GPIO pins rather than sending values thru I2C busses. And some boards require all the four BUCK1 voltages and two BUCK2 voltages; e.g., S5PC110-Universal.

 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
