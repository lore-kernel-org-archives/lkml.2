Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322Ab2IKKSO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:18:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:7225 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752577Ab2IKKSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:18:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,402,1344236400"; 
   d="scan'208";a="191539078"
Date: Tue, 11 Sep 2012 12:18:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: arizona: Suppress needless calls to the primary IRQ
Message-ID: <20120911101810.GN3647@sortiz-mobl>
References: <1345575723-15794-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345575723-15794-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Aug 21, 2012 at 08:02:03PM +0100, Mark Brown wrote:
> We can read back if the primary IRQ is asserted from the register map,
> meaning that we can suppress polling of the interrupt status registers
> when only the AoD IRQ domain is asserting.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-irq.c |   18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
Applied, thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
