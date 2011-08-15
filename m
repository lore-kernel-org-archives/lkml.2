Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1HOGAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 02:00:17 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:30389
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881Ab1HOGAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 02:00:14 -0400
X-SpamScore: -14
X-BigFish: VS-14(zz1432N14e3M98dKzz1202hzz8275dhz2dh2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Mon, 15 Aug 2011 14:07:09 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: David Miller <davem@davemloft.net>
CC: <shawn.guo@linaro.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <patches@linaro.org>
Subject: Re: [PATCH] dt: add of_alias_scan and of_alias_get_id
Message-ID: <20110815060708.GH7244@S2100-06.ap.freescale.net>
References: <1313371817-5135-1-git-send-email-shawn.guo@linaro.org>
 <20110814.224341.2228974983062837890.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110814.224341.2228974983062837890.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, Aug 14, 2011 at 10:43:41PM -0700, David Miller wrote:
> From: Shawn Guo <shawn.guo@linaro.org>
> Date: Mon, 15 Aug 2011 09:30:17 +0800
> 
> >  	*allnextp = NULL;
> >  
> > +	/* Get pointer to "/chosen" and "/aliasas" nodes for use everywhere */
> > +	of_chosen = of_find_node_by_path("/chosen");
> > +	if (of_chosen == NULL)
> > +		of_chosen = of_find_node_by_path("/chosen@0");
> > +	of_aliases = of_find_node_by_path("/aliases");
> > +	of_alias_scan(dt_alloc);
> > +
> >  	pr_debug(" <- unflatten_device_tree()\n");
> >  }
> 
> You need to add invocations of the scan to other places in the
> tree that build the in-kernel device tree.

Can you please help me a little bit more with the "other places"?
I'm still pretty new to device tree beyond ARM platform.

-- 
Regards,
Shawn

