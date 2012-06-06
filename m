Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab2FFGBo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 02:01:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46262 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab2FFGBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 02:01:43 -0400
MIME-Version: 1.0
In-Reply-To: <1338961426-31470-1-git-send-email-sachin.kamat@linaro.org>
References: <1338961426-31470-1-git-send-email-sachin.kamat@linaro.org>
From: Rahul Bedarkar <rpal143@gmail.com>
Date: Wed, 6 Jun 2012 11:31:18 +0530
Message-ID: <CA+NV+Vkdd_yVnbNgeW4Tr7fRqEyQc=1gD2=5LY_pSsvF89AW0g@mail.gmail.com>
Subject: Re: [PATCH 1/1] PM: devfreq: Add missing static storage class
 specifier in devfreq.c file
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It could be static.

On Wed, Jun 6, 2012 at 11:13 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Fixes the following sparse warning:
> drivers/devfreq/devfreq.c:30:14: warning: symbol 'devfreq_class' was not declared. Should it be static?
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/devfreq/devfreq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 70c31d4..9eb6805 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -27,7 +27,7 @@
>  #include <linux/hrtimer.h>
>  #include "governor.h"
>
> -struct class *devfreq_class;
> +static struct class *devfreq_class;
>
>  /*
>  * devfreq_work periodically monitors every registered device.
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
