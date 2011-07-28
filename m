Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab1G1Oms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 10:42:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33010 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1G1Omq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 10:42:46 -0400
MIME-Version: 1.0
In-Reply-To: <1311853470.21232.31.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1311853470.21232.31.camel@mfleming-mobl1.ger.corp.intel.com>
From: "KESHAV P.R." <skodabenz@gmail.com>
Date: Thu, 28 Jul 2011 20:12:25 +0530
Message-ID: <CAH0pPxRN_uQn74tsLyg6a-y427QAUmmFAksq2mO6K0-CEGJNgQ@mail.gmail.com>
Subject: Re: [syslinux] efilinux release 0.8
To: For discussion of Syslinux and tftp-hpa <syslinux@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
     Compile error in Archlinux x86_64 with gcc-multilib 4.6.1 ,
gnu-efi 3.0k (x86_64 UEFI libs only) - GIT devel branch - snapshot
http://git.kernel.org/?p=boot/efilinux/efilinux.git;a=snapshot;h=471830a5a7494b6ca59f914cc7e93e75ed4b2a88;sf=tgz

cc -I. -I/usr/include/efi -I/usr/include/efi/x86_64
-DEFI_FUNCTION_WRAPPER -fPIC -fshort-wchar -ffreestanding -Wall -Ifs/
-Iloaders/ -Dx86_64 -Werror   -c -o entry.o entry.c
In file included from entry.c:38:0:
protocol.h: In function 'locate_protocol':
protocol.h:62:31: error: 'EFI_BOOT_SERVICES' has no member named
'LocateProtocol'
make: *** [entry.o] Error 1


gnu-efi 3.0k File list (libs in /usr/lib/ not /usr/lib64 in Archlinux)

gnu-efi /usr/
gnu-efi /usr/include/
gnu-efi /usr/include/efi/
gnu-efi /usr/include/efi/efi.h
gnu-efi /usr/include/efi/efi_nii.h
gnu-efi /usr/include/efi/efi_pxe.h
gnu-efi /usr/include/efi/efiapi.h
gnu-efi /usr/include/efi/eficon.h
gnu-efi /usr/include/efi/efidebug.h
gnu-efi /usr/include/efi/efidef.h
gnu-efi /usr/include/efi/efidevp.h
gnu-efi /usr/include/efi/efierr.h
gnu-efi /usr/include/efi/efifs.h
gnu-efi /usr/include/efi/efigpt.h
gnu-efi /usr/include/efi/efilib.h
gnu-efi /usr/include/efi/efilink.h
gnu-efi /usr/include/efi/efinet.h
gnu-efi /usr/include/efi/efipart.h
gnu-efi /usr/include/efi/efiprot.h
gnu-efi /usr/include/efi/efipxebc.h
gnu-efi /usr/include/efi/efirtlib.h
gnu-efi /usr/include/efi/efiser.h
gnu-efi /usr/include/efi/efistdarg.h
gnu-efi /usr/include/efi/efiui.h
gnu-efi /usr/include/efi/libsmbios.h
gnu-efi /usr/include/efi/pci22.h
gnu-efi /usr/include/efi/protocol/
gnu-efi /usr/include/efi/protocol/adapterdebug.h
gnu-efi /usr/include/efi/protocol/eficonsplit.h
gnu-efi /usr/include/efi/protocol/efidbg.h
gnu-efi /usr/include/efi/protocol/efivar.h
gnu-efi /usr/include/efi/protocol/intload.h
gnu-efi /usr/include/efi/protocol/legacyboot.h
gnu-efi /usr/include/efi/protocol/piflash64.h
gnu-efi /usr/include/efi/protocol/vgaclass.h
gnu-efi /usr/include/efi/romload.h
gnu-efi /usr/include/efi/x86_64/
gnu-efi /usr/include/efi/x86_64/efibind.h
gnu-efi /usr/include/efi/x86_64/efilibplat.h
gnu-efi /usr/include/efi/x86_64/pe.h
gnu-efi /usr/lib/
gnu-efi /usr/lib/crt0-efi-x86_64.o
gnu-efi /usr/lib/elf_x86_64_efi.lds
gnu-efi /usr/lib/libefi.a
gnu-efi /usr/lib/libgnuefi.a

Firmware to be used is Tianocore UDK/EDK2 DUET x86_64 (UEFI 2.3.1
compliant reference implementation)
https://gitorious.org/tianocore_uefi_duet_builds (wiki
https://gitorious.org/tianocore_uefi_duet_builds/pages/Home ) and
VirtualBox EFI firmware (based on Tianocore OVMF). I already boot
grub2 (x86_64-efi platform) with it (including Linux 3.0 x86_64
kernel).

Can this be built using Tianocore EDK2 libraries instead of gnu-efi.
Also is this going to be syslinux UEFI bootloader or independent of
it? Thanks for the program.

Regards.

Keshav
