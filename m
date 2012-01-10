Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab2AJIiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 03:38:55 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:34287
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382Ab2AJIiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 03:38:54 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dhc1ahc1bh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Tue, 10 Jan 2012 16:38:43 +0800
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
Message-ID: <20120110083842.GA2414@b20223-02.ap.freescale.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-4-git-send-email-b29396@freescale.com>
 <20120108130542.GC2203@richard-laptop>
 <20120109020848.GF1835@S2101-09.ap.freescale.net>
 <20120109021702.GV2414@b20223-02.ap.freescale.net>
 <20120109063136.GI1835@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120109063136.GI1835@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 02:32:12PM +0800, Shawn Guo wrote:
> On Mon, Jan 09, 2012 at 10:17:03AM +0800, Richard Zhao wrote:
> > On Mon, Jan 09, 2012 at 10:08:51AM +0800, Shawn Guo wrote:
> > > On Sun, Jan 08, 2012 at 09:05:44PM +0800, Richard Zhao wrote:
> > > > > +enum imx_imx53_pinctrl_pads {
> > > > > +	MX53_GPIO_19 = 0,
> > > > > +	MX53_KEY_COL0 = 1,
> > > > > +	MX53_KEY_ROW0 = 2,
> > > > > +	MX53_KEY_COL1 = 3,
> > > > > +	MX53_KEY_ROW1 = 4,
> > > > > +	MX53_KEY_COL2 = 5,
> > > > > +	MX53_KEY_ROW2 = 6,
> > > > ...
> > > > Why not describe it in dts and make this file generic for imx?
> > > > One node for one pad,
> > > 
> > > Doing this will bloat the device tree dramatically.  Actually I had
> > > a patch doing so before the pinctrl subsystem was born, but it
> > > concerned Grant a lot for that reason and thus died.
> > are you against describing pad in dts or one node per pad?
> > one node per pad is just a tip to extend pad property, to support
> > other features (pinconf in your word).
> 
> I definitely want to describe pinconf in device tree, though what's
> the best interface for pinctrl client driver to talk to pinconf is
> still vague to me.
> 
> > > 
> > > > it'll be easy to extend pad properties. You know
> > > > the pad may set pull up/down, open drain, drive strenth, daisy chain etc.
> > > > The features have to be supported, to make your model usefull.
> > > > 
> > > As Aisheng mentioned, the pinconf support will be added later.
> > I expect pinconf come together, and get a ready-to-use patch series.
> > 
> As I was educated by Linus.W, we can not drink ocean and we need to
> split big chunk of work into pieces and achieve it step by step.
Sure, we can not drink out the ocean :). But if people can not use it
in real case, how do we verify the driver? How do we know the driver
goes in the right way?

Thanks
Richard
> 
> -- 
> Regards,
> Shawn
> 

