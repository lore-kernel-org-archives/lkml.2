Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0KMMkT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 07:40:19 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63829 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab0KMMkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 07:40:17 -0500
Message-ID: <4CDE86C3.9080407@ru.mvista.com>
Date: Sat, 13 Nov 2010 15:38:27 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 20/20] ARM: LPAE: Add the Kconfig entries
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com> <1289584840-18097-21-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1289584840-18097-21-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 12-11-2010 21:00, Catalin Marinas wrote:

> This patch adds the ARM_LPAE and ARCH_PHYS_ADDR_T_64BIT Kconfig entries
> allowing LPAE support to be compiled into the kernel.

> Signed-off-by: Catalin Marinas<catalin.marinas@arm.com>
[...]

> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> index 8493ed0..3ca2d15 100644
> --- a/arch/arm/mm/Kconfig
> +++ b/arch/arm/mm/Kconfig
> @@ -615,6 +615,19 @@ config IO_36
>
>   comment "Processor Features"
>
> +config ARM_LPAE
> +	bool "Support for the Large Physical Address Extension"
> +	depends on MMU&&  CPU_V7
> +	help
> +	  Say Y if you have an ARMv7 processor supporting the LPAE page table
> +	  format and you would like access memory beyond the 4GB limit.

    Maybe "like to access"?

WBR, Sergei
