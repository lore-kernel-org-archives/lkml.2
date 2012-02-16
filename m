Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652Ab2BPPbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:31:50 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:33782 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134Ab2BPPbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:31:49 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Jiandong Zheng <jdzheng@broadcom.com>
Subject: Re: [PATCH] arch/arm/mach-bcmring/dma.c: included linux/sched.h twice
Date: Thu, 16 Feb 2012 16:30:52 +0100
User-Agent: KMail/1.9.10
Cc: Scott Branden <sbranden@broadcom.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1329403558-32661-1-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1329403558-32661-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201202161630.53031.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329406309;5b366e4b;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ignore this one since the fix is already in linux-next.

Danny

On Donnerstag, 16. Februar 2012, Danny Kukawka wrote:
> arch/arm/mach-bcmring/dma.c included 'linux/sched.h' twice,
> remove the duplicates.
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  arch/arm/mach-bcmring/dma.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-bcmring/dma.c b/arch/arm/mach-bcmring/dma.c
> index 1024396..e5fd241 100644
> --- a/arch/arm/mach-bcmring/dma.c
> +++ b/arch/arm/mach-bcmring/dma.c
> @@ -35,7 +35,6 @@
>
>  #include <linux/pfn.h>
>  #include <linux/atomic.h>
> -#include <linux/sched.h>
>  #include <mach/dma.h>
>
>  /* ---- Public Variables -------------------------------------------------
> */


