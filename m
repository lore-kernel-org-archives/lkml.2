Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab2KUJII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:08:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47409 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2KUJIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:08:05 -0500
Date: Wed, 21 Nov 2012 12:07:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johan Meiring <johanmeiring@gmail.com>
Cc: gregkh@linuxfoundation.org, a.beregalov@gmail.com, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] staging: cxt1e1: musycc.c: fixes placement of
 parentheses
Message-ID: <20121121090749.GF11248@mwanda>
References: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
 <1353432532-21203-6-git-send-email-johanmeiring@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353432532-21203-6-git-send-email-johanmeiring@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 07:28:48PM +0200, Johan Meiring wrote:
> This commit fixes several incorrect placements of parantheses, as
> identified by the checkpatch.pl tool.
> 

This patch is fine, and all.
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>

But you could go beyond fixing just checkpatch.pl warnings.

> Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
> ---
>  drivers/staging/cxt1e1/musycc.c |  490 +++++++++++++++++++--------------------
>  1 file changed, 245 insertions(+), 245 deletions(-)
> 
> diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
> index 42e1ca4..b2cc68a 100644
> --- a/drivers/staging/cxt1e1/musycc.c
> +++ b/drivers/staging/cxt1e1/musycc.c
> @@ -60,21 +60,21 @@ extern ci_t *CI;                /* dummy pointr to board ZEROE's data - DEBUG
>  
>  /*******************************************************************/

This line could be deleted.

>  /* forward references */

Obvious comment is obvious.

> -void        c4_fifo_free (mpi_t *, int);
> -void        c4_wk_chan_restart (mch_t *);
> -void        musycc_bh_tx_eom (mpi_t *, int);
> -int         musycc_chan_up (ci_t *, int);
> -status_t __init musycc_init (ci_t *);
> -STATIC void __init musycc_init_port (mpi_t *);
> -void        musycc_intr_bh_tasklet (ci_t *);
> -void        musycc_serv_req (mpi_t *, u_int32_t);
> -void        musycc_update_timeslots (mpi_t *);
> +void        c4_fifo_free(mpi_t *, int);
> +void        c4_wk_chan_restart(mch_t *);
> +void        musycc_bh_tx_eom(mpi_t *, int);
> +int         musycc_chan_up(ci_t *, int);
> +status_t __init musycc_init(ci_t *);
> +STATIC void __init musycc_init_port(mpi_t *);
> +void        musycc_intr_bh_tasklet(ci_t *);
> +void        musycc_serv_req(mpi_t *, u_int32_t);
> +void        musycc_update_timeslots(mpi_t *);


These would look better done properly.

void musycc_serv_req(mpi_t *pi, u_int32_t req);

Keep the parameter names because they serve as documentation.  And
actually, they should be moved to a header file which is included
instead of declared in the .c files where they are used.

regards,
dan carpenter

