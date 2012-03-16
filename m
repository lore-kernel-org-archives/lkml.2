Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2CPSiP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 14:38:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:39222 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab2CPSiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 14:38:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129842966"
Date: Fri, 16 Mar 2012 19:46:09 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/4] mfd/ab8500: don't use mutex_lock_interruptible
Message-ID: <20120316184609.GN20524@sortiz-mobl>
References: <1331211706-9763-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331211706-9763-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Mar 08, 2012 at 02:01:46PM +0100, Linus Walleij wrote:
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> This disadvantage of having it interruptible is that it would
> appear to work OK in most situations, but in the rare case
> that this call does fail, it can lead to misconfiguration
> of the AB, such as a regulator not being turned off and
> leading to a platform power consumption increase.
> 
> There's no real benefit to having this interruptible.
> 
> Make it a plain mutex_lock. The non-interruptability matches
> other low-level I/O functions such as SPI and I2C.
> 
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/mfd/ab8500-core.c |   12 +++---------
>  1 files changed, 3 insertions(+), 9 deletions(-)
All 4 patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
