Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab0GITTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:19:45 -0400
Received: from kroah.org ([198.145.64.141]:39825 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab0GITTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:19:42 -0400
Date: Fri, 9 Jul 2010 12:18:25 -0700
From: Greg KH <greg@kroah.com>
To: Thomas Renninger <trenn@suse.de>
Cc: lenb@kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       platform-driver-x86@vger.kernel.org, astarikovskiy@suse.de,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 1/6] ACPI: Provide /sys/devices/system/ec/
Message-ID: <20100709191825.GB8989@kroah.com>
References: <1277996570-2686-1-git-send-email-trenn@suse.de>
 <1277996570-2686-2-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277996570-2686-2-git-send-email-trenn@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 05:02:45PM +0200, Thomas Renninger wrote:
> This patch provides the same information through sysfs, which previously was
> provided through /proc/acpi/embedded_controller/*/info
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> 
> CC: Alexey Starikovskiy <astarikovskiy@suse.de>
> CC: Len Brown <lenb@kernel.org>
> CC: linux-kernel@vger.kernel.org
> CC: linux-acpi@vger.kernel.org
> CC: Bjorn Helgaas <bjorn.helgaas@hp.com>
> CC: platform-driver-x86@vger.kernel.org
> 
> Index: linux-2.6.34-master/drivers/acpi/Kconfig
> ===================================================================
> ---
>  drivers/acpi/Kconfig    |   13 +++++++
>  drivers/acpi/Makefile   |    1 +
>  drivers/acpi/ec.c       |   18 +++-------
>  drivers/acpi/ec_sys.c   |   92 +++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/internal.h |   24 ++++++++++++
>  5 files changed, 135 insertions(+), 13 deletions(-)
>  create mode 100644 drivers/acpi/ec_sys.c
> 
> diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
> index 7464115..f13708a 100644
> --- a/drivers/acpi/Kconfig
> +++ b/drivers/acpi/Kconfig
> @@ -104,6 +104,19 @@ config ACPI_SYSFS_POWER
>  	help
>  	  Say N to disable power /sys interface
>  
> +config ACPI_EC_SYSFS
> +	tristate "EC read/write access through sysfs"

As you are adding new sysfs files, please document them in
Documentation/ABI/

thanks,

greg k-h
