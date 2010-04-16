Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105Ab0DPL2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 07:28:25 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:54574 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab0DPL2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 07:28:24 -0400
Date: Fri, 16 Apr 2010 13:28:20 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Jakob Viketoft <jakob.viketoft@bitsim.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>
Subject: Re: [PATCH] colibri.h: Fix building for colibri 270...
Message-ID: <20100416112820.GM30801@buzzloop.caiaq.de>
References: <4BC8330E.6000503@bitsim.com>
 <20100416100126.GI30801@buzzloop.caiaq.de>
 <4BC84766.5060208@bitsim.com>
 <4BC8493D.60900@bitsim.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC8493D.60900@bitsim.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 01:25:49PM +0200, Jakob Viketoft wrote:
> Jakob Viketoft wrote:
> >Daniel Mack wrote:
> <...>
> >  CC      drivers/pcmcia/pxa2xx_colibri.o
> >In file included from drivers/pcmcia/pxa2xx_colibri.c:25:
> >arch/arm/mach-pxa/include/mach/colibri.h:13: error: expected ')'
> >before '*' token
> >make[2]: *** [drivers/pcmcia/pxa2xx_colibri.o] Error 1
> >make[1]: *** [drivers/pcmcia] Error 2
> >make: *** [drivers] Error 2
> 
> Adding a "#include <mach/mfp.h>" seem to cure this problem. If you
> agree I can supply a new patch with the correct solution this time.

Ok. Add it to colibri.h, and while at it, you can kick the ax88796.h
inclusion. That's a leftover and isn't needed.

Thanks,
Daniel
