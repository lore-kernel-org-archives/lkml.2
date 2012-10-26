Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2JZGSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:18:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32933 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab2JZGSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:18:52 -0400
X-AuditID: cbfee612-b7f8f6d000003efa-00-508a2b47d918
Date: Fri, 26 Oct 2012 06:18:32 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] devfreq: exynos4_bus.c: Fixed an alignment of the func
 call args.
To: Sangho Yi <antiroot@gmail.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121026061719829@myungjoo.ham
Msgkey: 20121026061719829@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121026061719829@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <20045605.160791351232311768.JavaMail.weblogic@epv6ml08>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t8zTV1P7a4Ag6ldOhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj0OTvLAXruCsWn1zD2MDYwt3FyMkhJKAusWjJSTYQW0LARGLH
	o/2sELaYxIV764HiXEA1yxglut89ZIQp2jNhKyNEYj6jxMkDHWAdLAKqEus2H2bvYuTgYBPQ
	k5j5ORkkLCwQJrHn80ewEhGBVIm2W41gy5gFHCUeXb7DDHGEksSafa9YQGxeAUGJkzOfsEDs
	UpXYPLmXFSKuJnFu/wKouITErOkXoA7llZjR/hQqLicx7esaZghbWuL8rA2MMM8s/v4YKs4v
	cez2DiaQM0F6n9wPhhmze/MXaDgISEw9cxCqVUuid84sqPF8EmsWvmWBGbPr1HJmmN77W+Yy
	QbylKDGl+yE7hK0l8eXHPjZ0b/EKuEiseDWTaQKj8iwkqVlI2mchaUdWs4CRZRWjaGpBckFx
	UnqqhV5xYm5xaV66XnJ+7iZGSFoQ2sG4rMHiEKMAB6MSD++Bks4AIdbEsuLK3EOMEhzMSiK8
	u6cChXhTEiurUovy44tKc1KLDzH6AONvIrOUaHI+MGXllcQbGhsYGxpaGpqZWpoa4BBWEuet
	8EgJEBJITyxJzU5NLUgtghnHxMEp1cBYf+Op1m+pg/OcXgYbufy9l6W80O+C/nz/M6aJHBUH
	lil+8DCVXXOvZpfPQkGNokWvXrP4l/jzTJfm/Hzz1QYbFZbi+No0Rs2AFce/Cz3aI/43/cDl
	CO+nd1Oeq0TYzDjwR8mtcceBE2I7RW89Ov9DtXBfVugZXrcIweUzpcRE7yyZaTJr3dy7SizF
	GYmGWsxFxYkA0Z8N3zgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/tGbru2l0BBh93C1pc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jEOTv7MUrOOuWHxyDWMDYwt3FyMnh5CAusSiJSfZQGwJAROJPRO2MkLYYhIX7q0HinMB1cxn
	lDh5oIMVJMEioCqxbvNh9i5GDg42AT2JmZ+TQcLCAmESez5/BCsREUiVaLvVCDaTWcBR4tHl
	O8wQu5Qk1ux7xQJi8woISpyc+YQFYpeqxObJvawQcTWJc/sXQMUlJGZNv8AKYfNKzGh/ChWX
	k5j2dQ0zhC0tcX7WBribF39/DBXnlzh2ewcTyJkgvU/uB8OM2b35C9S7AhJTzxyEatWS6J0z
	C2o8n8SahW9ZYMbsOrWcGab3/pa5TBBvKUpM6X7IDmFrSXz5sY8N3Vu8Ai4SK17NZJrAKDcL
	SWoWkvZZSNqR1SxgZFnFKJpakFxQnJSeaqFXnJhbXJqXrpecn7uJEZygngntYFzWYHGIUYCD
	UYmH90BJZ4AQa2JZcWXuIUYJDmYlEd7dU4FCvCmJlVWpRfnxRaU5qcWHGH2A8TeRWUo0OR+Y
	PPNK4g2NDYwNDS3NDUwNjSxwCCuJ81Z4pAQICaQnlqRmp6YWpBbBjGPi4JRqYDzqu50zcOKK
	Y6I7locqGPpvOi1YUvLc/UX2/C25y/LezzlxIlXxfNS29zuXtS+Skrvw3/tOkNC8mDtOx3Sf
	vZpX7nNhhTvHkyn3bK7ct6j8Vj+zdb6H6LKfnpcP/O/fz8OstaCq5snx5GO6mWsuhB9NDa0Q
	f3R8O6evVM2HlKSQTU1PF85Y1v1WiaU4I9FQi7moOBEAXJoTbn0DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9Q6It7W023111

> I fixed the following check item (via checkpatch.pl --strict option):
> CHECK: Alignment should match open parenthesis
> 
> Signed-off-by: Sangho Yi <antiroot@gmail.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

I'll apply the patch after setting up devfreq for next tree.
Thanks.


Cheers,
MyungJoo

> ---
>  drivers/devfreq/exynos4_bus.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
> index 88ddc77..f4089c4 100644
> --- a/drivers/devfreq/exynos4_bus.c
> +++ b/drivers/devfreq/exynos4_bus.c
> @@ -1034,7 +1034,7 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
>  	opp = opp_find_freq_floor(dev, &exynos4_devfreq_profile.initial_freq);
>  	if (IS_ERR(opp)) {
>  		dev_err(dev, "Invalid initial frequency %lu kHz.\n",
> -		       exynos4_devfreq_profile.initial_freq);
> +			exynos4_devfreq_profile.initial_freq);
>  		err = PTR_ERR(opp);
>  		goto err_opp_add;
>  	}
> --
> 1.7.9.5
> 
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
