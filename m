Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab2IPXLw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 19:11:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:14088 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab2IPXLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 19:11:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,432,1344236400"; 
   d="scan'208";a="205674801"
Date: Mon, 17 Sep 2012 01:11:48 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com,
        ldewangan@nvidia.com, kyle.manna@fuel7.com,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH v3] rtc: tps65910: Add RTC driver for TPS65910 PMIC RTC
Message-ID: <20120916231148.GL3647@sortiz-mobl>
References: <1344430022-2779-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344430022-2779-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venu,

On Wed, Aug 08, 2012 at 06:17:02PM +0530, Venu Byravarasu wrote:
> TPS65910 PMIC is a MFD with RTC as one of the device.
> Adding RTC driver for supporting RTC device present
> inside TPS65910 PMIC.
> 
> Only support for RTC alarm is implemented as part of this patch.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
For the MFD changes:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
