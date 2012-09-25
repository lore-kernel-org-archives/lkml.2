Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2IYGyA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:54:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:24376 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2IYGx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:53:58 -0400
Date: Tue, 25 Sep 2012 09:53:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Gorskin Ilya <revent82@gmail.com>
Cc: gregkh@linuxfoundation.org, klmckinney1@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging:bcm: fix coding style error in InterfaceIsr.c
Message-ID: <20120925065351.GQ4587@mwanda>
References: <1348549469-7222-1-git-send-email-revent82@gmail.com>
 <1348549469-7222-2-git-send-email-revent82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348549469-7222-2-git-send-email-revent82@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 11:04:29AM +0600, Gorskin Ilya wrote:
> This is a patch to the InterfaceIsr.c file that
> fixes up a coding style issues found by the checkpatch.pl tool

I'm afraid all these need to be redone along the lines which I
explained in my other email.

> 
> Signed-off-by: Ilya Gorskin <revent82@gmail.com>
> ---
>  drivers/staging/bcm/InterfaceIsr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/bcm/InterfaceIsr.c b/drivers/staging/bcm/InterfaceIsr.c
> index 4f78451..0e68485 100644
> --- a/drivers/staging/bcm/InterfaceIsr.c
> +++ b/drivers/staging/bcm/InterfaceIsr.c
> @@ -120,7 +120,7 @@ static void read_int_callback(struct urb *urb/*, struct pt_regs *regs*/)
>  			urb->status = STATUS_SUCCESS ;
>  			break ;
>  			/*return;*/
> -		default:
> +	default:
>  			/*This is required to check what is the defaults
>  			* conditions when it occurs..*/
>  			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, NEXT_SEND,

Checkpatch is a tool that finds ugly code.  You've silenced the
warning.  The code still looks like dog vommit, but now checkpatch
doesn't find it.  Don't do that.

regards,
dan carpenter

