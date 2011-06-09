Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab1FISVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:21:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63069 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab1FISU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:20:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eWPUOLps9RbpzKzc69IX3Z3o5rDQRdsOSEBzOPWFx6qkNyUDtVcuEpnziAnmXdG4I3
         oDeDD/aSJvTXypzeYCFhKheqyYSI2GA3z+YNDnITdyC5NoxtDrAOCwnfJOX8pTMm4SZd
         0lX9N0omhSOGVf3bb50UZT7G37AdVoiB8BiJw=
Subject: Re: [PATCH] printk-formats.txt documentation update
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Murray <amurray@mpcdata.com>
Cc: joe@perches.com, w.sang@pengutronix.de, geert@linux-m68k.org,
        linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org, rdunlap@xenotime.net, udknight@gmail.com,
        Andrew Murray <amurray@mpc-data.co.uk>
In-Reply-To: <1307642692-23556-1-git-send-email-amurray@mpcdata.com>
References: <BANLkTik14_Zbfb3e9FXx_yUs35kBh6FqFg@mail.gmail.com>
	 <1307642692-23556-1-git-send-email-amurray@mpcdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 03:20:49 +0900
Message-ID: <1307643649.1340.8.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-06-09 (목), 19:04 +0100, Andrew Murray:
> From: Andrew Murray <amurray@mpc-data.co.uk>
> 
> This patch updates the incomplete documentation concerning the printk
> extended format specifiers.
> 
> Signed-off-by: Andrew Murray <amurray@mpc-data.co.uk>
> ---
>  Documentation/printk-formats.txt |  119 +++++++++++++++++++++++++++++++++++++-
>  1 files changed, 117 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
> index 1b5a5dd..69713d6 100644
> --- a/Documentation/printk-formats.txt
> +++ b/Documentation/printk-formats.txt
> @@ -9,7 +9,121 @@ If variable is of Type,		use printk format specifier:
>  		size_t			%zu or %zx
>  		ssize_t			%zd or %zx
>  
> -Raw pointer value SHOULD be printed with %p.
> +Raw pointer value SHOULD be printed with %p. The kernel supports
> +the following extended format specifiers for pointer types:
> +
> +Symbols/Function Pointers:
> +
> +	%pF	versatile_init+0x0/0x110
> +	%pf	versatile_init
> +	%pS	versatile_init+0x0/0x110
> +	%ps	versatile_init
> +	%pB	versatile_init+0x0/0x110
> +

-EBADEXAMPLE :)

If %pB is used, the offset part in the output could not be 0. That's the
key (and the only) difference of the %pB specifier than others. Thus the
output would be something like:

	%pB	prev_fn_of_versatile_init+0x88/0x88

Thanks.


-- 
Regards,
Namhyung Kim


