Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab2KTLtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:49:31 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52779 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2KTLta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:49:30 -0500
X-AuditID: cbfee61b-b7f616d00000319b-ee-50ab6e3fcb47
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>, linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, patches@linaro.org
References: <1353300961-22632-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1353300961-22632-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 1/1] pinctrl: Samsung: Do not initialise statics to 0
Date: Tue, 20 Nov 2012 20:49:19 +0900
Message-id: <0c8a01cdc715$1312c410$39384c30$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3GEwe7xGUJWj8aTxycVDMrdoC0XQBAem7w
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI137vNUBBr3TBCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG9QeLWAqecVTsP9bO3sDYx97FyMEhIWAi0XmpoouRE8gUk7hw
	bz1bFyMXh5DAMkaJhmcrWCESJhJ7jt1ghUgsYpS4ebCFHcKZxyTR8HoxO0gVm4CGxOH3z8Bs
	EQEviYvzfzOC2MwCBhJTz+4FiwsJuEv0T1vMBmJzCnhITPvYA1YjLOAp8a51Cdg2FgFViRvf
	VrKCXMcrYCvReCgeJMwrICjxY/I9FoiRWhLrdx5ngrDlJTavecsM8Yy6xKO/uhAXGEl0z33L
	DlEiIrHvxTtGiOkCEt8mH2KBKJeV2HSAGeQTCYFF7BKvp71ngvhXUuLgihssExglZiHZPAvJ
	5llINs9CsmIBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjJC4kt7BuKrB4hCjAAejEg/v
	w4RVAUKsiWXFlbmHGCU4mJVEeJ0CVgcI8aYkVlalFuXHF5XmpBYfYvQBunwis5Rocj4w5vNK
	4g2NjU3MTExNzC1NzU1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYLTXUX0R8uPL64R4
	g3lMdxbnx/7bu1VT4MqS6ts8bmnc3Efzvz4ysZrWWLvWVdI/dMc72X0Wki9zDEo5xXdcLX7U
	skDy8bK5WZZZdrNOT+KZ5uM7d9G6DUZlmRKXrNwyJBeonA++PDnutaSbbNep5n/5171qHzF9
	LAvo8flp//LOHbZ1xSXtX5RYijMSDbWYi4oTAav3/nDYAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAV37vNUBBp+f8Fhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjOsPFrEUPOOo2H+snb2B
	sY+9i5GTQ0LARGLPsRusELaYxIV769m6GLk4hAQWMUrcPNjCDuHMY5JoeL0YrINNQEPi8Ptn
	YLaIgJfExfm/GUFsZgEDialn94LFhQTcJfqnLWYDsTkFPCSmfewBqxEW8JR417oEbBuLgKrE
	jW8rgWwODl4BW4nGQ/EgYV4BQYkfk++xQIzUkli/8zgThC0vsXnNW2aQcgkBdYlHf3UhLjCS
	6J77lh2iRERi34t3jBMYhWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpe
	cn7uJkZw3D6T3sG4qsHiEKMAB6MSD+/DhFUBQqyJZcWVuYcYJTiYlUR4nQJWBwjxpiRWVqUW
	5ccXleakFh9i9AH6cyKzlGhyPjCl5JXEGxqbmBlZGplZGJmYm+MQVhLnbfZICRASSE8sSc1O
	TS1ILYIZx8TBKdXAWPP6j8+JXyzXUrckN19z3cM2qyQ8flGaG9ufuhqjxGuLdHSL+tgYU1VO
	+31infKbn3dfZkby85d/2Q5FhK9LqT32IrVwUv8Ht0l2M8LnfutcfX3xgpZ33D7pe7RVF107
	mZhx5HSn3/u5+dPEdA86x8n94GYxnrUpZ+7P1r0WzrfOqWddr93PrMRSnJFoqMVcVJwIAOXP
	4cMIAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin Kamat wrote:
> 
> Static variables are initialised to 0 by GCC.
> Fixes the following checkpatch error:
> ERROR: do not initialise statics to 0 or NULL
> FILE: pinctrl/pinctrl-samsung.c:50:
> static unsigned int pin_base = 0;
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/pinctrl/pinctrl-samsung.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pinctrl/pinctrl-samsung.c b/drivers/pinctrl/pinctrl-
> samsung.c
> index 81c9896..36f8875 100644
> --- a/drivers/pinctrl/pinctrl-samsung.c
> +++ b/drivers/pinctrl/pinctrl-samsung.c
> @@ -47,7 +47,7 @@ struct pin_config {
>  	{ "samsung,pin-pud-pdn", PINCFG_TYPE_PUD_PDN },
>  };
> 
> -static unsigned int pin_base = 0;
> +static unsigned int pin_base;
> 
>  static inline struct samsung_pin_bank *gc_to_pin_bank(struct gpio_chip
> *gc)
>  {
> --
> 1.7.4.1

Looks OK to me.

Linus, can I pick this up in my tree?

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

