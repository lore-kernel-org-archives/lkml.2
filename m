Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab2FKOWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:22:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:36660 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858Ab2FKOWQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:22:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="110716456"
Message-ID: <1339424520.29057.49.camel@smile>
Subject: Re: dmatest to use synopsys dma driver (dw_dmac.c)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: satendra.pratap@mindspeed.com
Cc: hskinnemoen@gmail.com, viresh.kumar@st.com, linux-kernel@vger.kernel.org
Date: Mon, 11 Jun 2012 17:22:00 +0300
In-Reply-To: <OF45FACB1C.595B6E12-ON65257A1A.003F5069-65257A1A.003FB93D@mindspeed.com>
References: <OFA47B3090.4F32E90D-ON65257A18.003404DE-65257A18.00341A63@LocalDomain>
	 <OF45FACB1C.595B6E12-ON65257A1A.003F5069-65257A1A.003FB93D@mindspeed.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 17:06 +0530, satendra.pratap@mindspeed.com wrote: 
> >> 1. dmatest with ported dw_dmac.c (from linux-3.4 to linux-3.2.2):
> 
> >>dmatest started automatically and tries test with all registered 8
> >>channels of our dma engine but we get crashes with every channel as 
> shown
> >>below:
> 
> These crashes are solved but I get same " test timed out" for this ported 
> driver too
> as I was getting with original one. After debugging, it seems that after 
> dma transfer is complete no interrupt is 
> generated.......I have verified irq number etc , handler registered 
> properly but I don get any interrupts..
> I am looking into the code to see whether there is any polling mechanism 
> is used in the driver ?

I have few patches to fix this driver for our hardware.
The dw_dmac has few issues, one of them is impossibility to configure
some important parts of the IP-block like block_ts or tr_width.

So, I could send patchset which probably helps you a bit.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
