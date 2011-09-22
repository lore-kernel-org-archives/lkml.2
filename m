Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1IVGne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:43:34 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:19855
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609Ab1IVGn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:43:26 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275ch8275dhz2dh2a8h668h839h944h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Thu, 22 Sep 2011 14:53:08 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] dt: add of_alias_scan and of_alias_get_id
Message-ID: <20110922065307.GB27978@S2100-06.ap.freescale.net>
References: <20110921204545.19871.99088.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110921204545.19871.99088.stgit@ponder>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 02:46:54PM -0600, Grant Likely wrote:
> From: Shawn Guo <shawn.guo@linaro.org>
> 
> The patch adds function of_alias_scan to populate a global lookup
> table with the properties of 'aliases' node and function
> of_alias_get_id for drivers to find alias id from the lookup table.
> 
> v3: Split out automatic addition of aliases on id lookup so that it can be
>     debated separately from the core functionality.
> v2: - Add of_chosen/of_aliases populating and of_alias_scan() invocation
>     for OF_PROMTREE.
>     - Add locking
>     - rework parse loop
> 
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

On imx serial driver:

Tested-by: Shawn Guo <shawn.guo@linaro.org>

Hi Grant,

I just posted a patch to have of_alias_get_id() back for imx serial
driver with replying to this one.  Can you please merge it to through
your tree as well?

-- 
Regards,
Shawn

