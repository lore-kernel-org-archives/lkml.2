Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966124Ab2JZTPE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 15:15:04 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:36943 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933966Ab2JZTPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 15:15:01 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18MSulsWFNVfPZWW156umPB
Date: Fri, 26 Oct 2012 12:14:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Constantine Shulyupin <const@MakeLinux.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: remove duplicated declaration of
 omap4430_init_late
Message-ID: <20121026191455.GQ11908@atomide.com>
References: <1351272589-9885-1-git-send-email-const@MakeLinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351272589-9885-1-git-send-email-const@MakeLinux.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Constantine Shulyupin <const@MakeLinux.com> [121026 10:31]:
> From: Constantine Shulyupin <const@MakeLinux.com>
> 
> Problem:
> Function omap4430_init_late is declared twice in arch/arm/mach-omap2/common.h.
> Fix: remove out of order declaration, assuming all functions ordered accordingly processor number.
>  
> 
> Signed-off-by: Constantine Shulyupin <const@MakeLinux.com>

Thanks, applying into omap-for-v3.7-rc2/fixes-part2-take3.

Regards,

Tony

> ---
>  arch/arm/mach-omap2/common.h |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
> index 7045e4d..45478d1 100644
> --- a/arch/arm/mach-omap2/common.h
> +++ b/arch/arm/mach-omap2/common.h
> @@ -152,7 +152,6 @@ void am33xx_init_early(void);
>  void omap4430_init_early(void);
>  void omap5_init_early(void);
>  void omap3_init_late(void);	/* Do not use this one */
> -void omap4430_init_late(void);
>  void omap2420_init_late(void);
>  void omap2430_init_late(void);
>  void omap3430_init_late(void);
> -- 
> 1.7.9.5
> 
