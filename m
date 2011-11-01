Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab1KATYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:24:35 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58157 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1KATYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:24:33 -0400
Message-ID: <4EB046F9.7060306@us.ibm.com>
Date: Tue, 01 Nov 2011 14:22:33 -0500
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: avi@redhat.com, mingo@redhat.com, x86@kernel.org, hpa@zytor.com,
        arnd@arndb.de, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, ryanh@linux.vnet.ibm.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 1/6 V2] Add flag to indicate that a vm was stopped by
 the host
References: <1320091650-24682-1-git-send-email-emunson@mgebm.net> <1320091650-24682-2-git-send-email-emunson@mgebm.net>
In-Reply-To: <1320091650-24682-2-git-send-email-emunson@mgebm.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11110119-1780-0000-0000-0000009E5849
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 03:07 PM, Eric B Munson wrote:
> This flag will be used to check if the vm was stopped by the host when a soft
> lockup was detected.
>
> Signed-off-by: Eric B Munson<emunson@mgebm.net>

Adding Jeremy since the pvclock ABI is shared across Xen and KVM.

Regards,

Anthony Liguori

> ---
>   arch/x86/include/asm/pvclock-abi.h |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/include/asm/pvclock-abi.h b/arch/x86/include/asm/pvclock-abi.h
> index 35f2d19..6167fd7 100644
> --- a/arch/x86/include/asm/pvclock-abi.h
> +++ b/arch/x86/include/asm/pvclock-abi.h
> @@ -40,5 +40,6 @@ struct pvclock_wall_clock {
>   } __attribute__((__packed__));
>
>   #define PVCLOCK_TSC_STABLE_BIT	(1<<  0)
> +#define PVCLOCK_GUEST_STOPPED	(1<<  1)
>   #endif /* __ASSEMBLY__ */
>   #endif /* _ASM_X86_PVCLOCK_ABI_H */

