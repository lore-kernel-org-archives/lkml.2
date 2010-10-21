Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab0JUQKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:10:33 -0400
Received: from mail.wdtv.com ([66.118.69.84]:55670 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469Ab0JUQKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:10:32 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.36
Date: Thu, 21 Oct 2010 12:10:20 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>
References: <AANLkTimdii2F3PsG4SxO5Zym7TB=MSGhtN+TpG=HmbcT@mail.gmail.com> <201010211050.01356.gene.heskett@gmail.com>
In-Reply-To: <201010211050.01356.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201010211210.21109.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 21, 2010, Gene Heskett wrote:
>On Wednesday, October 20, 2010, Linus Torvalds wrote:
>>So it's a week later than I wanted (plus all the days that added up
>>from me having a few 8-day weeks during this release window), but it's
>>out there now.
>
>[...]
>
>>                            Linus
>
>Built with the 2.6.35.7 .config run through a "make oldconfig" as a
>framework, it doesn't find the disk drives once the boot files are
>loaded, so sits and times out waiting for sda2 to appear.  That of
>course leaves nothing in the logs.  .config attached. ASUS M2N-SLI Delux
>mobo, sata1 through sata4 occupied by 1Tb seagate sata-II drives. 
>Currently running 32 bit pclos, uptodate with 2.6.35.7.
>
>PEBKAC or ?
>
>>---
>>
>>Al Viro (5):
>>      MIPS: Don't block signals if we'd failed to setup a sigframe
>>      MIPS: secure_computing, syscall audit: syscall number should in
>>
>>r2, not r0.
>>
>>      MIPS: Sanitize restart logics
>>      MIPS: Fix error values in case of bad_stack
>>      MIPS: do_sigaltstack() expects userland pointers
>>
>>Alex Deucher (1):
>>      drm/radeon/kms: avivo cursor workaround applies to evergreen as
>>
>>well
>>
>>Amit Shah (1):
>>      virtio: console: Don't block entire guest if host doesn't read
>>      data
>>
>>Antonio Ospite (2):
>>      HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
>>      HID: hidraw, fix a NULL pointer dereference in hidraw_write
>>
>>Avi Kivity (1):
>>      KVM: Fix fs/gs reload oops with invalid ldt
>>
>>Clemens Ladisch (1):
>>      ALSA: rawmidi: fix oops (use after free) when unloading a driver
>>
>>module
>>
>>Dan Carpenter (1):
>>      ps3disk: passing wrong variable to bvec_kunmap_irq()
>>
>>Daniel Mack (2):
>>      Input: evdev - fix Ooops in EVIOCGABS/EVIOCSABS
>>      Input: evdev - fix EVIOCSABS regression
>>
>>David Daney (2):
>>      MIPS: Repair Kbuild make clean breakage.
>>      MIPS: jz4740: Fix Kbuild Platform file.
>>      
>>      [SCSI] bsg: fix incorrect device_status value
>>      uml: fix build
>>
>>Fran�ois Jaouen (1):
>>      HID: Add Cando touch screen 15.6-inch product id
>>
>>Jon Povey (1):
>>      i2c-davinci: Fix TX setup for more SoCs
>>
>>Julia Lawall (1):
>>      SERIAL: ioc3_serial: Return -ENOMEM on memory allocation failure
>>
>>Kyle McMartin (4):
>>      m32r: restore _BLOCKABLE
>>      m32r: get_user takes an lvalue, not a pointer
>>      m32r: add kernel/.gitignore and ignore vmlinux.lds
>>      m32r: test __LITTLE_ENDIAN__ instead of __LITTLE_ENDIAN
>>
>>Linus Torvalds (4):
>>      Export dump_{write,seek} to binary loader modules
>>      De-pessimize rds_page_copy_user
>>      v4l1: fix 32-bit compat microcode loading translation
>>      Linux 2.6.36
>>
>>Marc Kleine-Budde (1):
>>      i2c-imx: do not allow interruptions when waiting for I2C to
>>
>>complete
>>
>>Martin K. Petersen (1):
>>      [SCSI] Fix VPD inquiry page wrapper
>>
>>Michel Thebeau (1):
>>      MIPS: O32 compat/N32: Fix to use compat syscall wrappers for AIO
>>
>>syscalls.
>>
>>Namhyung Kim (2):
>>      MIPS: 32-bit: Fix build failure in asm/fcntl.h
>>      MIPS: Enable ISA_DMA_API config to fix build failure
>>
>>Ohad Ben-Cohen (1):
>>      mmc: sdio: fix SDIO suspend/resume regression
>>
>>Pierre BAILLY (1):
>>      HID: Add MULTI_INPUT quirk for turbox/mosart touchscreen
>>
>>Ralf Baechle (1):
>>      MAINTAINERS: Change list for ioc_serial to linux-serial.
>>
>>Salman Qazi (1):
>>      hrtimer: Preserve timer state in remove_hrtimer()
>>
>>Sascha Hauer (1):
>>      mxc_nand: do not depend on disabling the irq in the interrupt
>>
>>handler
>>
>>Stefan Richter (1):
>>      firewire: ohci: fix TI TSB82AA2 regression since 2.6.35
>>
>>Tejun Heo (1):
>>      ubd: fix incorrect sector handling during request restart
>>
>>Wu Zhangjin (1):
>>      MIPS: Remove all generated vmlinuz* files on "make clean"
>>
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>in the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>Please read the FAQ at  http://www.tux.org/lkml/

Addendum:  a rebuild and it works, but my audio is gone, and the vga=788 at 
the end of the kernel line in my menu.lst is now invalid. I'll dbl-check 
the audio, a make oldconfig seems to have skipped some stuff.  What broke the 
video modes?

Thanks.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
It doesn't matter what you do, it only matters what you say you've
done and what you're going to do.
