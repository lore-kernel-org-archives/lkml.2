Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab2JBKLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 06:11:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:56656 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab2JBKLi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 06:11:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,522,1344236400"; 
   d="scan'208";a="229464326"
Message-ID: <1349172693.13371.178.camel@smile>
Subject: Re: dmatest to use synopsys dma driver (dw_dmac.c)
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Satendra Pratap <satendra.pratap@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 02 Oct 2012 13:11:33 +0300
In-Reply-To: <loom.20120607T120203-129@post.gmane.org>
References: <loom.20120607T120203-129@post.gmane.org>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 10:03 +0000, Satendra Pratap wrote: 
> We have Synopsys DMAC controller on our SoC and are trying to use open source
> dw_dmac.c driver. We are using linux-3.2.2 kernel but it seems dw_dmac.c does 
> not have any support for it. Later I checked out that its been added in later 
> versions of dw_dmac.c so I backported dw_dmac from linux-3.4 to linux-3.2.2.
> I have tried using dmatest to validate dw_dmac.c driver. I just compile kernel 
> with dw_dmac.c and with dmatest support then I test it. (I think I need not to 
> modify dmatest in order wo work with dw_dmac).
> While testing I get crashes with the ported driver (from linux-3.4 to linux-
> 3.2.2) but with the original driver in linux-3.2.2 I get no crashes but "test 
> timed out"


> Any help is greatly appreciated. It would be of very much help is some one could 
> (who has used dw_dmac.c) could share their code to use dw_dmac.c.

I published all my patches already here in the mailing list. Part of
them is under review, but another part has been pushed to the
linux-next.

I highly encourage you to try most recent version from the linux-next.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
