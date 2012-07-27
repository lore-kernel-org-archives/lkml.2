Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab2G0N2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 09:28:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:7774 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab2G0N2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 09:28:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="198930107"
Date: Fri, 27 Jul 2012 15:28:10 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: a.zummo@towertech.it, broonie@opensource.wolfsonmicro.com,
        ldewangan@nvidia.com, kyle.manna@fuel7.com, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc: tps65910: Add RTC driver for TPS65910 PMIC RTC
Message-ID: <20120727132810.GO16859@sortiz-mobl>
References: <1343284519-30505-1-git-send-email-vbyravarasu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343284519-30505-1-git-send-email-vbyravarasu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Venu,

On Thu, Jul 26, 2012 at 12:05:19PM +0530, Venu Byravarasu wrote:
> TPS65910 PMIC is a MFD with RTC as one of the device.
> Adding RTC driver for supporting RTC device present
> inside TPS65910 PMIC.
> 
> Only support for RTC alarm is implemented as part of this patch.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> 
>  drivers/rtc/Kconfig          |   10 ++
>  drivers/rtc/Makefile         |    1 +
>  drivers/rtc/rtc-tps65910.c   |  353 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/tps65910.h |   10 ++
>  4 files changed, 374 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/rtc/rtc-tps65910.c
For the MFD parts:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
