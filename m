Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab1CYPAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:00:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60886 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab1CYPAc (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 25 Mar 2011 11:00:32 -0400
Date: Fri, 25 Mar 2011 10:59:43 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 07/21]drivers:xen Remove extra comma.
Message-ID: <20110325145943.GE27651@dumpdata.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
 <1300994819-30930-7-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300994819-30930-7-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D8CADE0.0076,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 12:26:45PM -0700, Justin P. Mattock wrote:
> The patch below removes an extra comma from various parts 
> of the kernel. Please have a look when you have time, and let
> me know if its legit or not.

Looks ok.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> 
> ---
>  drivers/xen/evtchn.c      |    2 +-
>  drivers/xen/swiotlb-xen.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
> index ef11daf..dbc13e9 100644
> --- a/drivers/xen/evtchn.c
> +++ b/drivers/xen/evtchn.c
> @@ -470,7 +470,7 @@ static int evtchn_open(struct inode *inode, struct file *filp)
>  
>  	filp->private_data = u;
>  
> -	return nonseekable_open(inode, filp);;
> +	return nonseekable_open(inode, filp);
>  }
>  
>  static int evtchn_release(struct inode *inode, struct file *filp)
> diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
> index 54469c3..65ea21a 100644
> --- a/drivers/xen/swiotlb-xen.c
> +++ b/drivers/xen/swiotlb-xen.c
> @@ -54,7 +54,7 @@ u64 start_dma_addr;
>  
>  static dma_addr_t xen_phys_to_bus(phys_addr_t paddr)
>  {
> -	return phys_to_machine(XPADDR(paddr)).maddr;;
> +	return phys_to_machine(XPADDR(paddr)).maddr;
>  }
>  
>  static phys_addr_t xen_bus_to_phys(dma_addr_t baddr)
> -- 
> 1.7.4.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
