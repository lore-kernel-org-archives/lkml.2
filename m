Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab2DXJFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 05:05:05 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:34353
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754543Ab2DXJFC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 05:05:02 -0400
X-SpamScore: -17
X-BigFish: VS-17(zcb8kz9371I154dM1432N98dK1447Mzz1202hzz8275bh8275dhz2dh2a8h668h839hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 24 Apr 2012 17:15:04 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dong Aisheng <b29396@freescale.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, <linux-kernel@vger.kernel.org>,
        <linus.walleij@stericsson.com>, <devicetree-discuss@lists.ozlabs.org>,
        <rob.herring@calxeda.com>, <linux-arm-kernel@lists.infradead.org>,
        <kernel@pengutronix.de>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v2 3/3] ARM: imx6q: switch to use pinctrl driver
Message-ID: <20120424091504.GC32166@shlinux2.ap.freescale.net>
References: <1334933916-12971-1-git-send-email-b29396@freescale.com>
 <1334933916-12971-3-git-send-email-b29396@freescale.com>
 <CACRpkdbbdkhN-hVF6vP4j6bP-Nsdft5UjjpAVhcKn6KSpEbcuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CACRpkdbbdkhN-hVF6vP4j6bP-Nsdft5UjjpAVhcKn6KSpEbcuQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Apr 24, 2012 at 10:56:43AM +0200, Linus Walleij wrote:
> On Fri, Apr 20, 2012 at 4:58 PM, Dong Aisheng <b29396@freescale.com> wrote:
> 
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> >
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> >
> > ---
> > This is not a formal patch and is only used for test
> > since before the pinctrl core handle dummy state is in,
> > enable pinctrl in driver will break other platforms.
> >
> > ChangeLog v1->v2:
> > * using updated binding
> > ---
> >  arch/arm/boot/dts/imx6q-arm2.dts   |    2 ++
> >  arch/arm/boot/dts/imx6q.dtsi       |   17 +++++++++++++++++
> >  arch/arm/mach-imx/Kconfig          |    2 ++
> >  drivers/mmc/host/sdhci-esdhc-imx.c |   12 ++++++++++++
> >  4 files changed, 33 insertions(+), 0 deletions(-)
> 
> Since this touches the MMC driver I'd like an ACK from the
> maintainer, but no maintainer is set for this subdriver, still
> it feels like Sascha and/or Wolfram should be involved.
> 
This is for test.
Before the pinctrl dummy state patch got in first, we can not get
it in since it will break other platforms not support pinctrl to
use this driver.
I will send a formal patch after dummy state patch is in.

Thanks for the review.

Regards
Dong Aisheng

