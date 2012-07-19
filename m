Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126Ab2GSK1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 06:27:35 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45500 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab2GSK1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 06:27:30 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-4a-5007e110bcef
Sun-Java-System-SMTP-Warning: Lines longer than SMTP allows found and wrapped.
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>, linux-mmc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cjb@laptop.org, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        patches@linaro.org
References: <CAGxe1ZGMvrec-nEYdZJ84Hub0fByYvnkCY_dRq2k489gCRSxQg@mail.gmail.com>
 <1342521538-12790-1-git-send-email-thomas.abraham@linaro.org>
In-reply-to: <1342521538-12790-1-git-send-email-thomas.abraham@linaro.org>
Subject: RE: [PATCH 3/9] mmc: dw_mmc: lookup for optional biu and ciu clocks
Date: Thu, 19 Jul 2012 19:27:25 +0900
Message-id: <004201cd6599$17401610$45c04230$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1kBmuDnJjoRYCIRaySILzEftlKUgBV62wA
Content-language: ko
x-cr-hashedpuzzle: BVWC MlP4 SIfu WuYG YyZI hHg4 qb6X rOmj ABKqwg== ACESaQ==
 ACqeAg== AHWCVA== AJ27lA== AMHWtA== AMSH+w==
 ATXFHw==;11;YwBqAGIAQABsAGEAcAB0AG8AcAAuAG8AcgBnADsAZABlAHYAaQBjAGUAdAByAGUAZQAtAGQAaQBzAGMAdQBzAHMAQABsAGkAcwB0AHMALgBvAHoAbABhAGIAcwAuAG8AcgBnADsAZwByAGEAbgB0AC4AbABpAGsAZQBsAHkAQABzAGUAYwByAGUAdABsAGEAYgAuAGMAYQA7AGsAZwBlAG4AZQAuAGsAaQBtAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AYQByAG0ALQBrAGUAcgBuAGUAbABAAGwAaQBzAHQAcwAuAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbABpAG4AdQB4AC0AbQBtAGMAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAHMAYQBtAHMAdQBuAGcALQBzAG8AYwBAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAcABhAHQAYwBoAGUAcwBAAGwAaQBuAGEAcgBvAC4AbwByAGcAOwByAG8AYgAuAGgAZQByAHIAaQBuAGcAQABjAGEAbAB4AGUAZABhAC4AYwBvAG0AOwB0AGgAbwBtAGEAcwAuAGEAYgByAGEAaABhAG0AQABsAGkAbgBhAHIAbwAuAG8AcgBnAA==;Sosha1_v1;7;{CCD2D25B-6D09-4F01-84AD-475055CFA53C};dABnAGkAaAAuAGoAdQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAb
	wBtAA==;Thu,
 19 Jul 2012 10:27:00 GMT;UgBFADoAIABbAFAAQQBUAEMASAAgADMALwA5AF0AIABtAG0AYwA6ACAAZAB3AF8AbQBtAGMAOgAgAGwAbwBvAGsAdQBwACAAZgBvAHIAIABvAHAAdABpAG8AbgBhAGwAIABiAGkAdQAgAGEAbgBkACAAYwBpAHUAIABjAGwAbwBjAGsAcwA=
x-cr-puzzleid: {CCD2D25B-6D09-4F01-84AD-475055CFA53C}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t9jQV2Bh+wBBg9+C1tc3jWHzeLI/35G
	ixnn9zE5MHt83iQXwBjFZZOSmpNZllqkb5fAlfHqyA7Ggu3yFauOdrE2MO6S7GLk5JAQMJG4
	9XYOM4QtJnHh3nq2LkYuDiGB6YwSh/onMkM4fxglJr77zA5SJSzgJ9E0ZxJYB5uAlsTfN2/A
	bBGBIonFCxoYQRqYBe4wSjyadZIRonsSo8SMp39Yuhg5ODgFvCTaVqtBDPKROHf2DDtImEVA
	VeLstVCQMK+ArUTf91msELagxI/J91hAbGYBA4n3s/pYIWx5ic1r3jKDtEoIqEs8+qsLYooI
	GElcm2IHUSEise/FO0aIv+5xShxtyYWwTSVu/pjJMoFRdBaSBbOQLJiFZMEsJKMWMLKsYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAiOkWfSOxhXNVgcYhTgYFTi4e3QZw8QYk0sK67MPcQo
	wcGsJMK77T5QiDclsbIqtSg/vqg0J7X4EKM0B4uSOK+J91d/IYH0xJLU7NTUgtQimCwTB6dU
	A2OjwUKdR8bLL141Ppd6Jzbx99GPwV57pk/L9Axy91PeufO7yu/THeYMC3bPYVn1sfBGy/XU
	a3fc3Xo/vQi+psx75MPWWy0iZ4yvRe7Udf9ju9HCe4XdTs2+GeoPFxrM69b4w7Vmgarcrlbr
	pXeWhq6cmZ3pVXz5avYXzt1GrjdbPBQ3HJOWdbJXYinOSDTUYi4qTgQA5qXwXY0CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

July 17, 2012, Thomas Abraham <thomas.abraham@linaro.org> wrote:
> Some platforms allow for clock gating and control of bus interface unit clock
> and card interface unit clock. Add support for clock lookup of optional biu
> and ciu clocks for clock gating and clock speed determination.
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> ---
>  drivers/mmc/host/dw_mmc.c  |   39 ++++++++++++++++++++++++++++++++++++---
>  include/linux/mmc/dw_mmc.h |    4 ++++
>  2 files changed, 40 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index cd58063..ebd22d8 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1953,13 +1953,30 @@ int dw_mci_probe(struct dw_mci *host)
>  		return -ENODEV;
>  	}
> 
> -	if (!host->pdata->bus_hz) {
> +	host->biu_clk = clk_get(host->dev, "biu");
> +	if (IS_ERR(host->biu_clk))
> +		dev_dbg(host->dev, "biu clock not available\n");
> +	else
> +		clk_prepare_enable(host->biu_clk);
> +
> +	host->ciu_clk = clk_get(host->dev, "ciu");
> +	if (IS_ERR(host->ciu_clk))
> +		dev_dbg(host->dev, "ciu clock not available\n");
> +	else
> +		clk_prepare_enable(host->ciu_clk);
> +
> +	if (IS_ERR(host->ciu_clk))
> +		host->bus_hz = host->pdata->bus_hz;
> +	else
> +		host->bus_hz = clk_get_rate(host->ciu_clk);
I have posted similar patch some time back.
bus_hz represents input rate for cclk_in of mshc.
Host of samsung soc doesn't use input clock from system directly.
As you have introduced CLKSEL in your another patch, input clock can be changed prior to cclk_in.
For non-samsung  host, we don't need to consider this with generic way?

Thanks,
Seungwon Jeon

> +
> +	if (!host->bus_hz) {
>  		dev_err(host->dev,
>  			"Platform data must supply bus speed\n");
> -		return -ENODEV;
> +		ret = -ENODEV;
> +		goto err_clk;
>  	}
> 
> -	host->bus_hz = host->pdata->bus_hz;
>  	host->quirks = host->pdata->quirks;
> 
>  	spin_lock_init(&host->lock);
> @@ -2109,6 +2126,16 @@ err_dmaunmap:
>  		regulator_disable(host->vmmc);
>  		regulator_put(host->vmmc);
>  	}
> +
> +err_clk:
> +	if (!IS_ERR(host->ciu_clk)) {
> +		clk_disable_unprepare(host->ciu_clk);
> +		clk_put(host->ciu_clk);
> +	}
> +	if (!IS_ERR(host->biu_clk)) {
> +		clk_disable_unprepare(host->biu_clk);
> +		clk_put(host->biu_clk);
> +	}
>  	return ret;
>  }
>  EXPORT_SYMBOL(dw_mci_probe);
> @@ -2142,6 +2169,12 @@ void dw_mci_remove(struct dw_mci *host)
>  		regulator_put(host->vmmc);
>  	}
> 
> +	if (!IS_ERR(host->ciu_clk))
> +		clk_disable_unprepare(host->ciu_clk);
> +	if (!IS_ERR(host->biu_clk))
> +		clk_disable_unprepare(host->biu_clk);
> +	clk_put(host->ciu_clk);
> +	clk_put(host->biu_clk);
>  }
>  EXPORT_SYMBOL(dw_mci_remove);
> 
> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
> index a37a573..787ad56 100644
> --- a/include/linux/mmc/dw_mmc.h
> +++ b/include/linux/mmc/dw_mmc.h
> @@ -78,6 +78,8 @@ struct mmc_data;
>   * @data_offset: Set the offset of DATA register according to VERID.
>   * @dev: Device associated with the MMC controller.
>   * @pdata: Platform data associated with the MMC controller.
> + * @biu_clk: Pointer to bus interface unit clock instance.
> + * @ciu_clk: Pointer to card interface unit clock instance.
>   * @slot: Slots sharing this MMC controller.
>   * @fifo_depth: depth of FIFO.
>   * @data_shift: log2 of FIFO item size.
> @@ -158,6 +160,8 @@ struct dw_mci {
>  	u16			data_offset;
>  	struct device		*dev;
>  	struct dw_mci_board	*pdata;
> +	struct clk		*biu_clk;
> +	struct clk		*ciu_clk;
>  	struct dw_mci_slot	*slot[MAX_MCI_SLOTS];
> 
>  	/* FIFO push and pull */
> --
> 1.6.6.rc2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

