Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2D0WZo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 18:25:44 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36804 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab2D0WZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 18:25:42 -0400
Message-ID: <4F9B1CDF.7080009@linaro.org>
Date: Fri, 27 Apr 2012 15:25:35 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Richard Cochran <richardcochran@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC V1 2/5] ntp: Fix a stale comment and a few stray newlines.
References: <cover.1335510125.git.richardcochran@gmail.com> <5f62cef3da3fa954d9f4f246053e15da1724e792.1335510125.git.richardcochran@gmail.com>
In-Reply-To: <5f62cef3da3fa954d9f4f246053e15da1724e792.1335510125.git.richardcochran@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042722-4242-0000-0000-0000017B833B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 01:12 AM, Richard Cochran wrote:
> Signed-off-by: Richard Cochran<richardcochran@gmail.com>
Queued.

thanks
-john

> ---
>   kernel/time/ntp.c |    6 ++----
>   1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index f03fd83..d0a2183 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -473,8 +473,6 @@ int second_overflow(unsigned long secs)
>   							<<  NTP_SCALE_SHIFT;
>   	time_adjust = 0;
>
> -
> -
>   out:
>   	spin_unlock_irqrestore(&ntp_lock, flags);
>
> @@ -559,10 +557,10 @@ static inline void process_adj_status(struct timex *txc, struct timespec *ts)
>   	/* only set allowed bits */
>   	time_status&= STA_RONLY;
>   	time_status |= txc->status&  ~STA_RONLY;
> -
>   }
> +
>   /*
> - * Called with the xtime lock held, so we can access and modify
> + * Called with ntp_lock held, so we can access and modify
>    * all the global NTP state:
>    */
>   static inline void process_adjtimex_modes(struct timex *txc, struct timespec *ts)

