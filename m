Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781Ab1DJUnZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 16:43:25 -0400
Received: from linode.aoot.com ([69.164.194.13]:59424 "EHLO linode.aoot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab1DJUnW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 16:43:22 -0400
X-Greylist: delayed 1822 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Apr 2011 16:43:22 EDT
Message-ID: <4DA20F4A.3040205@opengridcomputing.com>
Date: Sun, 10 Apr 2011 15:12:58 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: roel <roel.kluin@gmail.com>
CC: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] RDMA/cxgb4: missing parentheses
References: <4DA20964.6050806@gmail.com>
In-Reply-To: <4DA20964.6050806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Steve Wise <swise@opengridcomputing.com>

On 4/10/2011 2:47 PM, roel wrote:
> Parens are missing: '|' has a higher presedence than '?'.
>
> Signed-off-by: Roel Kluin<roel.kluin@gmail.com>
> ---
>   drivers/infiniband/hw/cxgb4/qp.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
> index 70a5a3c..80cab20 100644
> --- a/drivers/infiniband/hw/cxgb4/qp.c
> +++ b/drivers/infiniband/hw/cxgb4/qp.c
> @@ -214,7 +214,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
>   		V_FW_RI_RES_WR_HOSTFCMODE(0) |	/* no host cidx updates */
>   		V_FW_RI_RES_WR_CPRIO(0) |	/* don't keep in chip cache */
>   		V_FW_RI_RES_WR_PCIECHN(0) |	/* set by uP at ri_init time */
> -		t4_sq_onchip(&wq->sq) ? F_FW_RI_RES_WR_ONCHIP : 0 |
> +		(t4_sq_onchip(&wq->sq) ? F_FW_RI_RES_WR_ONCHIP : 0) |
>   		V_FW_RI_RES_WR_IQID(scq->cqid));
>   	res->u.sqrq.dcaen_to_eqsize = cpu_to_be32(
>   		V_FW_RI_RES_WR_DCAEN(0) |

