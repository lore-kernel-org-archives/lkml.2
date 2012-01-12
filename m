Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab2ALAWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 19:22:23 -0500
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:33273 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102Ab2ALAWV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 19:22:21 -0500
MIME-Version: 1.0
In-Reply-To: <1326276130-4042-2-git-send-email-myungjoo.ham@samsung.com>
References: <1326276130-4042-1-git-send-email-myungjoo.ham@samsung.com> <1326276130-4042-2-git-send-email-myungjoo.ham@samsung.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Wed, 11 Jan 2012 16:21:59 -0800
Message-ID: <CAJOA=zOX0X9M2Lqu1GQC3o37V7e-jja7KbHteJ+yDWL-JRf5YA@mail.gmail.com>
Subject: Re: [PATCH 2/2] PM / devfreq: fixed syntax errors.
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        myungjoo.ham@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 2:02 AM, MyungJoo Ham <myungjoo.ham@samsung.com> wrote:
> If devfreq.h was included without CONFIG_PM_DEVFREQ, there has been a
> compiler error with an additional semicolon added. This patch removes
> that errorneous semicolon.

Looks good.

Reviewed-by: Mike Turquette <mturquette@ti.com>

>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  include/linux/devfreq.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index e9385bf..5862475 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -205,12 +205,12 @@ struct devfreq_simple_ondemand_data {
>  static struct devfreq *devfreq_add_device(struct device *dev,
>                                          struct devfreq_dev_profile *profile,
>                                          struct devfreq_governor *governor,
> -                                         void *data);
> +                                         void *data)
>  {
>        return NULL;
>  }
>
> -static int devfreq_remove_device(struct devfreq *devfreq);
> +static int devfreq_remove_device(struct devfreq *devfreq)
>  {
>        return 0;
>  }
> --
> 1.7.4.1
>
