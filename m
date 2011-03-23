Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab1CWNL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:11:57 -0400
Received: from fifo99.com ([67.223.236.141]:45725 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932891Ab1CWNLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:11:55 -0400
Subject: Re: [PATCH 09/20] video: msm: Split out MDP2.2 HW specific code.
From: Daniel Walker <dwalker@fifo99.com>
To: Carl Vanderlip <carlv@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Colin Cross <ccross@android.com>, linux-fbdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1300485423-27281-1-git-send-email-carlv@codeaurora.org>
References: <1300484846-26393-1-git-send-email-carlv@codeaurora.org>
	 <1300485423-27281-1-git-send-email-carlv@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 06:11:52 -0700
Message-ID: <1300885912.6117.16.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-18 at 14:57 -0700, Carl Vanderlip wrote:
> index df9d74e..d6e75c3 100644
> --- a/arch/arm/mach-msm/Kconfig
> +++ b/arch/arm/mach-msm/Kconfig
> @@ -76,6 +76,11 @@ config HAS_MSM_DEBUG_UART_PHYS
>  config  MSM_VIC
>         bool
>  
> +config MSM_MDP22
> +       bool
> +       depends on ARCH_MSM7X00A
> +       default y
> + 

You should remove the "default y" and this should be moved to a Kconfig
under video (shouldn't be added into mach-msm).

Daniel

