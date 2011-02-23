Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab1BWJqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:46:46 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35483 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab1BWJqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:46:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=iHqwelqs6jcGgGFqNxEQkQDRwDuie474zX/BOezLCM5KGWPpln/qYoEichP2ZHK8FW
         W9oe/dFzS5o/knP2rGLd74QMq7nQdLQEUgrRVdBMsPCX1JJM+YO7aJsj4/9fTRB46uYD
         ciXKjWuvnTYdh0tDT8CGqzT0s5SVCCJG9QCX8=
Date: Wed, 23 Feb 2011 17:46:35 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        maximlevitsky@gmail.com
Subject: Re: [PATCH 07/18] MAINTAINERS: Update media path
Message-ID: <20110223094633.GD3090@gmail.com>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	maximlevitsky@gmail.com
References: <cover.1298439175.git.joe@perches.com>
 <565315e4561a8a74158f84974b91e097ab0b6bf4.1298439175.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <565315e4561a8a74158f84974b91e097ab0b6bf4.1298439175.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:42:00PM -0800, Joe Perches wrote:
> Commit 52b661449aecc47e652a164c0d8078b31e10aca0
> ("[media] rc: Rename remote controller type to rc_type instead of ir_type")
> moved it around.
> 
> cc: Maxim Levitsky <maximlevitsky@gmail.com>
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
> ---
>  MAINTAINERS |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c169e27..6556c9f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2447,8 +2447,7 @@ F:	include/linux/cb710.h
>  ENE KB2426 (ENE0100/ENE020XX) INFRARED RECEIVER
>  M:	Maxim Levitsky <maximlevitsky@gmail.com>
>  S:	Maintained
> -F:	drivers/media/IR/ene_ir.c
> -F:	drivers/media/IR/ene_ir.h
> +F:	drivers/media/rc/ene_ir.*
>  
>  EPSON 1355 FRAMEBUFFER DRIVER
>  M:	Christopher Hoover <ch@murgatroid.com>
> -- 
> 1.7.4.rc3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
