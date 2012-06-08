Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761994Ab2FHITg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:19:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:63154 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761558Ab2FHITd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:19:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="153382296"
Date: Fri, 8 Jun 2012 10:30:03 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, t-kristo@ti.com,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] MFD: twl6040: Update Kconfig to avoid build breakage
Message-ID: <20120608083003.GI22557@sortiz-mobl>
References: <1339137300-16546-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339137300-16546-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, Jun 08, 2012 at 09:35:00AM +0300, Peter Ujfalusi wrote:
> twl6040 needs CONFIG_IRQ_DOMAIN to compile, without this we have:
> drivers/mfd/twl6040-irq.c: In function 'twl6040_irq_init':
> drivers/mfd/twl6040-irq.c:164:2: error: implicit declaration of function 'irq_domain_add_legacy'
> drivers/mfd/twl6040-irq.c:165:11: error: 'irq_domain_simple_ops' undeclared (first use in this function)
> drivers/mfd/twl6040-irq.c:165:11: note: each undeclared identifier is reported only once for each function it appears in
> 
> Reported by: Randy Dunlap <rdunlap@xenotime.net>
> 
> At the same time limit the twl6040 availability to ARM architecture since
> it is unlikely that this chip is going to be used on other architectures.
Right, but you're losing a lot of the linux-next build coverage.
With a dependency on ARM, we may have missed the above build error for
example. Would you mind removing that dependency ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
