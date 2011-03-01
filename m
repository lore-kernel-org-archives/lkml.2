Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1CAWvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 17:51:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:53035 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab1CAWvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 17:51:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,249,1297065600"; 
   d="scan'208";a="662815793"
Date: Tue, 1 Mar 2011 14:51:20 -0800
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ozan Caglayan <ozan@pardus.org.tr>
Subject: Re: 2.6.38 regression caused by commit 415e12b
Message-ID: <20110301225058.GA2294@xanatos>
References: <20110228014218.GA11083@xanatos>
 <201102282129.56835.rjw@sisk.pl>
 <20110301183057.GA2359@xanatos>
 <201103012155.34182.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103012155.34182.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 09:55:33PM +0100, Rafael J. Wysocki wrote:
> Please check if the appended patch (on top of the Linus' current) helps.

Sorry, it doesn't help.  Same message as before.

Sarah

> ---
>  drivers/acpi/pci_root.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> Index: linux-2.6/drivers/acpi/pci_root.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/pci_root.c
> +++ linux-2.6/drivers/acpi/pci_root.c
> @@ -48,10 +48,7 @@ static int acpi_pci_root_add(struct acpi
>  static int acpi_pci_root_remove(struct acpi_device *device, int type);
>  static int acpi_pci_root_start(struct acpi_device *device);
>  
> -#define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT \
> -				| OSC_ACTIVE_STATE_PWR_SUPPORT \
> -				| OSC_CLOCK_PWR_CAPABILITY_SUPPORT \
> -				| OSC_MSI_SUPPORT)
> +#define ACPI_PCIE_REQ_SUPPORT (OSC_EXT_PCI_CONFIG_SUPPORT | OSC_MSI_SUPPORT)
>  
>  static const struct acpi_device_id root_device_ids[] = {
>  	{"PNP0A03", 0},
