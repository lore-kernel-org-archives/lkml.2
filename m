Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643Ab0FUKZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 06:25:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:23452 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537Ab0FUKZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 06:25:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,452,1272870000"; 
   d="scan'208";a="809881266"
Date: Mon, 21 Jun 2010 12:25:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, kyungmin.park@samsung.com
Subject: Re: [PATCH v3] drivers: regulator: add Maxim 8998 driver
Message-ID: <20100621102528.GA22491@sortiz-mobl>
References: <1276671856-18902-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276671856-18902-1-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 09:04:16AM +0200, Marek Szyprowski wrote:
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> This patch adds voltage regulator driver for Maxim 8998 chip. This chip
> is used on Samsung Aquila and GONI boards and provides following
> functionalities:
> - 4 BUCK voltage converters, 17 LDO power regulators and 5 other power
>   controllers
> - battery charger
> 
> This patch adds basic driver for voltage regulators and MAX 8998 MFD core.
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Looks good to me:
Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
