Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab0F3TnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 15:43:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867Ab0F3TnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 15:43:21 -0400
Date: Wed, 30 Jun 2010 12:42:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       LKML <linux-kernel@vger.kernel.org>,
       rtc-linux <rtc-linux@googlegroups.com>
Subject: Re: [PATCH 3/3] RTC/nuc900: fix build warning
Message-Id: <20100630124242.fc966300.akpm@linux-foundation.org>
In-Reply-To: <4C231FF5.9090602@gmail.com>
References: <4C231FF5.9090602@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 17:05:57 +0800
Wan ZongShun <mcuos.com@gmail.com> wrote:

> Firstly,I am sorry for this patch, because I omit the warning
> when I submit 'nuc900-rtc-change-the-waiting-for-device-ready-implement.patch'.
> so I have to send a patch to fix it.

When fixing a warning or build error, pelase quote the compiler
messages in the changelog so we can see what got fixed.

> It is reported by Nuvoton test guys, thanks.

I don't know who that is.  Perhaps use the Reported-by: tag here?

> Signed-off-by: Wan ZongShun <mcuos.com@gmail.com>
> 
> ---
>  drivers/rtc/rtc-nuc900.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
> index 0267ea3..62de66a 100644
> --- a/drivers/rtc/rtc-nuc900.c
> +++ b/drivers/rtc/rtc-nuc900.c
> @@ -85,7 +85,7 @@ static irqreturn_t nuc900_rtc_interrupt(int irq, void *_rtc)
> 
>  static int *check_rtc_access_enable(struct nuc900_rtc *nuc900_rtc)
>  {
> -	unsigned int i, timeout = 0x1000;
> +	unsigned int timeout = 0x1000;
>  	__raw_writel(INIRRESET, nuc900_rtc->rtc_reg + REG_RTC_INIR);

Well it's pretty obvious what the warning was this time.
