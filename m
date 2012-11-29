Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab2K2Rbc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:31:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:42725 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab2K2Rbb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:31:31 -0500
Date: Thu, 29 Nov 2012 09:31:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] hv: hv_balloon: remove duplicated include from
 hv_balloon.c
Message-ID: <20121129173125.GA7839@kroah.com>
References: <CAPgLHd-9_p_haRkx-2D_5eT-E6_g84N=Hjs4JB5gu_kPVSp2Vw@mail.gmail.com>
 <426367E2313C2449837CD2DE46E7EAF930E5E818@SN2PRD0310MB382.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930E5E818@SN2PRD0310MB382.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 05:09:42PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Wei Yongjun [mailto:weiyj.lk@gmail.com]
> > Sent: Wednesday, November 28, 2012 9:23 PM
> > To: KY Srinivasan; Haiyang Zhang
> > Cc: yongjun_wei@trendmicro.com.cn; devel@linuxdriverproject.org; linux-
> > kernel@vger.kernel.org
> > Subject: [PATCH -next] hv: hv_balloon: remove duplicated include from
> > hv_balloon.c
> > 
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > 
> > Remove duplicated include.
> > 
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > ---
> >  drivers/hv/hv_balloon.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
> > index f6c0011..0ce08c4 100644
> > --- a/drivers/hv/hv_balloon.c
> > +++ b/drivers/hv/hv_balloon.c
> > @@ -29,7 +29,6 @@
> >  #include <linux/memory_hotplug.h>
> >  #include <linux/memory.h>
> >  #include <linux/notifier.h>
> > -#include <linux/mman.h>
> >  #include <linux/percpu_counter.h>
> > 
> >  #include <linux/hyperv.h>
> 
> Could you generate patches using git.

Why do you think this wasn't generated using git?

