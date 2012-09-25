Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab2IYNUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:20:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48017 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755742Ab2IYNUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:20:09 -0400
Message-ID: <1348579169.2476.1.camel@joe-AO722>
Subject: Re: [PATCHv1 6/6] MAINTAINERS: add recently created files to
 dw_dmac section
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1348575190-11761-7-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348575190-11761-7-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 25 Sep 2012 06:19:29 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.0-0ubuntu1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2012-09-25 at 15:13 +0300, Andy Shevchenko wrote:
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

You also added yourself as a maintainer.
Congrats/sympathies, etc...

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -6007,10 +6007,13 @@ F:	drivers/tty/serial
>  
>  SYNOPSYS DESIGNWARE DMAC DRIVER
>  M:	Viresh Kumar <viresh.linux@gmail.com>
> +M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>  S:	Maintained
>  F:	include/linux/dw_dmac.h
>  F:	drivers/dma/dw_dmac_regs.h
>  F:	drivers/dma/dw_dmac.c
> +F:	drivers/dma/dw_dmac_at32.c
> +F:	drivers/dma/dw_dmac_pci.c

Perhaps these F: lines instead

F:	include/linux/dw_dmac.h
F:	drivers/dma/dw_dmac*



