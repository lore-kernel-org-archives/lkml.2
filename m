Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2LJGOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:14:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61917 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2LJGOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:14:19 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee61b-b7f616d00000319b-7d-50c57dba8864
Message-id: <50C57DB9.8070100@samsung.com>
Date: Mon, 10 Dec 2012 15:14:17 +0900
From: =?UTF-8?B?6rmA7Iq57Jqw?= <sw0312.kim@samsung.com>
Reply-to: sw0312.kim@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011
 Thunderbird/16.0.1
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: inki.dae@samsung.com, jy0922.shim@samsung.com, kyungmin.park@samsung.com,
        airlied@linux.ie, yongjun_wei@trendmicro.com.cn,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        sw0312.kim@samsung.com
Subject: Re: [PATCH -next] drm/exynos/iommu: fix return value check in
 drm_create_iommu_mapping()
References: <CAPgLHd-65GoO=4D++ir2tq5hv=PtgYzEk4AB6_tyi-SRtsENYg@mail.gmail.com>
In-reply-to: <CAPgLHd-65GoO=4D++ir2tq5hv=PtgYzEk4AB6_tyi-SRtsENYg@mail.gmail.com>
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zbd1dtUcDDG7+4bO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZH982Mxc846r41PWZuYGxkbOLkZNDQsBE4u/ntWwQtpjEhXvr
	gWwuDiGBZYwSxy9vZ4Upuvz/DCtEYhGjxOpdn8A6eAUEJX5MvsfSxcjBwSwgL3HkUjZImFlA
	XWLSvEXMEPVdTBKPVjxhh6jXkmiZcYERxGYRUJVYcmo6C4jNJmAu0fnxEthMIQEFiSsTj7GD
	zBQVCJPYuTkdxBQRUJF4d70eYvwNRomXn6RBbGGBZIlHlzYwgZQICQRIPO2vAAlzCgRLHNn3
	D2qRgMS3yYfAjpQQkJXYdADsMAmBeewSnVtXsEN8KClxcMUNlgmM4rOQ/DUL4a9ZSP5awMi8
	ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyMkRqR3MK5qsDjEKMDBqMTDG6B4NECINbGsuDL3
	EKMEB7OSCC/XsSMBQrwpiZVVqUX58UWlOanFhxh9gI6dyCwlmpwPjN+8knhDYwNjQ0NLQzNT
	S1MDHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhhlVz7z4Lj9ZPK8trWWU1pXqoimbihi
	XPuayyfe5YtK1tmqtB9z41+s8E268+qM5er+fcu3u/xhT1fsfSOa4/+yQzm3dEOE/80ZT/WL
	V0gXf/9yNkv9w8P7K3qORsmf/n7BQ/inRIZeB3/gooRvOgtMKy4m+PtPEhKbOSMuuC8m99HD
	2xxSuq5KLMUZiYZazEXFiQCsLXS7vgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jAd1dtUcDDFqXcFlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjI9vm5kLnnFVfOr6zNzA
	2MjZxcjJISFgInH5/xlWCFtM4sK99WxdjFwcQgKLGCVW7/rEBpLgFRCU+DH5HksXIwcHs4C8
	xJFL2SBhZgF1iUnzFjFD1HcxSTxa8YQdol5LomXGBUYQm0VAVWLJqeksIDabgLlE58dLYDOF
	BBQkrkw8xg4yU1QgTGLn5nQQU0RAReLd9XqI8TcYJV5+kgaxhQWSJR5d2sAEUiIkECDxtL8C
	JMwpECxxZN8/xgmMgrOQ3DkL4c5ZSO5cwMi8ilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4
	Ap9J72Bc1WBxiFGAg1GJhzdA8WiAEGtiWXFl7iFGCQ5mJRFermNHAoR4UxIrq1KL8uOLSnNS
	iw8x+gB9OZFZSjQ5H5gc8kriDY1NzIwsjcyMTcyNjXEIK4nzNnukBAgJpCeWpGanphakFsGM
	Y+LglGpgzDjn9t1+1f8rW/4YLHA5zX2E8ekm1VmblVn+LbK//bhndWnSw+w9Xb1enMuzDMOY
	Pu3YoXq4w51pp6hjQu7FrWnrMqVUP6jWS5vNOyH/Wu7O0VVJDfd+PuYOE3uz4nTVqyefas/v
	DZz61qLNpanWb3bRHd8bhv/0Nt19/JTT5svTTVcEha5OnKHEUpyRaKjFXFScCADhe/5a7QIA	AA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2012년 12월 07일 21:50, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> In case of error, function arm_iommu_create_mapping() returns
> ERR_PTR() and never returns NULL. The NULL test in the return
> value check should be replaced with IS_ERR().
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/gpu/drm/exynos/exynos_drm_iommu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/exynos/exynos_drm_iommu.c b/drivers/gpu/drm/exynos/exynos_drm_iommu.c
> index 09db198..3b3d3a6 100644
> --- a/drivers/gpu/drm/exynos/exynos_drm_iommu.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_iommu.c
> @@ -56,7 +56,7 @@ int drm_create_iommu_mapping(struct drm_device *drm_dev)
>  	mapping = arm_iommu_create_mapping(&platform_bus_type, priv->da_start,
>  						priv->da_space_size,
>  						priv->da_space_order);
> -	if (!mapping)
> +	if (IS_ERR(mapping))
>  		return -ENOMEM;

One more fix is needed here.
-		return -ENOMEM;
+ 		return PTR_ERR(mapping);

>  
>  	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
> 
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

-- 
Seung-Woo Kim
Samsung Software R&D Center
--

