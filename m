Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab1LELsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 06:48:45 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:47019 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756115Ab1LELsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 06:48:43 -0500
Date: Mon, 5 Dec 2011 11:48:38 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jamie Iles <jamie@jamieiles.com>, robherring2@gmail.com,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/macb: add DT support
Message-ID: <20111205114838.GC21006@totoro>
References: <20111202153832.GA4998@totoro>
 <1322846050-4543-1-git-send-email-nicolas.ferre@atmel.com>
 <20111202172854.GB4998@totoro>
 <4ED910B6.7080000@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED910B6.7080000@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 06:53:58PM +0100, Nicolas Ferre wrote:
> On 12/02/2011 06:28 PM, Jamie Iles :
[...]
> >diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> >index 103c6e6..89060e6 100644
> >--- a/drivers/net/ethernet/cadence/macb.c
> >+++ b/drivers/net/ethernet/cadence/macb.c
> >@@ -1247,6 +1247,8 @@ static const struct of_device_id macb_dt_ids[] = {
> >  	{ .compatible = "cdns,at32ap7000-macb" },
> >  	{ .compatible = "cdns,at91sam9260-macb" },
> >  	{ .compatible = "cdns,macb" },
> >+	{ .compatible = "cdns,pc302-gem" },
> >+	{ .compatible = "cdns,gem" },
> >  	{ /* sentinel */ }
> >  };
> 
> BTW, I think we may also modify the MII/RMII selection code for
> adding gigabit selection... but maybe you already have the patches?

No, I don't have access to a version of the GEM with gigabit support.  
The platforms I was working on used it as a 10/100 controller, but had 
to use the GEM to get hardware timestamping support.

Jamie
