Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab2JCLT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:19:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43674 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594Ab2JCLT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:19:57 -0400
Date: Wed, 3 Oct 2012 13:19:51 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <mjg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Add EFI maintainer entry
Message-ID: <20121003111951.GA17760@gmail.com>
References: <1349255042-20971-1-git-send-email-matt@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349255042-20971-1-git-send-email-matt@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Fleming <matt@console-pimps.org> wrote:

> From: Matt Fleming <matt.fleming@intel.com>
> 
> We're starting to need a channel through which we can funnel EFI
> patches to make sure they get merged in a timely fashion. Matthew and
> Peter seem happy enough for me to take that bullet.
> 
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Matthew Garrett <mjg@redhat.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Len Brown <len.brown@intel.com>
> ---
>  MAINTAINERS | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8c22b7f..a2a2756 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2632,6 +2632,18 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
>  S:	Maintained
>  F:	sound/usb/misc/ua101.c
>  
> +EXTENSIBLE FIRMWARE INTERFACE (EFI)
> +M:	Matt Fleming <matt.fleming@intel.com>
> +L:	linux-efi@vger.kernel.org
> +S:	Maintained
> +F:	Documentation/x86/efi-stub.txt
> +F:	arch/ia64/kernel/efi.c
> +F:	arch/x86/boot/compressed/eboot.[ch]
> +F:	arch/x86/include/asm/efi.h
> +F:	arch/x86/platform/efi/*
> +F:	drivers/firmware/efivars.c
> +F:	include/linux/efi*.h
> +

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
