Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab2CATFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:05:40 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:47608 "EHLO violet"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964801Ab2CATFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:05:37 -0500
Date: Thu, 1 Mar 2012 20:05:10 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Cloud Ren <cjren@qca.qualcomm.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com
Subject: Re: [PATCH 3/3] atl1c: refine driver description
Message-ID: <20120301190510.GA12450@electric-eye.fr.zoreil.com>
References: <1330580469-23348-1-git-send-email-cjren@qca.qualcomm.com> <1330580469-23348-4-git-send-email-cjren@qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330580469-23348-4-git-send-email-cjren@qca.qualcomm.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cloud Ren <cjren@qca.qualcomm.com> :
[...]
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 815f683..1d5218a 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -22,6 +22,9 @@
>  #include "atl1c.h"
>  
>  char atl1c_driver_name[] = "atl1c";
> +static const char atl1c_drv_description[] =
> +	"Qualcomm Atheros(R) AR813x/AR815x PCI-E Ethernet Network Driver";
> +

Missing __initdata

Btw you can remove cards_found and the bd_number field.

-- 
Ueimor
