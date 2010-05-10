Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab0EJG7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 02:59:14 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:40061 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab0EJG7N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 02:59:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MGz4flbLdldHkFwFI1EpQq1tfutvpuqInGxfqcpTuBg5pdzq38RuALTOZZcXxs7bGX
         oHUdjNaT4ZlB3J3DezwtYUJcZS/SSR27MH0vle+O6ngDMNonMbiNi/tgnQzIPsd0eDCu
         iDXlmeFnzK7Wy7taK8hBE0Gy3BkJBxbldHmBU=
MIME-Version: 1.0
In-Reply-To: <1273425124-6750-1-git-send-email-pshah.mumbai@gmail.com>
References: <1273425124-6750-1-git-send-email-pshah.mumbai@gmail.com>
Date: Mon, 10 May 2010 09:59:11 +0300
Message-ID: <AANLkTiny2Vk3y5DGYWEphQ94_HbgMUEZB1uub08WWs4w@mail.gmail.com>
Subject: Re: [PATCH] Staging: wlags49_h2: fixed C99 comments style issues in 
	wl_profile.c
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, pe1dnn@amsat.org,
       ext-andriy.shevchenko@nokia.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 9, 2010 at 8:12 PM, Prashant P. Shah <pshah.mumbai@gmail.com> wrote:
> This is a patch to the wl_profile.c file that fixes the C99 comments
> style issues found by the checkpatch.pl tool.
>
> Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
> ---
>  drivers/staging/wlags49_h2/wl_profile.c |   54 +++++++++++++++---------------
>  1 files changed, 27 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/staging/wlags49_h2/wl_profile.c b/drivers/staging/wlags49_h2/wl_profile.c
> index 13ade70..4a3b64d 100644
> --- a/drivers/staging/wlags49_h2/wl_profile.c
> +++ b/drivers/staging/wlags49_h2/wl_profile.c

...

> @@ -118,17 +118,17 @@ int parse_yes_no(char *value);
>
>  int parse_yes_no(char *value)
>  {
> -int rc = 0;                                                                            //default to NO for invalid parameters
> +int rc = 0;                                                                            /* default to NO for invalid parameters */
>
>        if (strlen(value) == 1) {
>                if ((value[0] | ('Y'^'y')) == 'y')
>                        rc = 1;
> -//     } else {
> -//             this should not be debug time info, it is an enduser data entry error ;?
> -//             DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_MICROWAVE_ROBUSTNESS);
> +/*     } else {
> +               this should not be debug time info, it is an enduser data entry error ;?
> +               DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_MICROWAVE_ROBUSTNESS); */
In such case you have lost the internal comments. I think it should look like
/*
} else {
/* ... */
...
*/


>        }
>        return rc;
> -} // parse_yes_no
> +} /* parse_yes_no */
>
>
>  /*******************************************************************************


-- 
With Best Regards,
Andy Shevchenko
