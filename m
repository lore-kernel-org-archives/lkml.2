Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab0KPUPn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 15:15:43 -0500
Received: from kroah.org ([198.145.64.141]:57073 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759458Ab0KPUPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 15:15:35 -0500
Date: Tue, 16 Nov 2010 12:14:44 -0800
From: Greg KH <greg@kroah.com>
To: Al Cho <acho@novell.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        yiyingc@ene.com.tw, jlee@novell.com, segooon@gmail.com
Subject: Re: [PATCH 2/3] staging/keucr: fix keucr common code style
Message-ID: <20101116201444.GA15963@kroah.com>
References: <1289887967-2924-1-git-send-email-acho@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289887967-2924-1-git-send-email-acho@novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 02:12:47PM +0800, Al Cho wrote:
> fix keucr common code style
> 
> Signed-off-by: Al Cho <acho@novell.com>
> ---
>  drivers/staging/keucr/common.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/keucr/common.h b/drivers/staging/keucr/common.h
> index 8693c54..f2be045 100644
> --- a/drivers/staging/keucr/common.h
> +++ b/drivers/staging/keucr/common.h
> @@ -1,7 +1,6 @@
>  #ifndef COMMON_INCD
>  #define COMMON_INCD
>  
> -typedef void VOID;

You just deleted an unused typedef, which is great, but your description
of the patch isn't correct.  Care to resend it with a correct
description?

thanks,

greg k-h
