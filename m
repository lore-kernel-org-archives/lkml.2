Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab2KTLrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:47:45 -0500
Received: from mga11.intel.com ([192.55.52.93]:18254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104Ab2KTLro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:47:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,285,1352102400"; 
   d="scan'208";a="249934467"
Date: Tue, 20 Nov 2012 12:47:40 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/5] mfd: arizona: Updates for v3.7
Message-ID: <20121120114740.GO18738@sortiz-mobl>
References: <20121120044544.GF4483@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120044544.GF4483@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Nov 20, 2012 at 01:45:47PM +0900, Mark Brown wrote:
>  drivers/mfd/arizona-core.c  |   14 +-
>  drivers/mfd/arizona-irq.c   |    1 +
>  drivers/mfd/wm5102-tables.c |  519 +------------------------------------------
>  3 files changed, 13 insertions(+), 521 deletions(-)
All 5 patches applied to my for-linus branch, thanks.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
