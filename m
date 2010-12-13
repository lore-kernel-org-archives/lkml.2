Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188Ab0LMQhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:37:23 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:33877 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929Ab0LMQhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:37:22 -0500
From: "Olaya, Margarita" <magi.olaya@ti.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Tejun Heo <tj@kernel.org>, Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jaroslav Kysela <perex@perex.cz>
Date: Mon, 13 Dec 2010 10:36:22 -0600
Subject: RE: [PATCH 09/30] sound: don't use flush_scheduled_work()
Thread-Topic: [PATCH 09/30] sound: don't use flush_scheduled_work()
Thread-Index: AcuayjN3inyPGgQSQuKjGWsgk2iBLwAGW+yQ
Message-ID: <1889FA7136B567478A67D4B0F85B0CCEA4E22A06@dlee06.ent.ti.com>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
	 <1292086307-19211-10-git-send-email-tj@kernel.org>
	 <s5hk4jfbc94.wl%tiwai@suse.de> <4D0492CB.2010702@kernel.org>
	 <s5hhbejb1yr.wl%tiwai@suse.de>
	 <20101212124041.GD15189@opensource.wolfsonmicro.com>
	 <4D04F211.6080602@kernel.org>
	 <20101212184733.GB20358@opensource.wolfsonmicro.com>
	 <4D05195A.8070107@kernel.org>
	 <20101212190035.GA21207@opensource.wolfsonmicro.com>
 <1292247149.3320.64.camel@odin>
In-Reply-To: <1292247149.3320.64.camel@odin>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oBDGbVUc001381

Hi Liam, 

> -----Original Message-----
> From: Liam Girdwood [mailto:lrg@slimlogic.co.uk] 
> Sent: Monday, December 13, 2010 7:32 AM
> To: Mark Brown; Olaya, Margarita
> Cc: Tejun Heo; Takashi Iwai; linux-kernel@vger.kernel.org; 
> Jaroslav Kysela
> Subject: Re: [PATCH 09/30] sound: don't use flush_scheduled_work()
> 
> On Sun, 2010-12-12 at 19:00 +0000, Mark Brown wrote:
> > On Sun, Dec 12, 2010 at 07:50:02PM +0100, Tejun Heo wrote:
> > 
> > > > For future reference please note that sound/soc is 
> maintained as a
> > > > subtree of ALSA - if you could send patches to that 
> separately to myself
> > > > and Liam as well as Takashi and Jaroslav that'd make 
> life a little
> > > > easier.
> > 
> > > I can resplit and resend if necessary.  Takashi, do you 
> wanna take the
> > > patch as-is or resplit?  Or shall I route it through wq tree?
> > 
> > No need, just merge it along with the rest of the patch 
> however that's
> > going.  I was mentioning this for future reference rather 
> than for the
> > present patch.
> > 
> > Liam, will the TWL6040 updates Magi posted the other day also be
> > affected?  I seem to remember they added the same pattern 
> as WM835x has.
> 
> Not sure myself.
> 
> Magi, could you check your patch queue for any use of
> flush_scheduled_work() here ?

flush_scheduled_work() is not being used in TWL6040 patches.

Regards,
Margarita

> 
> Thanks
> 
> Liam
> -- 
> Freelance Developer, SlimLogic Ltd
> ASoC and Voltage Regulator Maintainer.
> http://www.slimlogic.co.uk
> 
> ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
