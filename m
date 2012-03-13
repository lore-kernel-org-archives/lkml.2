Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743Ab2CMRZX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 13:25:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42925 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758691Ab2CMRZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 13:25:21 -0400
Date: Tue, 13 Mar 2012 10:25:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Chris Ball <cjb@laptop.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Adrian Hunter <adrian.hunter@intel.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/3] mmc: sdhci-pci: allow 8-bit bus width for Intel PCH
Message-ID: <20120313172514.GA28309@kroah.com>
References: <1331659002-13743-1-git-send-email-alexander.stein@systec-electronic.com>
 <1331659002-13743-3-git-send-email-alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331659002-13743-3-git-send-email-alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 06:16:42PM +0100, Alexander Stein wrote:
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2800,6 +2800,8 @@
>  #define PCI_DEVICE_ID_INTEL_82454NX     0x84cb
>  #define PCI_DEVICE_ID_INTEL_84460GX	0x84ea
>  #define PCI_DEVICE_ID_INTEL_IXP4XX	0x8500
> +#define PCI_DEVICE_ID_INTEL_PCH_SDIO0	0x8809
> +#define PCI_DEVICE_ID_INTEL_PCH_SDIO1	0x880a
>  #define PCI_DEVICE_ID_INTEL_IXP2800	0x9004
>  #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152

Did you read the comment at the top of this file before adding your new
device ids?

If not, please do so, and redo your patch.

thanks,

greg k-h
