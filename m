Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab2LMRPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:15:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740Ab2LMRPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:15:41 -0500
Message-ID: <1355418938.2229.13.camel@ul30vt.home>
Subject: Re: [PATCH]iommu: Include linux/err.h
From: Alex Williamson <alex.williamson@redhat.com>
To: Wang YanQing <udknight@gmail.com>
Cc: joerg.roedel@amd.com, linux-kernel@vger.kernel.org
Date: Thu, 13 Dec 2012 10:15:38 -0700
In-Reply-To: <20121213165539.GA10948@udknight>
References: <20121213165539.GA10948@udknight>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-12-14 at 00:55 +0800, Wang YanQing wrote:
> The linux/iommu.h header uses ERR_PTR defined
> in linux/err.h but doesn't include it.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  include/linux/iommu.h | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index f3b99e1..f4a49a6 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -20,6 +20,7 @@
>  #define __LINUX_IOMMU_H
>  
>  #include <linux/errno.h>
> +#include <linux/err.h>
>  #include <linux/types.h>
>  
>  #define IOMMU_READ	(1)



