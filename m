Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897Ab0JTVCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 17:02:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755093Ab0JTVCA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 17:02:00 -0400
MIME-Version: 1.0
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Oct 2010 14:01:27 -0700
Message-ID: <AANLkTimdii2F3PsG4SxO5Zym7TB=MSGhtN+TpG=HmbcT@mail.gmail.com>
Subject: Linux 2.6.36
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So it's a week later than I wanted (plus all the days that added up
from me having a few 8-day weeks during this release window), but it's
out there now.

The delay means that the merge window that opens now would cover the
upcoming kernel summit. However, I really hope that everybody sends me
their patches and pull requests _before_ KS even starts. And if you're
affected by the kernel summit you probably won't have time during it
to finalize anything that week anyway, especially for those staying
for plumbers afterwards, and...

So I'm going to hope that we could perhaps even do the 2.6.37 -rc1
release and close the merge window the Sunday before KS opens. Since
2.6.36 was longer than usual (at least it felt that way), I wouldn't
mind having a 2.6.37 that is shorter than usual.

But holler if this really screws up any plans. Ten days instead of two
weeks? Let's see if it's even reasonably realistic.

Anyway, I'm appending the shortlog since -rc8. At least it's
noticeably shorter than the -rc7 and -rc8 logs were, and most of it
really is pretty small.

For the bigger picture of changes since 2.6.35, see for example

   http://kernelnewbies.org/Linux_2_6_36

but it may be worth pointing out that we ended up disabling the new
fanotify system calls because people were still unsure about the
interfaces. Better let the interface discussion cook a bit longer than
release with a bad interface that we need to redo.

                            Linus

---
Al Viro (5):
      MIPS: Don't block signals if we'd failed to setup a sigframe
      MIPS: secure_computing, syscall audit: syscall number should in
r2, not r0.
      MIPS: Sanitize restart logics
      MIPS: Fix error values in case of bad_stack
      MIPS: do_sigaltstack() expects userland pointers

Alex Deucher (1):
      drm/radeon/kms: avivo cursor workaround applies to evergreen as well

Amit Shah (1):
      virtio: console: Don't block entire guest if host doesn't read data

Antonio Ospite (2):
      HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
      HID: hidraw, fix a NULL pointer dereference in hidraw_write

Avi Kivity (1):
      KVM: Fix fs/gs reload oops with invalid ldt

Clemens Ladisch (1):
      ALSA: rawmidi: fix oops (use after free) when unloading a driver module

Dan Carpenter (1):
      ps3disk: passing wrong variable to bvec_kunmap_irq()

Daniel Mack (2):
      Input: evdev - fix Ooops in EVIOCGABS/EVIOCSABS
      Input: evdev - fix EVIOCSABS regression

David Daney (2):
      MIPS: Repair Kbuild make clean breakage.
      MIPS: jz4740: Fix Kbuild Platform file.

      [SCSI] bsg: fix incorrect device_status value
      uml: fix build

François Jaouen (1):
      HID: Add Cando touch screen 15.6-inch product id

Jon Povey (1):
      i2c-davinci: Fix TX setup for more SoCs

Julia Lawall (1):
      SERIAL: ioc3_serial: Return -ENOMEM on memory allocation failure

Kyle McMartin (4):
      m32r: restore _BLOCKABLE
      m32r: get_user takes an lvalue, not a pointer
      m32r: add kernel/.gitignore and ignore vmlinux.lds
      m32r: test __LITTLE_ENDIAN__ instead of __LITTLE_ENDIAN

Linus Torvalds (4):
      Export dump_{write,seek} to binary loader modules
      De-pessimize rds_page_copy_user
      v4l1: fix 32-bit compat microcode loading translation
      Linux 2.6.36

Marc Kleine-Budde (1):
      i2c-imx: do not allow interruptions when waiting for I2C to complete

Martin K. Petersen (1):
      [SCSI] Fix VPD inquiry page wrapper

Michel Thebeau (1):
      MIPS: O32 compat/N32: Fix to use compat syscall wrappers for AIO syscalls.

Namhyung Kim (2):
      MIPS: 32-bit: Fix build failure in asm/fcntl.h
      MIPS: Enable ISA_DMA_API config to fix build failure

Ohad Ben-Cohen (1):
      mmc: sdio: fix SDIO suspend/resume regression

Pierre BAILLY (1):
      HID: Add MULTI_INPUT quirk for turbox/mosart touchscreen

Ralf Baechle (1):
      MAINTAINERS: Change list for ioc_serial to linux-serial.

Salman Qazi (1):
      hrtimer: Preserve timer state in remove_hrtimer()

Sascha Hauer (1):
      mxc_nand: do not depend on disabling the irq in the interrupt handler

Stefan Richter (1):
      firewire: ohci: fix TI TSB82AA2 regression since 2.6.35

Tejun Heo (1):
      ubd: fix incorrect sector handling during request restart

Wu Zhangjin (1):
      MIPS: Remove all generated vmlinuz* files on "make clean"
