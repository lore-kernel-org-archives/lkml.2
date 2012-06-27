Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2F0C6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 22:58:11 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:53069 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab2F0C6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 22:58:10 -0400
Date: Wed, 27 Jun 2012 02:58:46 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Rob Landley <rob@landley.net>, Miklos Szeredi <mszeredi@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: kernel-parameters.txt remove
 capability.disable
Message-ID: <20120627025846.GA13155@mail.hallyn.com>
References: <20120626013402.GC9997@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120626013402.GC9997@zod.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Josh Boyer (jwboyer@redhat.com):
> Remove the documentation for capability.disable.  The code supporting this
> parameter was removed with:
> 
> 	commit 5915eb53861c5776cfec33ca4fcc1fd20d66dd27
> 	Author: Miklos Szeredi <mszeredi@suse.cz>
> 	Date:   Thu Jul 3 20:56:05 2008 +0200
> 
>     	security: remove dummy module
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>

Thanks!

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  Documentation/kernel-parameters.txt |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index a92c5eb..9415bcc 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -446,12 +446,6 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			possible to determine what the correct size should be.
>  			This option provides an override for these situations.
>  
> -	capability.disable=
> -			[SECURITY] Disable capabilities.  This would normally
> -			be used only if an alternative security model is to be
> -			configured.  Potentially dangerous and should only be
> -			used if you are entirely sure of the consequences.
> -
>  	ccw_timeout_log [S390]
>  			See Documentation/s390/CommonIO for details.
>  
> -- 
> 1.7.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
