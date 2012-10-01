Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab2JAMEE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:04:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:29064 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab2JAMEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:04:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,515,1344236400"; 
   d="scan'208";a="217451959"
Date: Mon, 1 Oct 2012 14:03:43 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, b-cousson@ti.com, balbi@ti.com,
        santosh.shilimkar@ti.com
Subject: Re: [PATCHv3 1/4] mfd: smsc: Add support for smsc gpio io/keypad
 driver
Message-ID: <20121001120343.GG12231@sortiz-mobl>
References: <1349089282-22105-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349089282-22105-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sourav,

On Mon, Oct 01, 2012 at 04:31:22PM +0530, Sourav Poddar wrote:
> smsc ece1099 is a keyboard scan or gpio expansion device.
> The patch create keypad and gpio expander child for this
> multi function smsc driver.
> 
> Tested on omap5430 evm with 3.6-rc6 custom kernel.
> 
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
> Changes since v2:
>  - Change the cache type, max register assignment
>  - remove of_device_table, since i2c based device gets 
> probed according to i2c_device_id through dt.
>  - Modify the remove function
>  - Minor return patch cleanups.
>  Documentation/smsc_ece1099.txt |   56 ++++++++++++++++++++
>  drivers/mfd/Kconfig            |   12 ++++
>  drivers/mfd/Makefile           |    1 +
>  drivers/mfd/smsc-ece1099.c     |  113 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/smsc.h       |  109 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 291 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/smsc_ece1099.txt
>  create mode 100644 drivers/mfd/smsc-ece1099.c
>  create mode 100644 include/linux/mfd/smsc.h
Applied with a warning fix for the !CONFIG_OF case.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
