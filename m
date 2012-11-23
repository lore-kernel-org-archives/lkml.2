Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab2KWNWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 08:22:09 -0500
Received: from mga03.intel.com ([143.182.124.21]:5647 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab2KWNWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 08:22:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,307,1352102400"; 
   d="scan'208";a="221455884"
Date: Fri, 23 Nov 2012 15:25:18 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ACPI: add SDHCI to ACPI platform devices
Message-ID: <20121123132518.GZ3867@intel.com>
References: <1353670561-22515-1-git-send-email-adrian.hunter@intel.com>
 <1353670561-22515-3-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353670561-22515-3-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 01:36:00PM +0200, Adrian Hunter wrote:
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

> ---
>  drivers/acpi/scan.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 8c4ac6d..67a7fa6 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -35,6 +35,8 @@ static const char *dummy_hid = "device";
>   */
>  static const struct acpi_device_id acpi_platform_device_ids[] = {
>  
> +	{ "PNP0D40" },
> +
>  	{ }
>  };
>  
> -- 
> 1.7.11.7
