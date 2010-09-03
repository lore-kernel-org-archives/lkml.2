Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0ICUUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:20:10 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37067 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756715Ab0ICUUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:20:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type:content-transfer-encoding;
        b=HfSEF03PAX4pDGkgy1VAJCv+dCemZCOhnnBg2Wat6KKEgYXT/wgrr3FZCMGQTJZDPy
         NFmIeWgktjI3MwN2mCK94B56suTOik4Q7Tav+VWHUJwkucJMxBWNCrY6/RdFeE71Viz4
         SmXDwceuwdYxDn4JbFV38bJwhvxZ/TMQ7sHWI=
MIME-Version: 1.0
Date: Fri, 3 Sep 2010 22:20:03 +0200
X-Google-Sender-Auth: suB-yQx8rSk1PzDC8-P7y8jXoOg
Message-ID: <AANLkTi=oqzXfD5H+v08jEZft7M2sOhQEpJoiYUoRKfG=@mail.gmail.com>
Subject: Build regressions/improvements in v2.6.36-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is the list of all build error/warning regressions/improvements
in v2.6.36-rc3
compared to v2.6.35.

When comparing v2.6.36-rc3 to v2.6.36-rc2, the summaries are:
  - build errors: +64/-7
  - build warnings: +146/-109
I.e. in general the build is still regressing.

In addition, I put the verbose summary at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v2.6.36-rc3.summary.gz
so you can easily find out for which configs and architectures the
errors/warnings you're
interested in are happening.

Happy fixing! ;-)

Thanks to the linux-next team for providing the build service.


*** ERRORS ***

161 regressions:
	/opt/crosstool/gcc-4.3.2-nolibc/bin/../lib/gcc/sh4-linux/4.3.2/../../../../sh4-linux/bin/ld:
error in arch/sh/kernel/vsyscall/vsyscall-trapa.o(.eh_frame); no
.eh_frame_hdr table will be created.:  => N/A
	arch/avr32/include/asm/syscalls.h: error: previous declaration of
‘sys_execve’ was here:  => 25
	arch/avr32/kernel/process.c: error: conflicting types for ‘sys_execve’:  => 390
	arch/cris/arch-v10/drivers/sync_serial.c: error: 'ret' undeclared
(first use in this function):  => 626
	arch/cris/arch-v10/drivers/sync_serial.c: error: (Each undeclared
identifier is reported only once:  => 626
	arch/cris/arch-v10/drivers/sync_serial.c: error: conflicting types
for 'sync_serial_ioctl':  => 959
	arch/cris/arch-v10/drivers/sync_serial.c: error: for each function it
appears in.):  => 626
	arch/cris/arch-v10/drivers/sync_serial.c: error: previous declaration
of 'sync_serial_ioctl' was here:  => 160
	arch/cris/arch-v10/kernel/irq.c: error: implicit declaration of
function 'breakpoint':  => 261
	arch/cris/arch-v10/kernel/irq.c: error: implicit declaration of
function 'kgdb_init':  => 260
	arch/mips/include/asm/bug.h: error: previous definition of 'BUG' was
here:  => 12
	arch/mips/include/asm/fcntl.h: error: expected
specifier-qualifier-list before 'off_t':  => 63
	arch/parisc/include/asm/spinlock.h: error: 'asm' operand has
impossible constraints:  => 25
	arch/parisc/include/asm/spinlock.h: error: can't find a register in
class 'R1_REGS' while reloading 'asm':  => 25
	arch/powerpc/platforms/85xx/mpc85xx_mds.c: error: 'np' undeclared
(first use in this function):  => 367
	arch/powerpc/platforms/85xx/mpc85xx_mds.c: error: (Each undeclared
identifier is reported only once:  => 367
	arch/powerpc/platforms/85xx/mpc85xx_mds.c: error: for each function
it appears in.):  => 367
	arch/powerpc/platforms/85xx/p1022_ds.c: error: 'udbg_progress'
undeclared here (not in a function):  => 147
	arch/powerpc/platforms/85xx/p1022_ds.c: error: implicit declaration
of function 'lmb_end_of_DRAM':  => 100
	arch/powerpc/platforms/85xx/p1022_ds.c: error: linux/lmb.h: No such
file or directory:  => 22:23
	arch/powerpc/sysdev/fsl_rio.c: error: 'MCSR_MASK' undeclared (first
use in this function):  => 248
	arch/powerpc/sysdev/fsl_rio.c: error: (Each undeclared identifier is
reported only once:  => 248
	arch/powerpc/sysdev/fsl_rio.c: error: for each function it appears
in.):  => 248
	arch/sh/include/asm/syscalls_32.h: error: previous declaration of
'sys_execve' was here:  => 22
	arch/sh/kernel/process_32.c: error: conflicting types for 'sys_execve':  => 299
	arch/sparc/include/asm/uaccess_64.h: error: call to
'copy_from_user_overflow' declared with attribute error:
copy_from_user() buffer size is not provably correct:  => 232
	arch/xtensa/kernel/irq.c: error: 'irq_cpustat_t' has no member named
'__nmi_count':  => 107
	arch/xtensa/kernel/pci.c: error: '_PAGE_NO_CACHE' undeclared (first
use in this function):  => 362
	arch/xtensa/kernel/pci.c: error: (Each undeclared identifier is
reported only once:  => 362
	arch/xtensa/kernel/pci.c: error: for each function it appears in.):  => 362
	arch/xtensa/platforms/iss/network.c: error: 'struct net_device' has
no member named 'change_mtu':  => 697
	arch/xtensa/platforms/iss/network.c: error: 'struct net_device' has
no member named 'get_stats':  => 693
	arch/xtensa/platforms/iss/network.c: error: 'struct net_device' has
no member named 'hard_start_xmit':  => 691
	arch/xtensa/platforms/iss/network.c: error: 'struct net_device' has
no member named 'open':  => 690
	arch/xtensa/platforms/iss/network.c: error: 'struct net_device' has
no member named 'set_mac_address':  => 696
	arch/xtensa/platforms/iss/network.c: error: 'struct net_device' has
no member named 'set_multicast_list':  => 694
	arch/xtensa/platforms/iss/network.c: error: 'struct net_device' has
no member named 'stop':  => 692
	arch/xtensa/platforms/iss/network.c: error: 'struct net_device' has
no member named 'tx_timeout':  => 695
	drivers/block/hd.c: error: implicit declaration of function 'inb_p':  => 257
	drivers/block/hd.c: error: implicit declaration of function 'outb_p':  => 298
	drivers/block/paride/bpck.c: error: invalid operands to binary &
(have 'void *' and 'int'):  => 56, 62
	drivers/block/paride/kbic.c: error: invalid operands to binary |
(have 'void *' and 'int'):  => 67, 85, 53, 57, 61, 91
	drivers/char/ipmi/ipmi_si_intf.c: error: invalid operands to binary
<< (have 'void *' and 'int'):  => 1378, 1393
	drivers/char/specialix.c: error: invalid operands to binary | (have
'void *' and 'int'):  => 238, 228
	drivers/char/tpm/tpm.h: error: invalid operands to binary & (have
'void *' and 'int'):  => 125
	drivers/char/tpm/tpm_tis.c: error: implicit declaration of function
'ioread32':  => 392
	drivers/char/tpm/tpm_tis.c: error: implicit declaration of function
'ioread8':  => 83
	drivers/char/tpm/tpm_tis.c: error: implicit declaration of function
'iowrite32':  => 401
	drivers/char/tpm/tpm_tis.c: error: implicit declaration of function
'iowrite8':  => 96
	drivers/gpio/timbgpio.c: error: 'IRQ_TYPE_EDGE_BOTH' undeclared
(first use in this function):  => 146
	drivers/gpio/timbgpio.c: error: 'IRQ_TYPE_EDGE_FALLING' undeclared
(first use in this function):  => 153
	drivers/gpio/timbgpio.c: error: 'IRQ_TYPE_LEVEL_HIGH' undeclared
(first use in this function):  => 138
	drivers/gpio/timbgpio.c: error: 'IRQ_TYPE_LEVEL_LOW' undeclared
(first use in this function):  => 138
	drivers/gpio/timbgpio.c: error: 'handle_simple_irq' undeclared (first
use in this function):  => 258
	drivers/gpio/timbgpio.c: error: (Each undeclared identifier is
reported only once:  => 138
	drivers/gpio/timbgpio.c: error: dereferencing pointer to incomplete
type:  => 173
	drivers/gpio/timbgpio.c: error: for each function it appears in.):  => 138
	drivers/gpio/timbgpio.c: error: implicit declaration of function
'generic_handle_irq':  => 178
	drivers/gpio/timbgpio.c: error: implicit declaration of function
'get_irq_chip_data':  => 109
	drivers/gpio/timbgpio.c: error: implicit declaration of function
'get_irq_data':  => 169
	drivers/gpio/timbgpio.c: error: implicit declaration of function
'set_irq_chained_handler':  => 266
	drivers/gpio/timbgpio.c: error: implicit declaration of function
'set_irq_chip':  => 293
	drivers/gpio/timbgpio.c: error: implicit declaration of function
'set_irq_chip_and_handler_name':  => 257
	drivers/gpio/timbgpio.c: error: implicit declaration of function
'set_irq_chip_data':  => 259
	drivers/gpio/timbgpio.c: error: implicit declaration of function
'set_irq_data':  => 265
	drivers/gpio/timbgpio.c: error: implicit declaration of function
'set_irq_handler':  => 297
	drivers/gpio/timbgpio.c: error: unknown field 'disable' specified in
initializer:  => 184
	drivers/gpio/timbgpio.c: error: unknown field 'enable' specified in
initializer:  => 183
	drivers/gpio/timbgpio.c: error: unknown field 'name' specified in
initializer:  => 182
	drivers/gpio/timbgpio.c: error: unknown field 'set_type' specified in
initializer:  => 185
	drivers/gpio/timbgpio.c: error: variable 'timbgpio_irqchip' has
initializer but incomplete type:  => 181
	drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of
function 'ioread8':  => 74
	drivers/i2c/busses/i2c-ocores.c: error: implicit declaration of
function 'iowrite8':  => 69
	drivers/i2c/busses/i2c-pca-platform.c: error: implicit declaration of
function 'ioread8':  => 46
	drivers/i2c/busses/i2c-pca-platform.c: error: implicit declaration of
function 'iowrite8':  => 64
	drivers/input/gameport/lightning.c: error: invalid operands to binary
& (have 'void *' and 'int'):  => 177, 141, 86
	drivers/input/gameport/ns558.c: error: invalid operands to binary &
(have 'void *' and 'int'):  => 84
	drivers/input/keyboard/hil_kbd.c: error: implicit declaration of
function 'input_abs_max':  => 241
	drivers/input/touchscreen/mk712.c: error: invalid operands to binary
| (have 'void *' and 'int'):  => 129
	drivers/misc/lkdtm.c: error: 'BUG' redeclared as different kind of
symbol:  => 70
	drivers/misc/lkdtm.c: error: called object '2' is not a function:  => 281
	drivers/mmc/host/tmio_mmc.h: error: negative width in bit-field
'<anonymous>':  => 192
	drivers/net/can/sja1000/sja1000_platform.c: error: implicit
declaration of function 'ioread8':  => 41
	drivers/net/can/sja1000/sja1000_platform.c: error: implicit
declaration of function 'iowrite8':  => 46
	drivers/net/cris/eth_v10.c: error: too many arguments to function
'e100rxtx_interrupt':  => 1721
	drivers/net/hamradio/baycom_ser_fdx.c: error: invalid operands to
binary >> (have 'void *' and 'int'):  => 188
	drivers/net/hamradio/baycom_ser_fdx.c: error: invalid operands to
binary | (have 'void *' and 'int'):  => 387, 328
	drivers/net/hamradio/baycom_ser_hdx.c: error: invalid operands to
binary | (have 'void *' and 'int'):  => 446, 208
	drivers/net/hamradio/yam.c: error: invalid operands to binary ^ (have
'void *' and 'int'):  => 715
	drivers/net/hamradio/yam.c: error: invalid operands to binary | (have
'void *' and 'int'):  => 519, 483, 337, 310, 321, 318
	drivers/parport/parport_pc.c: error: asm/parport.h: No such file or
directory:  => 67:25
	drivers/parport/parport_pc.c: error: implicit declaration of function
'parport_pc_find_nonpci_ports':  => 3377
	drivers/parport/parport_pc.c: error: invalid operands to binary &
(have 'void *' and 'int'):  => 266
	drivers/parport/parport_pc.c: error: invalid operands to binary ^
(have 'void *' and 'int'):  => 1778, 123
	drivers/parport/parport_pc.c: error: invalid operands to binary |
(have 'void *' and 'int'):  => 1643, 265
	drivers/serial/8250.c: error: asm/serial.h: No such file or
directory:  => 110:24
	drivers/serial/8250.c: error: implicit declaration of function
'inb_p':  => 1278
	drivers/serial/8250.c: error: implicit declaration of function
'outb_p':  => 1279
	drivers/serial/8250_early.c: error: 'BASE_BAUD' undeclared (first use
in this function):  => 160
	drivers/serial/8250_early.c: error: (Each undeclared identifier is
reported only once:  => 160
	drivers/serial/8250_early.c: error: asm/serial.h: No such file or
directory:  => 37:24
	drivers/serial/8250_early.c: error: for each function it appears in.):  => 160
	drivers/serial/mfd.c: error: implicit declaration of function 'kfree':  => 175
	drivers/serial/mfd.c: error: implicit declaration of function
'kzalloc':  => 144
	drivers/serial/mrst_max3110.c: error: 'IRQ_TYPE_EDGE_FALLING'
undeclared (first use in this function):  => 470
	drivers/serial/mrst_max3110.c: error: (Each undeclared identifier is
reported only once:  => 470
	drivers/serial/mrst_max3110.c: error: for each function it appears
in.):  => 470
	drivers/staging/comedi/drivers.c: error: 'PAGE_KERNEL_NOCACHE'
undeclared (first use in this function):  => 505
	drivers/staging/comedi/drivers.c: error: (Each undeclared identifier
is reported only once:  => 505
	drivers/staging/comedi/drivers.c: error: for each function it appears
in.):  => 505
	error: "pci_domain_nr" [drivers/gpu/drm/drm.ko] undefined!:  => N/A
	error: "vgacon_remap_base" [drivers/video/vga16fb.ko] undefined!:  => N/A
	error: vsprintf.c: relocation truncated to fit: R_AVR32_11H_PCREL
against `.text'+718:  => (.text+0xb1e)
	fs/ceph/mds_client.c: error: insn does not satisfy its constraints::  => 3190
	fs/fcntl.c: error: negative width in bit-field '<anonymous>':  => 773
	fs/nfs/nfsroot.c: error: __setup_str_nfs_root_setup causes a section
type conflict:  => 403
	fs/ntfs/file.c: error: insn does not satisfy its constraints::  => 2069
	include/drm/drmP.h: error: implicit declaration of function
'pci_domain_nr':  => 1102
	include/linux/vgaarb.h: error: asm/vga.h: No such file or directory:  => 34:21
	include/scsi/libsrp.h: error: field 'queue' has incomplete type:  => 24
	init/Kconfig: error: recursive dependency detected!:  => 985
	kernel/cgroup.c: error: this is the insn::  => 4685, 4755
	kernel/cgroup.c: error: unable to find a register to spill in class
'R0_REGS':  => 4685, 4755
	kernel/trace/trace_clock.c: error: implicit declaration of function
'raw_local_irq_restore':  => 112
	kernel/trace/trace_clock.c: error: implicit declaration of function
'raw_local_irq_save':  => 86
	lib/atomic64_test.c: error: 'atomic64_t' undeclared (first use in
this function):  => 24
	lib/atomic64_test.c: error: 'v' undeclared (first use in this function):  => 26
	lib/atomic64_test.c: error: (Each undeclared identifier is reported
only once:  => 24
	lib/atomic64_test.c: error: expected ';' before 'v':  => 24
	lib/atomic64_test.c: error: for each function it appears in.):  => 24
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_add':  => 34
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_add_return':  => 45
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_add_unless':  => 108
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_cmpxchg':  => 99
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_dec':  => 84
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_dec_if_positive':  => 119
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_dec_return':  => 90
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_inc':  => 74
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_inc_not_zero':  => 135
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_inc_return':  => 80
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_read':  => 31
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_set':  => 28
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_sub':  => 54
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_sub_return':  => 65
	lib/atomic64_test.c: error: implicit declaration of function
'atomic64_xchg':  => 94
	mm/memcontrol.c: error: implicit declaration of function
'is_swap_pte':  => 4016
	mm/memcontrol.c: error: implicit declaration of function
'mem_cgroup_do_precharge':  => 4118
	mm/memcontrol.c: error: previous definition of
'mem_cgroup_can_attach' was here:  => 3954
	mm/memcontrol.c: error: previous definition of
'mem_cgroup_cancel_attach' was here:  => 3961
	mm/memcontrol.c: error: previous definition of 'mem_cgroup_move_task'
was here:  => 3968
	mm/memcontrol.c: error: redefinition of 'mem_cgroup_can_attach':  => 4165
	mm/memcontrol.c: error: redefinition of 'mem_cgroup_cancel_attach':  => 4206
	mm/memcontrol.c: error: redefinition of 'mem_cgroup_move_task':  => 4314
	net/mac80211/led.c: error: dereferencing pointer to incomplete type:
=> 74, 85, 63, 96
	net/mac80211/led.c: error: implicit declaration of function
'led_trigger_register':  => 64
	net/mac80211/led.c: error: implicit declaration of function
'led_trigger_unregister':  => 107
	net/mac80211/led.c: error: invalid application of 'sizeof' to
incomplete type 'struct led_trigger' :  => 92, 81, 59, 70
	net/rds/rdma.c: error: insn does not satisfy its constraints::  => 647
	sound/isa/es18xx.c: error: implicit declaration of function
'snd_dma_pointer':  => 818
	sound/isa/es18xx.c: error: implicit declaration of function
'snd_dma_program':  => 501
	sound/isa/sscape.c: error: implicit declaration of function
'snd_dma_program':  => 481


*** WARNINGS ***

616 regressions:
	.config: warning: override: SLOB changes choice state:  => 155, 111
	.config: warning: override: reassigning to symbol ENABLE_MUST_CHECK:
=> 4893, 5227
	.config: warning: override: reassigning to symbol
PROFILE_ALL_BRANCHES:  => 4891, 5225
	<stdin>: warning: #warning syscall dup3 not implemented:  => 1494:2, 1495:2
	<stdin>: warning: #warning syscall epoll_create1 not implemented:  =>
1490:2, 1491:2
	<stdin>: warning: #warning syscall eventfd2 not implemented:  => 1486:2, 1487:2
	<stdin>: warning: #warning syscall fallocate not implemented:  =>
1470:2, 1471:2
	<stdin>: warning: #warning syscall fanotify_init not implemented:  => 1526:2
	<stdin>: warning: #warning syscall fanotify_mark not implemented:  => 1530:2
	<stdin>: warning: #warning syscall inotify_init1 not implemented:  =>
1503:2, 1502:2
	<stdin>: warning: #warning syscall perf_event_open not implemented:
=> 1518:2, 1519:2
	<stdin>: warning: #warning syscall pipe2 not implemented:  => 1499:2, 1498:2
	<stdin>: warning: #warning syscall pread64 not implemented:  => 906:2, 907:2
	<stdin>: warning: #warning syscall preadv not implemented:  => 1507:2, 1506:2
	<stdin>: warning: #warning syscall prlimit64 not implemented:  => 1534:2
	<stdin>: warning: #warning syscall pwrite64 not implemented:  => 910:2, 911:2
	<stdin>: warning: #warning syscall pwritev not implemented:  => 1511:2, 1510:2
	<stdin>: warning: #warning syscall recvmmsg not implemented:  => 1523:2, 1522:2
	<stdin>: warning: #warning syscall rt_tgsigqueueinfo not implemented:
 => 1515:2, 1514:2
	<stdin>: warning: #warning syscall signalfd4 not implemented:  =>
1483:2, 1482:2
	<stdin>: warning: #warning syscall sync_file_range not implemented:
=> 1431:2, 1430:2
	<stdin>: warning: #warning syscall timerfd_create not implemented:
=> 1462:2, 1463:2
	<stdin>: warning: #warning syscall timerfd_gettime not implemented:
=> 1478:2, 1479:2
	<stdin>: warning: #warning syscall timerfd_settime not implemented:
=> 1474:2, 1475:2
	<stdin>: warning: #warning syscall umount2 not implemented:  => 394:2, 395:2
	arch/cris/arch-v10/drivers/axisflashmap.c: warning: format '%08x'
expects type 'unsigned int', but argument 3 has type 'uint64_t':  =>
356, 374, 292
	arch/cris/arch-v10/drivers/axisflashmap.c: warning: format '%08x'
expects type 'unsigned int', but argument 4 has type 'uint64_t':  =>
356, 374
	arch/cris/arch-v10/drivers/sync_serial.c: warning: initialization
from incompatible pointer type:  => 251
	arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1
of 'memcpy' discards qualifiers from pointer target type:  => 1341,
1351
	arch/cris/arch-v10/drivers/sync_serial.c: warning: passing argument 1
of 'virt_to_phys' discards qualifiers from pointer target type:  =>
1222
	arch/cris/arch-v32/drivers/axisflashmap.c: warning: ISO C90 forbids
mixed declarations and code:  => 403, 530
	arch/cris/arch-v32/drivers/axisflashmap.c: warning: cast to pointer
from integer of different size:  => 593
	arch/cris/arch-v32/drivers/axisflashmap.c: warning: format '%08x'
expects type 'unsigned int', but argument 3 has type 'uint64_t':  =>
342
	arch/cris/arch-v32/kernel/debugport.c: warning: ISO C90 forbids mixed
declarations and code:  => 123
	arch/cris/arch-v32/kernel/fasttimer.c: warning: ISO C90 forbids mixed
declarations and code:  => 353
	arch/cris/arch-v32/kernel/ptrace.c: warning: unused variable 'tmp':  => 118
	arch/cris/arch-v32/mach-a3/pinmux.c: warning: ISO C90 forbids mixed
declarations and code:  => 273, 96
	arch/cris/arch-v32/mach-fs/pinmux.c: warning: ISO C90 forbids mixed
declarations and code:  => 225, 97
	arch/cris/arch-v32/mm/intmem.c: warning: comparison of distinct
pointer types lacks a cast:  => 123, 116
	arch/cris/arch-v32/mm/intmem.c: warning: initialization from
incompatible pointer type:  => 149
	arch/cris/mm/fault.c: warning: ISO C90 forbids mixed declarations and
code:  => 205
	arch/ia64/kernel/mca.c: warning: assignment makes pointer from
integer without a cast:  => 1862
	arch/ia64/sn/kernel/bte.c: warning: cast from pointer to integer of
different size:  => 125, 117
	arch/ia64/sn/kernel/tiocx.c: warning: ignoring return value of
'bus_register', declared with attribute warn_unused_result:  => 493
	arch/ia64/sn/kernel/tiocx.c: warning: ignoring return value of
'device_create_file', declared with attribute warn_unused_result:  =>
213
	arch/ia64/sn/kernel/tiocx.c: warning: ignoring return value of
'device_register', declared with attribute warn_unused_result:  => 210
	arch/ia64/sn/pci/tioca_provider.c: warning: initialization from
incompatible pointer type:  => 660, 659
	arch/m68k/include/asm/io_mm.h: warning: this is the location of the
previous definition:  => 274:1, 271:1
	arch/m68k/include/asm/parport.h: warning: "insl" redefined:  => 14:1
	arch/m68k/include/asm/parport.h: warning: "outsl" redefined:  => 15:1
	arch/m68k/kernel/setup.c: warning: unused variable 'i':  => 218
	arch/m68k/kernel/sys_m68k.c: warning: passing argument 1 of 'kunmap'
from incompatible pointer type:  => 519, 511
	arch/m68k/mvme147/config.c: warning: #warning check me!:  => 152:2
	arch/m68k/mvme16x/config.c: warning: #warning check me!:  => 261:2
	arch/mips/pci/pci.c: warning: passing argument 2 of 'pci_fixup_irqs'
from incompatible pointer type:  => 160
	arch/mips/sibyte/bcm1480/smp.c: warning: passing argument 1 of
'__cpus_clear' discards qualifiers from pointer target type:  => 149
	arch/parisc/kernel/signal.c: warning: cast from pointer to integer of
different size:  => 294
	arch/powerpc/include/asm/io-defs.h: warning: array subscript is above
array bounds:  => 6, 11, 9
	arch/powerpc/include/asm/io.h: warning: array subscript is above
array bounds:  => 159
	arch/s390/kvm/../../../virt/kvm/kvm_main.c: warning: unused variable
'r':  => 1781
	arch/s390/mm/extmem.c: warning: 'end_addr' may be used uninitialized
in this function:  => 573
	arch/s390/mm/extmem.c: warning: 'start_addr' may be used
uninitialized in this function:  => 573
	arch/sh/boards/mach-se/770x/setup.c: warning: initialization makes
pointer from integer without a cast:  => 134, 157
	arch/sh/drivers/dma/dma-sh.c: warning: 'dmae_name' defined but not used:  => 28
	arch/sh/drivers/dma/dma-sh.c: warning: unused variable 'cnt':  => 235
	arch/sh/include/asm/ptrace.h: warning: this is the location of the
previous definition:  => 39:1
	arch/sh/kernel/cpu/clock-cpg.c: warning: 'arch_init_clk_ops' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/clock.h:58):  => 336
	arch/sh/kernel/cpu/clock-cpg.c: warning: 'arch_init_clk_ops' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/clock.h:7)  CC
kernel/kfifo.o:  => 54
	arch/sh/kernel/cpu/clock-cpg.c: warning: 'arch_init_clk_ops' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/clock.h:7):  => 54
	arch/sh/kernel/cpu/clock-cpg.c: warning: 'cpg_clk_init' is deprecated
(declared at /scratch/kisskb/src/arch/sh/kernel/cpu/clock-cpg.c:331):
=> 350
	arch/sh/kernel/cpu/clock-cpg.c: warning: 'cpg_clk_init' is deprecated
(declared at /scratch/kisskb/src/arch/sh/kernel/cpu/clock-cpg.c:49):
=> 75
	arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in
branch to syscall_call; converted into longer instruction sequence:
=> 209
	arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in
branch to syscall_exit_work; converted into longer instruction
sequence:  => 364, 361
	arch/sh/kernel/cpu/sh2/../../entry-common.S: Warning: overflow in
branch to syscall_trace_entry; converted into longer instruction
sequence:  => 337, 335
	arch/sh/kernel/cpu/sh2a/clock-sh7201.c: warning: 'return' with a
value, in function returning void:  => 37
	arch/sh/kernel/cpu/sh4/clock-sh4-202.c: warning: 'cpg_clk_init' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/clock.h:11):  => 165
	arch/sh/kernel/cpu/sh4a/clock-sh7780.c: warning: 'cpg_clk_init' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/clock.h:11):  => 112
	arch/sh/kernel/cpu/sh4a/clock-shx3.c: warning: 'cpg_clk_init' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/clock.h:11):  => 122
	arch/sh/math-emu/math.c: warning: left shift count >= width of type:
=> 334, 145, 310, 122, 108, 115
	arch/sh/math-emu/math.c: warning: left shift count is negative:  =>
333, 310, 323, 129, 122, 108, 115, 81, 92
	arch/sh/math-emu/math.c: warning: right shift count >= width of type:
 => 294, 296
	arch/sh/math-emu/math.c: warning: right shift count is negative:  =>
334, 310, 129, 122, 108, 115, 294, 324, 145
	arch/um/kernel/exec.c: warning: passing argument 2 of 'execve1' from
incompatible pointer type:  => 69, 85
	arch/um/kernel/exec.c: warning: passing argument 3 of 'execve1' from
incompatible pointer type:  => 69, 85
	arch/x86/kernel/head_32.S: Warning: shift count out of range (32 is
not between 0 and 31):  => 64
	arch/x86/kernel/pci-gart_64.c: warning: 'info.aper_base' may be used
uninitialized in this function:  => 735
	arch/xtensa/kernel/entry.S: Warning: value 0xffffffff30000000
truncated to 0x30000000:  => 1544, 1545
	arch/xtensa/kernel/pci.c: warning: format '%ld' expects type 'long
int', but argument 4 has type 'resource_size_t':  => 84
	arch/xtensa/kernel/process.c: warning: unused variable 'ti':  => 180
	arch/xtensa/kernel/time.c: warning: initialization from incompatible
pointer type:  => 42
	block/cfq-iosched.c: warning: control reaches end of non-void
function:  => 2882
	block/compat_ioctl.c: warning: 'n' may be used uninitialized in this
function:  => 191
	block/compat_ioctl.c: warning: 'udata' may be used uninitialized in
this function:  => 190
	block/elevator.c: warning: 'elevator_get' uses dynamic stack
allocation:  => 175
	crypto/anubis.c: warning: 'inter' is used uninitialized in this
function:  => 581
	crypto/async_tx/async_pq.c: warning: 'async_syndrome_val' uses
dynamic stack allocation:  => 392
	crypto/async_tx/raid6test.c: warning: 'raid6_dual_recov' uses dynamic
stack allocation:  => 131
	crypto/cbc.c: warning: 'crypto_cbc_decrypt_inplace' uses dynamic
stack allocation:  => 167
	crypto/cipher.c: warning: 'cipher_crypt_unaligned' uses dynamic stack
allocation:  => 76
	crypto/ctr.c: warning: 'crypto_ctr_crypt_final' uses dynamic stack
allocation:  => 66
	crypto/ctr.c: warning: 'crypto_ctr_crypt_inplace' uses dynamic stack
allocation:  => 119
	crypto/ctr.c: warning: 'crypto_rfc3686_crypt' uses dynamic stack
allocation:  => 300
	crypto/cts.c: warning: 'cts_cbc_decrypt' uses dynamic stack allocation:  => 217
	crypto/cts.c: warning: 'cts_cbc_encrypt' uses dynamic stack allocation:  => 123
	crypto/hmac.c: warning: 'hmac_setkey' uses dynamic stack allocation:  => 90
	crypto/pcbc.c: warning: 'crypto_pcbc_decrypt_inplace' uses dynamic
stack allocation:  => 175
	crypto/pcbc.c: warning: 'crypto_pcbc_encrypt_inplace' uses dynamic
stack allocation:  => 95
	crypto/shash.c: warning: 'shash_final_unaligned' uses dynamic stack
allocation:  => 129
	crypto/shash.c: warning: 'shash_update_unaligned' uses dynamic stack
allocation:  => 93
	crypto/testmgr.c: warning: 'alg_test_crc32c' uses dynamic stack
allocation:  => 1499
	crypto/vmac.c: warning: passing argument 1 of 'vmac_set_key' discards
qualifiers from pointer target type:  => 548
	crypto/xcbc.c: warning: 'crypto_xcbc_digest_setkey' uses dynamic
stack allocation:  => 79
	drivers/acpi/acpi_pad.c: warning: 'num_cpus' may be used
uninitialized in this function:  => 432
	drivers/acpi/acpica/nsrepair.c: warning: 'new_object' may be used
uninitialized in this function:  => 125
	drivers/acpi/sysfs.c: warning: passing argument 1 of
'__check_old_set_param' from incompatible pointer type:  => 152, 154
	drivers/ata/sata_mv.c: warning: 'msi' defined but not used:  => 80
	drivers/ata/sata_mv.c: warning: 'mv5_sht' defined but not used:  => 653
	drivers/ata/sata_mv.c: warning: 'mv_dump_pci_cfg' defined but not
used:  => 1255
	drivers/atm/nicstar.c: warning: 'err' may be used uninitialized in
this function:  => 956
	drivers/base/power/main.c: warning: comparison of distinct pointer
types lacks a cast:  => 414
	drivers/block/drbd/drbd_vli.h: warning: control reaches end of
non-void function:  => 164
	drivers/block/hd.c: warning: statement with no effect:  => 468
	drivers/block/z2ram.c: warning: format '%lu' expects type 'long
unsigned int', but argument 2 has type 'sector_t':  => 83, 82
	drivers/cdrom/gdrom.c: warning: 'ctrl_inb' is deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:94):  => 238, 149, 538,
155, 387, 400, 548, 144, 634
	drivers/cdrom/gdrom.c: warning: 'ctrl_inl' is deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:104):  => 409
	drivers/cdrom/gdrom.c: warning: 'ctrl_inw' is deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:99):  => 190
	drivers/cdrom/gdrom.c: warning: 'ctrl_outb' is deprecated (declared
at /scratch/kisskb/src/arch/sh/include/asm/io.h:114):  => 613, 204,
206, 720, 638, 617, 205, 235, 616, 615, 183, 213, 618, 199, 202, 716,
201, 717, 619, 624
	drivers/cdrom/gdrom.c: warning: 'ctrl_outl' is deprecated (declared
at /scratch/kisskb/src/arch/sh/include/asm/io.h:124):  => 605, 602,
730, 731, 603, 604, 407
	drivers/char/cyclades.c: warning: 'cyz_interrupt' defined but not
used:  => 1200, 1201
	drivers/char/hw_random/n2-drv.c: warning: initialization makes
pointer from integer without a cast:  => 390
	drivers/char/ip2/ip2main.c: warning: 'ip2main_pci_tbl' defined but
not used:  => 3212, 3194
	drivers/char/keyboard.c: warning: comparison is always true due to
limited range of data type:  => 719
	drivers/char/mbcs.c: warning: ignoring return value of
'device_create_file', declared with attribute warn_unused_result:  =>
786
	drivers/char/mem.c: warning: cast to pointer from integer of
different size:  => 342
	drivers/char/mxser.c: warning: 'mxser_disable_must_enchance_mode'
defined but not used:  => 306, 307
	drivers/char/mxser.c: warning: 'mxser_get_must_hardware_id' defined
but not used:  => 391, 392
	drivers/char/n_gsm.c: warning: ignoring return value of
'__kfifo_must_check_helper', declared with attribute
warn_unused_result:  => 1580
	drivers/char/rocket.c: warning: 'rmSpeakerReset' defined but not
used:  => 3152, 3163, 3164
	drivers/char/rocket.c: warning: 'rocket_pci_ids' defined but not
used:  => 1756, 1767
	drivers/char/rocket.c: warning: 'sPCIInitController' defined but not
used:  => 2611, 2627, 2622
	drivers/char/specialix.c: warning: 'specialx_pci_tbl' defined but not
used:  => 2359
	drivers/char/tpm/tpm.c: warning: 'tpm_suspend_setup' defined but not
used:  => 1085
	drivers/char/tpm/tpm.c: warning: format '%zd' expects type 'signed
size_t', but argument 3 has type 'ssize_t':  => 390, 423
	drivers/char/tty_buffer.c: warning: comparison of distinct pointer
types lacks a cast:  => 251, 288
	drivers/gpio/timbgpio.c: warning: (near initialization for
'timbgpio_irqchip'):  => 182, 185, 183, 184
	drivers/gpio/timbgpio.c: warning: excess elements in struct
initializer:  => 182, 185, 183, 184
	drivers/gpio/timbgpio.c: warning: initialization makes pointer from
integer without a cast:  => 109, 169, 125, 117
	drivers/gpio/wm8994-gpio.c: warning: 'wm8994_gpio_to_irq' defined but
not used:  => 84
	drivers/gpu/drm/drm_context.c: warning: passing argument 2 of
'__constant_test_and_set_bit' discards qualifiers from pointer target
type:  => 233
	drivers/gpu/drm/drm_context.c: warning: passing argument 2 of
'__generic_test_and_set_bit' discards qualifiers from pointer target
type:  => 233
	drivers/gpu/drm/drm_edid.c: warning: array subscript is above array
bounds:  => 1076, 1294, 1252
	drivers/gpu/drm/drm_pci.c: warning: passing argument 1 of
'virt_to_phys' makes pointer from integer without a cast:  => 109, 84
	drivers/gpu/drm/drm_vm.c: warning: passing argument 1 of
'virt_to_phys' makes pointer from integer without a cast:  => 308
	drivers/gpu/drm/radeon/radeon_gart.c: warning: passing argument 3 of
'pci_free_consistent' discards qualifiers from pointer target type:
=> 69
	drivers/hwmon/i5k_amb.c: warning: 'i5k_amb_ids' defined but not used:
 => 500, 493
	drivers/i2c/busses/i2c-cpm.c: warning: passing argument 3 of
'dma_alloc_coherent' from incompatible pointer type:  => 536, 543
	drivers/i2c/busses/i2c-sh7760.c: warning: 'ctrl_inl' is deprecated
(declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:104):  =>
109
	drivers/i2c/busses/i2c-sh7760.c: warning: 'ctrl_outl' is deprecated
(declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124):  =>
104
	drivers/ide/ide-floppy.c: warning: 'pc' may be used uninitialized in
this function:  => 234
	drivers/ide/ide-io-std.c: warning: statement with no effect:  => 200, 185
	drivers/ide/ide-io.c: warning: control reaches end of non-void
function:  => 295
	drivers/ide/ide-io.c: warning: passing argument 2 of
'__constant_test_and_set_bit' discards qualifiers from pointer target
type:  => 415
	drivers/ide/ide-io.c: warning: passing argument 2 of
'__generic_test_and_set_bit' discards qualifiers from pointer target
type:  => 415
	drivers/infiniband/core/uverbs_main.c: warning: the address of
'uverbs_event_fops' will always evaluate as 'true':  => 526, 537
	drivers/infiniband/hw/amso1100/c2_qp.c: warning: 'actual_sge_count'
may be used uninitialized in this function:  => 960, 798, 799, 961
	drivers/infiniband/hw/amso1100/c2_qp.c: warning: 'tot_len' may be
used uninitialized in this function:  => 797, 798
	drivers/infiniband/hw/amso1100/c2_vq.c: warning: cast from pointer to
integer of different size:  => 154, 126, 110
	drivers/infiniband/hw/cxgb4/cm.c: warning: cast to pointer from
integer of different size:  => 2326
	drivers/infiniband/hw/cxgb4/cq.c: warning: cast from pointer to
integer of different size:  => 58, 135
	drivers/infiniband/hw/cxgb4/mem.c: warning: cast from pointer to
integer of different size:  => 74
	drivers/infiniband/hw/cxgb4/qp.c: warning: cast from pointer to
integer of different size:  => 147, 1063, 988
	drivers/infiniband/hw/ipath/ipath_driver.c: warning: 'pnum' may be
used uninitialized in this function:  => 1637
	drivers/infiniband/hw/nes/nes_verbs.c: warning: cast to pointer from
integer of different size:  => 476, 3487, 477, 3486
	drivers/input/joystick/analog.c: warning: #warning Precise timer not
defined for this architecture.:  => 175:2
	drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_inb' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:94):  => 170, 158, 169,
157
	drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_inw' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:99):  => 142, 143
	drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_outb' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:114):  => 152, 161, 162,
153
	drivers/input/keyboard/jornada680_kbd.c: warning: 'ctrl_outw' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:119):  => 147, 166, 165,
148
	drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_fhs'
defined but not used:  => 319, 320
	drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_i8042timer'
defined but not used:  => 359, 360
	drivers/input/misc/hp_sdc_rtc.c: warning: 'hp_sdc_rtc_set_rt' defined
but not used:  => 280, 279
	drivers/input/misc/hp_sdc_rtc.c: warning: ignoring return value of
'down_interruptible', declared with attribute warn_unused_result:  =>
182, 178, 111
	drivers/input/misc/twl4030-vibra.c: warning: 'twl4030_vibra_resume'
defined but not used:  => 188
	drivers/input/misc/twl4030-vibra.c: warning: 'twl4030_vibra_suspend'
defined but not used:  => 177
	drivers/input/touchscreen/hp680_ts_input.c: warning: 'ctrl_inb' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:94):  => 32, 53, 40, 31,
48
	drivers/input/touchscreen/hp680_ts_input.c: warning: 'ctrl_outb' is
deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:114):  => 35, 51, 43
	drivers/isdn/hardware/eicon/message.c: warning: array subscript is
above array bounds:  => 8426, 8436, 8427, 8447, 8435, 8434
	drivers/isdn/hardware/mISDN/hfcpci.c: warning: ignoring return value
of 'driver_for_each_device', declared with attribute
warn_unused_result:  => 2320
	drivers/isdn/hardware/mISDN/mISDNipac.c: warning: unsupported
argument to '__builtin_return_address':  => 754
	drivers/isdn/hardware/mISDN/netjet.c: warning: comparison is always
false due to limited range of data type:  => 318
	drivers/isdn/hardware/mISDN/w6692.c: warning: 'enable_pots' defined
but not used:  => 560
	drivers/isdn/hardware/mISDN/w6692.c: warning: 'setvolume' defined but
not used:  => 533
	drivers/isdn/hardware/mISDN/w6692.c: warning: unsupported argument to
'__builtin_return_address':  => 1188
	drivers/isdn/hisax/config.c: warning: 'hisax_pci_tbl' defined but not
used:  => 1910, 1909
	drivers/isdn/i4l/isdn_common.c: warning: unused variable 's':  => 1285
	drivers/isdn/icn/icn.c: warning: #warning TODO test headroom or use
skb->nb to flag ACK:  => 721:4
	drivers/isdn/sc/init.c: warning: passing argument 1 of 'readl' makes
pointer from integer without a cast:  => 497, 487, 507
	drivers/leds/leds-gpio.c: warning: 'flags' may be used uninitialized
in this function:  => 251
	drivers/md/dm-raid1.c: warning: 'do_write' uses dynamic stack
allocation:  => 650
	drivers/md/dm-raid1.c: warning: 'mirror_flush' uses dynamic stack
allocation:  => 285
	drivers/md/dm-raid1.c: warning: 'mirror_status' uses dynamic stack
allocation:  => 1391
	drivers/md/dm-stripe.c: warning: 'stripe_status' uses dynamic stack
allocation:  => 336
	drivers/md/raid0.c: warning: control reaches end of non-void function:  => 424
	drivers/media/dvb/frontends/dib3000mc.c: warning: the frame size of
2208 bytes is larger than 2048 bytes:  => 853
	drivers/media/dvb/frontends/dib7000p.c: warning: the frame size of
2288 bytes is larger than 2048 bytes:  => 1367
	drivers/media/dvb/ngene/ngene-core.c: warning: unused variable
'flags':  => 1308
	drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' is used
uninitialized in this function:  => 1245
	drivers/media/video/sh_mobile_ceu_camera.c: warning: 'sd' may be used
uninitialized in this function:  => 1707, 1683, 943
	drivers/media/video/sh_mobile_ceu_camera.c: warning: unused variable
'sd':  => 1648
	drivers/media/video/vino.c: warning: 'data_norm' may be used
uninitialized in this function:  => 2566, 2656
	drivers/memstick/core/mspro_block.c: warning: control reaches end of
non-void function:  => 663
	drivers/message/fusion/mptsas.c: warning: unused variable 'log_info':  => 5010
	drivers/message/i2o/i2o_config.c: warning: cast to pointer from
integer of different size:  => 935, 880
	drivers/mfd/twl4030-irq.c: warning: passing argument 1 of
'spin_lock_irq' from incompatible pointer type:  => 571
	drivers/mfd/twl4030-irq.c: warning: passing argument 1 of
'spin_unlock_irq' from incompatible pointer type:  => 576
	drivers/mfd/twl6030-irq.c: warning: cast to pointer from integer of
different size:  => 267
	drivers/misc/ics932s401.c: warning: 'reg' may be used uninitialized
in this function:  => 392
	drivers/misc/ics932s401.c: warning: 'x' may be used uninitialized in
this function:  => 375
	drivers/misc/sgi-gru/grufault.c: warning: 'paddr' may be used
uninitialized in this function:  => 265
	drivers/misc/sgi-gru/grufault.c: warning: 'ps' may be used
uninitialized in this function:  => 266
	drivers/mmc/host/sdhci.c: warning: 'pwr' may be used uninitialized in
this function:  => 1037
	drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1044
bytes is larger than 1024 bytes:  => 858
	drivers/mtd/chips/cfi_cmdset_0001.c: warning: the frame size of 1412
bytes is larger than 1024 bytes:  => 1800
	drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1132
bytes is larger than 1024 bytes:  => 420
	drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1376
bytes is larger than 1024 bytes:  => 983
	drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 1672
bytes is larger than 1024 bytes:  => 658
	drivers/mtd/chips/cfi_cmdset_0020.c: warning: the frame size of 2288
bytes is larger than 2048 bytes:  => 657
	drivers/mtd/devices/doc2001plus.c: warning: passing argument 2 of
'MemWriteDOC' discards qualifiers from pointer target type:  => 767
	drivers/mtd/devices/docprobe.c: warning: #warning Unknown
architecture for DiskOnChip. No default probe locations defined:  =>
80:2, 79:2
	drivers/mtd/ftl.c: warning: passing argument 4 of
'part->mbd.mtd->read' from incompatible pointer type:  => 527, 294,
228, 490
	drivers/mtd/ftl.c: warning: passing argument 4 of
'part->mbd.mtd->write' from incompatible pointer type:  => 564, 535,
426, 507, 442, 555
	drivers/mtd/maps/solutionengine.c: warning: assignment makes pointer
from integer without a cast:  => 74, 76
	drivers/mtd/maps/solutionengine.c: warning: format '%08lx' expects
type 'long unsigned int', but argument 2 has type 'resource_size_t':
=> 86
	drivers/mtd/maps/solutionengine.c: warning: format '%08lx' expects
type 'long unsigned int', but argument 3 has type 'resource_size_t':
=> 86
	drivers/mtd/nand/alauda.c: warning: passing argument 3 of
'alauda_write_page' discards qualifiers from pointer target type:  =>
480
	drivers/mtd/nand/diskonchip.c: warning: #warning Unknown architecture
for DiskOnChip. No default probe locations defined:  => 56:2, 57:2
	drivers/mtd/sm_ftl.c: warning: comparison of distinct pointer types
lacks a cast:  => 200, 199
	drivers/mtd/ubi/vmt.c: warning: ‘err’ may be used uninitialized in
this function:  => 408
	drivers/mtd/ubi/wl.c: warning: 'e' may be used uninitialized in this
function:  => 390
	drivers/net/acenic.c: warning: passing argument 3 of
'pci_free_consistent' discards qualifiers from pointer target type:
=> 775, 770, 781
	drivers/net/arcnet/capmode.c: warning: 'arcnet_cap_init' defined but
not used:  => 64
	drivers/net/can/sja1000/sja1000.h: warning: "REG_SR" redefined:  => 60:1
	drivers/net/gianfar_ethtool.c: warning: the frame size of 2048 bytes
is larger than 1024 bytes:  => 846
	drivers/net/hamradio/baycom_ser_fdx.c: warning: statement with no
effect:  => 395, 307, 311, 396
	drivers/net/hamradio/baycom_ser_fdx.c: warning: suggest explicit
braces to avoid ambiguous 'else':  => 327
	drivers/net/hamradio/baycom_ser_hdx.c: warning: statement with no
effect:  => 413, 392, 455, 454, 396
	drivers/net/hamradio/yam.c: warning: statement with no effect:  =>
315, 527, 528, 492, 909, 493, 316
	drivers/net/hp100.c: warning: label 'out3' defined but not used:  => 3048
	drivers/net/lib82596.c: warning: passing argument 2 of
'dma_cache_sync' discards qualifiers from pointer target type:  =>
391, 1262, 600, 961, 896, 581, 1287, 629, 375, 1318, 580, 855, 837,
372, 388
	drivers/net/lib8390.c: warning: '____alloc_ei_netdev' defined but not
used:  => 1016
	drivers/net/lib8390.c: warning: '__ei_get_stats' defined but not used:  => 879
	drivers/net/lib8390.c: warning: '__ei_poll' defined but not used:  => 526
	drivers/net/lib8390.c: warning: '__ei_set_multicast_list' defined but
not used:  => 981
	drivers/net/lib8390.c: warning: '__ei_start_xmit' defined but not used:  => 302
	drivers/net/lib8390.c: warning: '__ei_tx_timeout' defined but not used:  => 256
	drivers/net/ll_temac_main.c: warning: cast to pointer from integer of
different size:  => 626
	drivers/net/pcmcia/ibmtr_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 235
	drivers/net/pcmcia/ibmtr_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 235
	drivers/net/pcmcia/nmclan_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 650
	drivers/net/pcmcia/nmclan_cs.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 650
	drivers/net/pcmcia/smc91c92_cs.c: warning: 'j' may be used
uninitialized in this function:  => 846
	drivers/net/pcmcia/smc91c92_cs.c: warning: unused variable 'smc':  => 1004
	drivers/net/phy/broadcom.c: warning: 'broadcom_tbl' defined but not
used:  => 933
	drivers/net/phy/cicada.c: warning: 'cicada_tbl' defined but not used:  => 162
	drivers/net/phy/davicom.c: warning: 'davicom_tbl' defined but not used:  => 222
	drivers/net/phy/et1011c.c: warning: 'et1011c_tbl' defined but not used:  => 114
	drivers/net/phy/icplus.c: warning: 'icplus_tbl' defined but not used:  => 137
	drivers/net/phy/lxt.c: warning: 'lxt_tbl' defined but not used:  => 226
	drivers/net/phy/marvell.c: warning: 'marvell_tbl' defined but not used:  => 724
	drivers/net/phy/micrel.c: warning: 'micrel_tbl' defined but not used:  => 234
	drivers/net/phy/national.c: warning: 'ns_tbl' defined but not used:  => 154
	drivers/net/phy/qsemi.c: warning: 'qs6612_tbl' defined but not used:  => 141
	drivers/net/phy/realtek.c: warning: 'realtek_tbl' defined but not used:  => 82
	drivers/net/phy/smsc.c: warning: 'smsc_tbl' defined but not used:  => 257
	drivers/net/phy/ste10Xp.c: warning: 'ste10Xp_tbl' defined but not used:  => 135
	drivers/net/phy/vitesse.c: warning: 'vitesse_tbl' defined but not used:  => 195
	drivers/net/qlcnic/qlcnic_main.c: warning: 'pci_using_dac' may be
used uninitialized in this function:  => 1340
	drivers/net/s2io.c: warning: 'tcp_len' may be used uninitialized in
this function:  => 7568
	drivers/net/seeq8005.c: warning: integer overflow in expression:  => 701, 544
	drivers/net/sh_eth.c: warning: 'ctrl_inl' is deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:104):  => 365, 860, 660,
288, 1128, 814, 937, 891, 366, 1258, 286, 848, 361, 906, 664, 1298,
1266, 1256, 1302, 394, 842, 363, 830, 857, 364, 388, 1003, 362, 382,
855, 1199, 1254, 852
	drivers/net/sh_eth.c: warning: 'ctrl_outl' is deprecated (declared at
/scratch/kisskb/src/arch/sh/include/asm/io.h:124):  => 892, 643, 685,
660, 1330, 1314, 942, 831, 288, 1332, 1218, 647, 1200, 667, 918, 690,
676, 1310, 1312, 633, 1267, 1311, 1257, 1315, 815, 1319, 342, 1333,
1324, 857, 683, 1215, 1219, 1328, 382, 1318, 658, 1329, 673, 860,
1327, 650, 640, 661, 1317, 339, 286, 655, 848, 531, 687, 1259, 1313,
1298, 1325, 1255, 1302, 626, 639, 1316, 1331, 388, 636, 509, 1003,
652, 629, 855, 852
	drivers/net/smc911x.c: warning: unused variable 'lp':  => 2127
	drivers/net/smc911x.h: warning: control reaches end of non-void
function:  => 135
	drivers/net/smc91x.c: warning: cast from pointer to integer of
different size:  => 1913
	drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_insw'
makes integer from pointer without a cast:  => 488
	drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_inw'
makes integer from pointer without a cast:  => 1341, 1248, 1284, 831,
794, 1659, 727, 1287, 677, 1339, 798, 1231, 1224, 1881, 1172, 1664,
1898, 722, 858, 490, 1196, 1343, 772, 1949, 1826, 1690, 468, 328, 394,
438, 1223, 715, 419, 754, 1685, 1344, 1264, 1692, 675, 569, 750, 689,
312, 1278, 619, 409, 1924, 1911, 1340
	drivers/net/smc91x.c: warning: passing argument 1 of 'sh_mv.mv_outsw'
makes integer from pointer without a cast:  => 595
	drivers/net/smc91x.c: warning: passing argument 2 of 'sh_mv.mv_outw'
makes integer from pointer without a cast:  => 836, 1839, 276, 1284,
831, 1457, 1460, 723, 598, 1923, 937, 580, 667, 595, 1666, 1681, 488,
1694, 938, 379, 1653, 1680, 1130, 1072, 343, 1263, 849, 612, 936, 579,
347, 726, 394, 294, 1022, 1458, 1225, 378, 803, 592, 1695, 1198, 751,
1023, 689, 393, 1199, 311, 1948, 1248, 1173, 309, 795, 1195, 1683,
389, 1660, 469, 327, 1652, 1287, 677, 1345, 1197, 1171, 416, 1293,
252, 760, 1656, 863, 323, 758, 783, 268, 345, 308, 348, 819, 1910,
1265, 858, 1658, 1897, 1818, 1684, 387, 755, 307, 801, 491, 269, 1294,
1463, 354, 759, 344, 1073, 388, 355, 1811, 1667, 1461, 251, 1342, 326,
1686, 1655, 439, 1278, 619, 781, 1812
	drivers/net/smc91x.h: warning: "SMC_inb" redefined:  => 567:1
	drivers/net/smc91x.h: warning: "SMC_inl" redefined:  => 525:1
	drivers/net/smc91x.h: warning: "SMC_insl" redefined:  => 527:1
	drivers/net/smc91x.h: warning: "SMC_outb" redefined:  => 568:1
	drivers/net/smc91x.h: warning: "SMC_outl" redefined:  => 526:1
	drivers/net/smc91x.h: warning: "SMC_outsl" redefined:  => 528:1
	drivers/net/smc91x.h: warning: this is the location of the previous
definition:  => 181:1, 180:1, 183:1, 185:1, 178:1, 184:1
	drivers/net/tehuti.c: warning: passing argument 2 of
'bdx_tx_push_desc_safe' discards qualifiers from pointer target type:
=> 330
	drivers/net/tlan.c: warning: label 'err_out' defined but not used:  => 685
	drivers/net/wan/farsync.c: warning: cast to pointer from integer of
different size:  => 1408
	drivers/net/wireless/ath/ar9170/ar9170.h: warning: control reaches
end of non-void function:  => 76
	drivers/net/wireless/iwmc3200wifi/rx.c: warning: comparison is always
true due to limited range of data type:  => 1198
	drivers/net/wireless/libertas/cfg.c: warning: passing argument 3 of
'lbs_deb_hex' discards qualifiers from pointer target type:  => 273
	drivers/net/wireless/mwl8k.c: warning: 'ap_legacy_rates' may be used
uninitialized in this function:  => 3403
	drivers/net/wireless/p54/p54usb.c: warning: 'p54u_device_reset'
defined but not used:  => 406, 407
	drivers/parisc/led.c: warning: assignment from incompatible pointer
type:  => 366
	drivers/parport/parport_pc.c: warning: 'parport_pc_find_isa_ports'
defined but not used:  => 3333
	drivers/parport/parport_pc.c: warning: statement with no effect:  =>
1890, 413, 359, 334, 357, 332
	drivers/parport/parport_pc.c: warning: suggest explicit braces to
avoid ambiguous 'else':  => 385
	drivers/pci/probe.c: warning: large integer implicitly truncated to
unsigned type:  => 197, 207
	drivers/pci/setup-bus.c: warning: passing argument 1 of
'pdev_assign_resources_sorted' discards qualifiers from pointer target
type:  => 706
	drivers/pcmcia/cs.c: warning: 'pcmcia_socket_dev_resume' defined but
not used:  => 849
	drivers/regulator/wm831x-dcdc.c: warning: control reaches end of
non-void function:  => 124
	drivers/rtc/rtc-cmos.c: warning: #warning Assuming 128 bytes of
RTC+NVRAM address space, not 64 bytes.:  => 693:2
	drivers/rtc/rtc-m41t80.c: warning: passing argument 1 of
'rtc_valid_tm' from incompatible pointer type:  => 367
	drivers/rtc/rtc-msm6242.c: warning: 'return' with a value, in
function returning void:  => 85
	drivers/rtc/rtc-rp5c01.c: warning: 'return' with a value, in function
returning void:  => 79
	drivers/s390/block/dasd_alias.c: warning: 'flags' may be used
uninitialized in this function:  => 381
	drivers/scsi/NCR5380.h: warning: 'NCR5380_exit' declared 'static' but
never defined:  => 303
	drivers/scsi/advansys.c: warning: #warning this driver is still not
properly converted to the DMA API:  => 72:2
	drivers/scsi/aic7xxx_old.c: warning: passing argument 3 of
'pci_free_consistent' discards qualifiers from pointer target type:
=> 8490
	drivers/scsi/atari_NCR5380.c: warning: unused variable 'oldto':  => 917
	drivers/scsi/constants.c: warning: zero-length gnu_printf format
string:  => 1407, 1413, 1456
	drivers/scsi/constants.c: warning: zero-length printf format string:
=> 1407, 1413, 1456
	drivers/scsi/fdomain.c: warning: 'fdomain_pci_tbl' defined but not
used:  => 1773
	drivers/scsi/hpsa.c: warning: 'cp' may be used uninitialized in this
function:  => 2335, 2299
	drivers/scsi/initio.c: warning: 'i91u_pci_devices' defined but not
used:  => 131
	drivers/scsi/ips.c: warning: #warning "This driver has only been
tested on the x86/ia64/x86_64 platforms":  => 210:2
	drivers/scsi/mac_scsi.c: warning: "NDEBUG_ABORT" is not defined:  =>
220:5, 271:5
	drivers/scsi/mpt2sas/mpt2sas_base.c: warning: right shift count >=
width of type:  => 3022, 3020
	drivers/scsi/mpt2sas/mpt2sas_ctl.c: warning:
'_ctl_sas_device_find_by_handle' defined but not used:  => 94
	drivers/scsi/mpt2sas/mpt2sas_scsih.c: warning: unused variable
'mpi_reply':  => 2718
	drivers/scsi/pmcraid.c: warning: passing argument 2 of 'access_ok'
makes pointer from integer without a cast:  => 3800
	drivers/scsi/scsi_debug.c: warning: comparison of distinct pointer
types lacks a cast:  => 1965, 1846, 1756, 2013, 1992, 1686
	drivers/scsi/scsi_debug.c: warning: passing argument 1 of
'__div64_32' from incompatible pointer type:  => 1965, 1846, 1756,
2013, 1992, 1686
	drivers/scsi/scsi_debug.c: warning: right shift count >= width of
type:  => 1965, 1846, 1756, 2013, 1992, 1686
	drivers/scsi/scsi_sysfs.c: warning: dereferencing 'void *' pointer:  => 384
	drivers/scsi/scsi_tgt_if.c: warning: passing argument 1 of
'virt_to_phys' makes pointer from integer without a cast:  => 289
	drivers/scsi/sd.c: warning: zero-length gnu_printf format string:  =>
2586, 2630, 2636, 2594, 2628, 2588
	drivers/scsi/sd.c: warning: zero-length printf format string:  =>
2630, 2636, 2628
	drivers/scsi/stex.c: warning: passing argument 2 of
'scsi_sg_copy_from_buffer' discards qualifiers from pointer target
type:  => 636
	drivers/scsi/sun3_NCR5380.c: warning: "NCR_TIMEOUT" is not defined:  => 1440:5
	drivers/scsi/sun3_NCR5380.c: warning: "NDEBUG_MERGING" is not
defined:  => 476:15, 487:15, 495:15
	drivers/scsi/sun3_NCR5380.c: warning: 'merge_contiguous_buffers'
defined but not used:  => 473
	drivers/scsi/sun3_NCR5380.c: warning: assignment discards qualifiers
from pointer target type:  => 2331, 2275, 993, 1145
	drivers/scsi/sun3_scsi.h: warning: "NDEBUG" is not defined:  =>
346:5, 232:5, 334:5, 286:5, 262:5, 298:5, 328:5, 280:5, 250:5, 268:5,
310:5, 238:5, 316:5, 322:5, 226:5, 358:5, 352:5, 274:5, 340:5, 292:5,
304:5, 244:5, 256:5
	drivers/scsi/sun3_scsi.h: warning: "NDEBUG_ABORT" is not defined:  => 346:14
	drivers/scsi/sun3_scsi.h: warning: "NDEBUG_MERGING" is not defined:  => 358:14
	drivers/scsi/sun3_scsi.h: warning: "NDEBUG_TAGS" is not defined:  => 352:14
	drivers/scsi/sym53c8xx_2/sym_hipd.c: warning: zero-length gnu_printf
format string:  => 78
	drivers/scsi/sym53c8xx_2/sym_hipd.c: warning: zero-length printf
format string:  => 78
	drivers/serial/8250.c: warning: 'i' may be used uninitialized in this
function:  => 1701
	drivers/serial/8250.c: warning: statement with no effect:  => 2190
	drivers/serial/mfd.c: warning: assignment makes pointer from integer
without a cast:  => 144, 1361, 818, 187
	drivers/serial/ucc_uart.c: warning: format '%x' expects type
'unsigned int', but argument 3 has type 'dma_addr_t':  => 238
	drivers/sh/maple/maple.c: warning: 'ctrl_inl' is deprecated (declared
at /scratch/kisskb/src/arch/sh/include/asm/io.h:104):  => 133
	drivers/sh/maple/maple.c: warning: 'ctrl_outl' is deprecated
(declared at /scratch/kisskb/src/arch/sh/include/asm/io.h:124):  =>
109, 453, 99, 639, 278, 97, 108, 799, 110
	drivers/sh/superhyway/superhyway-sysfs.c: warning: format '%08lx'
expects type 'long unsigned int', but argument 3 has type
'resource_size_t':  => 33
	drivers/telephony/ixj.c: warning: 'ixj_pci_tbl' defined but not used:  => 286
	drivers/uio/uio.c: warning: passing argument 1 of 'virt_to_phys'
makes pointer from integer without a cast:  => 654
	drivers/usb/core/devio.c: warning: cast from pointer to integer of
different size:  => 1380
	drivers/usb/gadget/dbgp.c: warning: comparison is always true due to
limited range of data type:  => 389
	drivers/usb/gadget/r8a66597-udc.h: warning: 'data' may be used
uninitialized in this function:  => 139
	drivers/usb/gadget/storage_common.c: warning: 'fsg_show_nofua'
defined but not used:  => 718, 720
	drivers/usb/gadget/storage_common.c: warning: 'fsg_store_nofua'
defined but not used:  => 782, 785
	drivers/usb/host/ehci-hcd.c: warning: 'ehci_port_power' defined but
not used:  => 436
	drivers/usb/host/ehci-hub.c: warning: 'ehci_adjust_port_wakeup_flags'
defined but not used:  => 109
	drivers/usb/host/ehci-lpm.c: warning: 'ehci_lpm_check' defined but
not used:  => 40
	drivers/usb/host/ehci-lpm.c: warning: 'ehci_lpm_set_da' defined but
not used:  => 20
	drivers/usb/host/ohci-hub.c: warning: 'ohci_finish_controller_resume'
defined but not used:  => 318
	drivers/usb/host/oxu210hp-hcd.c: warning: unused variable 'base':  => 3906
	drivers/usb/host/whci/hcd.c: warning: 'whci_hcd_id_table' defined but
not used:  => 359
	drivers/usb/host/xhci-ring.c: warning: 'event_trb' may be used
uninitialized in this function:  => 1719
	drivers/usb/storage/isd200.c: warning: the frame size of 2208 bytes
is larger than 2048 bytes:  => 580
	drivers/uwb/i1480/i1480-est.c: warning: 'i1480_est_id_table' defined
but not used:  => 94
	drivers/uwb/whc-rc.c: warning: 'whcrc_id_table' defined but not used:
 => 452, 451
	drivers/video/gbefb.c: warning: ignoring return value of
'device_create_file', declared with attribute warn_unused_result:  =>
1094, 1093
	drivers/video/metronomefb.c: warning: passing argument 1 of
'load_waveform' discards qualifiers from pointer target type:  => 687
	drivers/video/s1d13xxxfb.c: warning: 'bltbit_fifo_status' defined but
not used:  => 464, 463, 465
	drivers/video/s1d13xxxfb.c: warning: 'bltbit_wait_bitset' defined but
not used:  => 421, 420, 422
	drivers/virtio/virtio_ring.c: warning: cast to pointer from integer
of different size:  => 274
	drivers/w1/masters/ds2490.c: warning: passing argument 2 of
'ds_write_block' discards qualifiers from pointer target type:  => 827
	drivers/watchdog/alim7101_wdt.c: warning: 'alim7101_pci_tbl' defined
but not used:  => 433
	drivers/xen/events.c: warning: 'gsi_from_irq' defined but not used:  => 187
	drivers/xen/events.c: warning: 'mk_pirq_info' defined but not used:  => 141
	drivers/xen/events.c: warning: 'vector_from_irq' defined but not used:  => 197
	fs/9p/xattr.c: warning: format '%zd' expects type 'signed size_t',
but argument 3 has type 'ssize_t':  => 52
	fs/9p/xattr.c: warning: format '%zd' expects type 'signed size_t',
but argument 4 has type 'ssize_t':  => 52
	fs/afs/internal.h: warning: 'packed' attribute ignored for field of
type 'enum <anonymous>':  => 163
	fs/afs/write.c: warning: format '%zd' expects type 'signed size_t',
but argument 4 has type 'ssize_t':  => 672, 668
	fs/autofs/root.c: warning: 'autofs_root_compat_ioctl' declared
'static' but never defined:  => 30
	fs/autofs4/root.c: warning: 'autofs4_root_compat_ioctl' declared
'static' but never defined:  => 31
	fs/autofs4/symlink.c: warning: passing argument 2 of 'nd_set_link'
discards qualifiers from pointer target type:  => 18
	fs/bio-integrity.c: warning: control reaches end of non-void function:  => 61
	fs/btrfs/acl.c: warning: 'name' may be used uninitialized in this
function:  => 36
	fs/btrfs/inode.c: warning: 'extent_end' may be used uninitialized in
this function:  => 1029
	fs/btrfs/tree-log.c: warning: 'dst_di' may be used uninitialized in
this function:  => 1173
	fs/ceph/messenger.c: warning: 'proto' may be used uninitialized in
this function:  => 631
	fs/cifs/cifssmb.c: warning: 'pdata' may be used uninitialized in this
function:  => 3085
	fs/compat_ioctl.c: warning: 'fp' may be used uninitialized in this
function:  => 177
	fs/compat_ioctl.c: warning: 'length' may be used uninitialized in
this function:  => 209
	fs/compat_ioctl.c: warning: 'palp' may be used uninitialized in this
function:  => 208
	fs/compat_ioctl.c: warning: 'size' may be used uninitialized in this
function:  => 178
	fs/dcache.c: warning: control reaches end of non-void function:  => 1899, 1887
	fs/ecryptfs/crypto.c: warning: format '%zd' expects type 'signed
size_t', but argument 3 has type 'ssize_t':  => 1543
	fs/ext2/acl.c: warning: 'name_index' may be used uninitialized in
this function:  => 134
	fs/ext2/balloc.c: warning: passing argument 2 of 'test_and_clear_bit'
from incompatible pointer type:  => 550
	fs/ext2/balloc.c: warning: passing argument 2 of 'test_and_set_bit'
from incompatible pointer type:  => 740, 725
	fs/ext2/ialloc.c: warning: passing argument 2 of 'test_and_set_bit'
from incompatible pointer type:  => 493
	fs/ext3/acl.c: warning: 'name_index' may be used uninitialized in
this function:  => 137
	fs/ext3/balloc.c: warning: passing argument 2 of 'test_and_clear_bit'
from incompatible pointer type:  => 832, 619
	fs/ext3/balloc.c: warning: passing argument 2 of 'test_and_set_bit'
from incompatible pointer type:  => 828, 610
	fs/ext3/ialloc.c: warning: passing argument 2 of 'test_and_clear_bit'
from incompatible pointer type:  => 142
	fs/ext3/ialloc.c: warning: passing argument 2 of 'test_and_set_bit'
from incompatible pointer type:  => 471
	fs/ext4/acl.c: warning: 'name_index' may be used uninitialized in
this function:  => 137
	fs/ext4/balloc.c: warning: passing argument 2 of 'test_and_clear_bit'
from incompatible pointer type:  => 439
	fs/fat/namei_vfat.c: warning: 'lcase' may be used uninitialized in
this function:  => 590
	fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in
this function:  => 595
	fs/freevxfs/vxfs_lookup.c: warning: 'pp' may be used uninitialized in
this function:  => 179
	fs/fuse/dev.c: warning: 'total_len' may be used uninitialized in this
function:  => 1357
	fs/fuse/dev.c: warning: ‘total_len’ may be used uninitialized in this
function:  => 1357
	fs/isofs/compress.c: warning: 'zisofs_readpage' uses dynamic stack
allocation:  => 360
	fs/isofs/compress.c: warning: 'zisofs_uncompress_block' uses dynamic
stack allocation:  => 193
	fs/jffs2/acl.c: warning: 'xprefix' may be used uninitialized in this
function:  => 163
	fs/logfs/dir.c: warning: control reaches end of non-void function:  => 155
	fs/logfs/readwrite.c: warning: 'val' may be used uninitialized in
this function:  => 470
	fs/logfs/segment.c: warning: control reaches end of non-void function:  => 280
	fs/nfsd/export.c: warning: 'an_int' may be used uninitialized in this
function:  => 504
	fs/nfsd/nfs4state.c: warning: control reaches end of non-void function:  => 452
	fs/nilfs2/alloc.c: warning: passing argument 2 of
'test_and_clear_bit' from incompatible pointer type:  => 670, 557, 520
	fs/nilfs2/alloc.c: warning: passing argument 2 of 'test_and_set_bit'
from incompatible pointer type:  => 374, 355
	fs/notify/fanotify/fanotify.c: warning: 'marks_ignored_mask' may be
used uninitialized in this function:  => 162
	fs/notify/fanotify/fanotify.c: warning: 'marks_mask' may be used
uninitialized in this function:  => 162
	fs/ntfs/aops.c: warning: 'ntfs_write_mst_block' uses dynamic stack
allocation:  => 1329
	fs/ntfs/compress.c: warning: 'ntfs_decompress' uses dynamic stack
allocation:  => 445
	fs/ntfs/mft.c: warning: 'ntfs_sync_mft_mirror' uses dynamic stack
allocation:  => 636
	fs/ntfs/mft.c: warning: 'write_mft_record_nolock' uses dynamic stack
allocation:  => 844
	fs/ocfs2/cluster/tcp.c: warning: format '%zd' expects type 'signed
size_t', but argument 12 has type 'ssize_t':  => 936
	fs/ocfs2/dlmfs/dlmfs.c: warning: format '%zd' expects type 'signed
size_t', but argument 7 has type 'ssize_t':  => 328, 284
	fs/proc/task_mmu.c: warning: passing argument 1 of 'kunmap' from
incompatible pointer type:  => 631, 378, 473
	fs/qnx4/namei.c: warning: 'ino' may be used uninitialized in this
function:  => 104
	fs/reiserfs/inode.c: warning: 'reiserfs_new_directory' uses dynamic
stack allocation:  => 1709
	fs/reiserfs/xattr_acl.c: warning: 'name' may be used uninitialized in
this function:  => 203
	fs/smbfs/file.c: warning: format '%Zd' expects type 'signed size_t',
but argument 5 has type 'ssize_t':  => 353, 230, 277
	fs/sysfs/dir.c: warning: 'sysfs_pathname' defined but not used:  => 411
	fs/udf/super.c: warning: 'map' may be used uninitialized in this
function:  => 1158
	fs/udf/truncate.c: warning: 'adsize' may be used uninitialized in
this function:  => 209, 75
	fs/xfs/linux-2.6/xfs_acl.c: warning: 'ea_name' may be used
uninitialized in this function:  => 110
	fs/xfs/linux-2.6/xfs_trace.c: warning: 'xfs_fmtfsblock' defined but
not used:  => 57
	include/config/auto.conf: warning: symbol value '' invalid for
CROSS_COMPILE:  => 149, 3707, 307, 4062, 429
	include/config/auto.conf: warning: symbol value 'm' invalid for
BLK_CGROUP:  => 1302
	include/config/auto.conf: warning: symbol value 'm' invalid for
NET_CLS_CGROUP:  => 296
	include/config/auto.conf: warning: symbol value 'm' invalid for
SPI_DESIGNWARE:  => 1014
	include/linux/dmaengine.h: warning: control reaches end of non-void
function:  => 578
	include/linux/mca-legacy.h: warning: #warning "MCA legacy - please
move your driver to the new sysfs api":  => 12:2
	include/linux/ncp_fs_sb.h: warning: 'packed' attribute ignored for
field of type '__u16':  => 112, 109, 111, 113, 110
	include/linux/ncp_fs_sb.h: warning: 'packed' attribute ignored for
field of type '__u32':  => 108, 107
	include/linux/of_gpio.h: warning: 'struct gpio_chip' declared inside
parameter list:  => 74, 75
	include/linux/of_gpio.h: warning: its scope is only this definition
or declaration, which is probably not what you want:  => 74
	include/linux/sysv_fs.h: warning: 'packed' attribute ignored for
field of type '__fs32':  => 130, 181, 142, 114, 168, 42, 112, 180, 30,
144, 43, 100
	include/linux/sysv_fs.h: warning: 'packed' attribute ignored for
field of type 'sysv_zone_t[64]':  => 171
	include/math-emu/double.h: warning: "__BIG_ENDIAN" is not defined:  => 59:21
	include/math-emu/single.h: warning: "__BIG_ENDIAN" is not defined:  => 50:21
	include/media/soc_camera.h: warning: 'dummy' is used uninitialized in
this function:  => 278
	include/net/ipx.h: warning: 'packed' attribute ignored for field of
type '__be16':  => 32, 30
	include/net/ipx.h: warning: 'packed' attribute ignored for field of
type 'struct ipx_address':  => 42, 41
	include/sound/tlv320aic3x.h: warning: no newline at end of file:  => 17:7
	kernel/futex.c: warning: cast from pointer to integer of different
size:  => 2406
	kernel/irq/handle.c: warning: #warning __do_IRQ is deprecated. Please
convert to proper flow handlers:  => 432:3, 437:3
	kernel/kprobes.c: warning: ‘cleanup_rp_inst’ defined but not used:  => 910
	kernel/module.c: warning: passing argument 2 of 'add_kallsyms'
discards qualifiers from pointer target type:  => 2534
	kernel/pm_qos_params.c: warning: control may reach end of non-void
function ‘pm_qos_get_value’ being inlined:  => 200
	kernel/pm_qos_params.c: warning: control reaches end of non-void
function:  => 132
	kernel/power/hibernate.c: warning: comparison of distinct pointer
types lacks a cast:  => 223
	kernel/profile.c: warning: 'profile_cpu_callback' defined but not used:  => 359
	kernel/profile.c: warning: 'profile_discard_flip_buffers' defined but
not used:  => 293
	kernel/profile.c: warning: 'profile_flip_buffers' defined but not used:  => 270
	kernel/sched.c: warning: unsupported argument to
'__builtin_return_address':  => 3592, 3594
	kernel/signal.c: warning: cast from pointer to integer of different
size:  => 2207, 2551, 2230, 2214
	kernel/trace/trace_events.c: warning: enumeration value
'TRACE_REG_PERF_REGISTER' not handled in switch:  => 146
	kernel/trace/trace_events.c: warning: enumeration value
'TRACE_REG_PERF_UNREGISTER' not handled in switch:  => 146
	kernel/trace/trace_functions_graph.c: warning: comparison of distinct
pointer types lacks a cast:  => 652
	kernel/trace/trace_kprobe.c: warning: enumeration value
'TRACE_REG_PERF_REGISTER' not handled in switch:  => 1641
	kernel/trace/trace_kprobe.c: warning: enumeration value
'TRACE_REG_PERF_UNREGISTER' not handled in switch:  => 1641
	kernel/watchdog.c: warning: 'watchdog_disable_all_cpus' defined but
not used:  => 476, 477
	kernel/watchdog.c: warning: 'watchdog_enable_all_cpus' defined but
not used:  => 464, 463
	lib/atomic64_test.c: warning: #warning Please implement
atomic64_dec_if_positive for your  CC      fs/filesystems.o:  => 131:2
	lib/atomic64_test.c: warning: #warning Please implement
atomic64_dec_if_positive for your architecture, and add it to the IF
above:  => 131:2
	lib/atomic64_test.c: warning: ISO C90 forbids mixed declarations and
code:  => 25
	lib/btree.c: warning: 'btree_get_prev' uses dynamic stack allocation:  => 359
	lib/btree.c: warning: 'btree_merge' uses dynamic stack allocation:  => 670
	lib/decompress_bunzip2.c: warning: the frame size of 1888 bytes is
larger than 1024 bytes:  => 511
	lib/iomap.c: warning: statement with no effect:  => 205, 197, 201
	lib/libcrc32c.c: warning: 'crc32c' uses dynamic stack allocation:  => 58
	lib/radix-tree.c: warning: 'radix_tree_range_tag_if_tagged' uses
dynamic stack allocation:  => 737
	lib/vsprintf.c: warning: 'resource_string' uses dynamic stack
allocation:  => 693
	mm/bootmem.c: warning: control reaches end of non-void function:  => 413, 420
	mm/fremap.c: warning: passing argument 1 of 'kunmap' from
incompatible pointer type:  => 78
	mm/memcontrol.c: warning: 'move_anon' defined but not used:  => 286
	mm/memcontrol.c: warning: 'move_file' defined but not used:  => 292
	mm/memcontrol.c: warning: 'thresholds' may be used uninitialized in
this function:  => 3621, 3703
	mm/memcontrol.c: warning: 'val' may be used uninitialized in this
function:  => 3192
	mm/memory.c: warning: passing argument 1 of 'kunmap' from
incompatible pointer type:  => 3347, 772, 1643, 1319, 1314, 1410,
1391, 770, 3021, 1403, 984, 3376, 1705, 3160, 2749, 1954, 2809, 2337,
2185, 1640, 2852, 2754, 2240, 1805, 2139, 3062, 2046, 1323
	mm/mempolicy.c: warning: control reaches end of non-void function:  => 1597
	mm/mincore.c: warning: passing argument 1 of 'kunmap' from
incompatible pointer type:  => 144
	mm/mprotect.c: warning: passing argument 1 of 'kunmap' from
incompatible pointer type:  => 78
	mm/mremap.c: warning: passing argument 1 of 'kunmap' from
incompatible pointer type:  => 123, 122
	mm/pagewalk.c: warning: passing argument 1 of 'kunmap' from
incompatible pointer type:  => 23
	mm/percpu.c: warning: 'pcpu_build_alloc_info' defined but not used:  => 1092
	mm/rmap.c: warning: passing argument 1 of 'kunmap' from incompatible
pointer type:  => 1200, 1069, 704, 470, 523, 445, 434, 1064
	mm/slab.c: warning: passing argument 2 of '__cache_free' discards
qualifiers from pointer target type:  => 3854
	mm/slob.c: warning: comparison of distinct pointer types lacks a
cast:  => 482, 549, 481, 530, 550, 531
	mm/swapfile.c: warning: passing argument 1 of 'kunmap' from
incompatible pointer type:  => 976, 947, 983
	mm/vmalloc.c: warning: passing argument 1 of 'kunmap' from
incompatible pointer type:  => 230
	modpost: WARNING: modpost: Found 1 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 12 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 13 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 14 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 2 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 3 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 4 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 5 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 57 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 6 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 68 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 7 section mismatch(es).:  => N/A
	modpost: WARNING: modpost: Found 8 section mismatch(es).:  => N/A
	net/bluetooth/hci_sysfs.c: warning: the frame size of 4112 bytes is
larger than 2048 bytes:  => 441
	net/bridge/br_netfilter.c: warning: passing argument 4 of 'NF_HOOK'
discards qualifiers from pointer target type:  => 753
	net/bridge/br_netfilter.c: warning: passing argument 5 of 'NF_HOOK'
discards qualifiers from pointer target type:  => 753
	net/core/pktgen.c: warning: 'pktgen_if_write' uses dynamic stack
allocation:  => 1717
	net/core/rtnetlink.c: warning: 'rtnl_newlink' uses dynamic stack
allocation:  => 1570
	net/dccp/ccids/ccid2.c: warning: 'veclen' may be used uninitialized
in this function:  => 508
	net/dccp/ccids/ccid2.c: warning: 'vector' may be used uninitialized
in this function:  => 507
	net/dccp/timer.c: warning: comparison of distinct pointer types lacks
a cast:  => 281
	net/econet/af_econet.c: warning: 'econet_sendmsg' uses dynamic stack
allocation:  => 508
	net/ipv4/igmp.c: warning: overflow in implicit constant conversion:
=> 2304, 1887
	net/ipv4/netfilter/arp_tables.c: warning: passing argument 1 of
'arpt_get_target' discards qualifiers from pointer target type:  =>
234
	net/ipv4/netfilter/ip_tables.c: warning: passing argument 1 of
'ipt_get_target' discards qualifiers from pointer target type:  => 192
	net/ipv4/netfilter/ipt_ULOG.c: warning: passing argument 1 of
'__net_timestamp' discards qualifiers from pointer target type:  =>
210
	net/ipv6/netfilter/ip6_tables.c: warning: passing argument 1 of
'ip6t_get_target' discards qualifiers from pointer target type:  =>
221
	net/ipv6/xfrm6_state.c: warning: '__xfrm6_sort' uses dynamic stack
allocation:  => 76
	net/irda/irnet/irnet_ppp.c: warning: format '%Zd' expects type
'signed size_t', but argument 3 has type 'ssize_t':  => 332
	net/llc/llc_sap.c: warning: 'llc_sap_mcast' uses dynamic stack
allocation:  => 423
	net/mac80211/tx.c: warning: unused variable 'mesh_hdr':  => 1702
	net/netfilter/nfnetlink.c: warning: 'nfnetlink_rcv_msg' uses dynamic
stack allocation:  => 175
	net/netfilter/xt_time.c: warning: passing argument 1 of
'__net_timestamp' discards qualifiers from pointer target type:  =>
171
	net/packet/af_packet.c: warning: 'hdrlen' may be used uninitialized
in this function:  => 657, 648
	net/packet/af_packet.c: warning: ‘vnet_hdr_len’ may be used
uninitialized in this function:  => 1107
	net/rds/connection.c: warning: 'rds_for_each_conn_info' uses dynamic
stack allocation:  => 410
	net/rds/message.c: warning: passing argument 1 of 'virt_to_phys'
makes pointer from integer without a cast:  => 252
	net/rds/tcp_send.c: warning: passing argument 1 of 'virt_to_phys'
makes pointer from integer without a cast:  => 113
	net/rfkill/core.c: warning: control reaches end of non-void function:  => 603
	net/sched/cls_flow.c: warning: 'flow_classify' uses dynamic stack
allocation:  => 387
	net/sched/sch_generic.c: warning: unused variable 'drivername':  => 256
	net/sctp/socket.c: warning: 'newsock' may be used uninitialized in
this function:  => 4025
	net/sctp/tsnmap.c: warning: 'end' may be used uninitialized in this
function:  => 347
	net/sctp/tsnmap.c: warning: 'start' may be used uninitialized in this
function:  => 347
	net/sunrpc/auth_gss/auth_gss.c: warning: format '%Zd' expects type
'signed size_t', but argument 2 has type 'ssize_t':  => 706
	net/sunrpc/auth_gss/auth_gss.c: warning: format '%zd' expects type
'signed size_t', but argument 3 has type 'ssize_t':  => 688
	net/sunrpc/auth_gss/gss_krb5_crypto.c: warning: 'gss_krb5_cts_crypt'
uses dynamic stack allocation:  => 637
	net/sunrpc/svcauth_unix.c: warning: 'sin6' may be used uninitialized
in this function:  => 689, 690
	net/sunrpc/xprtsock.c: warning: format '%Zd' expects type 'signed
size_t', but argument 3 has type 'ssize_t':  => 1032
	net/xfrm/xfrm_policy.c: warning: 'xfrm_dst_ops' may be used
uninitialized in this function:  => 2340, 2393
	security/keys/keyctl.c: warning: #warning TIF_NOTIFY_RESUME not
implemented:  => 1342:2
	security/selinux/netnode.c: warning: 'idx' may be used uninitialized
in this function:  => 132
	sound/drivers/serial-u16550.c: warning: 'uart' may be used
uninitialized in this function:  => 905
	sound/mips/hal2.c: warning: 'l' may be used uninitialized in this
function:  => 203
	sound/mips/hal2.c: warning: 'new' may be used uninitialized in this
function:  => 232
	sound/mips/hal2.c: warning: 'old' may be used uninitialized in this
function:  => 232
	sound/mips/hal2.c: warning: 'r' may be used uninitialized in this
function:  => 203
	sound/oss/pss.c: warning: 'check_region' is deprecated (declared at
/scratch/kisskb/src/include/linux/ioport.h:169):  => 676
	sound/pci/atiixp.c: warning: 'chip' may be used uninitialized in this
function:  => 1652
	sound/pci/atiixp_modem.c: warning: 'chip' may be used uninitialized
in this function:  => 1288
	sound/pci/cs5535audio/cs5535audio_pcm.c: warning: large integer
implicitly truncated to unsigned type:  => 152, 161, 160, 153
	sound/pci/ctxfi/ctvmem.c: warning: 'entry' may be used uninitialized
in this function:  => 34, 80
	sound/pci/hda/hda_codec.c: warning: 'hda_cleanup_all_streams' defined
but not used:  => 1326
	sound/pci/hda/hda_codec.c: warning: 'restore_shutup_pins' defined but
not used:  => 940
	sound/pci/hda/patch_analog.c: warning: 'ad198x_power_eapd' defined
but not used:  => 480
	sound/pci/lx6464es/lx6464es.c: warning: cast to pointer from integer
of different size:  => 456, 455
	sound/pci/lx6464es/lx_core.c: warning: cast to pointer from integer
of different size:  => 1185
	sound/pci/via82xx.c: warning: 'chip' may be used uninitialized in
this function:  => 2503
	sound/pci/via82xx_modem.c: warning: 'chip' may be used uninitialized
in this function:  => 1168
	sound/pcmcia/pdaudiocf/pdaudiocf.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 226
	sound/pcmcia/pdaudiocf/pdaudiocf.c: warning:
'pcmcia_request_exclusive_irq' is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 226
	sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq'
is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:200):  => 233
	sound/pcmcia/vx/vxpocket.c: warning: 'pcmcia_request_exclusive_irq'
is deprecated (declared at
/scratch/kisskb/src/include/pcmcia/ds.h:202):  => 233
	sound/soc/codecs/wm8350.c: warning: 'mask' may be used uninitialized
in this function:  => 1349
	sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_ratio' may be used
uninitialized in this function:  => 749
	sound/soc/codecs/wm8900.c: warning: 'fll_div.fll_slow_lock_ref' may
be used uninitialized in this function:  => 749
	sound/soc/codecs/wm8900.c: warning: 'fll_div.fllclk_div' may be used
uninitialized in this function:  => 749
	sound/soc/codecs/wm8900.c: warning: 'fll_div.k' may be used
uninitialized in this function:  => 749
	sound/soc/codecs/wm8900.c: warning: 'fll_div.n' may be used
uninitialized in this function:  => 749
	sound/soc/codecs/wm_hubs.c: warning: 'reg_l' may be used
uninitialized in this function:  => 95
	sound/soc/codecs/wm_hubs.c: warning: 'reg_r' may be used
uninitialized in this function:  => 95
	sound/soc/soc-dapm.c: warning: unused variable 'codec':  => 440
	sound/usb/mixer.c: warning: unused variable 'chip':  => 762
	warning: "cause_of_death" [vmlinux] is COMMON symbol:  => N/A
	warning: "saved_config" [vmlinux] is COMMON symbol:  => N/A
	warning: (AMIGAONE && 6xx && BROKEN_ON_SMP) selects PCSPKR_PLATFORM
which has unmet direct dependencies (ALPHA || X86 || MIPS || PPC_PREP
|| PPC_CHRP || PPC_PSERIES):  => N/A
	warning: (BATTERY_DS2760 && POWER_SUPPLY) selects W1 which has unmet
direct dependencies (HAS_IOMEM):  => N/A
	warning: (COMPAT && SPARC64) selects COMPAT_BINFMT_ELF which has
unmet direct dependencies (COMPAT && BINFMT_ELF):  => N/A
	warning: (CRYPTO_LRW && CRYPTO && EXPERIMENTAL || CRYPTO_XTS &&
CRYPTO && EXPERIMENTAL || CRYPTO_GHASH && CRYPTO) selects
CRYPTO_GF128MUL which has unmet direct dependencies (EXPERIMENTAL):
=> N/A
	warning: (EP8248E && PPC_82xx || MPC85xx_MDS && FSL_SOC_BOOKE ||
NET_DSA && NET && EXPERIMENTAL && NETDEVICES && !S390 || MACB &&
NETDEVICES && NET_ETHERNET && (AVR32 || ARCH_AT91SAM9260 ||
ARCH_AT91SAM9263 || ARCH_AT91SAM9G20 || ARCH_AT91SAM9G45 ||
ARCH_AT91CAP9) || IXP4XX_ETH && NETDEVICES && NET_ETHERNET && ARM &&
ARCH_IXP4XX && IXP4XX_NPE && IXP4XX_QMGR || W90P910_ETH && NETDEVICES
&& NET_ETHERNET && ARM && ARCH_W90X900 || MIPS_AU1X00_ENET &&
NETDEVICES && NET_ETHERNET && MIPS_ALCHEMY || SH_ETH && NETDEVICES &&
NET_ETHERNET && SUPERH && (CPU_SUBTYPE_SH7710 || CPU_SUBTYPE_SH7712 ||
CPU_SUBTYPE_SH7763 || CPU_SUBTYPE_SH7619 || CPU_SUBTYPE_SH7724 ||
CPU_SUBTYPE_SH7757) || BFIN_MAC && NETDEVICES && NET_ETHERNET &&
(BF516 || BF518 || BF526 || BF527 || BF536 || BF537) || PXA168_ETH &&
NETDEVICES && NET_ETHERNET && CPU_PXA168 || TI_DAVINCI_EMAC &&
NETDEVICES && NET_ETHERNET && ARM && (ARCH_DAVINCI || ARCH_OMAP3) ||
ETHOC && NETDEVICES && NET_ETHERNET && HAS_IOMEM && HAS_DMA || GRETH
&& NETDEVICES && NET_ETHERNET && SPARC || SMSC911X && NETDEVICES &&
NET_ETHERNET && (ARM || SUPERH || BLACKFIN || MIPS) || DNET &&
NETDEVICES && NET_ETHERNET && HAS_IOMEM || TC35815 && NETDEVICES &&
NET_ETHERNET && NET_PCI && PCI && MIPS || R6040 && NETDEVICES &&
NET_ETHERNET && NET_PCI && PCI || SMSC9420 && NETDEVICES &&
NET_ETHERNET && NET_PCI && PCI || CPMAC && NETDEVICES && NET_ETHERNET
&& EXPERIMENTAL && AR7 || FEC && NETDEVICES && NET_ETHERNET && (M523x
|| M527x || M5272 || M528x || M520x || M532x || MACH_MX27 || ARCH_MX35
|| ARCH_MX25 || ARCH_MX5) || FEC_MPC52xx && NETDEVICES && NET_ETHERNET
&& PPC_MPC52xx && PPC_BESTCOMM || XILINX_EMACLITE && NETDEVICES &&
NET_ETHERNET && (PPC32 || MICROBLAZE) || BCM63XX_ENET && NETDEVICES &&
NET_ETHERNET && BCM63XX || FS_ENET && NETDEVICES && NET_ETHERNET &&
(CPM1 || CPM2 || PPC_MPC512x) || OCTEON_MGMT_ETHERNET && NETDEVICES &&
NET_ETHERNET && CPU_CAVIUM_OCTEON || SB1250_MAC && NETDEVICES &&
NETDEV_1000 && SIBYTE_SB1xxx_SOC || TIGON3 && NETDEVICES &&
NETDEV_1000 && PCI || FSL_PQ_MDIO && NETDEVICES && NETDEV_1000 &&
FSL_SOC || GIANFAR && NETDEVICES && NETDEV_1000 && FSL_SOC || UCC_GETH
&& NETDEVICES && NETDEV_1000 && QUICC_ENGINE || MV643XX_ETH &&
NETDEVICES && NETDEV_1000 && (MV64X60 || PPC32 || PLAT_ORION) ||
XILINX_LL_TEMAC && NETDEVICES && NETDEV_1000 && (PPC || MICROBLAZE) ||
S6GMAC && NETDEVICES && NETDEV_1000 && XTENSA_VARIANT_S6000 ||
STMMAC_ETH && NETDEV_1000 && NETDEVICES && CPU_SUBTYPE_ST40 ||
PASEMI_MAC && NETDEVICES && NETDEV_10000 && PPC_PASEMI && PCI ||
OCTEON_ETHERNET && STAGING && !STAGING_EXCLUDE_BUILD &&
CPU_CAVIUM_OCTEON) selects PHYLIB which has unmet direct dependencies
(!S390 && NETDEVICES):  => N/A
	warning: (ETRAX_USB_HOST && ETRAX_ARCH_V10 || MOUSE_APPLETOUCH &&
!S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || MOUSE_BCM5974 &&
!S390 && INPUT && INPUT_MOUSE && USB_ARCH_HAS_HCD || JOYSTICK_XPAD &&
!S390 && INPUT && INPUT_JOYSTICK && USB_ARCH_HAS_HCD ||
TABLET_USB_ACECAD && !S390 && INPUT && INPUT_TABLET &&
USB_ARCH_HAS_HCD || TABLET_USB_AIPTEK && !S390 && INPUT &&
INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_KBTAB && !S390 && INPUT
&& INPUT_TABLET && USB_ARCH_HAS_HCD || TABLET_USB_WACOM && !S390 &&
INPUT && INPUT_TABLET && USB_ARCH_HAS_HCD || TOUCHSCREEN_USB_COMPOSITE
&& !S390 && INPUT && INPUT_TOUCHSCREEN && USB_ARCH_HAS_HCD ||
INPUT_ATI_REMOTE && !S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD
|| INPUT_ATI_REMOTE2 && !S390 && INPUT && INPUT_MISC &&
USB_ARCH_HAS_HCD || INPUT_KEYSPAN_REMOTE && !S390 && INPUT &&
INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD || INPUT_POWERMATE &&
!S390 && INPUT && INPUT_MISC && USB_ARCH_HAS_HCD || INPUT_YEALINK &&
!S390 && INPUT && INPUT_MISC && EXPERIMENTAL && USB_ARCH_HAS_HCD ||
INPUT_CM109 && !S390 && INPUT && INPUT_MISC && EXPERIMENTAL &&
USB_ARCH_HAS_HCD) selects USB which has unmet direct dependencies
(USB_ARCH_HAS_HCD):  => N/A
	warning: (GFS2_FS && BLOCK && EXPERIMENTAL && (64BIT || LBDAF))
selects QUOTACTL which has unmet direct dependencies (XFS_QUOTA ||
QUOTA):  => N/A
	warning: (IMA && SECURITY && !S390) selects TCG_TPM which has unmet
direct dependencies (HAS_IOMEM && EXPERIMENTAL):  => N/A
	warning: (IRQSOFF_TRACER && TRACING_SUPPORT && FTRACE &&
TRACE_IRQFLAGS_SUPPORT && !ARCH_USES_GETTIMEOFFSET) selects
TRACE_IRQFLAGS which has unmet direct dependencies (DEBUG_KERNEL &&
TRACE_IRQFLAGS_SUPPORT && PROVE_LOCKING):  => N/A
	warning: (LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT &&
STACKTRACE_SUPPORT && LOCKDEP_SUPPORT && !MIPS && !PPC && !ARM_UNWIND
&& !S390 && !MICROBLAZE || FAULT_INJECTION_STACKTRACE_FILTER &&
FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT && !X86_64 && !PPC &&
!S390 && !MICROBLAZE || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT &&
DEBUG_KERNEL && STACKTRACE_SUPPORT && PROC_FS && !MIPS && !PPC &&
!S390 && !MICROBLAZE || FUNCTION_TRACER && TRACING_SUPPORT && FTRACE
&& HAVE_FUNCTION_TRACER || KMEMCHECK && HAVE_ARCH_KMEMCHECK &&
DEBUG_KERNEL && !X86_USE_3DNOW && (SLUB || SLAB) &&
!CC_OPTIMIZE_FOR_SIZE && !FUNCTION_TRACER) selects FRAME_POINTER which
has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K ||
M68KNOMMU || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) ||
ARCH_WANT_FRAME_POINTERS):  => N/A
	warning: (PAGE_POISONING && DEBUG_KERNEL &&
!ARCH_SUPPORTS_DEBUG_PAGEALLOC && !HIBERNATION) selects
DEBUG_PAGEALLOC which has unmet direct dependencies (DEBUG_KERNEL &&
ARCH_SUPPORTS_DEBUG_PAGEALLOC && (!HIBERNATION || !PPC && !SPARC) &&
!KMEMCHECK):  => N/A
	warning: (PPC_PRPMC2800 && EMBEDDED6xx || PPC_C2K && EMBEDDED6xx ||
AMIGAONE && 6xx && BROKEN_ON_SMP) selects NOT_COHERENT_CACHE which has
unmet direct dependencies (4xx || 8xx || E200 || PPC_MPC512x ||
GAMECUBE_COMMON):  => N/A
	warning: (PS3_PS3AV && PPC_PS3 || PS3_SYS_MANAGER && PPC_PS3) selects
PS3_VUART which has unmet direct dependencies (PPC_PS3 &&
PS3_ADVANCED):  => N/A
	warning: (RADIO_MIROPCM20 && MEDIA_SUPPORT && RADIO_ADAPTERS && ISA
&& VIDEO_V4L2 && SND) selects SND_ISA which has unmet direct
dependencies (ISA && ISA_DMA_API):  => N/A
	warning: (SCSI_SAS_LIBSAS && SCSI || SCSI_MPT2SAS && SCSI_LOWLEVEL &&
PCI && SCSI || FUSION_SAS && FUSION && PCI && SCSI) selects
SCSI_SAS_ATTRS which has unmet direct dependencies (SCSI &&
BLK_DEV_BSG):  => N/A
	warning: (SINGLE_MEMORY_CHUNK) selects NEED_MULTIPLE_NODES which has
unmet direct dependencies (DISCONTIGMEM || NUMA):  => N/A
	warning: (SUPERH32) selects HAVE_HW_BREAKPOINT which has unmet direct
dependencies (PERF_EVENTS):  => N/A
	warning: (USB_WUSB && USB_SUPPORT && EXPERIMENTAL && USB) selects UWB
which has unmet direct dependencies (EXPERIMENTAL && PCI):  => N/A
	warning: 3 bad relocations:  => N/A

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
