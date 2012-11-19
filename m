Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2KSR7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:59:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:54699 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab2KSR7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:59:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,280,1352102400"; 
   d="scan'208";a="219779111"
Date: Mon, 19 Nov 2012 18:58:58 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: ciminaghi@gnudd.com
Cc: rubini@gnudd.com, giancarlo.asnaghi@st.com,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/10] sta2x11-mfd patches
Message-ID: <20121119175858.GI18738@sortiz-mobl>
References: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352470801-2418-1-git-send-email-ciminaghi@gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

On Fri, Nov 09, 2012 at 03:19:51PM +0100, ciminaghi@gnudd.com wrote:
> From: Davide Ciminaghi <ciminaghi@gnudd.com>
> 
> Hi,
> 
> this is v3 of a patchset submitted on
> 2012/10/22 (see https://lkml.org/lkml/2012/10/22/290)
> and 2012/09/12 (see https://lkml.org/lkml/2012/9/12/139).
> Here's a summary of changes in v3:
> 
> * Regmap support fix:
> sta2x11_apb_soc_regs_writeable_reg() fixed as
> suggested by Mark Brown
> (see https://lkml.org/lkml/2012/10/23/448)
> 
> * Regmap support fix: regmap field in struct
> sta2x11_mfd (a single struct regmap * in v2) becomes
> an array of struct regmap pointers, one per platform
> device.
> 
> Davide Ciminaghi (10):
>   drivers/mfd/sta2x11-mfd: add apb-soc regs driver and factor out
>     common code
>   drivers/mfd/sta2x11-mfd: add regmap support
>   drivers/mfd/sta2x11-mfd: add sta2x11_mfd_get_regs_data() function
>   drivers/mfd/sta2x11-mfd: use defines for platform devices' names
>   drivers/mfd/sta2x11-mfd: only add sta2x11_mfd if it hasn't already
>     been added
>   drivers/mfd/sta2x11-mfd: platform probe: don't mind about gpio
>     platform data
>   drivers/mfd/sta2x11-mfd: use one lock per device instead of one lock
>     per mfd
>   drivers/mfd/sta2x11-mfd: add scr (otp registers) platform driver
>   drivers/mfd/sta2x11-mfd: add defines for some sta2x11 sctl registers
>   drivers/mfd/sta2x11-mfd: add myself to copyright
> 
>  drivers/mfd/Kconfig             |    1 +
>  drivers/mfd/sta2x11-mfd.c       |  532 +++++++++++++++++++++++++++------------
>  include/linux/mfd/sta2x11-mfd.h |  198 ++++++++++++++-
>  3 files changed, 574 insertions(+), 157 deletions(-)
Thanks, all 10 patches applied now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
