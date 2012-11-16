Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2KPRjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:39:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35231 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698Ab2KPRjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:39:11 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: <i.mazanov@gmail.com>, Igor Mazanov <i.mazanov@gmail.com>,
        Paul Walmsley <paul@pwsan.com>
From: Mike Turquette <mturquette@ti.com>
In-Reply-To: <50A674D2.9080403@gmail.com>
CC: <linux-omap@vger.kernel.org>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
References: <50A52134.2010502@gmail.com>
 <alpine.DEB.2.00.1211151845050.18192@utopia.booyaka.com>
 <50A674D2.9080403@gmail.com>
Message-ID: <20121116173900.20639.18889@nucleus>
User-Agent: alot/0.3.2+
Subject: Re: [PATCH] Remove inline from clock framework function definitions to build
 the kernel with GCC 4.7
Date: Fri, 16 Nov 2012 09:39:00 -0800
X-Originating-IP: [10.188.36.112]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Igor Mazanov (2012-11-16 09:16:02)
> Paul Walmsley wrote:
> > + Mike
> > 
> > On Thu, 15 Nov 2012, Igor Mazanov wrote:
> > 
> >>  Remove inline from clock framework function definitions to
> >>  build the kernel with GCC 4.7
> > 
> > sparse warns about this also.
> > 
> >> Signed-off-by: Igor Mazanov <i.mazanov@gmail.com>
> > 
> > This one is for Mike to deal with as CCF maintainer; it's out of the hands 
> > of the OMAP folks.
> 
> Thanks for comments, I'll bear in mind it for the future.
> 

I forgot to reply to this thread yesterday.  A fixes request has been
sent out, hopefully will be picked up for 3.7-rc6.

Thanks all,
Mike

> > 
> > Acked-by: Paul Walmsley <paul@pwsan.com>
> > 
> > 
> >> ---
> >>  include/linux/clk-provider.h |    4 ++--
> >>  1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> >> index c127315..f9f5e9e 100644
> >> --- a/include/linux/clk-provider.h
> >> +++ b/include/linux/clk-provider.h
> >> @@ -335,8 +335,8 @@ const char *__clk_get_name(struct clk *clk);
> >>  struct clk_hw *__clk_get_hw(struct clk *clk);
> >>  u8 __clk_get_num_parents(struct clk *clk);
> >>  struct clk *__clk_get_parent(struct clk *clk);
> >> -inline int __clk_get_enable_count(struct clk *clk);
> >> -inline int __clk_get_prepare_count(struct clk *clk);
> >> +int __clk_get_enable_count(struct clk *clk);
> >> +int __clk_get_prepare_count(struct clk *clk);
> >>  unsigned long __clk_get_rate(struct clk *clk);
> >>  unsigned long __clk_get_flags(struct clk *clk);
> >>  int __clk_is_enabled(struct clk *clk);
> >> --
> >> 1.7.4.4
> >>
> > 
> > 
> > - Paul
