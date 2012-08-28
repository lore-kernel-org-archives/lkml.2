Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab2H1FyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 01:54:21 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20872 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834Ab2H1FyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 01:54:20 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zcb8kz98dI1432Izz1202h1082kzzz2dh2a8h668h839h944hd25hf0ah107ah)
Date: Tue, 28 Aug 2012 13:33:37 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Zhao Richard-B20223 <B20223@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH v2 5/7] ARM: imx6q: convert to use syscon to access
 anatop registers
Message-ID: <20120828053336.GF5822@shlinux2.ap.freescale.net>
References: <1346052285-4344-1-git-send-email-b29396@freescale.com>
 <1346052285-4344-6-git-send-email-b29396@freescale.com>
 <20120828032309.GW4011@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120828032309.GW4011@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 11:23:10AM +0800, Zhao Richard-B20223 wrote:
...
> >  	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-anatop");
> np unused.

Correct.
Will drop it.

Regards
Dong Aisheng

