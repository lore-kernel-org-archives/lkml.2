Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab1I2XyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 19:54:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34686 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab1I2XyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 19:54:20 -0400
Date: Thu, 29 Sep 2011 16:54:17 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>, scameron@beardog.cce.hp.com,
        thenzel@redhat.com
Subject: Re: PATCH [1/1] cciss: auto engage scsi subsystem for tape support
Message-Id: <20110929165417.59fc03c7.akpm00@gmail.com>
In-Reply-To: <20110916213200.GA24786@beardog.cce.hp.com>
References: <20110916213200.GA24786@beardog.cce.hp.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Sep 2011 16:32:00 -0500
Mike Miller <mike.miller@hp.com> wrote:

> 
> commit 608b0262ce818901b931d7e6534aad375c698924
> Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Date:   Mon Aug 29 13:27:46 2011 -0500
> 
>     cciss: auto engage scsi mid-layer
> 
> Acked-by: Mike Miller <mike.miller@hp.com>

Nobody seems to have applied this to anything.

The patch has no signoffs.

The changelog is awful.  What are the end-user-visible effects of this
change?  How is anyone supposed to tell?

> --- a/drivers/block/cciss_scsi.c
> +++ b/drivers/block/cciss_scsi.c
> @@ -1720,5 +1720,6 @@ static int  cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
>  /* If no tape support, then these become defined out of existence */
>  
>  #define cciss_scsi_setup(cntl_num)
> +#define cciss_engage_scsi(h)
>  
>  #endif /* CONFIG_CISS_SCSI_TAPE */

cciss #includes .c files?  I can't believe you did that :(
