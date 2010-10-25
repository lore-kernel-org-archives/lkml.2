Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0JYMM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:12:58 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:57962 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab0JYMM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:12:57 -0400
Date: Mon, 25 Oct 2010 09:59:30 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: Add __devexit annotation for vx855_remove
Message-ID: <20101025075930.GB5411@prithivi.gnumonks.org>
References: <1287973925.23608.8.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287973925.23608.8.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Harald Welte <HaraldWelte@viatech.com>

On Mon, Oct 25, 2010 at 10:32:05AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/vx855.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/vx855.c b/drivers/mfd/vx855.c
> index ebb0597..348052a 100644
> --- a/drivers/mfd/vx855.c
> +++ b/drivers/mfd/vx855.c
> @@ -112,7 +112,7 @@ out:
>  	return ret;
>  }
>  
> -static void vx855_remove(struct pci_dev *pdev)
> +static void __devexit vx855_remove(struct pci_dev *pdev)
>  {
>  	mfd_remove_devices(&pdev->dev);
>  	pci_disable_device(pdev);
> -- 
> 1.7.2

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
