Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab1CAPej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:34:39 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:35902 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1CAPei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:34:38 -0500
Message-ID: <4D6D1208.6020001@ge.com>
Date: Tue, 01 Mar 2011 15:34:32 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, wfp5p@virginia.edu, cota@braap.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: vme: remove unreachable code
References: <1298759775-7822-1-git-send-email-manohar.vanga@cern.ch> <1298759775-7822-2-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1298759775-7822-2-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Mar 2011 15:34:22.0668 (UTC) FILETIME=[238840C0:01CBD826]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/11 22:36, Manohar Vanga wrote:
> Remove some unreachable code (kfree calls) from vme.c
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/vme.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
> index d9fc864..bbf58dc 100644
> --- a/drivers/staging/vme/vme.c
> +++ b/drivers/staging/vme/vme.c
> @@ -441,7 +441,6 @@ struct vme_resource *vme_master_request(struct device *dev,
>  
>  	return resource;
>  
> -	kfree(resource);
>  err_alloc:
>  	/* Unlock image */
>  	spin_lock(&master_image->lock);
> @@ -768,7 +767,6 @@ struct vme_dma_attr *vme_dma_pattern_attribute(u32 pattern,
>  
>  	return attributes;
>  
> -	kfree(pattern_attr);
>  err_pat:
>  	kfree(attributes);
>  err_attr:
> @@ -809,7 +807,6 @@ struct vme_dma_attr *vme_dma_pci_attribute(dma_addr_t address)
>  
>  	return attributes;
>  
> -	kfree(pci_attr);
>  err_pci:
>  	kfree(attributes);
>  err_attr:
> @@ -851,7 +848,6 @@ struct vme_dma_attr *vme_dma_vme_attribute(unsigned long long address,
>  
>  	return attributes;
>  
> -	kfree(vme_attr);
>  err_vme:
>  	kfree(attributes);
>  err_attr:


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
