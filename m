Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2GWUvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:51:10 -0400
Received: from na6sys009bog011.obsmtp.com ([74.125.150.62]:41945 "EHLO
	na6sys009bog011.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505Ab2GWUvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:51:09 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2012 16:51:07 EDT
MIME-Version: 1.0
In-Reply-To: <1343051366-26282-1-git-send-email-justinmattock@gmail.com>
References: <1343051366-26282-1-git-send-email-justinmattock@gmail.com>
Date: Mon, 23 Jul 2012 15:44:38 -0500
Message-ID: <CAB-zwWjCEprbEGJ5f3HoyHhZPTaMUramZk=YG=1b63U-pGymQA@mail.gmail.com>
Subject: Re: [PATCH NEXT]staging "tidspbridge" Fix typos.
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: gregkh@linuxfoundation.org, vjaquez@igalia.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

On Mon, Jul 23, 2012 at 8:49 AM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
> index f9609ce..2c82d5a 100644
> --- a/drivers/staging/tidspbridge/core/tiomap3430.c
> +++ b/drivers/staging/tidspbridge/core/tiomap3430.c
> @@ -328,7 +328,7 @@ static int bridge_brd_read(struct bridge_dev_context *dev_ctxt,
>                                            ul_num_bytes, mem_type);
>                 return status;
>         }
> -       /* copy the data from  DSP memory, */
> +       /* copy the data from DSP memory, */

I guess we can get rid of the comma (,) at the end of this sentence.

...
> diff --git a/drivers/staging/tidspbridge/include/dspbridge/proc.h b/drivers/staging/tidspbridge/include/dspbridge/proc.h
> index a82380e..9cd5022 100644
> --- a/drivers/staging/tidspbridge/include/dspbridge/proc.h
> +++ b/drivers/staging/tidspbridge/include/dspbridge/proc.h
> @@ -263,7 +263,7 @@ extern int proc_get_processor_id(void *proc, u32 * proc_id);
>   *  Returns:
>   *      0     :   Success.
>   *      -EFAULT :   Invalid processor handle.
> - *      -EPERM   :   General failure while retireving processor trace
> + *      -EPERM   :   General failure while retireing processor trace

This was meant to be 'retrieving'.

And given that this is focused on tidspbridge, could you change the
patch subject? To: staging: tidspbridge: fix typos.

Cheers,

Omar
