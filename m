Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab2IRGfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 02:35:37 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:33732 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab2IRGff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 02:35:35 -0400
MIME-Version: 1.0
In-Reply-To: <1347867577-13170-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1347867577-13170-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1347867577-13170-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 18 Sep 2012 12:05:34 +0530
X-Google-Sender-Auth: OlAMNLxQkNAjYMsZ1Tgf5Qq6n08
Message-ID: <CAOh2x==T8jRTY__1N_3zxc96CZnyd8fX3pJKL5SNY2gMCTmXLQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] dw_dmac: mark dwc_dump_chan_regs as inline
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org, Hein Tibosch <hein_tibosch@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 1:09 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 832538c..75ab5af 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -208,7 +208,7 @@ static inline unsigned int dwc_fast_fls(unsigned long long v)
>         return 0;
>  }
>
> -static void dwc_dump_chan_regs(struct dw_dma_chan *dwc)
> +static inline void dwc_dump_chan_regs(struct dw_dma_chan *dwc)
>  {
>         dev_err(chan2dev(&dwc->chan),
>                 "  SAR: 0x%x DAR: 0x%x LLP: 0x%x CTL: 0x%x:%08x\n",

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
