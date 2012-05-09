Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab2EIUvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:51:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54718 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab2EIUva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:51:30 -0400
Date: Wed, 9 May 2012 13:51:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johannes Thumshirn <morbidrsa@googlemail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stefanha@gmail.com, andor.daam@googlemail.com, grabner@icg.tugraz.at,
        jj@chaosbits.net, thomas@m3y3r.de
Subject: Re: [PATCH 36/36] drivers/staging/line6/config.h: Delete CHECKPOINT
 macro
Message-ID: <20120509205126.GA15545@kroah.com>
References: <1336415273-11713-1-git-send-email-morbidrsa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336415273-11713-1-git-send-email-morbidrsa@googlemail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 08:27:53PM +0200, Johannes Thumshirn wrote:
> Kill unused debugging macro CHECKPOINT
> 
> Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
> ---
>  drivers/staging/line6/config.h |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/line6/config.h b/drivers/staging/line6/config.h
> index a82d8bf..2493491 100644
> --- a/drivers/staging/line6/config.h
> +++ b/drivers/staging/line6/config.h
> @@ -34,11 +34,6 @@
>  #define CREATE_RAW_FILE      0
>  
>  #if DO_DEBUG_MESSAGES
> -#define CHECKPOINT pr_info("line6usb: %s (%s:%d)\n", \
> -			  __func__, __FILE__, __LINE__)
> -#endif

This patch doesn't apply as it seems to depend on a patch that is not in
my tree anywhere :(

greg k-h
