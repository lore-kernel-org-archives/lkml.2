Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1FMFlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 01:41:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36260 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab1FMFlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 01:41:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A/lFiEZABWZhmrw5zykiigxzkwCexAjnsxL+Romolf9cPlABXZDyxP3kR8I+P8V9hd
         dHDTNYcLy8FHJzpoBJ90avnT1miM0kozLsigJlv9eXg2rja2fqRtcXrtIsgMqENrcX4w
         JHnhlWsJhS6W4X67BDM8LHUd70zbxz//wJOqQ=
MIME-Version: 1.0
In-Reply-To: <1307941517.2703.0.camel@Tux>
References: <1307939723-2953-1-git-send-email-wanlong.gao@gmail.com>
	<BANLkTiknFkJ+TE5OYBuJm8gOoi1pMzbzTA@mail.gmail.com>
	<1307941517.2703.0.camel@Tux>
Date: Sun, 12 Jun 2011 22:41:45 -0700
Message-ID: <BANLkTik2tgB98qyfdJJLi7_J-9_BJUp+gg@mail.gmail.com>
Subject: Re: [PATCH] Documentation:fix the wrong file position in sched-arch.txt
From: Connor Hansen <cmdkhh@gmail.com>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 12, 2011 at 10:05 PM, Wanlong Gao <wanlong.gao@gmail.com> wrote:
> On 日, 2011-06-12 at 21:56 -0700, Connor Hansen wrote:
>> On Sun, Jun 12, 2011 at 9:35 PM, Wanlong Gao <wanlong.gao@gmail.com> wrote:
>> > The arch i386 had changed to x86.
>>
>> $ grep -R "i386" Documentation/ | wc -l
>> 155
>>
>> Fix them all with:
>> grep -lZR "i386" Documentation/ | xargs -0 -l sed -i -e 's/i386/x86/g'
>>
>> or send ~ 100 patches
> You see, but not all i386 can change to x86 in Documentation/
> right?

Documentation/filesystems/fuse.txt:  limited anyway to 32 pages (which
is 128kbyte on i386).
Documentation/filesystems/nfs/nfsroot.txt:   cdrecord dev=ATAPI:1,0,0
arch/i386/boot/image.iso
Documentation/filesystems/ntfs.txt:will find the precompiled (i386)
ldminfo utility there.  NOTE: You will not be
Documentation/filesystems/proc.txt:i386 and x86_64 platforms support
the new IRQ vector displays.
Documentation/filesystems/sysfs.txt:- The buffer will always be
PAGE_SIZE bytes in length. On i386, this
Documentation/filesystems/configfs/configfs.txt:of one page
(PAGE_SIZE, 4096 on i386).
Documentation/scsi/BusLogic.txt:Then install "arch/i386/boot/zImage"
as your standard kernel, run lilo if
Documentation/scsi/ChangeLog.sym53c8xx: - Only check for SISL/RAID on
i386 platforms.
Documentation/scsi/ChangeLog.sym53c8xx:   compiled for __i386__ when
normal IOs are used.
Documentation/scsi/ChangeLog.sym53c8xx: - Do not use the
readX()/writeX() kernel functions for __i386__,
Documentation/scsi/ibmmca.txt:      that the kernel was compiled for
i386 and the 9595 has a 486DX-2.
Documentation/scsi/ChangeLog.ncr53c8xx:   compiled for __i386__ when
normal IOs are used.
Documentation/scsi/ncr53c8xx.txt:This driver has been tested OK with
linux/i386, Linux/Alpha and Linux/PPC.
Documentation/robust-futexes.txt:i386 and x86_64 syscalls are wired up
at the moment, and Ulrich has
Documentation/robust-futexes.txt:tested the new glibc code (on x86_64
and i386), and it works for his
Documentation/isdn/README.HiSax:     cp
/usr/src/linux/arch/i386/boot/zImage /etc/kernel/linux.isdn
Documentation/highuid.txt:- The ELF core dump format only supports
16-bit UIDs on arm, i386, m68k,
Documentation/highuid.txt:  16-bit UIDs on arm, i386, m68k, sh, and sparc32.
Documentation/DocBook/kernel-hacking.tmpl:    on i386 because the GCC
runtime functions for it are missing from
Documentation/DocBook/genericirq.tmpl:  to unnecessary code
duplication: for example in i386, there is a
Documentation/00-INDEX:x86/i386/
Documentation/s390/Debugging390.txt:that are being included ( e.g.
double check that you aren't going to the i386 asm directory ).
Documentation/cdrom/cdrom-standard.tex:  that \linux\ now supports
(\ie, i386-PCs, Sparc Suns, etc.)
Documentation/fb/s3fb.txt:all on i386.
Documentation/fb/cirrusfb.txt:  i386
Documentation/memory-barriers.txt:     that's primarily a CPU-specific
concept. The i386 and x86_64 processors do
Documentation/memory-barriers.txt:     CPUs as i386 and x86_64 -
readily maps to the CPU's concept of I/O
Documentation/memory-barriers.txt:     Accesses to this space may be
fully synchronous (as on i386), but
Documentation/memory-barriers.txt:     i386 architecture machines, for
example, this is controlled by way of the
Documentation/memory-barriers.txt:(such as i386 or x86_64) are more
constrained than others (such as powerpc or
Documentation/init.txt:   E.g. i386 vs. x86_64 mismatch, or trying to
load x86 on ARM hardware.
Documentation/scheduler/sched-arch.txt:arch/i386/kernel/process.c has
examples of both polling and
Documentation/binfmt_misc.txt:  echo
':i386:M::\x7fELF\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x03:\xff\xff\xff\xff\xff\xfe\xfe\xff\xff\xff\xff\xff\xff\xff\xff\xff\xfb\xff\xff:/bin/em86:'
> register
Documentation/cpu-freq/cpu-drivers.txt:the reference implementation in
arch/i386/kernel/cpu/cpufreq/longrun.c
Documentation/serial/computone.txt:e) mv
/usr/src/linux/arch/i386/boot/zImage to /boot.
Documentation/crypto/descore-readme.txt:1) you should define one of
`i386,' `vax,' `mc68000,' or `sparc,'
Documentation/crypto/descore-readme.txt:   `i386' tries to configure
the code for a 386 by only declaring 3 registers
Documentation/x86/exception-tables.txt: > vmlinux:     file format elf32-i386
Documentation/x86/x86_64/boot-options.txt:   nomce (for compatibility
with i386): same as mce=off
Documentation/x86/x86_64/boot-options.txt:   nolapic     Don't use the
local APIC (alias for i386 compatibility)
Documentation/x86/x86_64/boot-options.txt:   pirq=...    See
Documentation/x86/i386/IO-APIC.txt
Documentation/x86/x86_64/kernel-stacks:  the split thread and
interrupt stacks on i386, this gives more room
Documentation/x86/x86_64/kernel-stacks:x86_64 also has a feature which
is not available on i386, the ability
Documentation/cpu-hotplug.txt:          i386:
Documentation/cpu-hotplug.txt:i386 (Intel), ppc, ppc64, parisc, s390,
ia64 and x86_64
Documentation/zh_CN/magic-number.txt:APM_BIOS_MAGIC        0x4101
apm_user          arch/i386/kernel/apm.c
Documentation/zh_CN/HOWTO:    - x86-64, é¨åi386, Andi Kleen <ak@suse.de>
Documentation/RCU/NMI-RCU.txt:work in
"arch/i386/oprofile/nmi_timer_int.c" and in
Documentation/RCU/NMI-RCU.txt:"arch/i386/kernel/traps.c".
Documentation/RCU/NMI-RCU.txt:only on i386, which in theory does not
need rcu_dereference_sched()
Documentation/block/ioprio.txt:#if defined(__i386__)
Documentation/timers/hrtimers.txt: i386, x86_64, ARM, PPC, PPC64, IA64
Documentation/timers/hrtimers.txt: i386(UP/SMP), x86_64(UP/SMP), ARM, PPC
Documentation/timers/highres.txt:the kernel binary size. The
conversion of i386 removes about 100 lines of
Documentation/timers/highres.txt:dynamic ticks on i386 SMP systems
which stop the local APIC in C3 power
Documentation/timers/highres.txt:e.g. the PIT on i386 SMP systems.
Documentation/timers/highres.txt:systems. This has been proved to work
with the PIT on i386 and the Incrementer
Documentation/timers/highres.txt:Aside the current initial submission
of i386 support, the patchset has been
Documentation/svga.txt:   Some options can be set in the source text
(in arch/i386/boot/video.S).
Documentation/kdump/kdump.txt:   of today, i386, x86_64, ppc64 and
ia64 architectures support relocatable
Documentation/kdump/kdump.txt:Dump-capture kernel config options (Arch
Dependent, i386 and x86_64)
Documentation/kdump/kdump.txt:1) On i386, enable high memory support
under "Processor type and
Documentation/kdump/kdump.txt:2) On i386 and x86_64, disable symmetric
multi-processing support
Documentation/kdump/kdump.txt:For i386 and x86_64:
Documentation/kdump/kdump.txt:For i386, x86_64 and ia64:
Documentation/kdump/kdump.txt:  systems with more than 4GB memory. On
i386, kexec automatically checks if
Documentation/sparc/README-2.5:   way as s390 people do now. It is
analogous to "make bzImage" on i386.
Documentation/ko_KR/HOWTO:    - x86-64, partly i386, Andi Kleen < ak@suse.de>
Documentation/vm/highmem.txt: (*) i386 PAE.
Documentation/vm/highmem.txt:In the i386 arch, for example, we choose
to map the kernel into every process's
Documentation/vm/highmem.txt:i386) has to be divided between user and
kernel space.
Documentation/vm/highmem.txt:i386 PAE
Documentation/vm/highmem.txt:The i386 arch, under some circumstances,
will permit you to stick up to 64GiB
Documentation/vm/hugetlbpage.txt:that is provided by most modern
architectures.  For example, i386
Documentation/vm/hugepage-mmap.c: * Other architectures, such as
ppc64, i386 or x86_64 are not so constrained.
Documentation/vm/hugepage-shm.c: * Other architectures, such as ppc64,
i386 or x86_64 are not so constrained.
Documentation/vm/map_hugetlb.c: * specified.  Specifying a fixed
address is not required on ppc64, i386
Documentation/devices.txt:              For Linux/i386, partitions 1-4
are the primary
Documentation/networking/packet_mmap.txt:   In a i386 architecture
PAGE_SIZE is 4096 bytes
Documentation/networking/packet_mmap.txt:   In a 2.4/i386 kernel MAX_ORDER is 10
Documentation/networking/packet_mmap.txt:   In a 2.6/i386 kernel MAX_ORDER is 11
Documentation/networking/packet_mmap.txt:respectively, with an i386
architecture.
Documentation/networking/packet_mmap.txt:In a 2.4/2.6 kernel and the
i386 architecture, the limit is 131072 bytes. The
Documentation/networking/packet_mmap.txt:i386 architecture:
Documentation/networking/packet_mmap.txt:Actually, this buffer size is
not possible with an i386 architecture.
Documentation/networking/packet_mmap.txt:an i386 kernel's memory size
is limited to 1GiB.
Documentation/networking/PLIP.txt:On an i386, for example, 10^6/100 =
10000usec. It is easy to see that it is
Documentation/networking/fore200e.txt:i386, alpha (untested), powerpc,
sparc and sparc64 archs.
Documentation/sysctl/kernel.txt:if your architecture did not always
support 32-bit UIDs (i.e. arm, i386,
Documentation/blockdev/README.DAC960:Then install
"arch/i386/boot/bzImage" or "arch/i386/boot/zImage" as your
Documentation/blockdev/ramdisk.txt:./arch/i386/kernel/setup.c:#define
RAMDISK_IMAGE_START_MASK     0x07FF
Documentation/blockdev/ramdisk.txt:./arch/i386/kernel/setup.c:#define
RAMDISK_PROMPT_FLAG          0x8000
Documentation/blockdev/ramdisk.txt:./arch/i386/kernel/setup.c:#define
RAMDISK_LOAD_FLAG            0x4000
Documentation/blockdev/ramdisk.txt:     /usr/src/linux# cat
arch/i386/boot/zImage > /dev/fd0
Documentation/local_ops.txt:i386 and x86_64) and any SMP
synchronization barrier. If the architecture does
Documentation/ia64/IRQ-redir.txt:that described in
Documentation/IRQ-affinity.txt for i386 systems.
Documentation/ia64/IRQ-redir.txt:compatibility reasons with i386.
Documentation/ia64/mca.txt:    chained stacks like i386 interrupt
stacks.  But that required
Documentation/ia64/mca.txt:* i386 backtrace is not very sensitive to
whether a process is running
Documentation/virtual/kvm/api.txt:      x86 includes both i386 and x86_64.
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:  somewhat like the
i386 SysRq interface.  Since there is a full-blown
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:       This GDB was
configured as "i386-redhat-linux"...
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:       This GDB was
configured as "i386-redhat-linux"...
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:  This GDB was
configured as "i386-redhat-linux"...
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:  and linux.  If you
forget for any of them, the i386 build seems to
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:
/usr/src/linux/asm-i386.  Then, move your UML pool someplace else and
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:  which need to
include the asm-i386 versions of headers get the
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:  back to
include/asm-i386 and to do UML builds someplace else.
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:  UM_FASTCALL from
CFLAGS in arch/um/Makefile-i386.  This will open up
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:  On i386 kernels,
there are two ways of running the loop that is used
Documentation/virtual/uml/UserModeLinux-HOWTO.txt:           at
../sysdeps/unix/sysv/linux/i386/sigaction.c:125
Documentation/virtual/lguest/lguest.c:   * a Linux boot header (see
Documentation/x86/i386/boot.txt)
Documentation/virtual/lguest/lguest.txt:
http://xm-test.xensource.com/ramdisks/initrd-1.1-i386.img
Documentation/make/headers_install.txt:  make headers_install
ARCH=i386 INSTALL_HDR_PATH=/usr/include
Documentation/mca.txt:i386 Micro Channel Architecture Support
Documentation/mca.txt:bits are set properly (see
arch/i386/boot/setup.S for information on
Documentation/mca.txt:this have been added in include/linux/mca.h and
arch/i386/kernel/mca.c.
Documentation/mca.txt:arch/i386/kernel/time.c) or the first timer
interrupt hangs the system.
Documentation/Changes:reiserfsck. These utils work on both i386 and
alpha platforms.
Documentation/Changes:In Linux 2.6.31+ the i386 kernel needs to run
the mcelog utility
Documentation/feature-removal-schedule.txt:What:        i386/x86_64
bzImage symlinks
Documentation/feature-removal-schedule.txt:Why: The i386/x86_64 merge
provides a symlink to the old bzImage
Documentation/kernel-parameters.txt:    X86-32  X86-32, aka i386
architecture is enabled.
Documentation/kernel-parameters.txt:            See
Documentation/x86/i386/IO-APIC.txt.
Documentation/magic-number.txt:APM_BIOS_MAGIC        0x4101
apm_user          arch/i386/kernel/apm.c
Documentation/oops-tracing.txt:i386, split into multiple lines for readability:
Documentation/kbuild/makefiles.txt:        #arch/i386/kernel/Makefile
Documentation/kbuild/makefiles.txt:        #arch/i386/Makefile
Documentation/kbuild/makefiles.txt:        #arch/i386/Makefile
Documentation/kbuild/makefiles.txt:        #arch/i386/boot/Makefile
Documentation/kbuild/makefiles.txt:        #arch/i386/Makefile
Documentation/kbuild/makefiles.txt:             $(Q)$(MAKE)
$(clean)=arch/i386/boot
Documentation/kbuild/makefiles.txt:When "make clean" is executed, make
will descend down in arch/i386/boot,
Documentation/kbuild/makefiles.txt:and clean as usual. The Makefile
located in arch/i386/boot/ may use
Documentation/kbuild/makefiles.txt:        #arch/i386/Makefile
Documentation/kbuild/makefiles.txt:        #arch/i386/Makefile
Documentation/kbuild/makefiles.txt:        cflags-$(CONFIG_M386) += -march=i386
Documentation/kbuild/makefiles.txt:        #arch/i386/Makefile
Documentation/kbuild/makefiles.txt:        #arch/i386/Makefile
Documentation/kbuild/makefiles.txt:        boot := arch/i386/boot
Documentation/kbuild/makefiles.txt:        #arch/i386/Makefile
Documentation/kbuild/makefiles.txt:        #arch/i386/Makefile
Documentation/kbuild/makefiles.txt:        #arch/i386/kernel/Makefile
Documentation/kbuild/makefiles.txt:        #arch/i386/boot/Makefile
Documentation/kbuild/makefiles.txt:     BUILD    arch/i386/boot/bzImage
Documentation/kbuild/makefiles.txt:        #arch/i386/kernel/Makefile
Documentation/kbuild/makefiles.txt:     This variable defines the
target architecture, such as "i386",
Documentation/kbuild/kbuild.txt:x86: i386 for 32 bit, x86_64 for 64 bit
Documentation/kprobes.txt:with a breakpoint instruction (e.g., int3 on
i386 and x86_64).
Documentation/kprobes.txt:64 bytes on i386.
Documentation/kprobes.txt:- i386 (Supports jump optimization)
Documentation/kprobes.txt:4. With CISC architectures (such as i386 and
x86_64), the kprobes code
Documentation/kprobes.txt:on i386, 13 for a general protection fault
or 14 for a page fault).
Documentation/kprobes.txt:i386: Intel Pentium M, 1495 MHz, 2957.31 bogomips
Documentation/kprobes.txt:i386: Intel(R) Xeon(R) E5410, 2.33GHz,
4656.90 bogomips

I don't see any problems,
Connor

>
> Thanks
>>
>> -Connor
>>
>> >
>> > Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
>> > ---
>> >  Documentation/scheduler/sched-arch.txt |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/Documentation/scheduler/sched-arch.txt b/Documentation/scheduler/sched-arch.txt
>> > index d43dbcb..28aa107 100644
>> > --- a/Documentation/scheduler/sched-arch.txt
>> > +++ b/Documentation/scheduler/sched-arch.txt
>> > @@ -66,7 +66,7 @@ Your cpu_idle routines need to obey the following rules:
>> >            barrier issued (followed by a test of need_resched with
>> >            interrupts disabled, as explained in 3).
>> >
>> > -arch/i386/kernel/process.c has examples of both polling and
>> > +arch/x86/kernel/process.c has examples of both polling and
>> >  sleeping idle functions.
>> >
>> >
>> > --
>> > 1.7.4.1
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>
>
>
