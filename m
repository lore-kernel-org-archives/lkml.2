Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab2K1J3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 04:29:11 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:8534 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619Ab2K1J3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 04:29:07 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-6c-50b5d961494d
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Cc: "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Will Newton'" <will.newton@imgtec.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1353535387-32106-1-git-send-email-dianders@chromium.org>
 <1353624835-19137-1-git-send-email-dianders@chromium.org>
In-reply-to: <1353624835-19137-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH v2 1/2] mmc: dw_mmc: exynos: Stop claiming wp-gpio
Date: Wed, 28 Nov 2012 18:29:04 +0900
Message-id: <001a01cdcd4a$cf01ad40$6d0507c0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3JBE88AmjmM6E8TGyM37YzfSXioAEKaDvA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zA93Em1sDDPYd5ba4vGsOm8WR//2M
	FjPO72NyYPb4vEkugDGKyyYlNSezLLVI3y6BK+Ns/xKmgs0CFavPvWJtYJzK28XIySEhYCLx
	o2crK4QtJnHh3nq2LkYuDiGBZYwSO7ZNYYQpWjlzGxuILSSwiFFi1nQziKI/jBIvrp8E62YT
	0JL4++YNM0hCBKR747oWMIdZ4BujxLSrF6DmNjJKHPw7AWwWp4CbxOEVrSwgtjCQ/ab1PJjN
	IqAqcWDfIrDdvAK2Eo1TXjNB2IISPybfA6thFjCQeD+rjxXClpfYvOYt0DYOoFvVJR791QUJ
	iwgYSdzedoINokREYt+Ld4wQ4wUkvk0+xAJRLiux6QDYnRICm9gl7ne+YYN4WVLi4IobLBOA
	nkWyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGCExJ7WDcWWDxSFG
	AQ5GJR5eB8etAUKsiWXFlbmHGCU4mJVEeHnagEK8KYmVValF+fFFpTmpxYcYfYAun8gsJZqc
	D0wHeSXxhsbGJmYmpibmlqbmpjiElcR5mz1SAoQE0hNLUrNTUwtSi2DGMXFwSjUwTk5T2r8m
	c+FP/mq3CVxT/8z+9KXz6WulaYKMbszH/q47N2O5/fnzWkV7Hyz10GBlyJqtetsx2zZmw7SO
	TQLCLfHiXjKLJxjPWfLWTcP0+4Uisf9p/TPOTQ1uXPBY4BNvihq77Zdf3ToXN9RcO7bvxHnT
	7TIPPBo5Y5PnO+vseHji7L556nsZWpRYijMSDbWYi4oTAQ2AHbTmAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xgG7iza0BBjcesVhc3jWHzeLI/35G
	ixnn9zE5MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hxtn8J
	U8FmgYrV516xNjBO5e1i5OSQEDCRWDlzGxuELSZx4d56MFtIYBGjxKzpZl2MXED2H0aJF9dP
	soIk2AS0JP6+ecMMkhARWMYosXFdC5jDLPCNUWLa1QtsEC2NjBIH/04Am8Up4CZxeEUrC4gt
	DGS/aT0PZrMIqEoc2LeIEcTmFbCVaJzymgnCFpT4MfkeWA2zgIHE+1l9rBC2vMTmNW+BtnEA
	3aou8eivLkhYRMBI4va2E2wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT
	0nMN9YoTc4tL89L1kvNzNzGCI/qZ1A7GlQ0WhxgFOBiVeHgdHLcGCLEmlhVX5h5ilOBgVhLh
	5WkDCvGmJFZWpRblxxeV5qQWH2L0AXp0IrOUaHI+MNnklcQbGpuYGVkamVkYmZib4xBWEudt
	9kgJEBJITyxJzU5NLUgtghnHxMEp1cC47/2ThzonlFbWsymcddq1esn5w1cZ1ctEhdZdurS8
	zfThPSdm+T4JjutpF4V2Sun8qSn8Z3rs4MdVr+2dVu06azipJuv3ouc3HEOOPbjj9+JV74Fj
	FQc+3z12JFoo+us/ayPHL32n+u5W3Rd7su2ij0llEeNDN2kVwwuWR/ewfbY6ybf88NpCKyWW
	4oxEQy3mouJEACMJeKoVAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes. pin of write protection is common property.
This change is good. I have some suggestion below.
Could you check it?

On Friday, November 23, 2012, Doug Anderson wrote:
> The exynos code claimed wp-gpio with devm_gpio_request() but never did
> anything with it.  That meant that anyone using a write protect GPIO
> would effectively be write protected all the time.
> 
> A future change will move the wp-gpio support to the core dw_mmc.c
> file.  Now the exynos-specific code won't claim the GPIO but will
> just set the DW_MCI_QUIRK_NO_WRITE_PROTECT quirk if write protect
> won't be used.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> 
> ---
> Changes in v2:
> - Nothing new in this patch
> 
>  drivers/mmc/host/dw_mmc-exynos.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> index 4d50da6..58cc03e 100644
> --- a/drivers/mmc/host/dw_mmc-exynos.c
> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> @@ -175,12 +175,12 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
>  		}
>  	}
> 
> -	gpio = of_get_named_gpio(slot_np, "wp-gpios", 0);
> -	if (gpio_is_valid(gpio)) {
> -		if (devm_gpio_request(host->dev, gpio, "dw-mci-wp"))
> -			dev_info(host->dev, "gpio [%d] request failed\n",
> -						gpio);
> -	} else {
> +	/*
> +	 * If there are no write-protect GPIOs present then we assume no write
> +	 * protect.  The mci_readl() in dw_mmc.c won't work since it's not
> +	 * hooked up on exynos.
> +	 */
> +	if (!of_find_property(slot_np, "wp-gpios", NULL)) {
>  		dev_info(host->dev, "wp gpio not available");
>  		host->pdata->quirks |= DW_MCI_QUIRK_NO_WRITE_PROTECT;
>  	}
All card types need this quirk in case wp-gpio property is empty?
I think wp-pin is valid for SD card, not eMMC/SDIO.
Of course, I know origin code did it.
How about removing whole checking routine?
Instead, new definition for this quirk can be added into 'dw_mci_of_quirks'(dw_mmc.c) and dts file.

Thanks,
Seungwon Jeon
> --
> 1.7.7.3

