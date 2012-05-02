Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab2EBD2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 23:28:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52775 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758479Ab2EBD2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 23:28:20 -0400
Date: Wed, 2 May 2012 11:28:12 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <aisheng.dong@freescale.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
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
Message-ID: <20120502032810.GV2194@S2101-09.ap.freescale.net>
References: <1335529578-14507-1-git-send-email-b29396@freescale.com>
 <1335529578-14507-4-git-send-email-b29396@freescale.com>
 <CACRpkdbE=fFhTr=MyD-2dgV=W07Kb-T+ax4dgdjZ8ONzoz3K7A@mail.gmail.com>
 <20120502015124.GP2194@S2101-09.ap.freescale.net>
 <20120502032707.GA1708@shlinux2.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502032707.GA1708@shlinux2.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:27:08AM +0800, Dong Aisheng wrote:
> On Wed, May 02, 2012 at 09:51:26AM +0800, Shawn Guo wrote:
> > On Wed, May 02, 2012 at 01:12:58AM +0200, Linus Walleij wrote:
> > > If I cannot apply it there are two ways to proceed:
> > > 1. Wait for next merge window
> > > 2. Pull pinctrl into i.MX tree
> > > 
> > Yes, if we would not wait for next merge window, I prefer to ask Arnd,
> > Olof to pull pinctrl into arm-soc as a dependency and we convert imx
> > drivers to the subsystem in there.
> > 
> > BTW, this patch should be split into two.  Adding dummy pinctrl for
> > imx should be one patch, and sdhci-imx-esdhc should be separate one.
> > And we may want to come up a series to convert all outstanding imx
> > driver to use pinctrl API, one patch for one driver with subsystem
> > maintainer Cc on the corresponding driver patch.
> > 
> I can split it.
> One question is that will driver convert patch go via subsystem tree
> or soc tree?
> If adding dummy pinctrl for imx goes via soc tree but sdhci-imx-esdhc
> goes via mmc driver, the next one may break.
> 
I meant we have the whole series go through arm-soc tree with ack from
subsystem maintainers collected.

-- 
Regards,
Shawn
