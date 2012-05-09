Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab2EIOiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:38:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:40228 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759767Ab2EIOiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:38:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="138661243"
Date: Wed, 9 May 2012 16:47:42 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: Guenter Roeck <guenter@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Peter Tyser <ptyser@xes-inc.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] watchdog: Convert iTCO_wdt driver to mfd model
Message-ID: <20120509144742.GJ1794@sortiz-mobl>
References: <ebd93f32-72b5-4452-b90d-5a15adb2f509@zimbra>
 <14a70d68-3e8a-43e8-9f8b-bfeedecac456@zimbra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14a70d68-3e8a-43e8-9f8b-bfeedecac456@zimbra>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaron,

On Fri, Apr 20, 2012 at 02:14:11PM -0500, Aaron Sierra wrote:
> This patch converts the iTCO_wdt driver to use the multi-function device
> driver model. It uses resources discovered by the lpc_ich driver, so that
> it no longer does its own PCI scanning.
> 
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/mfd/Kconfig                    |    3 +-
>  drivers/mfd/lpc_ich.c                  |  171 ++++++++++-
>  drivers/watchdog/Kconfig               |    1 +
>  drivers/watchdog/iTCO_vendor.h         |    6 +-
>  drivers/watchdog/iTCO_vendor_support.c |   43 ++--
>  drivers/watchdog/iTCO_wdt.c            |  529 +++++++-------------------------
>  include/linux/mfd/lpc_ich.h            |    7 +
>  7 files changed, 313 insertions(+), 447 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
