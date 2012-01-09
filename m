Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2AIGVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 01:21:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46941 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2AIGVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 01:21:43 -0500
Date: Mon, 9 Jan 2012 14:32:12 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Richard Zhao <richard.zhao@linaro.org>, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, w.sang@pengutronix.de, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        shawn.guo@freescale.com, kernel@pengutronix.de, cjb@laptop.org,
        Dong Aisheng <b29396@freescale.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3 3/5] pinctrl: imx: add pinctrl imx driver
Message-ID: <20120109063136.GI1835@S2101-09.ap.freescale.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-4-git-send-email-b29396@freescale.com>
 <20120108130542.GC2203@richard-laptop>
 <20120109020848.GF1835@S2101-09.ap.freescale.net>
 <20120109021702.GV2414@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109021702.GV2414@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 10:17:03AM +0800, Richard Zhao wrote:
> On Mon, Jan 09, 2012 at 10:08:51AM +0800, Shawn Guo wrote:
> > On Sun, Jan 08, 2012 at 09:05:44PM +0800, Richard Zhao wrote:
> > > > +enum imx_imx53_pinctrl_pads {
> > > > +	MX53_GPIO_19 = 0,
> > > > +	MX53_KEY_COL0 = 1,
> > > > +	MX53_KEY_ROW0 = 2,
> > > > +	MX53_KEY_COL1 = 3,
> > > > +	MX53_KEY_ROW1 = 4,
> > > > +	MX53_KEY_COL2 = 5,
> > > > +	MX53_KEY_ROW2 = 6,
> > > ...
> > > Why not describe it in dts and make this file generic for imx?
> > > One node for one pad,
> > 
> > Doing this will bloat the device tree dramatically.  Actually I had
> > a patch doing so before the pinctrl subsystem was born, but it
> > concerned Grant a lot for that reason and thus died.
> are you against describing pad in dts or one node per pad?
> one node per pad is just a tip to extend pad property, to support
> other features (pinconf in your word).

I definitely want to describe pinconf in device tree, though what's
the best interface for pinctrl client driver to talk to pinconf is
still vague to me.

> > 
> > > it'll be easy to extend pad properties. You know
> > > the pad may set pull up/down, open drain, drive strenth, daisy chain etc.
> > > The features have to be supported, to make your model usefull.
> > > 
> > As Aisheng mentioned, the pinconf support will be added later.
> I expect pinconf come together, and get a ready-to-use patch series.
> 
As I was educated by Linus.W, we can not drink ocean and we need to
split big chunk of work into pieces and achieve it step by step.

-- 
Regards,
Shawn
