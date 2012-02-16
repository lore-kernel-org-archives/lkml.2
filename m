Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2BPAxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 19:53:20 -0500
Received: from relmlor1.renesas.com ([210.160.252.171]:59722 "EHLO
	relmlor1.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab2BPAxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 19:53:17 -0500
X-IronPort-AV: E=Sophos;i="4.73,426,1325430000";   d="scan'208";a="68229243"
Message-id: <4F3C54A3.4000007@renesas.com>
Date: Thu, 16 Feb 2012 09:58:11 +0900
From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: "David S. Miller" <davem@davemloft.net>, Danny Kukawka <dkukawka@suse.de>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] renesas/sh_eth.c: fix linux/interrupt.h included twice
References: <1329328483-4682-1-git-send-email-danny.kukawka@bisect.de>
In-reply-to: <1329328483-4682-1-git-send-email-danny.kukawka@bisect.de>
Content-type: text/plain; charset=ISO-2022-JP
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Danny Kukawka さんは書きました:
> Remove double include of linux/interrupt.h.
> 
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/net/ethernet/renesas/sh_eth.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
> index 87b6501..59524f1 100644
> --- a/drivers/net/ethernet/renesas/sh_eth.c
> +++ b/drivers/net/ethernet/renesas/sh_eth.c
> @@ -34,7 +34,6 @@
>  #include <linux/phy.h>
>  #include <linux/cache.h>
>  #include <linux/io.h>
> -#include <linux/interrupt.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  #include <linux/ethtool.h>

Acked-by: Nobuhiro Iwamatsu <Nobuhiro.iwamatsu.yj@renesas.com>

Nobuhiro
