Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508Ab2I0IQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 04:16:59 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64382 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab2I0IQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 04:16:57 -0400
MIME-Version: 1.0
In-Reply-To: <1348731121-2515-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-3-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Thu, 27 Sep 2012 13:46:57 +0530
X-Google-Sender-Auth: mWEcMHoHxOET2HKUag3zvoC63ek
Message-ID: <CAOh2x==fDa9BFYHUqRW4T5nxr_O_=W4k2ghYXQ4CYhvsYuDBzA@mail.gmail.com>
Subject: Re: [PATCHv3 2/7] dmaengine: dw_dmac: add module alias
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 1:01 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>
> It's good to have a quasistatic name for the platform driver.
>
> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 0b88ced..bbb2a82 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1712,6 +1712,7 @@ static struct platform_driver dw_driver = {
>
>  module_platform_driver(dw_driver);
>
> +MODULE_ALIAS("platform:dw_dmac");

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
