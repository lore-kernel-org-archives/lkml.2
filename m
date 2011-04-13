Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805Ab1DMGWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 02:22:35 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:37498
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751126Ab1DMGWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 02:22:33 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 13 Apr 2011 14:26:06 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Chris Ball <cjb@laptop.org>
CC: Wolfram Sang <w.sang@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <linaro-dev@lists.linaro.org>, <patches@linaro.org>
Subject: Re: [PATCH 0/5] consolidate sdhci pltfm & OF drivers and get them
 self registered
Message-ID: <20110413062605.GA1310@S2100-06.ap.freescale.net>
References: <1301042931-4869-1-git-send-email-shawn.guo@linaro.org>
 <m38vvvz1p6.fsf@pullcord.laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <m38vvvz1p6.fsf@pullcord.laptop.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Thu, Mar 31, 2011 at 12:36:53PM -0400, Chris Ball wrote:
> Hi Wolfram,
> 
> On Fri, Mar 25 2011, Shawn Guo wrote:
> > Here are what the patch set does.
> >
> > * Remove .probe and .remove hooks from sdhci-pltfm.c and make it be
> >   a pure common helper function providers.
> > * Add .probe and .remove hooks for sdhci pltfm drivers sdhci-cns3xxx,
> >   sdhci-dove, sdhci-tegra, and sdhci-esdhc-imx to make them self
> >   registered with calling helper functions created above.
> > * Migrate the use of sdhci_of_host and sdhci_of_data to
> >   sdhci_pltfm_host and sdhci_pltfm_data, so that OF version host and
> >   data structure works can be saved, and pltfm version works for both
> >   cases.
> > * Add OF common helper stuff into sdhci-pltfm.c, and make OF version
> >   sdhci drivers sdhci-of-esdhc and sdhci-of-hlwd become self
> >   registered as well, so that sdhci-of-core.c and sdhci-of.h can be
> >   removed.
> > * Consolidate the OF and pltfm esdhc drivers into one with sharing
> >   the same pair of .probe and .remove hooks.  As a result,
> >   sdhci-esdhc-imx.c and sdhci-of-esdhc.c go away, while
> >   sdhci-esdhc.c comes in and works for both MPCxxx and i.MX.
> > * Eliminate include/linux/mmc/sdhci-pltfm.h with moving stuff into
> >   drivers/mmc/host/sdhci-pltfm.h.
> 
> If you get time, would appreciate getting an ACK from you on the patch
> changes (including Grant's review).  Thanks very much!
> 
Can you please take some time to help review?  I know you are on ELC
this week :)  What about next couple of weeks?

-- 
Regards,
Shawn

