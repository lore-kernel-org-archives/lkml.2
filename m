Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab0HaHN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 03:13:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:51850 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932172Ab0HaHN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 03:13:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,297,1280732400"; 
   d="scan'208";a="319050062"
Date: Tue, 31 Aug 2010 15:39:36 +0800
From: Feng Tang <feng.tang@intel.com>
To: Yong Wang <yong.y.wang@linux.intel.com>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <alan@linux.intel.com>
Subject: Re: [PATCH] spi/dw_spi: Enable Intel Moorestown SPI controller 1
Message-ID: <20100831153936.2ca0475c@feng-i7>
In-Reply-To: <20100831061416.GA5904@ywang-moblin2.bj.intel.com>
References: <20100831061416.GA5904@ywang-moblin2.bj.intel.com>
Organization: intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


NAK.

We should not export SPI1 has x86 core has no way to access its register.
though the device physically exists.

Thanks,
Feng

On Tue, 31 Aug 2010 14:14:16 +0800
Yong Wang <yong.y.wang@linux.intel.com> wrote:

> Enable Intel Moorestown SPI controller 1
> 
> Signed-off-by: Yong Wang <yong.y.wang@intel.com>
> ---
>  drivers/spi/dw_spi_pci.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/spi/dw_spi_pci.c b/drivers/spi/dw_spi_pci.c
> index 1f52755..eec9d0b 100644
> --- a/drivers/spi/dw_spi_pci.c
> +++ b/drivers/spi/dw_spi_pci.c
> @@ -142,6 +142,8 @@ static int spi_resume(struct pci_dev *pdev)
>  static const struct pci_device_id pci_ids[] __devinitdata = {
>  	/* Intel Moorestown platform SPI controller 0 */
>  	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0800) },
> +	/* Intel Moorestown platform SPI controller 1 */
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0801) },
>  	{},
>  };
>  
