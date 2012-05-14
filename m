Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab2ENU5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 16:57:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:61558 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400Ab2ENU5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 16:57:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="143886594"
Date: Mon, 14 May 2012 23:07:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: wm8994: Update to fully use irq_domain
Message-ID: <20120514210702.GJ12740@sortiz-mobl>
References: <1336935442-1920-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336935442-1920-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Sun, May 13, 2012 at 07:57:22PM +0100, Mark Brown wrote:
> Take advantage of the new regmap irq_domain support to dynamically
> allocate interrupts, using regmap_irq_get_virq() rather than irq_base
> to look up the interrupts. This means that most users should not need
> to specify an irq_base at all.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> The regmap-irq irq_domain support is only in -next, is it OK to merge
> this via regmap?  There's no massive urgency but it'd be nice.
Fine with me:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
