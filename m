Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab0KONaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 08:30:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754535Ab0KONaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 08:30:18 -0500
Date: Mon, 15 Nov 2010 14:30:14 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Steve Wise <swise@chelsio.com>, Roland Dreier <rolandd@cisco.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Subject: Re: [PATCH][trivial] infiniband: Only include linux/mutex.h once in
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h .
In-Reply-To: <alpine.LNX.2.00.1011072321150.26247@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1011151429480.7420@pobox.suse.cz>
References: <alpine.LNX.2.00.1011072321150.26247@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Nov 2010, Jesper Juhl wrote:

> Only include the header linux/mutex.h once inside 
> drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  iw_cxgb4.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> index 16032cd..42bb575 100644
> --- a/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> +++ b/drivers/infiniband/hw/cxgb4/iw_cxgb4.h
> @@ -46,7 +46,6 @@
>  #include <linux/timer.h>
>  #include <linux/io.h>
>  #include <linux/kfifo.h>
> -#include <linux/mutex.h>

The double include seems to be present in linux-next as of today. So I 
have picked the patch up. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
