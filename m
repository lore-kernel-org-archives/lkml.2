Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab2GJLoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:44:16 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44953 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2GJLoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:44:15 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYPSM_2SjNyeJ5o-PXGkTPcCRAqePRh9bRT54hAjZotCQ@mail.gmail.com>
References: <CAHdPZaN3HNCJRDGG9kNMfHKOxQr6ULYK36DQyhaQUOM83dtUxQ@mail.gmail.com>
	<CACRpkdYPSM_2SjNyeJ5o-PXGkTPcCRAqePRh9bRT54hAjZotCQ@mail.gmail.com>
Date: Tue, 10 Jul 2012 17:14:14 +0530
Message-ID: <CAHdPZaMrXD==UNMnKv7oaUrjaR1RBP=cJBycYSmsO33fC0VqeQ@mail.gmail.com>
Subject: Re: config warnings while selecting u300_defconfig
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 12:38 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Sat, Jul 7, 2012 at 7:02 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
>
>> While doing compiling for u300, i selected the u300_defconfig,
> (...)
>> i got the following warnings,
>>
>> root@devendra:/home/devendra/linux# make ARCH=arm
>> CROSS_COMPILE="/home/devendra/gcc-linaro-arm-linux-gnueabihf-2012.05-20120523_linux/bin/arm-linux-gnueabihf-"
>> drivers/pinctrl/
>> scripts/kconfig/conf --silentoldconfig Kconfig
>> include/config/auto.conf:394:warning: symbol value 'm' invalid for
>> STMMAC_PLATFORM
>> include/config/auto.conf:730:warning: symbol value 'elf64-x86-64'
>> invalid for OUTPUT_FORMAT
>> include/config/auto.conf:1050:warning: symbol value
>> 'arch/x86/configs/x86_64_defconfig' invalid for ARCH_DEFCONFIG
>> include/config/auto.conf:1335:warning: symbol value '' invalid for
>> ACPI_CUSTOM_DSDT_FILE
>> include/config/auto.conf:2388:warning: symbol value '-fcall-saved-rdi
>> -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8
>> -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11' invalid for
>> ARCH_HWEIGHT_CFLAGS
>
> The world is full of warnings, but I cannot see that any of these relate to
> the pinctrl subsystem ...
>
> You can surely fix them, but I won't be of any help to do so :-/
>
Actually its my mistake, those errors are just bogus, i was wrongly
doing the things , sorry,

> Yours,
> Linus Walleij

Devendra.
