Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934124Ab2J3SUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:20:18 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:40764 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759476Ab2J3SUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:20:13 -0400
Date: Tue, 30 Oct 2012 11:20:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Message-ID: <20121030182007.GA21851@core.coreip.homeip.net>
References: <20121025205901.GA3827@sirena.org.uk>
 <20121026062008.GA21734@arwen.pp.htv.fi>
 <20121026160316.GY18814@opensource.wolfsonmicro.com>
 <20121029194901.GA30152@arwen.pp.htv.fi>
 <20121030112410.GM4511@opensource.wolfsonmicro.com>
 <20121030114949.GC28722@arwen.pp.htv.fi>
 <20121030140714.GO4511@opensource.wolfsonmicro.com>
 <20121030151642.GE29159@arwen.pp.htv.fi>
 <20121030155821.GU4511@opensource.wolfsonmicro.com>
 <20121030172513.GA3993@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121030172513.GA3993@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 07:25:13PM +0200, Felipe Balbi wrote:
> On Tue, Oct 30, 2012 at 03:58:21PM +0000, Mark Brown wrote:
> > 
> > But then this comes round to the mindless code that ought to be factored
> > out :)  Only the more interesting cases that do something unusual really
> > register here.
> 
> fair enough. I see your point. Not saying I agree though, just that this
> discussion has been flying for far too long, so feel free to provide
> patches implementing what you're defending here ;-)
> 
> Guess code will speak for itself. On way or another, we need OMAP keypad
> driver working in mainline

Are you saying that introducing pincrtl infrastructure actually _broke_
the driver in mainline?

Thanks.

-- 
Dmitry
