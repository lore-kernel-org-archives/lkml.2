Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab2GVN5T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 09:57:19 -0400
Received: from shutemov.name ([176.9.204.213]:44188 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684Ab2GVN5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 09:57:18 -0400
Date: Sun, 22 Jul 2012 16:58:07 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/build change for v3.6
Message-ID: <20120722135807.GA17513@shutemov.name>
References: <20120722134451.GA7099@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120722134451.GA7099@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 03:44:51PM +0200, Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest x86-build-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-build-for-linus
> 
>    HEAD: d9b0cde91c60da0ed5f92cdc3ac878142e6b5f27 x86-64, gcc: Use -mpreferred-stack-boundary=3 if supported
> 
>  Thanks,
> 
> 	Ingo
> 
> ------------------>
> H.J. Lu (1):
>       x86-64, gcc: Use -mpreferred-stack-boundary=3 if supported
> 
> 
>  arch/x86/Makefile |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 1f25214..b0c5276 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -49,6 +49,9 @@ else
>          KBUILD_AFLAGS += -m64
>          KBUILD_CFLAGS += -m64
>  
> +	# Use -mpreferred-stack-boundary=3 if supported.
> +	KBUILD_CFLAGS += $(call cc-option,-mno-sse -mpreferred-stack-boundary=3)
> +

Broken indent?

>          # FIXME - should be integrated in Makefile.cpu (Makefile_32.cpu)
>          cflags-$(CONFIG_MK8) += $(call cc-option,-march=k8)
>          cflags-$(CONFIG_MPSC) += $(call cc-option,-march=nocona)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
