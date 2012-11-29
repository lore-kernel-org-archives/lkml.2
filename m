Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400Ab2K2Hqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 02:46:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:31655 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2K2Hqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 02:46:37 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-a3-50b712d144f4
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Will Newton'" <will.newton@imgtec.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1353535387-32106-1-git-send-email-dianders@chromium.org>
 <1353624835-19137-1-git-send-email-dianders@chromium.org>
 <001a01cdcd4a$cf01ad40$6d0507c0$%jun@samsung.com>
 <CAD=FV=Xdb5W_WrDPgxaTzMOYNP7DpD6Gztq9k2B85z1boUV+3w@mail.gmail.com>
In-reply-to: <CAD=FV=Xdb5W_WrDPgxaTzMOYNP7DpD6Gztq9k2B85z1boUV+3w@mail.gmail.com>
Subject: RE: [PATCH v2 1/2] mmc: dw_mmc: exynos: Stop claiming wp-gpio
Date: Thu, 29 Nov 2012 16:46:24 +0900
Message-id: <001301cdce05$a1ab0330$e5010990$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3NlQC/8K/e8fJMRQeW3zf0a7tuZwAbn2ng
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zQ92LQtsDDNaeYbe4vGsOm8WR//2M
	FjPO72NyYPb4vEkugDGKyyYlNSezLLVI3y6BK+PO6ya2giXqFe+332ZuYFwk18XIySEhYCKx
	9PsPdghbTOLCvfVsXYxcHEICyxglbl27zwpTNOXcNBaIxCJGiX2t3VDOH0aJTYdnMIJUsQlo
	Sfx984YZxBYR0JZ4+WAlM0gRs8BHJonOn+3scB0vb9xjAaniFAiWWP7/KxuILSzgJvGm9TxY
	nEVAVWLZ13tgk3gFbCWO/DnLAmELSvyYDNLLATRVT+L+RS2QMLOAvMTmNW+ZQcISAuoSj/7q
	gpgiAkYShzekQ1SISOx78Y4RYriAxLfJh1ggqmUlNh0Au1JCYB27xOoHT9ggHpaUOLjiBssE
	RolZSPbOQtg7C8neWUg2LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kREm1SOxhXNlgc
	YhTgYFTi4d1kuS1AiDWxrLgy9xCjBAezkgiv5h+gEG9KYmVValF+fFFpTmrxIUYfoMMnMkuJ
	JucDE0FeSbyhsbGJmYmpibmlqbkpDmElcd5mj5QAIYH0xJLU7NTUgtQimHFMHJxSDYyr/iZ0
	Km95W2qqfyPtr/rDH3tX84e+776mssE04KF8V8X+nQIJjX8+SXjlnxHS4ri5XnHvHpfH/oKy
	048/79cPPVb6ac8MPw8f7f4T5g23+s6UVTvsq83S/GloK5cVIOZ/wkJS6qRFx9c06/dvX2Uf
	2rVF/ej0nj32xtmvTp4y+qvQnFhuuEqJpTgj0VCLuag4EQDg6jpq4wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPIsWRmVeSWpSXmKPExsVy+t9jAd2LQtsDDBpmMVpc3jWHzeLI/35G
	ixnn9zE5MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5hx53UT
	W8ES9Yr3228zNzAukuti5OSQEDCRmHJuGguELSZx4d56ti5GLg4hgUWMEvtau1kgnD+MEpsO
	z2AEqWIT0JL4++YNM4gtIqAt8fLBSmaQImaBj0wSnT/b2eE6Xt64BzaXUyBYYvn/r2wgtrCA
	m8Sb1vNgcRYBVYllX++BTeIVsJU48ucsC4QtKPFjMkgvB9BUPYn7F7VAwswC8hKb17xlBglL
	CKhLPPqrC2KKCBhJHN6QDlEhIrHvxTvGCYxCs5DMmYUwZxaSObOQdCxgZFnFKJpakFxQnJSe
	a6hXnJhbXJqXrpecn7uJERzLz6R2MK5ssDjEKMDBqMTDu8lyW4AQa2JZcWXuIUYJDmYlEV7N
	P0Ah3pTEyqrUovz4otKc1OJDjD5AX05klhJNzgemmbySeENjEzMjSyMzCyMTc3McwkrivM0e
	KQFCAumJJanZqakFqUUw45g4OKUaGNlSdih02t3sdHr2fefnA/2PSkvd9P9ZWhusW2R1PnOF
	6qz15aFqL/3PPnu30n5roMmlcNauuXIs7M9qGBOiveyn/SupWtsdWSqv2cEfstRqBjd/RkPw
	lRmlkyNNrFT1z97k+Rak9ub6wykPuMR5jwhL6md17xNY9OSRPG/jf97X7g82Gb7drsRSnJFo
	qMVcVJwIAC+MIVcSAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On Thursday, November 29, 2012, Doug Anderson wrote:
> Seungwon,
> 
> Thanks for the review.  See below for comments.  If you'd like me to
> respin then please let me know.  Otherwise I look forward to your ack.
> 
> On Wed, Nov 28, 2012 at 1:29 AM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > Yes. pin of write protection is common property.
> > This change is good. I have some suggestion below.
> > Could you check it?
> >
> > On Friday, November 23, 2012, Doug Anderson wrote:
> >> The exynos code claimed wp-gpio with devm_gpio_request() but never did
> >> anything with it.  That meant that anyone using a write protect GPIO
> >> would effectively be write protected all the time.
> >>
> >> A future change will move the wp-gpio support to the core dw_mmc.c
> >> file.  Now the exynos-specific code won't claim the GPIO but will
> >> just set the DW_MCI_QUIRK_NO_WRITE_PROTECT quirk if write protect
> >> won't be used.
> >>
> >> Signed-off-by: Doug Anderson <dianders@chromium.org>
> >>
> >> ---
> >> Changes in v2:
> >> - Nothing new in this patch
> >>
> >>  drivers/mmc/host/dw_mmc-exynos.c |   12 ++++++------
> >>  1 files changed, 6 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> >> index 4d50da6..58cc03e 100644
> >> --- a/drivers/mmc/host/dw_mmc-exynos.c
> >> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> >> @@ -175,12 +175,12 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
> >>               }
> >>       }
> >>
> >> -     gpio = of_get_named_gpio(slot_np, "wp-gpios", 0);
> >> -     if (gpio_is_valid(gpio)) {
> >> -             if (devm_gpio_request(host->dev, gpio, "dw-mci-wp"))
> >> -                     dev_info(host->dev, "gpio [%d] request failed\n",
> >> -                                             gpio);
> >> -     } else {
> >> +     /*
> >> +      * If there are no write-protect GPIOs present then we assume no write
> >> +      * protect.  The mci_readl() in dw_mmc.c won't work since it's not
> >> +      * hooked up on exynos.
> >> +      */
> >> +     if (!of_find_property(slot_np, "wp-gpios", NULL)) {
> >>               dev_info(host->dev, "wp gpio not available");
> >>               host->pdata->quirks |= DW_MCI_QUIRK_NO_WRITE_PROTECT;
> >>       }
> > All card types need this quirk in case wp-gpio property is empty?
> > I think wp-pin is valid for SD card, not eMMC/SDIO.
> 
> Right.  It is only checked right now by the SD code (mmc/core/sd.c).
> It doesn't particularly hurt to set it the quirk in other cases though
> and it seems nice not to add special cases.  I could imagine someone
> extending the MMC code at some point to support write protect (via
> GPIO) for eMMC, so there's even a slight justification for avoiding
> the special case.
> 
> 
> > Of course, I know origin code did it.
> > How about removing whole checking routine?
> > Instead, new definition for this quirk can be added into 'dw_mci_of_quirks'(dw_mmc.c) and dts file.
> 
> On _exynos_ all SD cards need this quirk if there is no wp-gpio
> property.  However this is not generally true for all users of dw_mmc.
>  The DesignWare IP Block actually has a write protect input that can
> be read with "mci_readl(slot->host, WRTPRT)" but on exynos the
> DesignWare write protect line isn't exposed on any physical pins.
> That means that the only possible way to do write protect on exynos is
> using a GPIO.
> 
> The above means that on exynos if the GPIO isn't defined we will
> assume no write protect.  On other platforms if the GPIO isn't defined
> we'll assume that the "mci_readl" will work and we'll use that.
> 
> If people would prefer it I can code up an alternate solution that
> doesn't touch any exynos code but that would introduce a new device
> tree binding.  We could accomplish what's needed for exynos using a
> property like "broken-internal-wp".
> 
> Please let me know if you'd like me to submit a new patch with this
> solution or if you like the existing solution.
> 
Write protect is additional interface related with SD socket. 
WP switch appears in SD standard size card. 
In case EMMC/SDIO spec, there is no mentions about this WP pin.
As you mentioned above, that's why 'ger_ro' is called only in sd path(mmc/core/sd.c).
So, I meant that we don't need to consider WP pin status about non-SD type.

Such as exynos5250, there is no exposed interface from host controller for write protection pin.
In that case, if general gpio pin is connected like your board environment, we can define wp-gpio.
Otherwise, 'broken-internal-wp' property will be good solution.

Please feel free to modify.
If you will do, I'll be happy.

Thanks,
Seungwon Jeon
> >> --
> >> 1.7.7.3
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

