Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761058Ab0J0MXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 08:23:05 -0400
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:43633 "EHLO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab0J0MXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 08:23:03 -0400
Message-ID: <4CC8191E.40605@ge.com>
Date: Wed, 27 Oct 2010 13:20:46 +0100
From: Martyn Welch <martyn.welch@ge.com>
Organization: GE Intelligent Platforms
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Thunderbird/3.0.9
MIME-Version: 1.0
To: "Emilio G. Cota" <cota@braap.org>
CC: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: [PATCH 19/30] staging/vme/ca91cx42: mark the registers' base
 address pointer as __iomem
References: <1288055476-19438-1-git-send-email-cota@braap.org> <1288055476-19438-20-git-send-email-cota@braap.org>
In-Reply-To: <1288055476-19438-20-git-send-email-cota@braap.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2010 12:22:04.0167 (UTC) FILETIME=[9069F970:01CB75D1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/10/10 02:11, Emilio G. Cota wrote:
> From: Emilio G. Cota <cota@braap.org>
> 
> Signed-off-by: Emilio G. Cota <cota@braap.org>

Acked-by: Martyn Welch <martyn.welch@ge.com>

> ---
>  drivers/staging/vme/bridges/vme_ca91cx42.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.h b/drivers/staging/vme/bridges/vme_ca91cx42.h
> index e72c65b..02a7c79 100644
> --- a/drivers/staging/vme/bridges/vme_ca91cx42.h
> +++ b/drivers/staging/vme/bridges/vme_ca91cx42.h
> @@ -39,7 +39,7 @@
>  
>  /* Structure used to hold driver specific information */
>  struct ca91cx42_driver {
> -	void *base;	/* Base Address of device registers */
> +	void __iomem *base;	/* Base Address of device registers */
>  	wait_queue_head_t dma_queue;
>  	wait_queue_head_t iack_queue;
>  	wait_queue_head_t mbox_queue;


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square,
Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
