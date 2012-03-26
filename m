Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab2CZN1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 09:27:35 -0400
Received: from mxout1.idt.com ([157.165.5.25]:33560 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756465Ab2CZN1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 09:27:20 -0400
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: Vinod Koul <vinod.koul@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Fabio Estevam <festevam@gmail.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "samuel@sortiz.org" <samuel@sortiz.org>, "lrg@ti.com" <lrg@ti.com>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH linux-next] dmaengine: add context parameter fixups
Thread-Topic: [PATCH linux-next] dmaengine: add context parameter fixups
Thread-Index: AQHNCP2GFmjVJqLCs0CAsUAPMAdjTZZ6B1+AgAKASACAAEUZgIAAA30A//+7GxA=
Date: Mon, 26 Mar 2012 13:14:09 +0000
Message-ID: <8D983423E7EDF846BB3056827B8CC5D101384B@corpmail1.na.ads.idt.com>
References: <1332511242-30241-1-git-send-email-alexandre.bounine@idt.com>
	 <CAOMZO5B-Zutv-xwqLCAgNMO8A3Kyg4uWqS41koo-yoS4mGB1TQ@mail.gmail.com>
	 <1332740082.19804.15.camel@vkoul-udesk3>
	 <20120326094200.GA3098@opensource.wolfsonmicro.com>
 <1332755670.19804.91.camel@vkoul-udesk3>
In-Reply-To: <1332755670.19804.91.camel@vkoul-udesk3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.165.140.50]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2QDRqjE014597

On Mon, March 26, 2012 at 5:55 AM, Vinod Koul wrote:
> Subject: Re: [PATCH linux-next] dmaengine: add context parameter fixups
> 
> On Mon, 2012-03-26 at 10:42 +0100, Mark Brown wrote:
> > On Mon, Mar 26, 2012 at 11:04:42AM +0530, Vinod Koul wrote:
> > > On Sat, 2012-03-24 at 12:23 -0300, Fabio Estevam wrote:
> >
> > > > http://permalink.gmane.org/gmane.linux.alsa.devel/96215
> >
> > > And this seems to be linux-next.
> >
> > > Mark, Is this part of the sound updates that went to Linus?
> >
> > No, not yet - it was only sent after the merge window.  Quite why
> nobody
> > managed to notice it before then I don't know.  It'll go to him soon,
> or
> > at least to Takashi, but don't know if it'll make -rc1 or not.
> I should have noticed that sound needs update as well  :(
> 
> Now either I drop these from 3.4 or merge Linus's tree and apply
> Alexandre's fix (as that is the right fix rather than one in asoc tree)
> And since this was required for RIO patches which are still WIP, I
> think
> I am leaning towards former.
> 

I do not see any sense in dropping these API changes now.
Some audio files have been missed form the original patch because I did
not have them in the code tree when patch was built.
For those who was not in the list for original patches here is a link to
the patch details: https://lkml.org/lkml/2012/3/8/373

If we drop the API changes now we will need redo these changes again later.
We already dragged these changes long enough since original discussion in October.
I will send new inline wrapper for RapidIO today. 

Alex.


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
