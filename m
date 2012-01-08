Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2AHXLE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 18:11:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:11563 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab2AHXLC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 18:11:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="54494681"
Date: Mon, 9 Jan 2012 00:16:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] regulator: Add S5M8767A regulator driver
Message-ID: <20120108231657.GD13679@sortiz-mobl>
References: <1325225153-32389-1-git-send-email-sbkim73@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325225153-32389-1-git-send-email-sbkim73@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangbeom, Mark,

On Fri, Dec 30, 2011 at 03:05:53PM +0900, Sangbeom Kim wrote:
> S5M8767A is a cost-effective PMIC which is designed for mobile applications.
> It includes high efficient 9 Buck converters, 28 LDOs.
> Especially, S5M8767A is optimized for Multi-core SOCs.
> And during DVFS operation, S5M8767A output stable voltage.
> This patch implement regulator driver for S5M8767A.
> 
> Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
> ---
>  Changes since v3:
>  As Mark Brown comments
>  - Modify return value for get_voltage_sel
>  - Romove h/w access routine in the set_voltage_time_sel
>  - Replace kzalloc with devm_kzalloc
Mark, are you ok with this one ? As it depends on the previous MFD patches,
I'll have to take it through the MFD tree.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
