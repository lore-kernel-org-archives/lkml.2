Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab1ESDkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 23:40:04 -0400
Received: from eu1sys200aog109.obsmtp.com ([207.126.144.127]:36436 "EHLO
	eu1sys200aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932304Ab1ESDkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 23:40:01 -0400
Message-ID: <4DD490D1.9040201@st.com>
Date: Thu, 19 May 2011 09:08:57 +0530
From: viresh kumar <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Nicolas Pitre <nico@fluxnic.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Shiraz HASHIM <shiraz.hashim@st.com>,
        Armando VISCONTI <armando.visconti@st.com>
Subject: Re: [RFC] ARM Subarchitecture group maintainership
References: <201105181047.17309.arnd@arndb.de>
In-Reply-To: <201105181047.17309.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2011 02:17 PM, Arnd Bergmann wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8fce5e6..942d052 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -630,6 +630,17 @@ S:	Maintained
>  F:	drivers/amba/
>  F:	include/linux/amba/bus.h
>  
> +ARM SUBARCHITECTURES
> +M:	Arnd Bergmann <arnd@arndb.de>
> +M:	Nicolas Pitre <nico@fluxnic.net>
> +M:	Thomas Gleixner <tglx@linutronix.de>
> +M:	arm@kernel.org
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +S:	MAINTAINED
> +F:	arch/arm/mach-*/
> +F:	arch/arm/plat-*/
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-subarch.git
> +

Acked-by: Viresh Kumar <viresh.kumar@st.com>
(As Maintainer of SPEAr Soc from ST Microelectronics)

-- 
viresh
