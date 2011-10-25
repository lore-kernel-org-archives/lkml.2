Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab1JYE4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 00:56:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64912 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1JYE4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 00:56:07 -0400
Date: Tue, 25 Oct 2011 06:56:02 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Kyle Moffett <Kyle.D.Moffett@boeing.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [RFC PATCH 02/17] of_mdio: Don't phy_scan_fixups() twice
Message-ID: <20111025045602.GB798@ponder.secretlab.ca>
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <1319144425-15547-3-git-send-email-Kyle.D.Moffett@boeing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319144425-15547-3-git-send-email-Kyle.D.Moffett@boeing.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 05:00:09PM -0400, Kyle Moffett wrote:
> The "phy_device_register()" call 5 lines down already calls
> phy_scan_fixups(), there's no need to do it a second time.
> 
> Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>

Applied, thanks.

g.

> ---
>  drivers/of/of_mdio.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
> index d35e300..980c079 100644
> --- a/drivers/of/of_mdio.c
> +++ b/drivers/of/of_mdio.c
> @@ -83,7 +83,6 @@ int of_mdiobus_register(struct mii_bus *mdio, struct device_node *np)
>  				addr);
>  			continue;
>  		}
> -		phy_scan_fixups(phy);
>  
>  		/* Associate the OF node with the device structure so it
>  		 * can be looked up later */
> -- 
> 1.7.2.5
> 
