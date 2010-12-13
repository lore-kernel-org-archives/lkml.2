Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab0LMMx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 07:53:26 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:39607 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757469Ab0LMMxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 07:53:25 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <cover.1292241952.git.buytenh@wantstofly.org> <20101213123118.GA15575@mail.wantstofly.org>
MIME-Version: 1.0
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20101213123118.GA15575@mail.wantstofly.org>
Thread-Index: AcuawaeD0TpeYnyiSdqixEJjfZg4sQAAviiA
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5931
Date: Mon, 13 Dec 2010 18:23:23 +0530
Message-ID: <6f708926565a01fdf0d44eaed92de4cf@mail.gmail.com>
Subject: RE: [PATCH 17/20] mfd: twl6030: irq_data conversion.
To: Lennert Buytenhek <buytenh@wantstofly.org>,
        Balaji T Krishnamoorthy <balajitk@ti.com>,
        Rajendra Nayak <rnayak@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Lennert Buytenhek [mailto:buytenh@wantstofly.org]
> Sent: Monday, December 13, 2010 6:01 PM
> To: Balaji T K; Rajendra Nayak; Santosh Shilimkar
> Cc: Samuel Ortiz; linux-kernel@vger.kernel.org
> Subject: [PATCH 17/20] mfd: twl6030: irq_data conversion.
>
> Signed-off-by: Lennert Buytenhek <buytenh@secretlab.ca>

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

> ---
>  drivers/mfd/twl6030-irq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c
> index aaedb11..8785272 100644
> --- a/drivers/mfd/twl6030-irq.c
> +++ b/drivers/mfd/twl6030-irq.c
> @@ -325,7 +325,7 @@ int twl6030_init_irq(int irq_num, unsigned irq_base,
> unsigned irq_end)
>  	 */
>  	twl6030_irq_chip = dummy_irq_chip;
>  	twl6030_irq_chip.name = "twl6030";
> -	twl6030_irq_chip.set_type = NULL;
> +	twl6030_irq_chip.irq_set_type = NULL;
>
>  	for (i = irq_base; i < irq_end; i++) {
>  		set_irq_chip_and_handler(i, &twl6030_irq_chip,
> --
> 1.7.1
