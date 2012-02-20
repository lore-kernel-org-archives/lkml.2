Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab2BTRdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:33:24 -0500
Received: from mga03.intel.com ([143.182.124.21]:51314 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab2BTRdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:33:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="68395102"
Date: Mon, 20 Feb 2012 18:40:32 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com, mad_soft@inbox.ru,
        koen@dominion.thruhere.net
Subject: Re: [PATCH] mfd: asic3: Add to_irq() member to gpio_chip structure
Message-ID: <20120220174032.GK5387@sortiz-mobl>
References: <1327972715.82506.YahooMailClassic@web29004.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327972715.82506.YahooMailClassic@web29004.mail.ird.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Jan 31, 2012 at 01:18:35AM +0000, Paul Parsons wrote:
> The gpio_to_irq() macro is now defined as __gpio_to_irq() instead of IRQ_GPIO().
> The __gpio_to_irq() function returns -ENXIO if the referenced gpio_chip
> structure does not define a to_irq() member.
> This is true of the asic3 gpio_chip structure, and thus calls to gpio_to_irq()
> now fail (for example from the gpio-vbus module).
> This patch defines the to_irq() member in the asic3 gpio_chip structure.
Good old asic3...Thanks, I applied this one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
