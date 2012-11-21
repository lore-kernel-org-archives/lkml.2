Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2KUJnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:43:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:31358 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2KUJnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:43:16 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-bd-50aca233ad05
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        linux-samsung-soc@vger.kernel.org
Cc: linux-i2c@vger.kernel.org, "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Padmavathi Venna'" <padma.v@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Wolfram Sang'" <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1353450428-2615-1-git-send-email-dianders@chromium.org>
 <1353450428-2615-2-git-send-email-dianders@chromium.org>
In-reply-to: <1353450428-2615-2-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH 2/2] i2c: s3c2410: Get the i2c bus number from alias id
Date: Wed, 21 Nov 2012 18:43:15 +0900
Message-id: <0dfd01cdc7cc$a10b98c0$e322ca40$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HblPOtyAJMLMwSDujTmdTun+LaAAOiprg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zI13jRWsCDBbeVbTo+PuF0eLyrjls
	FjPO72NyYPb4vEkugDGKyyYlNSezLLVI3y6BK6N93zu2gh28Fasf7GRrYPzG1cXIySEhYCKx
	5t8jdghbTOLCvfVsXYxcHEICyxglDpzbxgpTdG/dG3aIxHRGieMTrzBDOH8ZJe59+8EMUsUm
	oCFx+P0zsFEiAn4SR5/vYAIpYhZYzyRxq/kY2CghgXqJzu5mIJuDg1PAVeJjWxBIWFjAW+LY
	0nWMIDaLgKrE7xvzmUBsXgFbib1fPjBD2IISPybfYwGxmQW0JNbvPM4EYctLbF7zlhlkpISA
	usSjv7oQJxhJvN33nA2iRERi34t3UOMFJL5NPsQCUS4rsekA2CsSArvYJe7MW84M8bCkxMEV
	N1gmMErMQrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYIfEmtYNx
	ZYPFIUYBDkYlHt6Na1cHCLEmlhVX5h5ilOBgVhLh3TRlTYAQb0piZVVqUX58UWlOavEhRh+g
	yycyS4km5wNTQV5JvKGxsYmZiamJuaWpuSkOYSVx3maPlAAhgfTEktTs1NSC1CKYcUwcnFIN
	jKsvLNqutak+fdeTtYy2TA4a3Ct4C3ha3j73EZeqsBWfJJ7VEzDT1l/OYO/zbTvKXr2QmSMq
	usnE26fa64Psk+qXOvPVf6Ru6kp+Etf5a/EE6w3f/YJbRKZpzzoXzzjf7vGDHddsFI1eNnEI
	JH6b4X/gtB7/rz2zr8vMYDygW/cg4vV5zfvTXiqxFGckGmoxFxUnAgDshlDm5AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xoK7xojUBBjNWyVh0/P3CaHF51xw2
	ixnn9zE5MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5jRvu8d
	W8EO3orVD3ayNTB+4+pi5OSQEDCRuLfuDTuELSZx4d56ti5GLg4hgemMEscnXmGGcP4yStz7
	9oMZpIpNQEPi8PtnYB0iAn4SR5/vYAIpYhZYzyRxq/kYK0hCSKBeorO7Gcjm4OAUcJX42BYE
	EhYW8JY4tnQdI4jNIqAq8fvGfCYQm1fAVmLvlw/MELagxI/J91hAbGYBLYn1O48zQdjyEpvX
	vGUGGSkhoC7x6K8uxAlGEm/3PWeDKBGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQ
	XFCclJ5rqFecmFtcmpeul5yfu4kRHM3PpHYwrmywOMQowMGoxMO7ce3qACHWxLLiytxDjBIc
	zEoivJumrAkQ4k1JrKxKLcqPLyrNSS0+xOgD9OhEZinR5HxgoskriTc0NjEzsjQyszAyMTfH
	IawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgVGk9q3xQuuAL3Wl1dUtsyecWdPwTvL6xbiY
	xaItV8Uvij5J8WJj+ObjoMXVWnBoypMTt64em7ymT1e0RHzL1cg88++Wk6vLylZeFOVkO7nm
	wZJeyYrJJzsE3wUyLtCf2X7ieQFfa+YuobkH5zDOnbbsnKBosa2fTpLD9fUTs601/cR16t3e
	H1FiKc5INNRiLipOBAAzIeGoEwMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> From: Padmavathi Venna <padma.v@samsung.com>
> 
> Get the i2c bus number that the device is connected to using the alias
> id.  This makes debugging / grokking of kernel messages much easier.
> 
> [dianders: slight patch cleanup from Padmavathi's original.]
> 
> Signed-off-by: Padmavathi Venna <padma.v@samsung.com>
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

> ---
>  drivers/i2c/busses/i2c-s3c2410.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-
> s3c2410.c
> index 3e0335f..ca43590 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -899,11 +899,19 @@ static void
>  s3c24xx_i2c_parse_dt(struct device_node *np, struct s3c24xx_i2c *i2c)
>  {
>  	struct s3c2410_platform_i2c *pdata = i2c->pdata;
> +	int id;
> 
>  	if (!np)
>  		return;
> 
> -	pdata->bus_num = -1; /* i2c bus number is dynamically assigned */
> +	id = of_alias_get_id(np, "i2c");
> +	if (id < 0) {
> +		dev_warn(i2c->dev, "failed to get alias id:%d\n", id);
> +		pdata->bus_num = -1;
> +	} else {
> +		/* i2c bus number is statically assigned from alias */
> +		pdata->bus_num = id;
> +	}
>  	of_property_read_u32(np, "samsung,i2c-sda-delay", &pdata-
> >sda_delay);
>  	of_property_read_u32(np, "samsung,i2c-slave-addr", &pdata-
> >slave_addr);
>  	of_property_read_u32(np, "samsung,i2c-max-bus-freq",
> --
> 1.7.7.3

