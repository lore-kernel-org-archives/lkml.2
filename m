Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab2IWTxD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 15:53:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:33403 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754113Ab2IWTxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 15:53:01 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/5BgBWdvH5Hsbtdlcjk37KR7Sg5KGaoQboJCYiZc
	mLUSNwToOb26wl
Message-ID: <505F6893.7000202@gmx.de>
Date: Sun, 23 Sep 2012 19:52:51 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120724 Icedove/3.0.11
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/5] video: msm: Remove useless mach/* includes
References: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org> <1348038044-1790-4-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1348038044-1790-4-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 07:00 AM, Stephen Boyd wrote:
> This driver doesn't need to use these mach includes so remove
> them. This is a necessary step to support a single zImage.
> 
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Applied.


Thanks,

Florian Tobias Schandinat

> ---
>  drivers/video/msm/mddi.c   | 3 ---
>  drivers/video/msm/mdp.c    | 1 -
>  drivers/video/msm/mdp_hw.h | 1 -
>  3 files changed, 5 deletions(-)
> 
> diff --git a/drivers/video/msm/mddi.c b/drivers/video/msm/mddi.c
> index b061d70..d43e178 100644
> --- a/drivers/video/msm/mddi.c
> +++ b/drivers/video/msm/mddi.c
> @@ -26,9 +26,6 @@
>  #include <linux/clk.h>
>  #include <linux/io.h>
>  #include <linux/sched.h>
> -#include <mach/msm_iomap.h>
> -#include <mach/irqs.h>
> -#include <mach/board.h>
>  #include <mach/msm_fb.h>
>  #include "mddi_hw.h"
>  
> diff --git a/drivers/video/msm/mdp.c b/drivers/video/msm/mdp.c
> index cb2ddf1..752eff7 100644
> --- a/drivers/video/msm/mdp.c
> +++ b/drivers/video/msm/mdp.c
> @@ -25,7 +25,6 @@
>  #include <linux/major.h>
>  #include <linux/slab.h>
>  
> -#include <mach/msm_iomap.h>
>  #include <mach/msm_fb.h>
>  #include <linux/platform_device.h>
>  #include <linux/export.h>
> diff --git a/drivers/video/msm/mdp_hw.h b/drivers/video/msm/mdp_hw.h
> index d804774..2a84137 100644
> --- a/drivers/video/msm/mdp_hw.h
> +++ b/drivers/video/msm/mdp_hw.h
> @@ -15,7 +15,6 @@
>  #ifndef _MDP_HW_H_
>  #define _MDP_HW_H_
>  
> -#include <mach/msm_iomap.h>
>  #include <mach/msm_fb.h>
>  
>  struct mdp_info {

