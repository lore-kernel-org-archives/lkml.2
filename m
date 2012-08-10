Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab2HJQYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 12:24:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58272 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2HJQYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 12:24:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6798"; a="223981261"
Message-ID: <502535C1.8060907@codeaurora.org>
Date: Fri, 10 Aug 2012 12:24:33 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [36/36] AArch64: MAINTAINERS update
References: <1341608777-12982-37-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1341608777-12982-37-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On 07/06/2012 05:06 PM, Catalin Marinas wrote:
> This patch updates the MAINTAINERS file for the AArch64 Linux kernel
> port.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> ---
> MAINTAINERS |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index eb22272..50699f5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -192,6 +192,12 @@ S:	Supported
>  F:	Documentation/scsi/aacraid.txt
>  F:	drivers/scsi/aacraid/
>  
> +AARCH64 ARCHITECTURE
> +M:	Catalin Marinas <catalin.marinas@arm.com>
> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)

I think it's important to include the Linux ARM kernel mailing list as a recipient for these changes and I hope you'll do so in all future revisions of the 64-bit patches.

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
