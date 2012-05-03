Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2ECJqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:46:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58251 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab2ECJqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:46:02 -0400
MIME-Version: 1.0
In-Reply-To: <1336037548-13718-1-git-send-email-sachin.kamat@linaro.org>
References: <1336037548-13718-1-git-send-email-sachin.kamat@linaro.org>
Date: Thu, 3 May 2012 15:16:01 +0530
Message-ID: <CAJe_ZhfmNt5jL1LrPJFM4XPiz-dA4yaBRMn92HTB7PWRXQJzRA@mail.gmail.com>
Subject: Re: [PATCH 1/1] DMA: PL330: Remove duplicate header file inclusion
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, vinod.koul@intel.com,
        dan.j.williams@intel.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 May 2012 15:02, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> Removes <linux/interrupt.h> file which was included twice.
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/dma/pl330.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 2ee6e23..e8ebca7 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -21,7 +21,6 @@
>  #include <linux/interrupt.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/dmaengine.h>
> -#include <linux/interrupt.h>
>  #include <linux/amba/bus.h>
>  #include <linux/amba/pl330.h>
>  #include <linux/pm_runtime.h>

Acked-by: Jassi Brar <jaswinder.singh@linaro.org>

Thanks.
