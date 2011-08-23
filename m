Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab1HWX3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:29:24 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47042 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755549Ab1HWX2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:28:13 -0400
X-Sasl-enc: sF7vlZ3A0MIq2uMWFap18AjInJPuzf/hWZJL/b8rMVu4 1314142092
Date: Tue, 23 Aug 2011 16:16:57 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 4/8] Staging: hv: vmbus: Fix checkpatch warnings
Message-ID: <20110823231657.GC9955@kroah.com>
References: <1311101018-23370-1-git-send-email-kys@microsoft.com>
 <1311101065-23417-1-git-send-email-kys@microsoft.com>
 <1311101065-23417-4-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311101065-23417-4-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 11:44:21AM -0700, K. Y. Srinivasan wrote:
> Fix  checkpatch warnings in hv.c
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/hv.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
> index e733173..14e6315 100644
> --- a/drivers/staging/hv/hv.c
> +++ b/drivers/staging/hv/hv.c
> @@ -111,7 +111,7 @@ static u64 do_hypercall(u64 control, void *input, void *output)
>  	u64 hv_status = 0;
>  	u64 input_address = (input) ? virt_to_phys(input) : 0;
>  	u64 output_address = (output) ? virt_to_phys(output) : 0;
> -	volatile void *hypercall_page = hv_context.hypercall_page;
> +	void *hypercall_page = hv_context.hypercall_page;

Are you sure?  This was just someone being foolish?  No other reason
someone tried to use volatile here?

greg k-h
