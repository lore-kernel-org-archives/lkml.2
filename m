Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab1FMM1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 08:27:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63512 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab1FMM1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 08:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M5x1XSHEpl125+DKBnWENpK7xmLLTqPuhh2oBRC6H7VPfA2h9orGB78NRGc9HriQhB
         JT6mlnIUpXXVg4D9PbYcdUqQIhdIRVziL320ZfMa/yfbV6pqTPYwiZQpczz2AlNLctb/
         RiVxBIEF1selmFqDUVJzFN0dQ0JvkBtyBogkE=
Date: Mon, 13 Jun 2011 15:27:17 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Mike Thomas <rmthomas@sciolus.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging/easycap: Fix thinko in "bars" module option
 description
Message-ID: <20110613122717.GF3583@shale.localdomain>
References: <cover.1307967011.git.kirr@mns.spb.ru>
 <14c0e4d0bb7ef1a05b9dcc14b2b51c706f844655.1307967011.git.kirr@mns.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14c0e4d0bb7ef1a05b9dcc14b2b51c706f844655.1307967011.git.kirr@mns.spb.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 04:18:29PM +0400, Kirill Smelkov wrote:
> Both bars=0 and bars=1 were described as meaning to display bars on
> signal lost. Actually bars=1 means "display bars", but bars=0 means
> display raw source as is (usually black screen).

Your description up here is much better than the one in the README.
Maybe just include yours and delete the original.

regards,
dan carpenter

> 
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Cc: Mike Thomas <rmthomas@sciolus.org>
> Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
> ---
>  drivers/staging/easycap/README |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/easycap/README b/drivers/staging/easycap/README
> index 16b8264..cd55eea 100644
> --- a/drivers/staging/easycap/README
> +++ b/drivers/staging/easycap/README
> @@ -60,7 +60,7 @@ Three module parameters are defined:
>  
>  debug      the easycap module is configured at diagnostic level n (0 to 9)
>  gain       audio gain level n (0 to 31, default is 16)
> -bars       0 =>  testcard bars when incoming video signal is lost
> +bars       0 =>  no testcard bars when incoming video signal is lost
>             1 =>  testcard bars when incoming video signal is lost (default)
>  
>  
> -- 
> 1.7.6.rc1
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
