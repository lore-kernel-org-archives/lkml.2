Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab2IZOpV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 10:45:21 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38631 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2IZOpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 10:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <1348663237-3237-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348663237-3237-5-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 26 Sep 2012 20:15:19 +0530
X-Google-Sender-Auth: JhXbPvuZfh9fjWR5reI79Oq3Ubs
Message-ID: <CAOh2x==ZCozF-Q1rjKapSYKK+x6HdyHs8N2ZJ96iSxoYZKPRXQ@mail.gmail.com>
Subject: Re: [PATCHv2 4/4] MAINTAINERS: add recently created files to dw_dmac section
From: viresh kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 6:10 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> Append myself to mail subsection as well.

Mail subsection? You are adding yourself as Maintainer of dw_dmac...
Do you really want that.
I am asking this, because that's not the normal practice followed in kernel.

This isn't done until unless, somebody has done a MAJOR modification
to the driver.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  MAINTAINERS |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7dfd0eb..b87cbb1d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5999,10 +5999,10 @@ F:      drivers/tty/serial
>
>  SYNOPSYS DESIGNWARE DMAC DRIVER
>  M:     Viresh Kumar <viresh.linux@gmail.com>
> +M:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>  S:     Maintained
>  F:     include/linux/dw_dmac.h
> -F:     drivers/dma/dw_dmac_regs.h
> -F:     drivers/dma/dw_dmac.c
> +F:     drivers/dma/dw/

I can't see this change...
