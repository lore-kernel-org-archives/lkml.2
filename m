Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab2GZGsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 02:48:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:40080 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab2GZGsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 02:48:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="186532011"
Subject: Re: [PATCH 9/9 v3] dma: shdma: convert to the shdma base library
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-sh@vger.kernel.org
In-Reply-To: <20120725035935.GA30468@linux-sh.org>
References: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
	 <1336576161-27082-10-git-send-email-g.liakhovetski@gmx.de>
	 <20120725035935.GA30468@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Jul 2012 12:19:21 +0530
Message-ID: <1343285361.1726.8980.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-25 at 12:59 +0900, Paul Mundt wrote:
> On Wed, May 09, 2012 at 05:09:21PM +0200, Guennadi Liakhovetski wrote:
> > The shdma base library has originally been extracted from the shdma driver,
> > which now can be converted to actually use it.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  drivers/dma/sh/shdma.c | 1122 ++++++++++++------------------------------------
> >  drivers/dma/sh/shdma.h |   44 +-
> >  include/linux/sh_dma.h |   33 +-
> >  3 files changed, 302 insertions(+), 897 deletions(-)
> > 
> Now that this has hit mainline, the sh-sci with DMA enabled build is
> broken:
> 
>   CC      drivers/tty/serial/sh-sci.o
> drivers/tty/serial/sh-sci.c: In function 'work_fn_rx':
> drivers/tty/serial/sh-sci.c:1413:67: error: dereferencing pointer to incomplete type
> drivers/tty/serial/sh-sci.c:1413:81: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/tty/serial/sh-sci.c:1413:90: warning: initialization from incompatible pointer type
> drivers/tty/serial/sh-sci.c:1413:161: error: invalid use of undefined type 'struct sh_desc'
> drivers/tty/serial/sh-sci.c:1419:83: error: dereferencing pointer to incomplete type
> drivers/tty/serial/sh-sci.c:1419:101: error: dereferencing pointer to incomplete type
> drivers/tty/serial/sh-sci.c:1423:42: error: dereferencing pointer to incomplete type
This was in -next for quite some time :(


-- 
~Vinod

