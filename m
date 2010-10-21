Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0JUAAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:00:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54448 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0JUAAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jr60yDwgibSq8m8aa5Wek0dfkEtscRb5Qfr6vV2NW6dd9ulopjcLyUKI/j1isAiuk8
         LWCbvzF8nX5ghO36guYZop3XeJFgJ8vOY57Q/dSDstIrNk1VWpeSKMQyG34HJlkboiU/
         9GX7NF9ycT8HkafowggtINLD65mIMw4Vo3hUE=
MIME-Version: 1.0
In-Reply-To: <AANLkTimdii2F3PsG4SxO5Zym7TB=MSGhtN+TpG=HmbcT@mail.gmail.com>
References: <AANLkTimdii2F3PsG4SxO5Zym7TB=MSGhtN+TpG=HmbcT@mail.gmail.com>
Date: Thu, 21 Oct 2010 09:00:07 +0900
Message-ID: <AANLkTinLUHHxBr78OjpJujh_fQZgp1KgtVU5qARJp4_a@mail.gmail.com>
Subject: Re: Linux 2.6.36
From: Minchan Kim <minchan.kim@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 6:01 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So it's a week later than I wanted (plus all the days that added up
> from me having a few 8-day weeks during this release window), but it's
> out there now.
>
> The delay means that the merge window that opens now would cover the
> upcoming kernel summit. However, I really hope that everybody sends me
> their patches and pull requests _before_ KS even starts. And if you're
> affected by the kernel summit you probably won't have time during it
> to finalize anything that week anyway, especially for those staying
> for plumbers afterwards, and...
>
> So I'm going to hope that we could perhaps even do the 2.6.37 -rc1
> release and close the merge window the Sunday before KS opens. Since
> 2.6.36 was longer than usual (at least it felt that way), I wouldn't
> mind having a 2.6.37 that is shorter than usual.
>
> But holler if this really screws up any plans. Ten days instead of two
> weeks? Let's see if it's even reasonably realistic.
>
> Anyway, I'm appending the shortlog since -rc8. At least it's
> noticeably shorter than the -rc7 and -rc8 logs were, and most of it
> really is pretty small.
>
> For the bigger picture of changes since 2.6.35, see for example
>
>   http://kernelnewbies.org/Linux_2_6_36
>
> but it may be worth pointing out that we ended up disabling the new
> fanotify system calls because people were still unsure about the
> interfaces. Better let the interface discussion cook a bit longer than
> release with a bad interface that we need to redo.
>
>                            Linus
>
> ---
> Al Viro (5):
>      MIPS: Don't block signals if we'd failed to setup a sigframe
>      MIPS: secure_computing, syscall audit: syscall number should in
> r2, not r0.
>      MIPS: Sanitize restart logics
>      MIPS: Fix error values in case of bad_stack
>      MIPS: do_sigaltstack() expects userland pointers
>
> Alex Deucher (1):
>      drm/radeon/kms: avivo cursor workaround applies to evergreen as well
>
> Amit Shah (1):
>      virtio: console: Don't block entire guest if host doesn't read data
>
> Antonio Ospite (2):
>      HID: hidraw, fix a NULL pointer dereference in hidraw_ioctl
>      HID: hidraw, fix a NULL pointer dereference in hidraw_write
>
> Avi Kivity (1):
>      KVM: Fix fs/gs reload oops with invalid ldt
>
> Clemens Ladisch (1):
>      ALSA: rawmidi: fix oops (use after free) when unloading a driver module
>
> Dan Carpenter (1):
>      ps3disk: passing wrong variable to bvec_kunmap_irq()
>
> Daniel Mack (2):
>      Input: evdev - fix Ooops in EVIOCGABS/EVIOCSABS
>      Input: evdev - fix EVIOCSABS regression
>
> David Daney (2):
>      MIPS: Repair Kbuild make clean breakage.
>      MIPS: jz4740: Fix Kbuild Platform file.
>
>      [SCSI] bsg: fix incorrect device_status value
>      uml: fix build
>
> François Jaouen (1):
>      HID: Add Cando touch screen 15.6-inch product id
>
> Jon Povey (1):
>      i2c-davinci: Fix TX setup for more SoCs
>
> Julia Lawall (1):
>      SERIAL: ioc3_serial: Return -ENOMEM on memory allocation failure
>
> Kyle McMartin (4):
>      m32r: restore _BLOCKABLE
>      m32r: get_user takes an lvalue, not a pointer
>      m32r: add kernel/.gitignore and ignore vmlinux.lds
>      m32r: test __LITTLE_ENDIAN__ instead of __LITTLE_ENDIAN
>
> Linus Torvalds (4):
>      Export dump_{write,seek} to binary loader modules
>      De-pessimize rds_page_copy_user
>      v4l1: fix 32-bit compat microcode loading translation
>      Linux 2.6.36
>
> Marc Kleine-Budde (1):
>      i2c-imx: do not allow interruptions when waiting for I2C to complete
>
> Martin K. Petersen (1):
>      [SCSI] Fix VPD inquiry page wrapper
>
> Michel Thebeau (1):
>      MIPS: O32 compat/N32: Fix to use compat syscall wrappers for AIO syscalls.
>
> Namhyung Kim (2):
>      MIPS: 32-bit: Fix build failure in asm/fcntl.h
>      MIPS: Enable ISA_DMA_API config to fix build failure
>
> Ohad Ben-Cohen (1):
>      mmc: sdio: fix SDIO suspend/resume regression
>
> Pierre BAILLY (1):
>      HID: Add MULTI_INPUT quirk for turbox/mosart touchscreen
>
> Ralf Baechle (1):
>      MAINTAINERS: Change list for ioc_serial to linux-serial.
>
> Salman Qazi (1):
>      hrtimer: Preserve timer state in remove_hrtimer()
>
> Sascha Hauer (1):
>      mxc_nand: do not depend on disabling the irq in the interrupt handler
>
> Stefan Richter (1):
>      firewire: ohci: fix TI TSB82AA2 regression since 2.6.35
>
> Tejun Heo (1):
>      ubd: fix incorrect sector handling during request restart
>
> Wu Zhangjin (1):
>      MIPS: Remove all generated vmlinuz* files on "make clean"


I met "INFO: suspicious rcu_dereference_check() usage"
Maybe we need this patch http://lkml.org/lkml/2010/10/12/4


---

<SNIP>

Fast TSC calibration using PIT
Detected 2660.408 MHz processor.
Calibrating delay loop (skipped), value calculated using timer frequency.. 5320.
81 BogoMIPS (lpj=10641632)
pid_max: default: 32768 minimum: 301
Security Framework initialized
SELinux:  Disabled at boot.
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys memory
Initializing cgroup subsys freezer
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
using mwait in idle threads.
Performance Events: PEBS fmt0+, Core2 events, Intel PMU driver.
... version:                2
... bit width:              40
... generic registers:      2
... value mask:             000000ffffffffff
... max period:             000000007fffffff
... fixed-purpose events:   3
... event mask:             0000000700000003
ACPI: Core revision 20100702
ftrace: converting mcount calls to 0f 1f 44 00 00
ftrace: allocating 21862 entries in 43 pages
Enabling APIC mode:  Flat.  Using 1 I/O APICs
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Quad CPU    Q9400  @ 2.66GHz stepping 0a
lockdep: fixing up alternatives.

===================================================
[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
kernel/sched.c:618 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 0
3 locks held by kworker/0:0/4:
 #0:  (events){+.+.+.}, at: [<c015fc3e>] process_one_work+0x11e/0x470
 #1:  ((&c_idle.work)){+.+.+.}, at: [<c015fc3e>] process_one_work+0x11e/0x470
 #2:  (&rq->lock){-.....}, at: [<c066a042>] init_idle+0x29/0x111

stack backtrace:
Pid: 4, comm: kworker/0:0 Not tainted 2.6.36 #44
Call Trace:
 [<c066c9bd>] ? printk+0x1d/0x20
 [<c017ad7a>] lockdep_rcu_dereference+0xaa/0xb0
 [<c013ed8e>] set_task_rq+0x1ae/0x2d0
 [<c066a0eb>] init_idle+0xd2/0x111
 [<c066a4dd>] fork_idle+0xae/0xc1
 [<c0668f48>] do_fork_idle+0x13/0x23
 [<c015fcba>] process_one_work+0x19a/0x470
 [<c015fc3e>] ? process_one_work+0x11e/0x470
 [<c0668f35>] ? do_fork_idle+0x0/0x23
 [<c0162069>] worker_thread+0x129/0x320
 [<c0161f40>] ? worker_thread+0x0/0x320
 [<c0165e1c>] kthread+0x7c/0x90
 [<c0165da0>] ? kthread+0x0/0x90
 [<c01034fa>] kernel_thread_helper+0x6/0x10
Booting Node   0, Processors  #1
Initializing CPU#1
lockdep: fixing up alternatives.
 #2
Initializing CPU#2
lockdep: fixing up alternatives.
 #3 Ok.
Initializing CPU#3
Brought up 4 CPUs
Total of 4 processors activated (21280.57 BogoMIPS).
devtmpfs: initialized
regulator: core version 0.5
Time:  8:38:59  Date: 10/21/10
NET: Registered protocol family 16
EISA bus registered
ACPI: bus type pci registered
PCI: MMCONFIG for domain 0000 [bus 00-10] at [mem
0xf8000000-0xf90fffff] (base 0xf8000000)
PCI: not using MMCONFIG
PCI: PCI BIOS revision 2.10 entry at 0xfdc00, last bus=17
PCI: Using configuration type 1 for base access
bio: create slab <bio-0> at 0
ACPI: EC: Look up EC in DSDT
ACPI: SSDT beb5efc5 001DD (v01  PmRef  Cpu0Ist 00003000 INTL 20050228)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 001DD (v01  PmRef  Cpu0Ist 00003000 INTL 20050228)
ACPI: SSDT beb5f1a2 0016E (v01  PmRef  Cpu1Ist 00003000 INTL 20050228)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 0016E (v01  PmRef  Cpu1Ist 00003000 INTL 20050228)
ACPI: SSDT beb5f310 0016E (v01  PmRef  Cpu2Ist 00003000 INTL 20050228)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 0016E (v01  PmRef  Cpu2Ist 00003000 INTL 20050228)
ACPI: SSDT beb5f47e 0016E (v01  PmRef  Cpu3Ist 00003000 INTL 20050228)
ACPI: Dynamic OEM Table Load:
ACPI: SSDT (null) 0016E (v01  PmRef  Cpu3Ist 00003000 INTL 20050228)
ACPI: Interpreter enabled

<SNIP>

--



-- 
Kind regards,
Minchan Kim
