Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab2HHBZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 21:25:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:8527 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab2HHBZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 21:25:32 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-9d-5021c00a6a89
From: Inki Dae <inki.dae@samsung.com>
To: "'Thomas Meyer'" <thomas@m3y3r.de>, jy0922.shim@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1344322645.14513.122.camel@localhost.localdomain>
In-reply-to: <1344322645.14513.122.camel@localhost.localdomain>
Subject: RE: [PATCH] drm/exynos: Use ERR_CAST inlined function instead of
 ERR_PTR(PTR_ERR(.. [1]
Date: Wed, 08 Aug 2012 10:26:04 +0900
Message-id: <002901cd7504$c72bd530$55837f90$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac10aqGXicos9/xGQ/egYHLMfm6zNAAmTV6g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jAV2uA4oBBmdOiVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mq7MnsRZ85Kj4NWMdewPjYfYuRg4OCQETibZjGV2MnECmmMSF
	e+vZuhi5OIQEFjFKHGpuYoFwZjNJzP/+ih2kik1AVWLiivtgVSICRxklPl/sZgZJCAnYScyf
	1MEGYnMK2Eu8/PmJBcQWFkiSaJ2+mxXEZgFqXnxkMyOIzStgK9G+5C8LhC0o8WPyPTCbWUBd
	YtK8RcwQtrzE5jVvmSEuVZd49FcXJCwiYCTxoWEhVLmIxL4X7xgnMArOQjJpFpJJs5BMmoWk
	ZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4IB9Jr2DcVWDxSFGAQ5GJR7eTamKAUKs
	iWXFlbmHGCU4mJVEeNtagUK8KYmVValF+fFFpTmpxYcYpTlYlMR5Tby/+gsJpCeWpGanphak
	FsFkmTg4pRoYCzPOXGDOLPr1T9b/1F3p6V8EuM2rLNor068Vqqes9Q4ufeoftXD1qye8Hxf/
	XHBNQlWm8uX7T+I+4otybKb++735otu92YfV1V54t15dd6c1+P7zSzq91nJqn2z4XuumF9xw
	NZwbk3m+4e7JZKXk3dY7ayUf9ucoFDtdWr+2Y1/a/EnNIWHJSizFGYmGWsxFxYkAVXjXnFQC	AAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Meyer [mailto:thomas@m3y3r.de]
> Sent: Tuesday, August 07, 2012 3:57 PM
> To: inki.dae@samsung.com; jy0922.shim@samsung.com; sw0312.kim@samsung.com;
> kyungmin.park@samsung.com; airlied@linux.ie; dri-
> devel@lists.freedesktop.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] drm/exynos: Use ERR_CAST inlined function instead of
> ERR_PTR(PTR_ERR(.. [1]
> 
> The semantic patch that makes this change is available
> in scripts/coccinelle/api/err_cast.cocci.
> 
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/gpu/drm/exynos/exynos_drm_gem.c
> b/drivers/gpu/drm/exynos/exynos_drm_gem.c
> --- a/drivers/gpu/drm/exynos/exynos_drm_gem.c
> +++ b/drivers/gpu/drm/exynos/exynos_drm_gem.c
> @@ -122,7 +122,7 @@ fail:
>  		__free_page(pages[i]);
> 
>  	drm_free_large(pages);
> -	return ERR_PTR(PTR_ERR(p));
> +	return ERR_CAST(p);
>  }
> 
>  static void exynos_gem_put_pages(struct drm_gem_object *obj,

Applied.

Thanks for your patch.

