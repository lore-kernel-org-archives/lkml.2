Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab1CAPfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 10:35:13 -0500
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:57216 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1CAPfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 10:35:11 -0500
Message-ID: <4D6D122B.5050404@ge.com>
Date: Tue, 01 Mar 2011 15:35:07 +0000
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Manohar Vanga <manohar.vanga@cern.ch>
CC: gregkh@suse.de, julia@diku.dk, cota@braap.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: vme: remove unreachable code
References: <1298762135-8752-1-git-send-email-manohar.vanga@cern.ch> <1298762135-8752-2-git-send-email-manohar.vanga@cern.ch>
In-Reply-To: <1298762135-8752-2-git-send-email-manohar.vanga@cern.ch>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Mar 2011 15:34:56.0980 (UTC) FILETIME=[37FBD940:01CBD826]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/11 23:15, Manohar Vanga wrote:
> Remove some more unreachable code found in bridges/vme_ca91cx42.c
> and bridges/vme_tsi148.c
> 
> Signed-off-by: Manohar Vanga <manohar.vanga@cern.ch>

Acked-by Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/bridges/vme_ca91cx42.c |    3 ---
>  drivers/staging/vme/bridges/vme_tsi148.c   |    2 --
>  2 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
> index 42de83e..5d734d9 100644
> --- a/drivers/staging/vme/bridges/vme_ca91cx42.c
> +++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
> @@ -560,8 +560,6 @@ static int ca91cx42_alloc_resource(struct vme_master_resource *image,
>  
>  	return 0;
>  
> -	iounmap(image->kern_base);
> -	image->kern_base = NULL;
>  err_remap:
>  	release_resource(&image->bus_resource);
>  err_resource:
> @@ -1782,7 +1780,6 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	return 0;
>  
> -	vme_unregister_bridge(ca91cx42_bridge);
>  err_reg:
>  	ca91cx42_crcsr_exit(ca91cx42_bridge, pdev);
>  err_lm:
> diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
> index 26ea42f..2df19ea 100644
> --- a/drivers/staging/vme/bridges/vme_tsi148.c
> +++ b/drivers/staging/vme/bridges/vme_tsi148.c
> @@ -869,8 +869,6 @@ static int tsi148_alloc_resource(struct vme_master_resource *image,
>  
>  	return 0;
>  
> -	iounmap(image->kern_base);
> -	image->kern_base = NULL;
>  err_remap:
>  	release_resource(&image->bus_resource);
>  err_resource:


-- 
Martyn Welch (Principal Software Engineer) | Registered in England and
GE Intelligent Platforms                   | Wales (3828642) at 100
T +44(0)127322748                          | Barbirolli Square, Manchester,
E martyn.welch@ge.com                      | M2 3AB  VAT:GB 927559189
