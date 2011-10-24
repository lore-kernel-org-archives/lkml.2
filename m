Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1JXJMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 05:12:13 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:41941
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753344Ab1JXJMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 05:12:12 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 24 Oct 2011 17:23:06 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rajendra Nayak <rnayak@ti.com>
CC: Grant Likely <grant.likely@secretlab.ca>, <patches@linaro.org>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <lrg@ti.com>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024092306.GC1755@S2100-06.ap.freescale.net>
References: <20111019144215.GA32007@S2100-06.ap.freescale.net>
 <4E9FAF42.5060200@ti.com>
 <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <4EA13053.7080306@ti.com>
 <20111021115809.GB337@S2100-06.ap.freescale.net>
 <4EA4FF6B.2080906@ti.com>
 <20111024081706.GC8708@ponder.secretlab.ca>
 <4EA5279E.3000505@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EA5279E.3000505@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 02:23:50PM +0530, Rajendra Nayak wrote:
> On Monday 24 October 2011 01:47 PM, Grant Likely wrote:
> >On Mon, Oct 24, 2011 at 11:32:19AM +0530, Rajendra Nayak wrote:
> >>On Friday 21 October 2011 05:28 PM, Shawn Guo wrote:
> >>>On Fri, Oct 21, 2011 at 02:11:55PM +0530, Rajendra Nayak wrote:
> >>>[...]
> >>>>>+       /* find device_node and attach it */
> >>>>>+       rdev->dev.of_node = of_find_node_by_name(NULL, regulator_desc->name);
> 
> Shawn/Mark,
> 
> How about the driver passing the of_node to be associated with the
> regulator, as part of regulator_desc, to the regulator core,
> instead of this complete DT search and the restriction of having
> to match DT node names with names in regulator_desc.
> 
If you agree that we should try to get DT core from creating
'struct dev' for each regulator, the of_node is not being attached
to any 'struct dev' in regulator driver either, so there is no
difference between finding the of_node in regulator driver and in
regulator core.

-- 
Regards,
Shawn

