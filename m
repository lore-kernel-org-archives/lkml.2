Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab2JaEdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 00:33:53 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37006 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab2JaEdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 00:33:52 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-b8-5090aa22af82
Message-id: <5090AA1E.1040005@samsung.com>
Date: Wed, 31 Oct 2012 13:33:34 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
MIME-version: 1.0
To: Sergei Trofimovich <slyich@gmail.com>
Cc: Chris Ball <cjb@laptop.org>, Sergei Trofimovich <slyfox@gentoo.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Will Newton <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exynos: mmc: use correct variable for MODULE_DEVICE_TABLE
References: <1351635712-17214-1-git-send-email-slyich@gmail.com>
In-reply-to: <1351635712-17214-1-git-send-email-slyich@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t9jQV2lVRMCDH5dN7C4vGsOm8WR//2M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWcXXuTpaCVq2LvJ90Gxj0cXYycHBICJhL/d7eyQ9hi
	EhfurWfrYuTiEBKYzigx6+4TRgjnJaPExmsLGEGqeAW0JHbNamQFsVkEVCUWrF0EFmcT0JHY
	/u04UxcjB4eoQJjEzs3pEOWCEj8m32MBsUUENCV+NRxgA7GZBW4wSlzfZAViCwv4Sbye/BZs
	pJCAg8TGA7fAxnAKOEocP54GUa4jsb91GlSrvMTmNW+ZJzAKzEKyYRaSsllIyhYwMq9iFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECA7DZ1I7GFc2WBxiFOBgVOLhNfzXHyDEmlhWXJl7iFGC
	g1lJhLdkxoQAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzNHikBQgLpiSWp2ampBalFMFkmDk6p
	Bkapv6ICylKNFz/qN9RMKJ5SXCHTKj9r7ipF6bs587ODnAyuvLvCu/RP11kfXnmVA1Ev7jG9
	LRSc/FpY4tNa8Q3/0hcFt7hubjsnyf2r6IT4txU3PSIS5l2tzpEJdroTVbLv08egf5/OS782
	79aUV6+4amhl8f7kFZ75rGVqi9u1dh4OvZL46rASS3FGoqEWc1FxIgAm8E2WPwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me.

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

On 10/31/2012 07:21 AM, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Found by gcc:
> 
>     linux-2.6/drivers/mmc/host/dw_mmc-exynos.c: At top level:
>     linux-2.6/drivers/mmc/host/dw_mmc-exynos.c:226:1: error: '__mod_of_device_table' aliased to undefined symbol 'dw_mci_pltfm_match'
> 
> CC: Chris Ball <cjb@laptop.org>
> CC: Thomas Abraham <thomas.abraham@linaro.org>
> CC: Will Newton <will.newton@imgtec.com>
> CC: linux-mmc@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
> ---
>  drivers/mmc/host/dw_mmc-exynos.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> index 660bbc5..0147ac3a 100644
> --- a/drivers/mmc/host/dw_mmc-exynos.c
> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> @@ -223,7 +223,7 @@ static const struct of_device_id dw_mci_exynos_match[] = {
>  			.data = (void *)&exynos5250_drv_data, },
>  	{},
>  };
> -MODULE_DEVICE_TABLE(of, dw_mci_pltfm_match);
> +MODULE_DEVICE_TABLE(of, dw_mci_exynos_match);
>  
>  int dw_mci_exynos_probe(struct platform_device *pdev)
>  {
> 

