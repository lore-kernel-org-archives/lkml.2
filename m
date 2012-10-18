Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2JRNOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:14:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28322 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2JRNOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:14:22 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-89-508000aba14f
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
        linux-kernel@vger.kernel.org
References: <1350483442-13180-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1350483442-13180-1-git-send-email-laurent.pinchart@ideasonboard.com>
Subject: RE: [PATCH] drivers: cma: Fix wrong CMA selected region size default
 value
Date: Thu, 18 Oct 2012 15:14:11 +0200
Organization: SPRC
Message-id: <00c501cdad32$78729e40$6957dac0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2scgaQRjrdq8+lTpqTMg4KlI51WAAvVnAw
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQd3VDA0BBk9PWVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M24eOMBbcY6+Y3TqHvYFxLlsXIyeHhICJxLnjp6BsMYkL99YD
	2VwcQgLTGSUuL7wJ5cxikrj4dREjSBWbgKFE19susA4RgSiJc7f2MYPYQgLBEtd+7weLcwqE
	SNxf3wFmCwuESrx8MZkdxGYRUJVY830FaxcjBwe/gJDExFkKIGFeAReJ22+PMkHYghI/Jt9j
	AbGZBbQk1u88zgRhy0tsXvOWGaRVQkBd4tFfXRBTRMBI4lG/IESFiMTdhuesExiFZiEZNAvJ
	oFlIBs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAQP5PawbiyweIQowAHoxIP
	76We+gAh1sSy4srcQ4wSHMxKIrwrNwGFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZ7pAQICaQn
	lqRmp6YWpBbBZJk4OKUaGHkdmFmXt7s/MSti42vpud7cPm3rUj6ba8/O2a5+yXz04O17vREZ
	S0rv7Fy/c2vPj8uKumYtDoosH3y6JXhCU550/RBRPDXbLzSqYLVpCGP1+bk5i18t3HFHuyey
	qNfl8P6dM/MD3pWq+Z8qYw11YVKdYHSIvfBtW3Du4q+zHXjmnj7e/sV8rxJLcUaioRZzUXEi
	ALMuSvFeAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wednesday, October 17, 2012 4:17 PM Laurent Pinchart wrote:

> Kconfig lists CMA_SIZE_SEL_ABSOLUTE as the default value fo the CMA
> selected region size, but that option isn't available in the defined
> choices. Set the default to CMA_SIZE_SEL_MBYTES instead.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/base/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 08b4c52..b34b5cd 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -236,7 +236,7 @@ config CMA_SIZE_PERCENTAGE
> 
>  choice
>  	prompt "Selected region size"
> -	default CMA_SIZE_SEL_ABSOLUTE
> +	default CMA_SIZE_SEL_MBYTES
> 
>  config CMA_SIZE_SEL_MBYTES
>  	bool "Use mega bytes value only"
> --

Right, thanks for the fix, applied to my dma-mapping tree.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


