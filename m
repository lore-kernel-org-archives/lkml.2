Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab1LHBq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 20:46:28 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:35726 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754951Ab1LHBq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 20:46:26 -0500
Message-ID: <4EE024DB.1020409@xenotime.net>
Date: Wed, 07 Dec 2011 18:45:47 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 7 (x86, not SMP)
References: <20111207171218.e11db78531e7f20659e2ca65@canb.auug.org.au> <4EDFBA25.1020102@xenotime.net> <20111207194252.GH1669@redhat.com> <4EDFCFF9.2080906@xenotime.net> <20111207210630.GI1669@redhat.com>
In-Reply-To: <20111207210630.GI1669@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> From: Don Zickus <dzickus@redhat.com>
> Date: Wed, 7 Dec 2011 16:03:40 -0500
> Subject: [PATCH] x86, NMI: NMI selftest depends on the local apic
> 
> The selftest doesn't work with out a local apic for now.
> 
> Reported-by: Randy Durlap <rdunlap@xenotime.net>
> Signed-off-by: Don Zickus <dzickus@redhat.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  arch/x86/Kconfig.debug |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index 020a4f1..d6eea6d 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -286,7 +286,7 @@ config DEBUG_STRICT_USER_COPY_CHECKS
>  
>  config DEBUG_NMI_SELFTEST
>  	bool "NMI Selftest"
> -	depends on DEBUG_KERNEL
> +	depends on DEBUG_KERNEL && X86_LOCAL_APIC
>  	---help---
>  	  Enabling this option turns on a quick NMI selftest to verify
>  	  that the NMI behaves correctly.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
