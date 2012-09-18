Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab2IRB7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 21:59:07 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:36476
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753939Ab2IRB7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 21:59:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1202h1d1ah1d2ah1082kzz8275dhz2dh2a8h668h839h944hd25hf0ah107ah1220h1288h12a5h12a9h12bdh1155h)
Date: Tue, 18 Sep 2012 09:33:34 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH v6 0/4] add syscon driver based on regmap for general
 registers access
Message-ID: <20120918013333.GB13226@shlinux2.ap.freescale.net>
References: <1346813836-28736-1-git-send-email-b29396@freescale.com>
 <20120905055410.GZ2362@S2101-09.ap.freescale.net>
 <20120917101028.GA13226@shlinux2.ap.freescale.net>
 <20120917133054.GT3647@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120917133054.GT3647@sortiz-mobl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 09:30:54PM +0800, Samuel Ortiz wrote:
> Hi Dong,
> 
> On Mon, Sep 17, 2012 at 06:10:29PM +0800, Dong Aisheng wrote:
> > Hi Samuel,
> > 
> > On Wed, Sep 05, 2012 at 01:54:12PM +0800, Shawn Guo wrote:
> > > Hi Samuel,
> > > 
> > > The series needs to go via mfd or arm-soc tree as a whole.  In case
> > > you want to take it through mfd tree, here is my ack.
> > > 
> > > Acked-by: Shawn Guo <shawn.guo@linaro.org>
> > > 
> > > Otherwise, I can take it via arm-soc tree with your ack.
> > > 
> > Ping...
> All 4 patches applied to my for-next branch. Sorry for the delay.
> 
Thanks.

Regards
Dong Aisheng

