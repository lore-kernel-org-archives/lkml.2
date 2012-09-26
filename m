Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab2IZDwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 23:52:19 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:35970 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2IZDwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 23:52:18 -0400
MIME-Version: 1.0
In-Reply-To: <1348575190-11761-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348575190-11761-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 26 Sep 2012 09:22:17 +0530
X-Google-Sender-Auth: FF0PJad2dNvd0kJ8jcvIq-kLRPA
Message-ID: <CAOh2x=kmOX==Dx=Jk4vJT+9_371bnkoDnELR7DO4f1D7iHt32Q@mail.gmail.com>
Subject: Re: [PATCHv1 2/6] dmaengine: dw_dmac: add driver for Atmel AT32
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 5:43 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index df32537..e47cc90 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -89,6 +89,15 @@ config DW_DMAC
>           Support the Synopsys DesignWare AHB DMA controller.  This
>           can be integrated in chips such as the Atmel AT32ap7000.
>
> +config DW_DMAC_AT32
> +       tristate "Synopsys DesignWare AHB DMA support for Atmel"
> +       depends on HAVE_CLK
> +       select DW_DMAC
> +       default y if CPU_AT32AP7000

Also, remove
default y if CPU_AT32AP7000 from  config DW_DMAC
