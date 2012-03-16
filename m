Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab2CPVFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:05:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:5375 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab2CPVFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:05:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140144992"
Date: Fri, 16 Mar 2012 14:05:42 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Gerard Snitselaar <dev@snitselaar.org>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: xhci: fix section mismatch in linux-next
Message-ID: <20120316210542.GG6077@xanatos>
References: <1331922851-28513-1-git-send-email-dev@snitselaar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331922851-28513-1-git-send-email-dev@snitselaar.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks fine.  Does it need to be applied to stable as well, or is this
just a "nice to have" that should be queued for 3.4?

Sarah Sharp

On Fri, Mar 16, 2012 at 11:34:11AM -0700, Gerard Snitselaar wrote:
> xhci_unregister_pci() is called in xhci_hcd_init().
> 
> Signed-off-by: Gerard Snitselaar <dev@snitselaar.org>
> ---
>  drivers/usb/host/xhci-pci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
> index ef98b38..0d7b851 100644
> --- a/drivers/usb/host/xhci-pci.c
> +++ b/drivers/usb/host/xhci-pci.c
> @@ -326,7 +326,7 @@ int __init xhci_register_pci(void)
>  	return pci_register_driver(&xhci_pci_driver);
>  }
>  
> -void __exit xhci_unregister_pci(void)
> +void xhci_unregister_pci(void)
>  {
>  	pci_unregister_driver(&xhci_pci_driver);
>  }
> -- 
> 1.7.7.6
> 
