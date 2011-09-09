Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab1IIIYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:24:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54698 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534Ab1IIIYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:24:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v3 18/36] Hexagon: Add time and timer functions
Date: Fri, 09 Sep 2011 10:23:45 +0200
Message-ID: <8440717.zkZKr0bf7e@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110909010916.422373448@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org> <20110909010916.422373448@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:x9gV480kC9TkZcS/WsvxzIhOt+6A0RryWQDTbm/1/aw
 m+r1wF2+ZQrabbYSK3zpWS5gRcHnC5XZYMNsfhuotZ6AhqdNew
 0RTWMQyZixeZkyoEwhu448tGS0AEpzmzIdvM7iJdfRTCOIUtMu
 15M2EDic5xYMxby5KPsMu0t0cUnpY71T0FkRsr8zd6rhWmfb/0
 4YvftFipaQ2SUBjrxSbhiiS5WALlHyC2823AL/xBwB68maZTeS
 cFYEpU9Hnz6jzKDM1gEk6OwgjxVFo1mXV8+hy6Ailo8iFC0W/6
 tk43KNZWhWLEKxtnN8TbaaOjqpGG5Gnl63Sx+2922xHOOvTQnb
 nLMdnWNSWmBnt42/bGSU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> + * 8x50 HDD Specs 5-8.  Simulator co-sim not fixed until
> + * release 1.1, and then it's "adjustable" and probably not defaulted.
> + */
> +#define RTOS_TIMER_INT         3
> +#ifdef CONFIG_HEXAGON_COMET
> +#define RTOS_TIMER_REGS_ADDR   0xAB000000UL
> +#endif
> +#define SLEEP_CLK_RATE         32000

I think it would be better to pull RTOS_TIMER_REGS_ADDR from the device
tree, but this is probably good enough for 3.2.

Acked-by: Arnd Bergmann <arnd@arndb.de>
