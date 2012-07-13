Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2GMI1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 04:27:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:54167 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab2GMI1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 04:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1342166974-4490-1-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Fri, 13 Jul 2012 09:27:02 +0100
X-Google-Sender-Auth: 2mXwmYjWpMBuLf9IP8_YDZR96DE
Message-ID: <CAOh2x=nuLGei7JowkVb6J=bdXzSFpSxrdKdjvzy4Eow_dp=vPA@mail.gmail.com>
Subject: Re: [PATCH 1/3] dw_dmac: mark dwc_dump_lli inline
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 9:09 AM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 9151511..db56ef4 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -413,7 +413,7 @@ static void dwc_scan_descriptors(struct dw_dma *dw, struct dw_dma_chan *dwc)
>         spin_unlock_irqrestore(&dwc->lock, flags);
>  }
>
> -static void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
> +static inline void dwc_dump_lli(struct dw_dma_chan *dwc, struct dw_lli *lli)
>  {
>         dev_printk(KERN_CRIT, chan2dev(&dwc->chan),
>                         "  desc: s0x%llx d0x%llx l0x%llx c0x%x:%x\n",

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
