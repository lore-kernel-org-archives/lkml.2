Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab1EXH5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:57:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:62171 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab1EXH5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:57:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,260,1304319600"; 
   d="scan'208";a="3829971"
Subject: Re: [PATCH] dmaengine/dw_dmac: Update maintainer-ship
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        shiraz.hashim@st.com, armando.visconti@st.com, viresh.linux@gmail.com
In-Reply-To: <f7a8ea363d81ddbfab43272711cb482e700540e5.1306220852.git.viresh.kumar@st.com>
References: <f7a8ea363d81ddbfab43272711cb482e700540e5.1306220852.git.viresh.kumar@st.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 May 2011 12:54:06 +0530
Message-ID: <1306221846.28926.317.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-24 at 12:44 +0530, Viresh Kumar wrote:
> Nobody is currently maintaining dw_dmac. We are using dw_dmac for SPEAr13xx and
> are currently maintaining it. After discussing with Vinod, sending this patch to
> update maintainer-ship of dw_dmac.
> 
> Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
> ---
>  MAINTAINERS                |    7 +++++++
>  drivers/dma/dw_dmac.c      |    2 ++
>  drivers/dma/dw_dmac_regs.h |    1 +
>  include/linux/dw_dmac.h    |    1 +
>  4 files changed, 11 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0b41524..a911177 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5430,6 +5430,13 @@ L:	linux-serial@vger.kernel.org
>  S:	Maintained
>  F:	drivers/tty/serial
>  
> +SYNOPSYS DESIGNWARE DMAC DRIVER
> +M:	Viresh Kumar <viresh.kumar@st.com>
> +S:	Maintained
> +F:	include/linux/dw_dmac.h
> +F:	drivers/dma/dw_dmac_regs.h
> +F:	drivers/dma/dw_dmac.c
> +
>  TIMEKEEPING, NTP
>  M:	John Stultz <johnstul@us.ibm.com>
>  M:	Thomas Gleixner <tglx@linutronix.de>
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 2a2e2fa..08e2202 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -3,6 +3,7 @@
>   * AVR32 systems.)
>   *
>   * Copyright (C) 2007-2008 Atmel Corporation
> + * Copyright (c) 2011-2012 Viresh Kumar <viresh.kumar@st.com>

2012???



-- 
~Vinod

