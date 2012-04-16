Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2DPPzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:55:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:15004 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab2DPPzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:55:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="142354540"
Date: Mon, 16 Apr 2012 18:04:33 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: linux-kernel@vger.kernel.org, philipp.zabel@gmail.com
Subject: Re: [PATCH v2] mfd: asic3: Set DS1WM clock_rate
Message-ID: <20120416160433.GK24130@sortiz-mobl>
References: <1333973911.59189.YahooMailClassic@web29014.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333973911.59189.YahooMailClassic@web29014.mail.ird.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Mon, Apr 09, 2012 at 01:18:31PM +0100, Paul Parsons wrote:
> The mfd/asic3 driver does not set the ds1wm_driver_data clock_rate field
> before passing the structure to the DS1WM w1 busmaster driver.
> This was not noticed before commit 26a6afb, because ds1wm_find_divisor()
> unintentionally returned the correct divisor when a zero clock_rate was
> passed in. However after that commit DS1WM fails a zero clock_rate:
> 
> ds1wm ds1wm: no suitable divisor for 0Hz clock
> 
> This patch sets the ds1wm_driver_data clock_rate field.
> 
> Signed-off-by: Paul Parsons <lost.distance@yahoo.com>
> Cc: Philipp Zabel <philipp.zabel@gmail.com>
> ---
> 
> V2:
> Separated arch/arm/mach-pxa/hx4700.c changes into a separate patch,
> to avoid crossing maintainer boundaries.
> This patch now submitted to linux-kernel instead of linux-arm-kernel.
> Rebased from linux-3.0.1 to linux-3.4-rc2.
> 
>  drivers/mfd/asic3.c       |    9 ++++++---
>  include/linux/mfd/asic3.h |    2 ++
>  2 files changed, 8 insertions(+), 3 deletions(-)
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
