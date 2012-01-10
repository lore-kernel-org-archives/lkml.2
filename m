Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab2AJNlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 08:41:15 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53809 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab2AJNlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 08:41:14 -0500
Date: Tue, 10 Jan 2012 21:51:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Richard Zhao <richard.zhao@freescale.com>,
        Richard Zhao <richard.zhao@linaro.org>, linus.walleij@stericsson.com,
        s.hauer@pengutronix.de, w.sang@pengutronix.de, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        shawn.guo@freescale.com, kernel@pengutronix.de, cjb@laptop.org,
        Dong Aisheng <b29396@freescale.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3 3/5] pinctrl: imx: add pinctrl imx driver
Message-ID: <20120110135147.GB26599@S2101-09.ap.freescale.net>
References: <1324402840-32451-1-git-send-email-b29396@freescale.com>
 <1324402840-32451-4-git-send-email-b29396@freescale.com>
 <20120108130542.GC2203@richard-laptop>
 <20120109020848.GF1835@S2101-09.ap.freescale.net>
 <20120109021702.GV2414@b20223-02.ap.freescale.net>
 <20120109063136.GI1835@S2101-09.ap.freescale.net>
 <20120110083842.GA2414@b20223-02.ap.freescale.net>
 <CACRpkdZ=G+=Aq49r9VYa1ZGMg=Sy3Dy3kHNbbcFRp-Hn6y1ZqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ=G+=Aq49r9VYa1ZGMg=Sy3Dy3kHNbbcFRp-Hn6y1ZqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 11:43:28AM +0100, Linus Walleij wrote:
> On Tue, Jan 10, 2012 at 9:38 AM, Richard Zhao
> <richard.zhao@freescale.com> wrote:
> > On Mon, Jan 09, 2012 at 02:32:12PM +0800, Shawn Guo wrote:
> >> As I was educated by Linus.W, we can not drink ocean and we need to
> >> split big chunk of work into pieces and achieve it step by step.
> > Sure, we can not drink out the ocean :). But if people can not use it
> > in real case, how do we verify the driver? How do we know the driver
> > goes in the right way?
> 
> If you prefer to do a big upfront design of the entire driver then please
> by all means do that.
> 
> What we need to know right now is what you need from the pin
> controller core to do that. We have a (custom) pinconf API now,
> does it fit the bill?
> 
Hmm, I do not think it fits right away, as I do not think it's sensible
to have pinctrl client drivers call pin_config_set() directly.

> I have spent some time on generic pin config, it was not much
> commented so if it helps you please ACK the patches.
> 
Since the ARM community is the one who is most interested in pinctrl
subsystem so far, I guess copying LAKML will help collect more comments
and various tags.  (For example, I'm interested in pinctrl, but I do
not track LKML as close as I do for LAKML).

> Next from discussions with Stpehen I've sort of figured out that
> we need a config mapping table of sorts and then a means to activate
> entries of that table at runtime. I'm trying to come up with something
> for this.
> 
That's something we are waiting for pinconf being usable for imx.

-- 
Regards,
Shawn
