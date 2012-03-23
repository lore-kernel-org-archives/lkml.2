Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab2CWEmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:42:05 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:1613 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751025Ab2CWEmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:42:03 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275dhz2dh2a8h668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Fri, 23 Mar 2012 12:53:20 +0800
From: Dong Aisheng <aisheng.dong@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
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
Subject: Re: [PATCH V3 5/6] dt: Document Tegra20/30 pinctrl binding
Message-ID: <20120323045319.GB23958@shlinux2.ap.freescale.net>
References: <1332440842-1098-1-git-send-email-swarren@wwwdotorg.org>
 <1332440842-1098-5-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1332440842-1098-5-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 02:27:21AM +0800, Stephen Warren wrote:
> Define a new binding for the Tegra pin controller, which is capable of
> defining all aspects of desired pin multiplexing and pin configuration.
> This is all based on the new common pinctrl bindings.
> 
> Add Tegra30 binding based on Tegra20 binding.
> 
> Add some basic stuff that was missing before:
> * How many and what reg property entries must be provided.
> * An example.
> 
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> v3: Fix typo in Tegra20 binding example
> ---
Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Regards
Dong Aisheng


