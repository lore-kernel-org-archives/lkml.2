Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0GZWsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 18:48:33 -0400
Received: from kroah.org ([198.145.64.141]:37961 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874Ab0GZWsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 18:48:32 -0400
Date: Mon, 26 Jul 2010 15:43:01 -0700
From: Greg KH <greg@kroah.com>
To: Michael Jensen <emjay1988@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: comedi: comedidev: Removed unused macro
 definitions
Message-ID: <20100726224301.GA5287@kroah.com>
References: <1280070874-8961-1-git-send-email-emjay1988@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280070874-8961-1-git-send-email-emjay1988@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 01:14:34AM +1000, Michael Jensen wrote:
> Removed macro definition that wasn't used.
> 
> Signed-off-by: Michael Jensen <emjay1988@gmail.com>
> ---
>  drivers/staging/comedi/comedidev.h |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 4eb2b77..b225fff 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -61,11 +61,6 @@
>  	module_init(x ## _init_module);					\
>  	module_exit(x ## _cleanup_module);
>  
> -#define COMEDI_MODULE_MACROS						\

This doesn't apply against the linux-next tree as this macro is already
gone from there.

What tree are you creating this diff against?

confused,

greg k-h
