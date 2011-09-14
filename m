Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab1INPxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:53:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47138 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887Ab1INPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:53:51 -0400
Date: Wed, 14 Sep 2011 09:47:25 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] MAINTAINERS: update devicetree maintainers
Message-ID: <20110914154725.GC3134@ponder.secretlab.ca>
References: <1316004470-22643-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316004470-22643-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 07:47:50AM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> As requested by Grant, adding myself as an additional devicetree maintainer.
> 
> Also, add Documentation/devicetree to the file list for devicetree.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

Thanks for agreeing to help Rob!

> ---
>  MAINTAINERS |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1a8cc60..09754a6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4719,10 +4719,12 @@ F:	drivers/i2c/busses/i2c-ocores.c
>  
>  OPEN FIRMWARE AND FLATTENED DEVICE TREE
>  M:	Grant Likely <grant.likely@secretlab.ca>
> +M:	Rob Herring <rob.herring@calxeda.com>
>  L:	devicetree-discuss@lists.ozlabs.org (moderated for non-subscribers)
>  W:	http://fdt.secretlab.ca
>  T:	git git://git.secretlab.ca/git/linux-2.6.git
>  S:	Maintained
> +F:	Documentation/devicetree
>  F:	drivers/of
>  F:	include/linux/of*.h
>  K:	of_get_property
> -- 
> 1.7.5.4
> 
