Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab2BCJVd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 04:21:33 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:40882 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755262Ab2BCJV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 04:21:29 -0500
Message-ID: <4F2BA6C0.10100@stericsson.com>
Date: Fri, 3 Feb 2012 10:20:00 +0100
From: Ulf Hansson <ulf.hansson@stericsson.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Per FORLIN <per.forlin@stericsson.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Viresh KUMAR <viresh.kumar@st.com>
Subject: Re: [PATCH 05/11] mmc/host: add context parameter for DMA_SLAVE and
 DMA_CYCLIC
References: <1328218341-31436-1-git-send-email-alexandre.bounine@idt.com> <1328218341-31436-6-git-send-email-alexandre.bounine@idt.com>
In-Reply-To: <1328218341-31436-6-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset="iso-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
> Fixups for calls affected by adding the new context parameter to DMA_SLAVE
> and DMA_CYCLIC interfaces.
> 
> Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Ian Molton <ian@mnementh.co.uk>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Ulf Hansson <ulf.hansson@stericsson.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Wolfram Sang <w.sang@pengutronix.de>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Viresh Kumar <viresh.kumar@st.com>
> ---
>  drivers/mmc/host/atmel-mci.c    |    2 +-
>  drivers/mmc/host/mmci.c         |    2 +-
>  drivers/mmc/host/mxcmmc.c       |    2 +-
>  drivers/mmc/host/mxs-mmc.c      |    2 +-
>  drivers/mmc/host/sh_mmcif.c     |    6 ++++--
>  drivers/mmc/host/tmio_mmc_dma.c |    4 ++--
>  6 files changed, 10 insertions(+), 8 deletions(-)
> 

I have not been following the patches for changing the API. But does 
that mean that before this patch we are getting compile errors/warnings? 
Is so, the complete API change should have been included in this patch 
as well, right?

Otherwise, looks good to me!

Acked-by: Ulf Hansson <ulf.hansson@stericsson.com>
