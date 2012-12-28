Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750971Ab2L1FRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 00:17:06 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:60464 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2L1FRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 00:17:00 -0500
Message-ID: <50DD2B34.9070905@linaro.org>
Date: Fri, 28 Dec 2012 10:46:36 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: patches@linaro.org, Chas Williams <chas@cmf.nrl.navy.mil>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: [PATCH 10/14] atm: Removed redundant check on unsigned variable
References: <1353048646-10935-1-git-send-email-tushar.behera@linaro.org> <1353048646-10935-11-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1353048646-10935-11-git-send-email-tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping.

On 11/16/2012 12:20 PM, Tushar Behera wrote:
> No need to check whether unsigned variable is less than 0.
> 
> CC: Chas Williams <chas@cmf.nrl.navy.mil>
> CC: linux-atm-general@lists.sourceforge.net
> CC: netdev@vger.kernel.org
> Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> ---
>  drivers/atm/fore200e.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
> index 361f5ae..fdd3fe7 100644
> --- a/drivers/atm/fore200e.c
> +++ b/drivers/atm/fore200e.c
> @@ -972,7 +972,7 @@ int bsq_audit(int where, struct host_bsq* bsq, int scheme, int magn)
>  		   where, scheme, magn, buffer->index, buffer->scheme);
>  	}
>  
> -	if ((buffer->index < 0) || (buffer->index >= fore200e_rx_buf_nbr[ scheme ][ magn ])) {
> +	if (buffer->index >= fore200e_rx_buf_nbr[ scheme ][ magn ]) {
>  	    printk(FORE200E "bsq_audit(%d): queue %d.%d, out of range buffer index = %ld !\n",
>  		   where, scheme, magn, buffer->index);
>  	}
> 


-- 
Tushar Behera
