Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0JWFro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 01:47:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34552 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab0JWFrn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 01:47:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GvZ0jv9wI0ejFkAwh21YmtRZbzqwtdkdBrHViZ4mIrVEl0zPkFLqVWGidBqxl4/qG7
         eURLbsB5iKJRyE+mziD8QALotirY+DAdX67bIbEwBvkofVvcEv6Znb18mHszSw1POhNJ
         Wx5SibJSTaOwbNU0kES3rsEbGx6XpLrUsAmRA=
MIME-Version: 1.0
In-Reply-To: <201010230117.o9N1H2Mk032101@hera.kernel.org>
References: <201010230117.o9N1H2Mk032101@hera.kernel.org>
Date: Sat, 23 Oct 2010 11:17:42 +0530
Message-ID: <AANLkTimOHBw19TuouqNsEaBcZnfU5kaBoB0Fm+QhRz4h@mail.gmail.com>
Subject: Re: [GIT PULL] x86/trampoline for 2.6.37
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Oct 23, 2010 at 6:47 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> Borislav Petkov (1):
>      x86-32, mm: Add an initial page table for core bootstrapping
>
> H. Peter Anvin (2):
>      Merge branch 'x86/vmware' into x86/trampoline
>      Merge branch 'x86/cleanups' into x86/trampoline
>
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -12,6 +12,11 @@
>  #include <asm/segment.h>
>  #include <asm/desc.h>
>
> +#ifdef CONFIG_X86_32
> +#include <asm/pgtable.h>
> +#include <asm/pgtable_32.h>
> +#endif
> +

pgtable.h will take care of pgtable_32.h, why you are doing this ?

Thanks,
--
Jaswinder Singh.
