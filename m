Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab2EBDSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:18:51 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:34716
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758602Ab2EBDSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:18:49 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 2 May 2012 11:27:08 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 4/4] mmc: sdhci-imx-esdhc: convert to use pinctrl
 subsystem
Message-ID: <20120502032707.GA1708@shlinux2.ap.freescale.net>
References: <1335529578-14507-1-git-send-email-b29396@freescale.com>
 <1335529578-14507-4-git-send-email-b29396@freescale.com>
 <CACRpkdbE=fFhTr=MyD-2dgV=W07Kb-T+ax4dgdjZ8ONzoz3K7A@mail.gmail.com>
 <20120502015124.GP2194@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120502015124.GP2194@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 09:51:26AM +0800, Shawn Guo wrote:
> On Wed, May 02, 2012 at 01:12:58AM +0200, Linus Walleij wrote:
> > If I cannot apply it there are two ways to proceed:
> > 1. Wait for next merge window
> > 2. Pull pinctrl into i.MX tree
> > 
> Yes, if we would not wait for next merge window, I prefer to ask Arnd,
> Olof to pull pinctrl into arm-soc as a dependency and we convert imx
> drivers to the subsystem in there.
> 
> BTW, this patch should be split into two.  Adding dummy pinctrl for
> imx should be one patch, and sdhci-imx-esdhc should be separate one.
> And we may want to come up a series to convert all outstanding imx
> driver to use pinctrl API, one patch for one driver with subsystem
> maintainer Cc on the corresponding driver patch.
> 
I can split it.
One question is that will driver convert patch go via subsystem tree
or soc tree?
If adding dummy pinctrl for imx goes via soc tree but sdhci-imx-esdhc
goes via mmc driver, the next one may break.

Regards
Dong Aisheng

