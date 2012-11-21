Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2KUKSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 05:18:48 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:63933 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KUKSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 05:18:46 -0500
X-AuditID: cbfee60b-b7f356d0000018d6-9d-50acaa84c655
Date: Wed, 21 Nov 2012 10:18:44 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/2] PM/devfreq: Fix return value in
 devfreq_remove_governor()
To: Sachin Kamat <sachin.kamat@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "patches@linaro.org" <patches@linaro.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121121101641393@myungjoo.ham
Msgkey: 20121121101641393@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121121101641393@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11617564.20991353493124275.JavaMail.weblogic@epml17>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t8zPd3WVWsCDCYtZLS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZjQ3v2QtWcVV0rOJuYGzh6mLk5BASUJdYtOQkG4gtIWAicWh/
	OyOELSZx4d56NoiaZYwS247nwdQsb1gIVMMFFJ/PKPH02gx2kASLgKrExecTgRIcHGwCehIz
	PyeDhIUFgiTuPb4JViIikCvxau9vsJnMAnkSE6c+ZoKYrySxZt8rFhCbV0BQ4uTMJywQu1Ql
	7r+7zggRV5No//UD6k4JiVnTL7BC2LwSM9qfQtXLSUz7uoYZwpaWOD9rA9wvi78/horzSxy7
	vYMJ5EyQ3if3g2HG7N78BWq8gMTUMwehWrUkTv6/DBXnk1iz8C0LzJhdp5Yzw/Te3zKXCeIt
	RYkp3Q/ZIWwtiS8/9rGhe4tXwFHi/c21jBMYlWchSc1C0j4LSTuymgWMLKsYRVMLkguKk9JT
	DfWKE3OLS/PS9ZLzczcxQlIC9w7GWQ0WhxgFOBiVeHi39K0JEGJNLCuuzD3EKMHBrCTCu2kK
	UIg3JbGyKrUoP76oNCe1+BCjDzD+JjJLiSbnA9NVXkm8obGBsaGhpaGZqaWpAQ5hJXFehYrp
	AUIC6YklqdmpqQWpRTDjmDg4pRoY0xZ+ce07vTWm0r+mWnnBxrW5PL2XX0VYaq+4OsXTJ2vF
	U427hZsXJQRL9mv36c3zrjM4Z/gmNbz1koxacfHZ4pbE7T/XKjfUvudw9fmvt0+rt4Fv9imG
	32tr8vpP+uTMYBR6nnpkfdNjay7PlOWnwndxu0y/+UFLefpDfcFGf+V5nx9uDf6lxFKckWio
	xVxUnAgA/kymTTYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t/tmbotq9YEGLS9tLS4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GY0N79kLVnFVdKzibmBs4epi5OQQElCXWLTkJBuILSFgIrG8YSEjhC0mceHeeqA4F1DNfEaJ
	p9dmsIMkWARUJS4+nwhUxMHBJqAnMfNzMkhYWCBI4t7jm2AlIgK5Eq/2/gabySyQJzFx6mMm
	iF1KEmv2vWIBsXkFBCVOznzCArFLVeL+u+uMEHE1ifZfP6DukZCYNf0CK4TNKzGj/SlUvZzE
	tK9rmCFsaYnzszbA3bz4+2OoOL/Esds7mEDOBOl9cj8YZszuzV+gxgtITD1zEKpVS+Lk/8tQ
	cT6JNQvfssCM2XVqOTNM7/0tc5kg3lKUmNL9kB3C1pL48mMfG7q3eAUcJd7fXMs4gVFuFpLU
	LCTts5C0I6tZwMiyilE0tSC5oDgpPdVQrzgxt7g0L10vOT93EyM4PT3j3sE4q8HiEKMAB6MS
	D++WvjUBQqyJZcWVuYcYJTiYlUR4N00BCvGmJFZWpRblxxeV5qQWH2L0AcbfRGYp0eR8YOrM
	K4k3NDYwNjS0NDcwNTSywCGsJM6rUDE9QEggPbEkNTs1tSC1CGYcEwenVANjpPS35P6fwU/f
	sDzcePuQi0CXsniu53WjksRIn/AF2Zr7g5JYVl4LsW8+8UNf1aDj5P1Niw+t/5Zz6lFmtp3d
	CYGu07P1P0/6v2+ed+uya7/rRU8o8PgFJ+ZLR/ExmFc/bok+/sLkY93JVVrqvquM29Y5uGxx
	ay+9duZpn/PM/iepk87V9K5SYinOSDTUYi4qTgQAwTrDKHwDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qALAIqiP029129

> Use the value obtained from the function instead of -EINVAL.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Both patches applied as they are obvious bugfixes.
I'll send pull request with other bugfixes within days.

> ---
>  drivers/devfreq/devfreq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index 83c2129..2bd9ab0 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -644,7 +644,7 @@ int devfreq_remove_governor(struct devfreq_governor *governor)
>  	if (IS_ERR(g)) {
>  		pr_err("%s: governor %s not registered\n", __func__,
>  		       governor->name);
> -		err = -EINVAL;
> +		err = PTR_ERR(g);
>  		goto err_out;
>  	}
>  	list_for_each_entry(devfreq, &devfreq_list, node) {
> -- 
> 1.7.4.1
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
