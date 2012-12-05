Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab2LEMpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:45:35 -0500
Received: from mga03.intel.com ([143.182.124.21]:2668 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab2LEMpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:45:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,221,1355126400"; 
   d="scan'208";a="176446943"
Date: Wed, 5 Dec 2012 14:48:46 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] ACPI / PM: Fix header of acpi_dev_pm_detach() in acpi.h
Message-ID: <20121205124846.GV3117@intel.com>
References: <3898205.CQSHFfLUWL@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3898205.CQSHFfLUWL@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 12:08:12PM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The header of acpi_dev_pm_detach() in include/linux/acpi.h has an
> incorrect return type, which should be void.  Fix that.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

> ---
>  include/linux/acpi.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/include/linux/acpi.h
> ===================================================================
> --- linux.orig/include/linux/acpi.h
> +++ linux/include/linux/acpi.h
> @@ -506,7 +506,7 @@ static inline int acpi_subsys_resume_ear
>  
>  #if defined(CONFIG_ACPI) && defined(CONFIG_PM)
>  int acpi_dev_pm_attach(struct device *dev, bool power_on);
> -int acpi_dev_pm_detach(struct device *dev, bool power_off);
> +void acpi_dev_pm_detach(struct device *dev, bool power_off);
>  #else
>  static inline int acpi_dev_pm_attach(struct device *dev, bool power_on)
>  {
