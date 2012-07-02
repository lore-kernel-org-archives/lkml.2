Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab2GBOYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 10:24:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:48705 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838Ab2GBOYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:24:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163116976"
Date: Mon, 2 Jul 2012 16:35:35 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Misael Lopez Cruz <misael.lopez@ti.com>
Subject: Re: [PATCH] mfd: TWL6040_CORE needs to select IRQ_DOMAIN
Message-ID: <20120702143535.GH22065@sortiz-mobl>
References: <1340156457.13830.1.camel@phoenix>
 <4FE22A53.9090309@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FE22A53.9090309@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Wed, Jun 20, 2012 at 12:53:55PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@xenotime.net>
> 
> Fix build error by selecting IRQ_DOMAIN:
> 
> drivers/mfd/twl6040-irq.c:164:2: error: implicit declaration of function 'irq_domain_add_legacy'
> drivers/mfd/twl6040-irq.c:165:11: error: 'irq_domain_simple_ops' undeclared (first use in this function)
This should also be fixed with MFD_CORE selecting IRQ_DOMAIN now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
