Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab1GJWcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 18:32:41 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19929 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753791Ab1GJWck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 18:32:40 -0400
Date: Mon, 11 Jul 2011 00:32:38 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Edwin van Vliet <edwin@cheatah.nl>
cc: roland@kernel.org, mike.marciniszyn@qlogic.com, mitko@qlogic.com,
        ralph.campbell@qlogic.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/infiniband/hw/qib/qib_iba7322: remove double
 define
In-Reply-To: <1310334587-26731-1-git-send-email-edwin@cheatah.nl>
Message-ID: <alpine.LNX.2.00.1107110032300.2818@swampdragon.chaosbits.net>
References: <1310334587-26731-1-git-send-email-edwin@cheatah.nl>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jul 2011, Edwin van Vliet wrote:

> Double define removed.
> 
> Signed-off-by: Edwin van Vliet <edwin@cheatah.nl>
> ---
>  drivers/infiniband/hw/qib/qib_iba7322.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
> index 8ec5237..821226c 100644
> --- a/drivers/infiniband/hw/qib/qib_iba7322.c
> +++ b/drivers/infiniband/hw/qib/qib_iba7322.c
> @@ -397,7 +397,6 @@ MODULE_PARM_DESC(txselect, \
>  #define crp_txdroppedpkt CREG_IDX(TxDroppedPktCnt)
>  #define crp_txhdrerr CREG_IDX(TxHeadersErrCnt)
>  #define crp_txlenerr CREG_IDX(TxLenErrCnt)
> -#define crp_txlenerr CREG_IDX(TxLenErrCnt)
>  #define crp_txminmaxlenerr CREG_IDX(TxMaxMinLenErrCnt)
>  #define crp_txsdmadesc CREG_IDX(TxSDmaDescCnt)
>  #define crp_txunderrun CREG_IDX(TxUnderrunCnt)
> 
Reviewed-by: Jesper Juhl <jj@chaosbits.net>

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

