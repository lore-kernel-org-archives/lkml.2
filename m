Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab2LJG30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:29:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:64965 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2LJG3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:29:25 -0500
X-AuditID: cbfee61b-b7f616d00000319b-d2-50c5813a28b3
From: Inki Dae <inki.dae@samsung.com>
To: sw0312.kim@samsung.com, "'Wei Yongjun'" <weiyj.lk@gmail.com>
Cc: jy0922.shim@samsung.com, kyungmin.park@samsung.com, airlied@linux.ie,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <CAPgLHd-65GoO=4D++ir2tq5hv=PtgYzEk4AB6_tyi-SRtsENYg@mail.gmail.com>
 <50C57DB9.8070100@samsung.com>
In-reply-to: <50C57DB9.8070100@samsung.com>
Subject: RE: [PATCH -next] drm/exynos/iommu: fix return value check in
 drm_create_iommu_mapping()
Date: Mon, 10 Dec 2012 15:29:14 +0900
Message-id: <00b301cdd69f$ac5220a0$04f661e0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3WnZV/cY4TP1s/R3O+NANBBZf/AQAAe9oA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRmVeSWpSXmKPExsVy+t8zHV2rxqMBBseOqFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MKS1xBXMFKj6tPcjUwHiAt4uRk0NCwERi/7ffzBC2mMSFe+vZ
	uhi5OIQEljFKvLqwihWmqPfCEiaIxCJGic4LTxkhnNlMEgfm/GQBqWITUJWYuOI+G4gtImAn
	MeHEBhaQImaBVYwS15+/AmrnAOooluifVAJSwymgLbG9fR47iC0skCxxePtmsF4WoDm9m06B
	xXkFbCVe7P7HCGELSvyYfA9sF7OAusSkeYuYIWxtiSfvLrCCjJcAij/6qwtiiggYSez7zgdR
	ISKx78U7RojpAhLfJh9igaiWldh0AOr3RewSLc/0IWxJiYMrbrBMYJSYhWTvLCR7ZyHZOwvJ
	hgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxQqJKegfjqgaLQ4wCHIxKPLwBikcDhFgT
	y4orcw8xSnAwK4nwch07EiDEm5JYWZValB9fVJqTWnyI0Qfo8InMUqLJ+cCIzyuJNzQ2MDY0
	tDQ0M7U0NcAhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qB0eDvvItneA8YLr9U+0fGN1bz
	4MX3PpO3LBJsE2oLk/c72FnpWMcT/TNo5zIds72h9ZbW7A48py+VLo3hEtkVUey4btY+mXmL
	op5cq4h4wf6RISXWKaFN0m7W3Ol8sue6Fmxj9Vgxy195/5KiqTZzWirMjzqGSBeK619TdO1/
	L2QYdUzb8kKeEktxRqKhFnNRcSIAl2AeedcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAV2rxqMBBlsuKFpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjCktcQVzBSo+rT3I1MB4
	gLeLkZNDQsBEovfCEiYIW0ziwr31bF2MXBxCAosYJTovPGWEcGYzSRyY85MFpIpNQFVi4or7
	bCC2iICdxIQTG1hAipgFVjFKXH/+CmgUB1BHsUT/pBKQGk4BbYnt7fPYQWxhgWSJw9s3g/Wy
	AM3p3XQKLM4rYCvxYvc/RghbUOLH5Htgu5gF1CUmzVvEDGFrSzx5d4EVZLwEUPzRX10QU0TA
	SGLfdz6IChGJfS/eMU5gFJqFZNAsJINmIRk0C0nLAkaWVYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxjBUftMegfjqgaLQ4wCHIxKPLwBikcDhFgTy4orcw8xSnAwK4nwch07EiDEm5JYWZVa
	lB9fVJqTWnyI0Qfoz4nMUqLJ+cCEklcSb2hsYmZkaWRmbGJubIxDWEmct9kjJUBIID2xJDU7
	NbUgtQhmHBMHp1QDY4Ztx8q7fnLbPvjp7vG43Ml24FMVv+pe5i/NKXk/nqx9Xn12mZNrpkO1
	GuvUu2IW3wtjep5tWro51kWo0LJjedjO+UfWPxDuMp4eGrVXwV9l/iktuUfKoZmC8gfU7yiV
	xy/bz+tf3RlhXcm8UvDIHmmOlBmCC7WtpE++vvPgz6nGYzdsD2c2KLEUZyQaajEXFScCAKOd
	F2UHAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: 김승우 [mailto:sw0312.kim@samsung.com]
> Sent: Monday, December 10, 2012 3:14 PM
> To: Wei Yongjun
> Cc: inki.dae@samsung.com; jy0922.shim@samsung.com;
> kyungmin.park@samsung.com; airlied@linux.ie; yongjun_wei@trendmicro.com.cn;
> linux-kernel@vger.kernel.org; dri-devel@lists.freedesktop.org;
> sw0312.kim@samsung.com
> Subject: Re: [PATCH -next] drm/exynos/iommu: fix return value check in
> drm_create_iommu_mapping()
> 
> 
> 
> On 2012년 12월 07일 21:50, Wei Yongjun wrote:
> > From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> >
> > In case of error, function arm_iommu_create_mapping() returns
> > ERR_PTR() and never returns NULL. The NULL test in the return
> > value check should be replaced with IS_ERR().
> >
> > Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> > ---
> >  drivers/gpu/drm/exynos/exynos_drm_iommu.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/gpu/drm/exynos/exynos_drm_iommu.c
> b/drivers/gpu/drm/exynos/exynos_drm_iommu.c
> > index 09db198..3b3d3a6 100644
> > --- a/drivers/gpu/drm/exynos/exynos_drm_iommu.c
> > +++ b/drivers/gpu/drm/exynos/exynos_drm_iommu.c
> > @@ -56,7 +56,7 @@ int drm_create_iommu_mapping(struct drm_device
> *drm_dev)
> >  	mapping = arm_iommu_create_mapping(&platform_bus_type, priv-
> >da_start,
> >  						priv->da_space_size,
> >  						priv->da_space_order);
> > -	if (!mapping)
> > +	if (IS_ERR(mapping))
> >  		return -ENOMEM;
> 
> One more fix is needed here.
> -		return -ENOMEM;
> + 		return PTR_ERR(mapping);

Oh, good point, I missed. Please re-send it.

Thanks,
Inki Dae

> 
> >
> >  	dev->dma_parms = devm_kzalloc(dev, sizeof(*dev->dma_parms),
> >
> >
> > _______________________________________________
> > dri-devel mailing list
> > dri-devel@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/dri-devel
> >
> 
> --
> Seung-Woo Kim
> Samsung Software R&D Center
> --

