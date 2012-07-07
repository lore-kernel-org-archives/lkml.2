Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab2GGRCg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 13:02:36 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53823 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351Ab2GGRCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 13:02:35 -0400
MIME-Version: 1.0
Date: Sat, 7 Jul 2012 22:32:34 +0530
Message-ID: <CAHdPZaN3HNCJRDGG9kNMfHKOxQr6ULYK36DQyhaQUOM83dtUxQ@mail.gmail.com>
Subject: config warnings while selecting u300_defconfig
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While doing compiling for u300, i selected the u300_defconfig,

make ARCH=arm CROSS_COMPILE="/home/devendra/gcc-linaro-arm-linux-gnueabihf-2012.05-20120523_linux/bin/arm-linux-gnueabihf-"
u300_defconfig

my cross toolchain is


linux# gcc-linaro-arm-linux-gnueabihf-2012.05-20120523_linux/bin/arm-linux-gnueabihf-gcc
--version

arm-linux-gnueabihf-gcc (crosstool-NG linaro-1.13.1-2012.05-20120523 -
Linaro GCC 2012.05) 4.7.1 20120514 (prerelease)


i got the following warnings,



root@devendra:/home/devendra/linux# make ARCH=arm
CROSS_COMPILE="/home/devendra/gcc-linaro-arm-linux-gnueabihf-2012.05-20120523_linux/bin/arm-linux-gnueabihf-"
drivers/pinctrl/
scripts/kconfig/conf --silentoldconfig Kconfig
include/config/auto.conf:394:warning: symbol value 'm' invalid for
STMMAC_PLATFORM
include/config/auto.conf:730:warning: symbol value 'elf64-x86-64'
invalid for OUTPUT_FORMAT
include/config/auto.conf:1050:warning: symbol value
'arch/x86/configs/x86_64_defconfig' invalid for ARCH_DEFCONFIG
include/config/auto.conf:1335:warning: symbol value '' invalid for
ACPI_CUSTOM_DSDT_FILE
include/config/auto.conf:2388:warning: symbol value '-fcall-saved-rdi
-fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8
-fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11' invalid for
ARCH_HWEIGHT_CFLAGS


i m not sure whether this is a compiler issue or a real warning.

Thanks,
Devendra.
