Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab2AXHea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 02:34:30 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:14955 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2AXHe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 02:34:28 -0500
Date: Tue, 24 Jan 2012 08:34:16 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.d.ralston@intel.com
Subject: Re: [PATCH 4/6] i2c-i801: SMBus patch for Intel Lynx Point
 DeviceIDs
Message-ID: <20120124083416.00c582d0@endymion.delvare>
In-Reply-To: <201201231637.36362.seth.heasley@intel.com>
References: <201201231637.36362.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 16:37:36 -0800, Seth Heasley wrote:
> This patch adds the SMBus controller DeviceIDs for the Intel Lynx Point PCH.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> ---
>  Documentation/i2c/busses/i2c-i801 |    1 +
>  drivers/i2c/busses/Kconfig        |    1 +
>  drivers/i2c/busses/i2c-i801.c     |    3 +++
>  3 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/i2c/busses/i2c-i801 b/Documentation/i2c/busses/i2c-i801
> index 2871fd5..71f55bb 100644
> --- a/Documentation/i2c/busses/i2c-i801
> +++ b/Documentation/i2c/busses/i2c-i801
> @@ -20,6 +20,7 @@ Supported adapters:
>    * Intel Patsburg (PCH)
>    * Intel DH89xxCC (PCH)
>    * Intel Panther Point (PCH)
> +  * Intel Lynx Point (PCH)
>     Datasheets: Publicly available at the Intel website
>  
>  On Intel Patsburg and later chipsets, both the normal host SMBus controller
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index a3afac4..ff64291 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -103,6 +103,7 @@ config I2C_I801
>  	    Patsburg (PCH)
>  	    DH89xxCC (PCH)
>  	    Panther Point (PCH)
> +	    Lynx Point (PCH)
>  
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called i2c-i801.
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index ab26840d..f9c3ca0 100644
> --- a/drivers/i2c/busses/i2c-i801.c
> +++ b/drivers/i2c/busses/i2c-i801.c
> @@ -51,6 +51,7 @@
>    Patsburg (PCH) IDF    0x1d72     32     hard     yes     yes     yes
>    DH89xxCC (PCH)        0x2330     32     hard     yes     yes     yes
>    Panther Point (PCH)   0x1e22     32     hard     yes     yes     yes
> +  Lynx Point (PCH)      0x8c22     32     hard     yes     yes     yes
>  
>    Features supported by this driver:
>    Software PEC                     no
> @@ -145,6 +146,7 @@
>  #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS	0x1e22
>  #define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
>  #define PCI_DEVICE_ID_INTEL_5_3400_SERIES_SMBUS	0x3b30
> +#define PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS	0x8c22
>  
>  struct i801_priv {
>  	struct i2c_adapter adapter;
> @@ -633,6 +635,7 @@ static const struct pci_device_id i801_ids[] = {
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS_IDF2) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_PANTHERPOINT_SMBUS) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_LYNXPOINT_SMBUS) },
>  	{ 0, }
>  };
>  

Applied, thanks.

-- 
Jean Delvare
