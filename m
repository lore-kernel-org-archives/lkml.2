Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab1FIOec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:34:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752332Ab1FIOeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:34:31 -0400
Message-ID: <4DF0D9F2.8050809@redhat.com>
Date: Thu, 09 Jun 2011 10:34:26 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: CONFIG_EFI should select CONFIG_RELOCATABLE
References: <1307629964-31658-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1307629964-31658-1-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2011 10:32 AM, Matthew Garrett wrote:
> EFI doesn't provide any guarantees that any given address will be free,
> so the bootloader must have the freedom to position the kernel
> appropriately. Make CONFIG_EFI select CONFIG_RELOCATABLE in order to
> ensure that this constraint is satisfiable.
>
> Signed-off-by: Matthew Garrett<mjg@redhat.com>

Yeah, this is a requirement by the UEFI spec.

Signed-off-by: Peter Jones <pjones@redhat.com>

> ---
>   arch/x86/Kconfig |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index da34972..580cd31 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1454,6 +1454,7 @@ config ARCH_USES_PG_UNCACHED
>   config EFI
>   	bool "EFI runtime service support"
>   	depends on ACPI
> +	select RELOCATABLE
>   	---help---
>   	  This enables the kernel to use EFI runtime services that are
>   	  available (such as the EFI variable services).


-- 
         Peter

All parts should go together without forcing. You must remember that
the parts you are  reassembling were disassembled by you.  Therefore,
if you can't get them together again, there must be a reason. By all
means, do not use a hammer.
		-- IBM maintenance manual, 1925

01234567890123456789012345678901234567890123456789012345678901234567890123456789
