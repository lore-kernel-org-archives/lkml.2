Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab1CQX5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 19:57:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:44697 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab1CQX5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 19:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,202,1299484800"; 
   d="scan'208";a="404396761"
Date: Fri, 18 Mar 2011 00:57:02 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Alessandro Zummo <a.zummo@towertech.it>, Joe Perches <joe@perches.com>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com
Subject: Re: [PATCH v6 1/2] MAX8997/8966 MFD: Add IRQ control feature
Message-ID: <20110317235701.GH32172@sortiz-mobl>
References: <1300239551-21285-1-git-send-email-myungjoo.ham@samsung.com>
 <1300239551-21285-2-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300239551-21285-2-git-send-email-myungjoo.ham@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi MyungJoo,

On Wed, Mar 16, 2011 at 10:39:10AM +0900, MyungJoo Ham wrote:
> This patch enables IRQ handling for MAX8997/8966 chips.
> 
> Please note that Fuel-Gauge-related IRQs are not implemented in this
> initial release. The fuel gauge module in MAX8997 is identical to
> MAX17042, which is already in Linux kernel. In order to use the
> already-existing MAX17042 driver for fuel gauge module in MAX8997, the
> main interrupt handler of MAX8997 should relay related interrupts to
> MAX17042 driver. However, in order to do this, we need to modify
> MAX17042 driver as well because MAX17042 driver does not have any
> interrupt handlers for now. We are not going to implement this in this
> initial release as it is not crucial in basic operations of MAX8997.
> 
> The IRQ handling of MAX8997/8966 MFD relays IRQ handlers to
> PMIC, MUIC, GPIO, and FLASH. Note that PMIC-IRQ handles RTC and Charger
> related inetrrupts as well.
Thanks a lot, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
