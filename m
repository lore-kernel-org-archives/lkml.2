Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab2KFK6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 05:58:21 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:43805 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2KFK6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 05:58:20 -0500
In-Reply-To: <1352156701-4038-102-git-send-email-keescook@chromium.org>
References: <1352156701-4038-1-git-send-email-keescook@chromium.org> <1352156701-4038-102-git-send-email-keescook@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 101/104] kernel/gcov: remove depends on CONFIG_EXPERIMENTAL
X-KeepSent: F5BEBD42:730724A2-C1257AAE:003C1F79;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5.3 September 15, 2011
Message-ID: <OFF5BEBD42.730724A2-ONC1257AAE.003C1F79-C1257AAE.003C4597@de.ibm.com>
From: Peter 1 Oberparleiter <Peter.Oberparleiter@de.ibm.com>
Date: Tue, 6 Nov 2012 11:58:05 +0100
X-MIMETrack: Serialize by Router on D06MC032/06/M/IBM(Release 8.5.3 ZX853HP5|January 12, 2012) at
 06/11/2012 11:58:05,
	Serialize complete at 06/11/2012 11:58:05
Content-Type: text/plain; charset="US-ASCII"
x-cbid: 12110610-4966-0000-0000-000003FEC5BF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(resend after gw issues)

Kees Cook <keescook@chromium.org> wrote on 06.11.2012 00:04:58:
> Subject: [PATCH 101/104] kernel/gcov: remove depends on 
CONFIG_EXPERIMENTAL
> 
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> Cc: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  kernel/gcov/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/gcov/Kconfig b/kernel/gcov/Kconfig
> index a920281..d4da55d 100644
> --- a/kernel/gcov/Kconfig
> +++ b/kernel/gcov/Kconfig
> @@ -35,7 +35,7 @@ config GCOV_KERNEL
>  config GCOV_PROFILE_ALL
>     bool "Profile entire Kernel"
>     depends on GCOV_KERNEL
> -   depends on SUPERH || S390 || X86 || (PPC && EXPERIMENTAL) || 
MICROBLAZE
> +   depends on SUPERH || S390 || X86 || PPC || MICROBLAZE
>     default n
>     ---help---
>     This options activates profiling for the entire kernel.

Acked-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

