Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab2CZHOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 03:14:35 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:34733
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105Ab2CZHOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 03:14:33 -0400
X-SpamScore: -10
X-BigFish: VS-10(zz9371I1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 26 Mar 2012 15:25:37 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "sjg@chromium.org" <sjg@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V4] pinctrl: core device tree mapping table parsing
 support
Message-ID: <20120326072536.GE23958@shlinux2.ap.freescale.net>
References: <1332520186-23476-1-git-send-email-swarren@wwwdotorg.org>
 <CACRpkdb1cp+A-b0hKUVyT_03hiLNTHm1qb=8xMUn-wk=UijO3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACRpkdb1cp+A-b0hKUVyT_03hiLNTHm1qb=8xMUn-wk=UijO3g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 03:00:12PM +0800, Linus Walleij wrote:
> On Fri, Mar 23, 2012 at 5:29 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
> > During pinctrl_get(), if the client device has a device tree node, look
> > for the common pinctrl properties there. If found, parse the referenced
> > device tree nodes, with the help of the pinctrl drivers, and generate
> > mapping table entries from them.
> >
> > During pinctrl_put(), free any results of device tree parsing.
> >
> > Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> 
> I really like this patch, nice clean and right to the point.
> 
> Can I have some more ACKs on it?
> 
> If no response in a day or two I'll apply it anyway just because
> I like it.
> 
Sorry for late.
I like it too.

Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng

