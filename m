Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708Ab2BOD2G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 22:28:06 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:56749 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932159Ab2BOD14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 22:27:56 -0500
Message-ID: <4F3B2631.6080900@st.com>
Date: Wed, 15 Feb 2012 08:57:45 +0530
From: Viresh Kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>
Subject: Re: [PATCH] [trivial] arm: Fix typo in spear3[012]0.c
References: <1329230142-2063-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1329230142-2063-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/2012 8:05 PM, Masanari Iida wrote:
> Correct spelling "registeration" to "registration" in
> arch/arm/mach-spear3xx/spear300.c, spear310.c and spear320.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  arch/arm/mach-spear3xx/spear300.c |    2 +-
>  arch/arm/mach-spear3xx/spear310.c |    2 +-
>  arch/arm/mach-spear3xx/spear320.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-spear3xx/spear300.c b/arch/arm/mach-spear3xx/spear300.c
> index a5e46b4..4f7f518 100644
> --- a/arch/arm/mach-spear3xx/spear300.c
> +++ b/arch/arm/mach-spear3xx/spear300.c
> @@ -469,7 +469,7 @@ void __init spear300_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
>  	if (pmx_driver.base) {
>  		ret = pmx_register(&pmx_driver);
>  		if (ret)
> -			printk(KERN_ERR "padmux: registeration failed. err no"
> +			printk(KERN_ERR "padmux: registration failed. err no"
>  					": %d\n", ret);
>  		/* Free Mapping, device selection already done */
>  		iounmap(pmx_driver.base);
> diff --git a/arch/arm/mach-spear3xx/spear310.c b/arch/arm/mach-spear3xx/spear310.c
> index 9004cf9..febaa6f 100644
> --- a/arch/arm/mach-spear3xx/spear310.c
> +++ b/arch/arm/mach-spear3xx/spear310.c
> @@ -303,6 +303,6 @@ void __init spear310_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
>  
>  	ret = pmx_register(&pmx_driver);
>  	if (ret)
> -		printk(KERN_ERR "padmux: registeration failed. err no: %d\n",
> +		printk(KERN_ERR "padmux: registration failed. err no: %d\n",
>  				ret);
>  }
> diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
> index ee29bef..deaaf19 100644
> --- a/arch/arm/mach-spear3xx/spear320.c
> +++ b/arch/arm/mach-spear3xx/spear320.c
> @@ -550,6 +550,6 @@ void __init spear320_init(struct pmx_mode *pmx_mode, struct pmx_dev **pmx_devs,
>  
>  	ret = pmx_register(&pmx_driver);
>  	if (ret)
> -		printk(KERN_ERR "padmux: registeration failed. err no: %d\n",
> +		printk(KERN_ERR "padmux: registration failed. err no: %d\n",
>  				ret);
>  }

Thanks.

Acked-by: Viresh Kumar <viresh.kumar@st.com>

-- 
viresh
