Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab2IYNiD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:38:03 -0400
Received: from mga14.intel.com ([143.182.124.37]:55857 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab2IYNiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:38:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,483,1344236400"; 
   d="scan'208";a="196826564"
Message-ID: <1348580274.13371.127.camel@smile>
Subject: Re: [PATCHv1 6/6] MAINTAINERS: add recently created files to
 dw_dmac section
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 25 Sep 2012 16:37:54 +0300
In-Reply-To: <1348579169.2476.1.camel@joe-AO722>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348575190-11761-7-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1348579169.2476.1.camel@joe-AO722>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 06:19 -0700, Joe Perches wrote: 
> On Tue, 2012-09-25 at 15:13 +0300, Andy Shevchenko wrote:
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> You also added yourself as a maintainer.
> Congrats/sympathies, etc...
Actually I prefer to be just a supporter, because I introduce few
additional files. But if I understood correctly, there is no way to
distinguish person statuses in one section.

> > diff --git a/MAINTAINERS b/MAINTAINERS
> []
> > @@ -6007,10 +6007,13 @@ F:	drivers/tty/serial
> >  
> >  SYNOPSYS DESIGNWARE DMAC DRIVER
> >  M:	Viresh Kumar <viresh.linux@gmail.com>
> > +M:	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >  S:	Maintained
> >  F:	include/linux/dw_dmac.h
> >  F:	drivers/dma/dw_dmac_regs.h
> >  F:	drivers/dma/dw_dmac.c
> > +F:	drivers/dma/dw_dmac_at32.c
> > +F:	drivers/dma/dw_dmac_pci.c
> 
> Perhaps these F: lines instead
> 
> F:	include/linux/dw_dmac.h
> F:	drivers/dma/dw_dmac*
Might be. There is another idea to move them under drivers/dma/dw/
folder. So, Viresh, what do you think is better?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
