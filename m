Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab2EBBvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 21:51:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42378 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab2EBBvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 21:51:35 -0400
Date: Wed, 2 May 2012 09:51:26 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dong Aisheng <b29396@freescale.com>, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, kernel@pengutronix.de, s.hauer@pengutronix.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 4/4] mmc: sdhci-imx-esdhc: convert to use pinctrl
 subsystem
Message-ID: <20120502015124.GP2194@S2101-09.ap.freescale.net>
References: <1335529578-14507-1-git-send-email-b29396@freescale.com>
 <1335529578-14507-4-git-send-email-b29396@freescale.com>
 <CACRpkdbE=fFhTr=MyD-2dgV=W07Kb-T+ax4dgdjZ8ONzoz3K7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbE=fFhTr=MyD-2dgV=W07Kb-T+ax4dgdjZ8ONzoz3K7A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 01:12:58AM +0200, Linus Walleij wrote:
> If I cannot apply it there are two ways to proceed:
> 1. Wait for next merge window
> 2. Pull pinctrl into i.MX tree
> 
Yes, if we would not wait for next merge window, I prefer to ask Arnd,
Olof to pull pinctrl into arm-soc as a dependency and we convert imx
drivers to the subsystem in there.

BTW, this patch should be split into two.  Adding dummy pinctrl for
imx should be one patch, and sdhci-imx-esdhc should be separate one.
And we may want to come up a series to convert all outstanding imx
driver to use pinctrl API, one patch for one driver with subsystem
maintainer Cc on the corresponding driver patch.

-- 
Regards,
Shawn
