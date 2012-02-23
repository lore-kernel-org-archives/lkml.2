Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2BWDk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 22:40:27 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:44746 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753377Ab2BWDkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 22:40:23 -0500
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 23 Feb 2012 11:48:06 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@nvidia.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 11/20] pinctrl: Downgrade pinctrl_get warning when no
 maps are found
Message-ID: <20120223034805.GB9141@shlinux2.ap.freescale.net>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-12-git-send-email-swarren@nvidia.com>
 <CACRpkdbpBZqUUwxwF8o8P1P9yknY7SRSzGmYsa3kQ1JH=QNJ7A@mail.gmail.com>
 <20120222065647.GE11087@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC66B@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC66B@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 09:21:25AM -0800, Stephen Warren wrote:
...
> > I'm afraid this is a little error-prone, that means even we specifed
> > the wrong map name or state name, the pinctrl_get still does not get
> > failed and it is a little different as what we want in this patch.
> 
> Yes, this does open up a small opportunity for an undetected error at
> this stage in the patch series.
> 
> However, this is closed later by the final patch that enhances the mapping
> table to represent pin config data, and "dummy" states.
> 
> I wrote/posted this patch to highlight that this code should be checking
> for non-existent states, rather than states which match no mapping table
> entries. Admittedly, there's no way to represent the difference at this
> point in the patch series. Once the final patch is applied, there's an
> explicit way to represent a state that exists, but has no mapping table
> entries, so the opportunity for error then no longer exists.
>
Ok, it's good.
Will see your final patch for this issue.

Regards
Dong Aisheng

