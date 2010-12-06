Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0LFPJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:09:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:64342 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab0LFPJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:09:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=txpXATppp3aniUNBQCK1ZgcjI5bYng9h/ppmCc45juBlmGqT242EIbmAHFPcEXccrc
         nTs3pcoXTHQfoNIttWmCYx7vY8zq/JR3+0FIbNu5MAllnCUwfed9uf5YF2SHfmFImmeA
         PlB4gs8MfnSAXqwMVoz8+VngLVVC2xB/6iCkI=
MIME-Version: 1.0
In-Reply-To: <20101206140055.34289498.sfr@canb.auug.org.au>
References: <20101206140055.34289498.sfr@canb.auug.org.au>
Date: Mon, 6 Dec 2010 16:09:33 +0100
Message-ID: <AANLkTi=iCZ=XQk3zXwK-BPnK4=9SU5W-arf+rom9dx8V@mail.gmail.com>
Subject: Re: linux-next: Tree for December 6
From: Zimny Lech <napohybelskurwysynom2010@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ave,

2010/12/6 Stephen Rothwell <sfr@canb.auug.org.au>:
> Hi all,
>
> [The mirroring on kernel.org is currently being slow, so this release may
> not be available yet.]
>
> Changes since 20101203:
>

Nothing new here, only known issues

Kernel: arch/x86/boot/bzImage is ready  (#5)
  Building modules, stage 2.
  MODPOST 314 modules
ERROR: "dma_release_channel" [drivers/serial/pch_uart.ko] undefined!
ERROR: "__dma_request_channel" [drivers/serial/pch_uart.ko] undefined!
WARNING: modpost: Found 4 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make: *** [sub-make] Error 2


WARNING: modpost: Found 9 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `pch_uart_startup':
pch_uart.c:(.text+0x102efc): undefined reference to `__dma_request_channel'
pch_uart.c:(.text+0x102f46): undefined reference to `__dma_request_channel'
pch_uart.c:(.text+0x103037): undefined reference to `dma_release_channel'
drivers/built-in.o: In function `pch_uart_shutdown':
pch_uart.c:(.text+0x103135): undefined reference to `dma_release_channel'
pch_uart.c:(.text+0x103151): undefined reference to `dma_release_channel'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2


  LD      drivers/rtc/built-in.o
make[4]: *** No rule to make target
`drivers/scsi/aic7xxx/aicasm/*.[chyl]', needed by
`drivers/scsi/aic7xxx/aicasm/aicasm'.  Stop.
make[3]: *** [drivers/scsi/aic7xxx] Error 2
make[2]: *** [drivers/scsi] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2

  GEN     /home/test/linux-2.6-obj/Makefile
scripts/kconfig/conf --silentoldconfig Kconfig
warning: (SCSI_SRP && SCSI_LOWLEVEL && SCSI && PCI) selects SCSI_TGT
which has unmet direct dependencies (SCSI && EXPERIMENTAL)
warning: (HAVE_TEXT_POKE_SMP && SMP) selects STOP_MACHINE which has
unmet direct dependencies (SMP && MODULE_UNLOAD || HOTPLUG_CPU)
warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS && CRYPTO
&& EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects CRYPTO_GF128MUL
which has unmet dire
warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C &&
!MEDIA_TUNER_CUSTOMISE) selects MEDIA_TUNER_TEA5761 which has unmet
direct dependencies (MEDIA
*
* Restart config...
*
*
* USB Gadget Support
*
USB Gadget Support (USB_GADGET) [Y/n/?] y
  Debugging information files (DEVELOPMENT) (USB_GADGET_DEBUG_FILES) [N/y/?] n
  Debugging information files in debugfs (DEVELOPMENT)
(USB_GADGET_DEBUG_FS) [N/y/?] n
  Maximum VBUS Power usage (2-500 mA) (USB_GADGET_VBUS_DRAW) [2] 2
  USB Peripheral Controller
  > 1. Renesas R8A66597 USB Peripheral Controller (USB_GADGET_R8A66597)
    2. PXA9xx Processor USB2.0 controller (USB_GADGET_PXA_U2O)
    3. Renesas M66592 USB Peripheral Controller (USB_GADGET_M66592)
    4. AMD5536 UDC (USB_GADGET_AMD5536UDC)
    5. MIPS USB CI13xxx (USB_GADGET_CI13XXX)
    6. NetChip 228x (USB_GADGET_NET2280)
    7. Toshiba TC86C001 'Goku-S' (USB_GADGET_GOKU)
    8. Intel Langwell USB Device Controller (USB_GADGET_LANGWELL)
    9. Intel EG20T(Topcliff) USB Device controller (USB_GADGET_EG20T)
    10. Dummy HCD (DEVELOPMENT) (USB_GADGET_DUMMY_HCD)
  choice[1-10?]: 1
  USB Gadget Drivers
    1. Gadget Zero (DEVELOPMENT) (USB_ZERO)
    2. Audio Gadget (EXPERIMENTAL) (USB_AUDIO)
  > 3. Ethernet Gadget (with CDC Ethernet support) (USB_ETH)
    4. File-backed Storage Gadget (USB_FILE_STORAGE)
    5. Mass Storage Gadget (USB_MASS_STORAGE)
    6. Serial Gadget (with CDC ACM and CDC OBEX support) (USB_G_SERIAL)
    7. Printer Gadget (USB_G_PRINTER)
    8. CDC Composite Device (Ethernet and ACM) (USB_CDC_COMPOSITE)
    9. Nokia composite gadget (USB_G_NOKIA)
    10. Multifunction Composite Gadget (EXPERIMENTAL) (USB_G_MULTI)
    11. HID Gadget (USB_G_HID)
    12. EHCI Debug Device Gadget (USB_G_DBGP)
    13. USB Webcam Gadget (USB_G_WEBCAM)
  choice[1-13?]: 3
    RNDIS support (USB_ETH_RNDIS) [Y/n/?] (NEW) aborted!

Console input/output is redirected. Run 'make oldconfig' to update
configuration.

make[3]: *** [silentoldconfig] Error 1
make[2]: *** [silentoldconfig] Error 2
make[1]: *** No rule to make target `include/config/auto.conf', needed
by `include/config/kernel.release'.  Stop.
make: *** [sub-make] Error 2


-- 
Slawa!
Zimny "Spie dziadu!" Lech z Wawelu

Piekielny strach zagrzmia³
Patrzê na sufit
Krew tam
Strzêpy g³ów w bólach jêcz± co¶
