Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960Ab2LJBkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 20:40:06 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:16266 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758Ab2LJBkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 20:40:04 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-00-50c53d71ecd6
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Axel Lin'" <axel.lin@ingics.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-kernel@vger.kernel.org
References: <1354027788.13128.1.camel@phoenix>
 <CACRpkdaz3XmrOxAWqk-gC4sXYhy=v4SJ2FTkUHBW8QCSRzOAig@mail.gmail.com>
In-reply-to: <CACRpkdaz3XmrOxAWqk-gC4sXYhy=v4SJ2FTkUHBW8QCSRzOAig@mail.gmail.com>
Subject: RE: [PATCH] pinctrl: exynos5440/samsung: Staticize pcfgs
Date: Mon, 10 Dec 2012 10:40:00 +0900
Message-id: <031e01cdd677$453d9b10$cfb8d130$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3QGJDBJN+kzs47QxmMrW98aIVgIAGXp5HA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI91C26MBBp2r1Swu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGqpYGpoJ9HBV3mr+xNTD+YOti5OSQEDCRaH50iwXCFpO4cG89
	UJyLQ0hgGaPEmlm/WWCKJtzZB5WYzigx4eBPKGcek8SB1vusIFVsAhoSh98/YwexRQTqJTas
	+MvcxcjBwSzgJzFxJ9g2IYFSiZ5p58CGcgoES8xu2MgGUiIs4CjxfoUaSJhFQFWi9ekbJhCb
	V8BWYtLZ+ywQtqDEj8n3wGxmAS2JzduaWCFseYnNa96CbZIQUJd49FcX4gAjiUdtb6FKRCT2
	vXjHCDFeQOLb5EMsEOWyEpsOMIM8IiEwj13i2M1LzBDvSkocXHGDZQKjxCwkm2ch2TwLyeZZ
	SFYsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRESV1I7GFc2WBxiFOBgVOLhDVA8GiDE
	mlhWXJl7iFGCg1lJhJfr2JEAId6UxMqq1KL8+KLSnNTiQ4w+QJdPZJYSTc4HxnxeSbyhsbGJ
	mYmpibmlqbkpDmElcd5mj5QAIYH0xJLU7NTUgtQimHFMHJxSDYxzTjMu2bM+4Uq5wpN3r23T
	WO+daH66ydRPI3/l03LflQppHE4us3OZ9vk/t5tQpjCf+b5I65mZxYv1O9zU2LeodD1pOBp7
	xUiA29u8Otjy+mlWLdfnf/7yCGzdItaqHrKewbQwet9ExVWGUuunijQ6bz7n+c3ZIHVO6cqv
	e+w0Nxzt4NvXxKrEUpyRaKjFXFScCAAATMjT2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jQd1C26MBBr1XlCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqqWBqaCfRwVd5q/sTUw
	/mDrYuTkkBAwkZhwZx+ULSZx4d56IJuLQ0hgOqPEhIM/oZx5TBIHWu+zglSxCWhIHH7/jB3E
	FhGol9iw4i9zFyMHB7OAn8TEnWCDhARKJXqmnWMBsTkFgiVmN2xkAykRFnCUeL9CDSTMIqAq
	0fr0DROIzStgKzHp7H0WCFtQ4sfke2A2s4CWxOZtTawQtrzE5jVvwTZJCKhLPPqrC3GAkcSj
	trdQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNz
	NzGCo/aZ1A7GlQ0WhxgFOBiVeHgDFI8GCLEmlhVX5h5ilOBgVhLh5Tp2JECINyWxsiq1KD++
	qDQntfgQow/QoxOZpUST84EJJa8k3tDYxMzI0sjMwsjE3ByHsJI4b7NHSoCQQHpiSWp2ampB
	ahHMOCYOTqkGxsKclZsjjr3/KvFW6RGTgr1TWrtJ+rKWkLUHNE8IFWTOvbhkPeuFtcUfWVyq
	3qqn2stM4zDN6T8XdE1o086FXRn6mS9OLXITVOuo3eTX3bZN81pi5sEQk5YArbX9x5nv7Svy
	k9ufZTy5eaeZvYBQ2k+BPY5nTntO237uzdWprzpaDGpMg1uWKrEUZyQaajEXFScCAClkzjsH	AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 
> On Tue, Nov 27, 2012 at 3:49 PM, Axel Lin <axel.lin@ingics.com> wrote:
> 
> > I got below build error with random config if CONFIG_PINCTRL_SAMSUNG=y
> &&
> > CONFIG_PINCTRL_EXYNOS5440=y.
> >
> > Fix the build error by making pcfgs static.
> >
> >   LD      drivers/pinctrl/built-in.o
> > drivers/pinctrl/pinctrl-exynos5440.o: In function `.LANCHOR0':
> > pinctrl-exynos5440.c:(.data+0x54): multiple definition of `pcfgs'
> > drivers/pinctrl/pinctrl-samsung.o:pinctrl-samsung.c:(.data+0x54): first
> defined here
> > make[2]: *** [drivers/pinctrl/built-in.o] Error 1
> > make[1]: *** [drivers/pinctrl] Error 2
> > make: *** [drivers] Error 2
> >
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> I'm not handling the Samsung drivers for this merge window.
> Samsung guys, can you please pick up this patch?
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
Applied, thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

