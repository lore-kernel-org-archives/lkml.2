Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab2AICRQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 21:17:16 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:31033 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755142Ab2AICRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 21:17:15 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 9 Jan 2012 10:17:03 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Richard Zhao <richard.zhao@linaro.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <w.sang@pengutronix.de>,
        <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>, <shawn.guo@freescale.com>,
        <kernel@pengutronix.de>, <cjb@laptop.org>,
        Dong Aisheng <b29396@freescale.com>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH v3 3/5] pinctrl: imx: add pinctrl imx driver
Message-ID: <20120109021702.GV2414@b20223-02.ap.freescale.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-4-git-send-email-b29396@freescale.com>
 <20120108130542.GC2203@richard-laptop>
 <20120109020848.GF1835@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120109020848.GF1835@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:08:51AM +0800, Shawn Guo wrote:
> On Sun, Jan 08, 2012 at 09:05:44PM +0800, Richard Zhao wrote:
> > > +enum imx_imx53_pinctrl_pads {
> > > +	MX53_GPIO_19 = 0,
> > > +	MX53_KEY_COL0 = 1,
> > > +	MX53_KEY_ROW0 = 2,
> > > +	MX53_KEY_COL1 = 3,
> > > +	MX53_KEY_ROW1 = 4,
> > > +	MX53_KEY_COL2 = 5,
> > > +	MX53_KEY_ROW2 = 6,
> > ...
> > Why not describe it in dts and make this file generic for imx?
> > One node for one pad,
> 
> Doing this will bloat the device tree dramatically.  Actually I had
> a patch doing so before the pinctrl subsystem was born, but it
> concerned Grant a lot for that reason and thus died.
are you against describing pad in dts or one node per pad?
one node per pad is just a tip to extend pad property, to support
other features (pinconf in your word).
> 
> > it'll be easy to extend pad properties. You know
> > the pad may set pull up/down, open drain, drive strenth, daisy chain etc.
> > The features have to be supported, to make your model usefull.
> > 
> As Aisheng mentioned, the pinconf support will be added later.
I expect pinconf come together, and get a ready-to-use patch series.

Thanks
Richard
> 
> -- 
> Regards,
> Shawn
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

