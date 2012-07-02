Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab2GBNcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:32:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:29948 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2GBNcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:32:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118101431"
Date: Mon, 2 Jul 2012 15:43:58 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        SangYoung Son <hello.son@samsung.com>
Subject: Re: linux-next: Tree for Jun 19 (mfd/max77693-irq.c)
Message-ID: <20120702134358.GE22065@sortiz-mobl>
References: <20120619150513.364d8c9f19a21b4c6feebbbf@canb.auug.org.au>
 <4FE0B464.6020207@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE0B464.6020207@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Tue, Jun 19, 2012 at 10:18:28AM -0700, Randy Dunlap wrote:
> On 06/18/2012 10:05 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20120618:
> 
> 
> on x86_64:
> 
>   CC      drivers/mfd/max77693-irq.o
> drivers/mfd/max77693-irq.c: In function 'max77693_irq_thread':
> drivers/mfd/max77693-irq.c:217:4: error: implicit declaration of function 'irq_find_mapping'
> drivers/mfd/max77693-irq.c: In function 'max77693_irq_init':
> drivers/mfd/max77693-irq.c:286:2: error: implicit declaration of function 'irq_domain_add_linear'
> drivers/mfd/max77693-irq.c:286:9: warning: assignment makes pointer from integer without a cast
> make[3]: *** [drivers/mfd/max77693-irq.o] Error 1
> 
> 
> Full randconfig file is attached.
This should be fixed in my for-next branch now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
