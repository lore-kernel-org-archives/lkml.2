Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab2LNLq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:46:28 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:37798 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2LNLq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:46:26 -0500
MIME-Version: 1.0
In-Reply-To: <1355477987-9808-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1355477987-9808-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 14 Dec 2012 17:16:25 +0530
Message-ID: <CAKohpokSb2tEV7HxcSUrWpZ5-UgmkaraJPd3e8Zq9L-5Q5+xsw@mail.gmail.com>
Subject: Re: [PATCH] dw_dmac: remove redundant check
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 December 2012 15:09, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> There is no need to check the callback_required parameter, due to we check the
> callback pointer to be a non-NULL.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 92f33af..3c8acfa 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -364,7 +364,7 @@ dwc_descriptor_complete(struct dw_dma_chan *dwc, struct dw_desc *desc,
>
>         spin_unlock_irqrestore(&dwc->lock, flags);
>
> -       if (callback_required && callback)
> +       if (callback)
>                 callback(param);
>  }

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
