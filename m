Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382Ab1BKWmg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:42:36 -0500
Received: from void.printf.net ([89.145.121.20]:57843 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab1BKWmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:42:35 -0500
Date: Fri, 11 Feb 2011 22:42:34 +0000
From: Chris Ball <cjb@laptop.org>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: add ricoh e823 pci id
Message-ID: <20110211224234.GA1958@void.printf.net>
References: <1297463131-3557-1-git-send-email-manoj.iyer@canonical.com> <1297463131-3557-2-git-send-email-manoj.iyer@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297463131-3557-2-git-send-email-manoj.iyer@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Manoj,

On Fri, Feb 11, 2011 at 04:25:31PM -0600, Manoj Iyer wrote:
> Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
> ---
>  drivers/mmc/host/sdhci-pci.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
> index 0dc905b..f7e622c 100644
> --- a/drivers/mmc/host/sdhci-pci.c
> +++ b/drivers/mmc/host/sdhci-pci.c
> @@ -547,6 +547,14 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
>  	},
>  
>  	{
> +		.vendor         = PCI_VENDOR_ID_RICOH,
> +		.device         = 0xe823,
> +		.subvendor      = PCI_ANY_ID,
> +		.subdevice      = PCI_ANY_ID,
> +		.driver_data    = (kernel_ulong_t)&sdhci_ricoh_mmc,
> +	},
> +
> +	{
>  		.vendor		= PCI_VENDOR_ID_ENE,
>  		.device		= PCI_DEVICE_ID_ENE_CB712_SD,
>  		.subvendor	= PCI_ANY_ID,

Thanks, pushed to mmc-next for .39.

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
