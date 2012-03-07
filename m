Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760108Ab2CGTyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 14:54:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760004Ab2CGTrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 14:47:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 02/29] Remove all #inclusions of asm/system.h
To: paul.gortmaker@windriver.com, hpa@zytor.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        arnd@arndb.de, dhowells@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Wed, 07 Mar 2012 19:46:14 +0000
Message-ID: <20120307194612.15987.76711.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
References: <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all #inclusions of asm/system.h preparatory to splitting and killing
it.  Performed with the following command:

perl -p -i -e 's!#\s*include\s*<asm/system[.]h>\n!!' `grep -Irl '#\s*include\s*<asm/system[.]h>' *`

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/alpha/boot/bootp.c                            |    1 -
 arch/alpha/boot/bootpz.c                           |    1 -
 arch/alpha/boot/head.S                             |    1 -
 arch/alpha/boot/main.c                             |    1 -
 arch/alpha/include/asm/atomic.h                    |    1 -
 arch/alpha/include/asm/core_lca.h                  |    1 -
 arch/alpha/include/asm/core_t2.h                   |    1 -
 arch/alpha/include/asm/io.h                        |    1 -
 arch/alpha/include/asm/irqflags.h                  |    1 -
 arch/alpha/include/asm/mmu_context.h               |    1 -
 arch/alpha/include/asm/spinlock.h                  |    1 -
 arch/alpha/kernel/head.S                           |    1 -
 arch/alpha/kernel/irq.c                            |    1 -
 arch/alpha/kernel/osf_sys.c                        |    1 -
 arch/alpha/kernel/process.c                        |    1 -
 arch/alpha/kernel/ptrace.c                         |    1 -
 arch/alpha/kernel/setup.c                          |    1 -
 arch/alpha/kernel/sys_alcor.c                      |    1 -
 arch/alpha/kernel/sys_cabriolet.c                  |    1 -
 arch/alpha/kernel/sys_dp264.c                      |    1 -
 arch/alpha/kernel/sys_eb64p.c                      |    1 -
 arch/alpha/kernel/sys_eiger.c                      |    1 -
 arch/alpha/kernel/sys_jensen.c                     |    1 -
 arch/alpha/kernel/sys_marvel.c                     |    1 -
 arch/alpha/kernel/sys_miata.c                      |    1 -
 arch/alpha/kernel/sys_mikasa.c                     |    1 -
 arch/alpha/kernel/sys_nautilus.c                   |    1 -
 arch/alpha/kernel/sys_noritake.c                   |    1 -
 arch/alpha/kernel/sys_rawhide.c                    |    1 -
 arch/alpha/kernel/sys_ruffian.c                    |    1 -
 arch/alpha/kernel/sys_rx164.c                      |    1 -
 arch/alpha/kernel/sys_sable.c                      |    1 -
 arch/alpha/kernel/sys_sio.c                        |    1 -
 arch/alpha/kernel/sys_sx164.c                      |    1 -
 arch/alpha/kernel/sys_takara.c                     |    1 -
 arch/alpha/kernel/sys_titan.c                      |    1 -
 arch/alpha/kernel/sys_wildfire.c                   |    1 -
 arch/alpha/lib/stacktrace.c                        |    1 -
 arch/alpha/mm/fault.c                              |    1 -
 arch/alpha/mm/init.c                               |    1 -
 arch/alpha/oprofile/common.c                       |    1 -
 arch/alpha/oprofile/op_model_ev4.c                 |    1 -
 arch/alpha/oprofile/op_model_ev5.c                 |    1 -
 arch/alpha/oprofile/op_model_ev6.c                 |    1 -
 arch/alpha/oprofile/op_model_ev67.c                |    1 -
 arch/arm/common/via82c505.c                        |    1 -
 arch/arm/include/asm/atomic.h                      |    1 -
 arch/arm/include/asm/bitops.h                      |    1 -
 arch/arm/include/asm/div64.h                       |    1 -
 arch/arm/include/asm/dma.h                         |    1 -
 arch/arm/include/asm/io.h                          |    1 -
 arch/arm/include/asm/processor.h                   |    1 -
 arch/arm/include/asm/uaccess.h                     |    1 -
 arch/arm/kernel/armksyms.c                         |    1 -
 arch/arm/kernel/entry-armv.S                       |    1 -
 arch/arm/kernel/fiq.c                              |    1 -
 arch/arm/kernel/head-nommu.S                       |    1 -
 arch/arm/kernel/head.S                             |    1 -
 arch/arm/kernel/hw_breakpoint.c                    |    1 -
 arch/arm/kernel/irq.c                              |    1 -
 arch/arm/kernel/machine_kexec.c                    |    1 -
 arch/arm/kernel/process.c                          |    1 -
 arch/arm/kernel/ptrace.c                           |    1 -
 arch/arm/kernel/setup.c                            |    1 -
 arch/arm/kernel/sleep.S                            |    1 -
 arch/arm/kernel/traps.c                            |    1 -
 arch/arm/mach-clps711x/p720t-leds.c                |    1 -
 arch/arm/mach-ebsa110/core.c                       |    1 -
 arch/arm/mach-ebsa110/leds.c                       |    1 -
 arch/arm/mach-footbridge/dc21285.c                 |    1 -
 arch/arm/mach-footbridge/ebsa285-leds.c            |    1 -
 arch/arm/mach-footbridge/netwinder-leds.c          |    1 -
 arch/arm/mach-imx/dma-v1.c                         |    1 -
 arch/arm/mach-integrator/core.c                    |    1 -
 arch/arm/mach-integrator/leds.c                    |    1 -
 arch/arm/mach-integrator/pci.c                     |    1 -
 arch/arm/mach-integrator/pci_v3.c                  |    1 -
 arch/arm/mach-iop33x/uart.c                        |    1 -
 arch/arm/mach-ixp2000/core.c                       |    1 -
 arch/arm/mach-ixp2000/enp2611.c                    |    1 -
 arch/arm/mach-ixp2000/ixdp2400.c                   |    1 -
 arch/arm/mach-ixp2000/ixdp2800.c                   |    1 -
 arch/arm/mach-ixp2000/ixdp2x00.c                   |    1 -
 arch/arm/mach-ixp2000/ixdp2x01.c                   |    1 -
 arch/arm/mach-ixp2000/pci.c                        |    1 -
 arch/arm/mach-ixp23xx/core.c                       |    1 -
 arch/arm/mach-ixp23xx/espresso.c                   |    1 -
 arch/arm/mach-ixp23xx/ixdp2351.c                   |    1 -
 arch/arm/mach-ixp23xx/pci.c                        |    1 -
 arch/arm/mach-ixp23xx/roadrunner.c                 |    1 -
 arch/arm/mach-ixp4xx/common-pci.c                  |    1 -
 arch/arm/mach-ixp4xx/goramo_mlr.c                  |    1 -
 arch/arm/mach-msm/board-sapphire.c                 |    1 -
 arch/arm/mach-mxs/system.c                         |    1 -
 arch/arm/mach-omap1/leds-h2p2-debug.c              |    1 -
 arch/arm/mach-omap1/leds-innovator.c               |    1 -
 arch/arm/mach-omap1/leds-osk.c                     |    1 -
 arch/arm/mach-omap1/mux.c                          |    1 -
 arch/arm/mach-omap1/time.c                         |    1 -
 arch/arm/mach-omap1/timer32k.c                     |    1 -
 arch/arm/mach-omap2/mux.c                          |    1 -
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |    1 -
 arch/arm/mach-omap2/sleep44xx.S                    |    1 -
 arch/arm/mach-orion5x/ls-chl-setup.c               |    1 -
 arch/arm/mach-orion5x/ls_hgl-setup.c               |    1 -
 arch/arm/mach-orion5x/lsmini-setup.c               |    1 -
 arch/arm/mach-pnx4008/core.c                       |    1 -
 arch/arm/mach-pnx4008/dma.c                        |    1 -
 arch/arm/mach-pnx4008/irq.c                        |    1 -
 arch/arm/mach-pnx4008/time.c                       |    1 -
 arch/arm/mach-pxa/corgi.c                          |    1 -
 arch/arm/mach-pxa/generic.c                        |    1 -
 arch/arm/mach-pxa/leds-idp.c                       |    1 -
 arch/arm/mach-pxa/leds-lubbock.c                   |    1 -
 arch/arm/mach-pxa/leds-mainstone.c                 |    1 -
 arch/arm/mach-pxa/poodle.c                         |    1 -
 arch/arm/mach-realview/core.c                      |    1 -
 arch/arm/mach-sa1100/dma.c                         |    1 -
 arch/arm/mach-sa1100/generic.c                     |    1 -
 arch/arm/mach-sa1100/leds-assabet.c                |    1 -
 arch/arm/mach-sa1100/leds-badge4.c                 |    1 -
 arch/arm/mach-sa1100/leds-cerf.c                   |    1 -
 arch/arm/mach-sa1100/leds-hackkit.c                |    1 -
 arch/arm/mach-sa1100/leds-lart.c                   |    1 -
 arch/arm/mach-sa1100/pm.c                          |    1 -
 arch/arm/mach-shark/leds.c                         |    1 -
 arch/arm/mach-shmobile/cpuidle.c                   |    1 -
 arch/arm/mach-shmobile/pm-r8a7779.c                |    1 -
 arch/arm/mach-shmobile/pm-sh7372.c                 |    1 -
 arch/arm/mach-shmobile/suspend.c                   |    1 -
 arch/arm/mach-tegra/cpu-tegra.c                    |    1 -
 arch/arm/mach-versatile/core.c                     |    1 -
 arch/arm/mach-versatile/pci.c                      |    1 -
 arch/arm/mach-vexpress/hotplug.c                   |    1 -
 arch/arm/mm/alignment.c                            |    1 -
 arch/arm/mm/cache-xsc3l2.c                         |    1 -
 arch/arm/mm/fault.c                                |    1 -
 arch/arm/mm/flush.c                                |    1 -
 arch/arm/mm/proc-fa526.S                           |    1 -
 arch/arm/nwfpe/fpa11.c                             |    1 -
 arch/arm/plat-iop/i2c.c                            |    1 -
 arch/arm/plat-iop/pci.c                            |    1 -
 arch/arm/plat-mxc/system.c                         |    1 -
 arch/arm/plat-omap/debug-leds.c                    |    1 -
 arch/arm/plat-omap/dma.c                           |    1 -
 arch/arm/plat-omap/mux.c                           |    1 -
 arch/arm/plat-pxa/dma.c                            |    1 -
 arch/arm/plat-s3c24xx/dma.c                        |    1 -
 arch/arm/plat-samsung/cpu.c                        |    1 -
 arch/arm/plat-samsung/time.c                       |    1 -
 arch/avr32/include/asm/atomic.h                    |    1 -
 arch/avr32/include/asm/bitops.h                    |    1 -
 arch/avr32/mach-at32ap/cpufreq.c                   |    1 -
 arch/avr32/oprofile/op_model_avr32.c               |    1 -
 arch/blackfin/kernel/ipipe.c                       |    1 -
 arch/blackfin/kernel/kgdb_test.c                   |    1 -
 arch/blackfin/kernel/ptrace.c                      |    1 -
 arch/blackfin/kernel/reboot.c                      |    1 -
 arch/c6x/include/asm/bitops.h                      |    1 -
 arch/c6x/kernel/soc.c                              |    1 -
 arch/cris/arch-v10/drivers/ds1302.c                |    1 -
 arch/cris/arch-v10/drivers/gpio.c                  |    1 -
 arch/cris/arch-v10/drivers/i2c.c                   |    1 -
 arch/cris/arch-v10/drivers/pcf8563.c               |    1 -
 arch/cris/arch-v10/drivers/sync_serial.c           |    1 -
 arch/cris/arch-v10/kernel/debugport.c              |    1 -
 arch/cris/arch-v10/kernel/ptrace.c                 |    1 -
 arch/cris/arch-v32/drivers/i2c.c                   |    1 -
 arch/cris/arch-v32/drivers/mach-a3/gpio.c          |    1 -
 arch/cris/arch-v32/drivers/mach-fs/gpio.c          |    1 -
 arch/cris/arch-v32/kernel/debugport.c              |    1 -
 arch/cris/arch-v32/kernel/fasttimer.c              |    1 -
 arch/cris/arch-v32/kernel/ptrace.c                 |    1 -
 arch/cris/arch-v32/mach-a3/dma.c                   |    1 -
 arch/cris/arch-v32/mach-fs/dma.c                   |    1 -
 arch/cris/include/asm/atomic.h                     |    1 -
 arch/cris/include/asm/bitops.h                     |    1 -
 arch/cris/include/asm/processor.h                  |    1 -
 arch/cris/kernel/process.c                         |    1 -
 arch/cris/kernel/ptrace.c                          |    1 -
 arch/frv/include/asm/atomic.h                      |    1 -
 arch/frv/kernel/debug-stub.c                       |    1 -
 arch/frv/kernel/gdb-io.c                           |    1 -
 arch/frv/kernel/gdb-stub.c                         |    1 -
 arch/frv/kernel/irq-mb93091.c                      |    1 -
 arch/frv/kernel/irq-mb93093.c                      |    1 -
 arch/frv/kernel/irq-mb93493.c                      |    1 -
 arch/frv/kernel/irq.c                              |    1 -
 arch/frv/kernel/process.c                          |    1 -
 arch/frv/kernel/ptrace.c                           |    1 -
 arch/frv/kernel/traps.c                            |    1 -
 arch/frv/mm/fault.c                                |    1 -
 arch/frv/mm/init.c                                 |    1 -
 arch/frv/mm/kmap.c                                 |    1 -
 arch/h8300/include/asm/atomic.h                    |    1 -
 arch/h8300/include/asm/bitops.h                    |    1 -
 arch/h8300/kernel/irq.c                            |    1 -
 arch/h8300/kernel/process.c                        |    1 -
 arch/h8300/kernel/ptrace.c                         |    1 -
 arch/h8300/kernel/traps.c                          |    1 -
 arch/h8300/mm/fault.c                              |    1 -
 arch/h8300/mm/init.c                               |    1 -
 arch/h8300/mm/kmap.c                               |    1 -
 arch/h8300/mm/memory.c                             |    1 -
 arch/hexagon/include/asm/bitops.h                  |    1 -
 arch/hexagon/kernel/ptrace.c                       |    1 -
 arch/hexagon/kernel/vm_events.c                    |    1 -
 arch/ia64/dig/setup.c                              |    1 -
 arch/ia64/hp/sim/boot/bootloader.c                 |    1 -
 arch/ia64/hp/sim/simeth.c                          |    1 -
 arch/ia64/include/asm/acpi.h                       |    1 -
 arch/ia64/include/asm/atomic.h                     |    1 -
 arch/ia64/include/asm/futex.h                      |    1 -
 arch/ia64/include/asm/io.h                         |    1 -
 arch/ia64/include/asm/pgtable.h                    |    1 -
 arch/ia64/include/asm/sal.h                        |    1 -
 arch/ia64/include/asm/sn/pda.h                     |    1 -
 arch/ia64/include/asm/spinlock.h                   |    1 -
 arch/ia64/include/asm/uv/uv.h                      |    1 -
 arch/ia64/kernel/acpi.c                            |    1 -
 arch/ia64/kernel/fsys.S                            |    1 -
 arch/ia64/kernel/gate.S                            |    1 -
 arch/ia64/kernel/gate.lds.S                        |    1 -
 arch/ia64/kernel/head.S                            |    1 -
 arch/ia64/kernel/iosapic.c                         |    1 -
 arch/ia64/kernel/irq_ia64.c                        |    1 -
 arch/ia64/kernel/ivt.S                             |    1 -
 arch/ia64/kernel/machvec.c                         |    1 -
 arch/ia64/kernel/mca.c                             |    1 -
 arch/ia64/kernel/mca_drv.c                         |    1 -
 arch/ia64/kernel/patch.c                           |    1 -
 arch/ia64/kernel/pci-dma.c                         |    1 -
 arch/ia64/kernel/perfmon.c                         |    1 -
 arch/ia64/kernel/ptrace.c                          |    1 -
 arch/ia64/kernel/setup.c                           |    1 -
 arch/ia64/kernel/smp.c                             |    1 -
 arch/ia64/kernel/smpboot.c                         |    1 -
 arch/ia64/kernel/time.c                            |    1 -
 arch/ia64/kernel/uncached.c                        |    1 -
 arch/ia64/kernel/unwind.c                          |    1 -
 arch/ia64/kernel/vmlinux.lds.S                     |    1 -
 arch/ia64/mm/fault.c                               |    1 -
 arch/ia64/mm/init.c                                |    1 -
 arch/ia64/oprofile/backtrace.c                     |    1 -
 arch/ia64/pci/pci.c                                |    1 -
 arch/ia64/sn/kernel/setup.c                        |    1 -
 arch/ia64/sn/kernel/sn2/prominfo_proc.c            |    1 -
 arch/ia64/sn/kernel/sn2/sn2_smp.c                  |    1 -
 arch/ia64/sn/kernel/sn2/timer.c                    |    1 -
 arch/ia64/sn/kernel/tiocx.c                        |    1 -
 arch/ia64/xen/xensetup.S                           |    1 -
 arch/m32r/include/asm/atomic.h                     |    1 -
 arch/m32r/include/asm/bitops.h                     |    1 -
 arch/m32r/include/asm/local.h                      |    1 -
 arch/m32r/kernel/ptrace.c                          |    1 -
 arch/m32r/kernel/traps.c                           |    1 -
 arch/m32r/mm/fault-nommu.c                         |    1 -
 arch/m32r/mm/fault.c                               |    1 -
 arch/m32r/platforms/m32104ut/setup.c               |    1 -
 arch/m32r/platforms/m32700ut/setup.c               |    1 -
 arch/m32r/platforms/mappi/setup.c                  |    1 -
 arch/m32r/platforms/mappi2/setup.c                 |    1 -
 arch/m32r/platforms/mappi3/setup.c                 |    1 -
 arch/m32r/platforms/oaks32r/setup.c                |    1 -
 arch/m32r/platforms/opsput/setup.c                 |    1 -
 arch/m32r/platforms/usrv/setup.c                   |    1 -
 arch/m68k/amiga/amisound.c                         |    1 -
 arch/m68k/amiga/config.c                           |    1 -
 arch/m68k/apollo/config.c                          |    1 -
 arch/m68k/atari/ataints.c                          |    1 -
 arch/m68k/atari/atasound.c                         |    1 -
 arch/m68k/atari/config.c                           |    1 -
 arch/m68k/bvme6000/config.c                        |    1 -
 arch/m68k/bvme6000/rtc.c                           |    1 -
 arch/m68k/hp300/time.c                             |    1 -
 arch/m68k/include/asm/atomic.h                     |    1 -
 arch/m68k/include/asm/sun3xflop.h                  |    1 -
 arch/m68k/kernel/ints.c                            |    1 -
 arch/m68k/kernel/irq.c                             |    1 -
 arch/m68k/kernel/process_mm.c                      |    1 -
 arch/m68k/kernel/process_no.c                      |    1 -
 arch/m68k/kernel/ptrace_mm.c                       |    1 -
 arch/m68k/kernel/ptrace_no.c                       |    1 -
 arch/m68k/kernel/traps.c                           |    1 -
 arch/m68k/kernel/vectors.c                         |    1 -
 arch/m68k/mac/config.c                             |    1 -
 arch/m68k/mac/misc.c                               |    1 -
 arch/m68k/mm/fault.c                               |    1 -
 arch/m68k/mm/init_mm.c                             |    1 -
 arch/m68k/mm/init_no.c                             |    1 -
 arch/m68k/mm/kmap.c                                |    1 -
 arch/m68k/mm/memory.c                              |    1 -
 arch/m68k/mm/motorola.c                            |    1 -
 arch/m68k/mm/sun3mmu.c                             |    1 -
 arch/m68k/mvme147/config.c                         |    1 -
 arch/m68k/mvme16x/config.c                         |    1 -
 arch/m68k/mvme16x/rtc.c                            |    1 -
 arch/m68k/platform/68328/config.c                  |    1 -
 arch/m68k/platform/68328/timers.c                  |    1 -
 arch/m68k/platform/68360/config.c                  |    1 -
 arch/m68k/platform/68EZ328/config.c                |    1 -
 arch/m68k/platform/68VZ328/config.c                |    1 -
 arch/m68k/q40/config.c                             |    1 -
 arch/m68k/q40/q40ints.c                            |    1 -
 arch/m68k/sun3/intersil.c                          |    1 -
 arch/m68k/sun3/mmu_emu.c                           |    1 -
 arch/m68k/sun3/prom/console.c                      |    1 -
 arch/m68k/sun3x/config.c                           |    1 -
 arch/m68k/sun3x/time.c                             |    1 -
 arch/microblaze/kernel/cpu/pvr.c                   |    1 -
 arch/microblaze/kernel/microblaze_ksyms.c          |    1 -
 arch/microblaze/kernel/process.c                   |    1 -
 arch/microblaze/kernel/prom.c                      |    1 -
 arch/microblaze/kernel/setup.c                     |    1 -
 arch/microblaze/kernel/timer.c                     |    1 -
 arch/microblaze/kernel/traps.c                     |    1 -
 arch/microblaze/lib/memcpy.c                       |    1 -
 arch/microblaze/mm/fault.c                         |    1 -
 arch/mips/cavium-octeon/setup.c                    |    1 -
 arch/mips/cavium-octeon/smp.c                      |    1 -
 arch/mips/dec/ecc-berr.c                           |    1 -
 arch/mips/dec/kn01-berr.c                          |    1 -
 arch/mips/dec/kn02xa-berr.c                        |    1 -
 arch/mips/dec/wbflush.c                            |    1 -
 arch/mips/emma/markeins/irq.c                      |    1 -
 arch/mips/fw/arc/misc.c                            |    1 -
 arch/mips/include/asm/atomic.h                     |    1 -
 arch/mips/include/asm/dma.h                        |    1 -
 arch/mips/include/asm/mach-au1x00/au1000_dma.h     |    1 -
 arch/mips/include/asm/processor.h                  |    1 -
 arch/mips/include/asm/txx9/jmr3927.h               |    1 -
 arch/mips/kernel/cpu-bugs64.c                      |    1 -
 arch/mips/kernel/cpu-probe.c                       |    1 -
 arch/mips/kernel/irq-rm7000.c                      |    1 -
 arch/mips/kernel/irq-rm9000.c                      |    1 -
 arch/mips/kernel/irq.c                             |    1 -
 arch/mips/kernel/irq_cpu.c                         |    1 -
 arch/mips/kernel/mips-mt.c                         |    1 -
 arch/mips/kernel/process.c                         |    1 -
 arch/mips/kernel/ptrace.c                          |    1 -
 arch/mips/kernel/ptrace32.c                        |    1 -
 arch/mips/kernel/rtlx.c                            |    1 -
 arch/mips/kernel/setup.c                           |    1 -
 arch/mips/kernel/signal32.c                        |    1 -
 arch/mips/kernel/signal_n32.c                      |    1 -
 arch/mips/kernel/smp-bmips.c                       |    1 -
 arch/mips/kernel/smp-cmp.c                         |    1 -
 arch/mips/kernel/smp-mt.c                          |    1 -
 arch/mips/kernel/smp.c                             |    1 -
 arch/mips/kernel/smtc-proc.c                       |    1 -
 arch/mips/kernel/smtc.c                            |    1 -
 arch/mips/kernel/spram.c                           |    1 -
 arch/mips/kernel/traps.c                           |    1 -
 arch/mips/kernel/unaligned.c                       |    1 -
 arch/mips/kernel/vpe.c                             |    1 -
 arch/mips/lasat/reset.c                            |    1 -
 arch/mips/math-emu/dsemul.c                        |    1 -
 arch/mips/mipssim/sim_smtc.c                       |    1 -
 arch/mips/mm/c-octeon.c                            |    1 -
 arch/mips/mm/c-r3k.c                               |    1 -
 arch/mips/mm/c-r4k.c                               |    1 -
 arch/mips/mm/c-tx39.c                              |    1 -
 arch/mips/mm/fault.c                               |    1 -
 arch/mips/mm/page.c                                |    1 -
 arch/mips/mm/sc-ip22.c                             |    1 -
 arch/mips/mm/sc-mips.c                             |    1 -
 arch/mips/mm/sc-r5k.c                              |    1 -
 arch/mips/mm/tlb-r3k.c                             |    1 -
 arch/mips/mm/tlb-r4k.c                             |    1 -
 arch/mips/mm/tlb-r8k.c                             |    1 -
 arch/mips/mti-malta/malta-init.c                   |    1 -
 arch/mips/netlogic/common/irq.c                    |    1 -
 arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c         |    1 -
 arch/mips/pmc-sierra/msp71xx/msp_irq_per.c         |    1 -
 arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c         |    1 -
 arch/mips/pmc-sierra/yosemite/irq.c                |    1 -
 arch/mips/pmc-sierra/yosemite/prom.c               |    1 -
 arch/mips/powertv/asic/irq_asic.c                  |    1 -
 arch/mips/powertv/init.c                           |    1 -
 arch/mips/rb532/irq.c                              |    1 -
 arch/mips/sgi-ip22/ip22-berr.c                     |    1 -
 arch/mips/sgi-ip22/ip22-reset.c                    |    1 -
 arch/mips/sgi-ip22/ip28-berr.c                     |    1 -
 arch/mips/sgi-ip27/ip27-irq.c                      |    1 -
 arch/mips/sgi-ip27/ip27-reset.c                    |    1 -
 arch/mips/sgi-ip32/ip32-irq.c                      |    1 -
 arch/mips/sgi-ip32/ip32-reset.c                    |    1 -
 arch/mips/sibyte/bcm1480/irq.c                     |    1 -
 arch/mips/sibyte/common/sb_tbprof.c                |    1 -
 arch/mips/sibyte/sb1250/bus_watcher.c              |    1 -
 arch/mips/sibyte/sb1250/irq.c                      |    1 -
 arch/mips/sni/reset.c                              |    1 -
 arch/mips/vr41xx/common/irq.c                      |    1 -
 arch/mips/vr41xx/common/pmu.c                      |    1 -
 arch/mn10300/include/asm/dma.h                     |    1 -
 arch/mn10300/kernel/entry.S                        |    1 -
 arch/mn10300/kernel/fpu.c                          |    1 -
 arch/mn10300/kernel/gdb-io-serial.c                |    1 -
 arch/mn10300/kernel/gdb-io-ttysm.c                 |    1 -
 arch/mn10300/kernel/gdb-stub.c                     |    1 -
 arch/mn10300/kernel/mn10300-serial.c               |    1 -
 arch/mn10300/kernel/mn10300-watchdog.c             |    1 -
 arch/mn10300/kernel/process.c                      |    1 -
 arch/mn10300/kernel/ptrace.c                       |    1 -
 arch/mn10300/kernel/setup.c                        |    1 -
 arch/mn10300/kernel/smp-low.S                      |    1 -
 arch/mn10300/kernel/smp.c                          |    1 -
 arch/mn10300/kernel/traps.c                        |    1 -
 arch/mn10300/lib/bitops.c                          |    1 -
 arch/mn10300/mm/fault.c                            |    1 -
 arch/mn10300/mm/init.c                             |    1 -
 arch/mn10300/mm/misalignment.c                     |    1 -
 arch/mn10300/mm/pgtable.c                          |    1 -
 arch/mn10300/mm/tlb-smp.c                          |    1 -
 arch/mn10300/proc-mn2ws0050/proc-init.c            |    1 -
 arch/openrisc/kernel/idle.c                        |    1 -
 arch/openrisc/kernel/process.c                     |    1 -
 arch/openrisc/kernel/prom.c                        |    1 -
 arch/openrisc/kernel/ptrace.c                      |    1 -
 arch/openrisc/kernel/setup.c                       |    1 -
 arch/openrisc/kernel/traps.c                       |    1 -
 arch/openrisc/mm/init.c                            |    1 -
 arch/openrisc/mm/tlb.c                             |    1 -
 arch/parisc/include/asm/atomic.h                   |    1 -
 arch/parisc/include/asm/processor.h                |    1 -
 arch/parisc/include/asm/spinlock.h                 |    1 -
 arch/parisc/include/asm/timex.h                    |    1 -
 arch/parisc/include/asm/uaccess.h                  |    1 -
 arch/parisc/kernel/cache.c                         |    1 -
 arch/parisc/kernel/firmware.c                      |    1 -
 arch/parisc/kernel/pci.c                           |    1 -
 arch/parisc/kernel/ptrace.c                        |    1 -
 arch/parisc/kernel/smp.c                           |    1 -
 arch/parisc/kernel/traps.c                         |    1 -
 arch/parisc/lib/bitops.c                           |    1 -
 arch/powerpc/include/asm/atomic.h                  |    1 -
 arch/powerpc/include/asm/dma.h                     |    1 -
 arch/powerpc/include/asm/hw_breakpoint.h           |    1 -
 arch/powerpc/kernel/align.c                        |    1 -
 arch/powerpc/kernel/crash.c                        |    1 -
 arch/powerpc/kernel/idle.c                         |    1 -
 arch/powerpc/kernel/irq.c                          |    1 -
 arch/powerpc/kernel/kprobes.c                      |    1 -
 arch/powerpc/kernel/lparcfg.c                      |    1 -
 arch/powerpc/kernel/ppc_ksyms.c                    |    1 -
 arch/powerpc/kernel/process.c                      |    1 -
 arch/powerpc/kernel/prom.c                         |    1 -
 arch/powerpc/kernel/prom_init.c                    |    1 -
 arch/powerpc/kernel/ptrace.c                       |    1 -
 arch/powerpc/kernel/ptrace32.c                     |    1 -
 arch/powerpc/kernel/rtas.c                         |    1 -
 arch/powerpc/kernel/setup-common.c                 |    1 -
 arch/powerpc/kernel/setup_32.c                     |    1 -
 arch/powerpc/kernel/setup_64.c                     |    1 -
 arch/powerpc/kernel/smp.c                          |    1 -
 arch/powerpc/kernel/softemu8xx.c                   |    1 -
 arch/powerpc/kernel/swsusp.c                       |    1 -
 arch/powerpc/kernel/swsusp_64.c                    |    1 -
 arch/powerpc/kernel/sysfs.c                        |    1 -
 arch/powerpc/kernel/traps.c                        |    1 -
 arch/powerpc/kernel/vdso.c                         |    1 -
 arch/powerpc/lib/alloc.c                           |    1 -
 arch/powerpc/mm/44x_mmu.c                          |    1 -
 arch/powerpc/mm/fault.c                            |    1 -
 arch/powerpc/mm/hash_utils_64.c                    |    1 -
 arch/powerpc/mm/init_32.c                          |    1 -
 arch/powerpc/mm/init_64.c                          |    1 -
 arch/powerpc/mm/numa.c                             |    1 -
 arch/powerpc/mm/pgtable_64.c                       |    1 -
 arch/powerpc/oprofile/common.c                     |    1 -
 arch/powerpc/oprofile/op_model_7450.c              |    1 -
 arch/powerpc/oprofile/op_model_cell.c              |    1 -
 arch/powerpc/oprofile/op_model_fsl_emb.c           |    1 -
 arch/powerpc/oprofile/op_model_power4.c            |    1 -
 arch/powerpc/oprofile/op_model_rs64.c              |    1 -
 arch/powerpc/platforms/82xx/pq2.c                  |    1 -
 arch/powerpc/platforms/83xx/km83xx.c               |    1 -
 arch/powerpc/platforms/83xx/mpc832x_mds.c          |    1 -
 arch/powerpc/platforms/83xx/mpc834x_itx.c          |    1 -
 arch/powerpc/platforms/83xx/mpc834x_mds.c          |    1 -
 arch/powerpc/platforms/83xx/mpc836x_mds.c          |    1 -
 arch/powerpc/platforms/83xx/sbc834x.c              |    1 -
 arch/powerpc/platforms/85xx/corenet_ds.c           |    1 -
 arch/powerpc/platforms/85xx/ksi8560.c              |    1 -
 arch/powerpc/platforms/85xx/mpc8536_ds.c           |    1 -
 arch/powerpc/platforms/85xx/mpc85xx_ads.c          |    1 -
 arch/powerpc/platforms/85xx/mpc85xx_cds.c          |    1 -
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |    1 -
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    1 -
 arch/powerpc/platforms/85xx/mpc85xx_rdb.c          |    1 -
 arch/powerpc/platforms/85xx/p1010rdb.c             |    1 -
 arch/powerpc/platforms/85xx/p1023_rds.c            |    1 -
 arch/powerpc/platforms/85xx/p2041_rdb.c            |    1 -
 arch/powerpc/platforms/85xx/p3041_ds.c             |    1 -
 arch/powerpc/platforms/85xx/p4080_ds.c             |    1 -
 arch/powerpc/platforms/85xx/p5020_ds.c             |    1 -
 arch/powerpc/platforms/85xx/sbc8548.c              |    1 -
 arch/powerpc/platforms/85xx/sbc8560.c              |    1 -
 arch/powerpc/platforms/85xx/socrates.c             |    1 -
 arch/powerpc/platforms/85xx/stx_gp3.c              |    1 -
 arch/powerpc/platforms/85xx/tqm85xx.c              |    1 -
 arch/powerpc/platforms/85xx/xes_mpc85xx.c          |    1 -
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |    1 -
 arch/powerpc/platforms/86xx/gef_sbc310.c           |    1 -
 arch/powerpc/platforms/86xx/gef_sbc610.c           |    1 -
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |    1 -
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c         |    1 -
 arch/powerpc/platforms/86xx/pic.c                  |    1 -
 arch/powerpc/platforms/86xx/sbc8641d.c             |    1 -
 arch/powerpc/platforms/8xx/mpc86xads_setup.c       |    1 -
 arch/powerpc/platforms/8xx/mpc885ads_setup.c       |    1 -
 arch/powerpc/platforms/8xx/tqm8xx_setup.c          |    1 -
 arch/powerpc/platforms/cell/smp.c                  |    1 -
 arch/powerpc/platforms/embedded6xx/c2k.c           |    1 -
 arch/powerpc/platforms/embedded6xx/holly.c         |    1 -
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c  |    1 -
 arch/powerpc/platforms/embedded6xx/prpmc2800.c     |    1 -
 arch/powerpc/platforms/embedded6xx/storcenter.c    |    1 -
 arch/powerpc/platforms/fsl_uli1575.c               |    1 -
 arch/powerpc/platforms/iseries/dt.c                |    1 -
 arch/powerpc/platforms/iseries/lpevents.c          |    1 -
 arch/powerpc/platforms/iseries/setup.c             |    1 -
 arch/powerpc/platforms/iseries/smp.c               |    1 -
 arch/powerpc/platforms/iseries/viopath.c           |    1 -
 arch/powerpc/platforms/maple/setup.c               |    1 -
 arch/powerpc/platforms/maple/time.c                |    1 -
 arch/powerpc/platforms/pasemi/setup.c              |    1 -
 arch/powerpc/platforms/powermac/cpufreq_32.c       |    1 -
 arch/powerpc/platforms/powermac/nvram.c            |    1 -
 arch/powerpc/platforms/powermac/setup.c            |    1 -
 arch/powerpc/platforms/powermac/time.c             |    1 -
 arch/powerpc/platforms/powernv/smp.c               |    1 -
 arch/powerpc/platforms/pseries/dtl.c               |    1 -
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |    1 -
 arch/powerpc/platforms/pseries/processor_idle.c    |    1 -
 arch/powerpc/platforms/pseries/ras.c               |    1 -
 arch/powerpc/platforms/pseries/smp.c               |    1 -
 arch/powerpc/platforms/wsp/chroma.c                |    1 -
 arch/powerpc/platforms/wsp/psr2.c                  |    1 -
 arch/powerpc/sysdev/cpm_common.c                   |    1 -
 arch/powerpc/sysdev/fsl_soc.c                      |    1 -
 arch/powerpc/sysdev/tsi108_dev.c                   |    1 -
 arch/s390/include/asm/atomic.h                     |    1 -
 arch/s390/include/asm/sigp.h                       |    1 -
 arch/s390/include/asm/smp.h                        |    1 -
 arch/s390/kernel/cpcmd.c                           |    1 -
 arch/s390/kernel/dis.c                             |    1 -
 arch/s390/kernel/machine_kexec.c                   |    1 -
 arch/s390/kernel/process.c                         |    1 -
 arch/s390/kernel/ptrace.c                          |    1 -
 arch/s390/kernel/setup.c                           |    1 -
 arch/s390/kernel/suspend.c                         |    1 -
 arch/s390/kernel/traps.c                           |    1 -
 arch/s390/kernel/vdso.c                            |    1 -
 arch/s390/kvm/kvm-s390.c                           |    1 -
 arch/s390/mm/fault.c                               |    1 -
 arch/s390/mm/init.c                                |    1 -
 arch/s390/mm/maccess.c                             |    1 -
 arch/s390/mm/pgtable.c                             |    1 -
 arch/sh/boards/mach-microdev/irq.c                 |    1 -
 arch/sh/include/asm/atomic.h                       |    1 -
 arch/sh/include/asm/bitops.h                       |    1 -
 arch/sh/include/asm/futex-irq.h                    |    1 -
 arch/sh/include/asm/io.h                           |    1 -
 arch/sh/include/asm/ptrace.h                       |    1 -
 arch/sh/kernel/cpu/init.c                          |    1 -
 arch/sh/kernel/cpu/irq/imask.c                     |    1 -
 arch/sh/kernel/cpu/sh2a/opcode_helper.c            |    1 -
 arch/sh/kernel/cpu/sh4/fpu.c                       |    1 -
 arch/sh/kernel/idle.c                              |    1 -
 arch/sh/kernel/io_trapped.c                        |    1 -
 arch/sh/kernel/process_32.c                        |    1 -
 arch/sh/kernel/ptrace_32.c                         |    1 -
 arch/sh/kernel/ptrace_64.c                         |    1 -
 arch/sh/kernel/reboot.c                            |    1 -
 arch/sh/kernel/signal_32.c                         |    1 -
 arch/sh/kernel/smp.c                               |    1 -
 arch/sh/kernel/traps.c                             |    1 -
 arch/sh/kernel/traps_32.c                          |    1 -
 arch/sh/kernel/traps_64.c                          |    1 -
 arch/sh/math-emu/math.c                            |    1 -
 arch/sh/mm/fault_32.c                              |    1 -
 arch/sh/mm/fault_64.c                              |    1 -
 arch/sh/mm/pmb.c                                   |    1 -
 arch/sh/mm/tlb-pteaex.c                            |    1 -
 arch/sh/mm/tlb-sh3.c                               |    1 -
 arch/sh/mm/tlb-sh4.c                               |    1 -
 arch/sh/mm/tlbflush_64.c                           |    1 -
 arch/sparc/include/asm/atomic_32.h                 |    1 -
 arch/sparc/include/asm/atomic_64.h                 |    1 -
 arch/sparc/include/asm/auxio_32.h                  |    1 -
 arch/sparc/include/asm/floppy_32.h                 |    1 -
 arch/sparc/include/asm/futex_64.h                  |    1 -
 arch/sparc/include/asm/io_32.h                     |    1 -
 arch/sparc/include/asm/io_64.h                     |    1 -
 arch/sparc/include/asm/mmu_context_64.h            |    1 -
 arch/sparc/include/asm/ns87303.h                   |    1 -
 arch/sparc/include/asm/pgtable_32.h                |    1 -
 arch/sparc/include/asm/pgtable_64.h                |    1 -
 arch/sparc/include/asm/ptrace.h                    |    2 --
 arch/sparc/include/asm/uaccess_64.h                |    1 -
 arch/sparc/kernel/devices.c                        |    1 -
 arch/sparc/kernel/irq_64.c                         |    1 -
 arch/sparc/kernel/muldiv.c                         |    1 -
 arch/sparc/kernel/process_32.c                     |    1 -
 arch/sparc/kernel/process_64.c                     |    1 -
 arch/sparc/kernel/ptrace_32.c                      |    1 -
 arch/sparc/kernel/ptrace_64.c                      |    1 -
 arch/sparc/kernel/reboot.c                         |    1 -
 arch/sparc/kernel/setup_32.c                       |    1 -
 arch/sparc/kernel/setup_64.c                       |    1 -
 arch/sparc/kernel/sparc_ksyms_64.c                 |    1 -
 arch/sparc/kernel/time_32.c                        |    1 -
 arch/sparc/kernel/traps_32.c                       |    1 -
 arch/sparc/kernel/traps_64.c                       |    1 -
 arch/sparc/kernel/unaligned_32.c                   |    1 -
 arch/sparc/kernel/unaligned_64.c                   |    1 -
 arch/sparc/kernel/visemul.c                        |    1 -
 arch/sparc/mm/btfixup.c                            |    1 -
 arch/sparc/mm/fault_32.c                           |    1 -
 arch/sparc/mm/init_32.c                            |    1 -
 arch/sparc/mm/init_64.c                            |    1 -
 arch/sparc/mm/loadmmu.c                            |    1 -
 arch/sparc/mm/tsb.c                                |    1 -
 arch/sparc/prom/console_32.c                       |    1 -
 arch/sparc/prom/console_64.c                       |    1 -
 arch/sparc/prom/misc_32.c                          |    1 -
 arch/sparc/prom/misc_64.c                          |    1 -
 arch/sparc/prom/p1275.c                            |    1 -
 arch/sparc/prom/ranges.c                           |    1 -
 arch/tile/include/asm/atomic.h                     |    1 -
 arch/tile/include/asm/bitops_32.h                  |    1 -
 arch/tile/include/asm/bitops_64.h                  |    1 -
 arch/tile/include/asm/cacheflush.h                 |    1 -
 arch/tile/include/asm/pgtable.h                    |    1 -
 arch/tile/include/asm/spinlock_32.h                |    1 -
 arch/tile/kernel/process.c                         |    1 -
 arch/tile/kernel/regs_32.S                         |    1 -
 arch/tile/kernel/regs_64.S                         |    1 -
 arch/tile/mm/fault.c                               |    1 -
 arch/tile/mm/init.c                                |    1 -
 arch/tile/mm/pgtable.c                             |    1 -
 arch/um/include/asm/fixmap.h                       |    1 -
 arch/unicore32/include/asm/io.h                    |    1 -
 arch/unicore32/include/asm/uaccess.h               |    1 -
 arch/unicore32/kernel/dma.c                        |    1 -
 arch/unicore32/kernel/head.S                       |    1 -
 arch/unicore32/kernel/hibernate.c                  |    1 -
 arch/unicore32/kernel/irq.c                        |    1 -
 arch/unicore32/kernel/ksyms.c                      |    1 -
 arch/unicore32/kernel/process.c                    |    1 -
 arch/unicore32/kernel/traps.c                      |    1 -
 arch/unicore32/mm/fault.c                          |    1 -
 arch/unicore32/mm/flush.c                          |    1 -
 arch/x86/ia32/ia32_aout.c                          |    1 -
 arch/x86/include/asm/apic.h                        |    1 -
 arch/x86/include/asm/elf.h                         |    1 -
 arch/x86/include/asm/futex.h                       |    1 -
 arch/x86/include/asm/local.h                       |    1 -
 arch/x86/include/asm/mc146818rtc.h                 |    1 -
 arch/x86/include/asm/processor.h                   |    1 -
 arch/x86/include/asm/stackprotector.h              |    1 -
 arch/x86/include/asm/tlbflush.h                    |    1 -
 arch/x86/include/asm/virtext.h                     |    1 -
 arch/x86/kernel/apm_32.c                           |    1 -
 arch/x86/kernel/cpu/mcheck/p5.c                    |    1 -
 arch/x86/kernel/cpu/mcheck/therm_throt.c           |    1 -
 arch/x86/kernel/cpu/mcheck/winchip.c               |    1 -
 arch/x86/kernel/cpu/mtrr/generic.c                 |    1 -
 arch/x86/kernel/cpuid.c                            |    1 -
 arch/x86/kernel/i8259.c                            |    1 -
 arch/x86/kernel/irqinit.c                          |    1 -
 arch/x86/kernel/kgdb.c                             |    1 -
 arch/x86/kernel/ldt.c                              |    1 -
 arch/x86/kernel/machine_kexec_32.c                 |    1 -
 arch/x86/kernel/mca_32.c                           |    1 -
 arch/x86/kernel/module.c                           |    1 -
 arch/x86/kernel/msr.c                              |    1 -
 arch/x86/kernel/pci-calgary_64.c                   |    1 -
 arch/x86/kernel/process.c                          |    1 -
 arch/x86/kernel/process_32.c                       |    1 -
 arch/x86/kernel/process_64.c                       |    1 -
 arch/x86/kernel/ptrace.c                           |    1 -
 arch/x86/kernel/setup.c                            |    1 -
 arch/x86/kernel/tls.c                              |    1 -
 arch/x86/kernel/traps.c                            |    1 -
 arch/x86/mm/init.c                                 |    1 -
 arch/x86/mm/init_32.c                              |    1 -
 arch/x86/mm/init_64.c                              |    1 -
 arch/x86/mm/pgtable_32.c                           |    1 -
 arch/x86/power/hibernate_32.c                      |    1 -
 arch/xtensa/include/asm/atomic.h                   |    1 -
 arch/xtensa/include/asm/bitops.h                   |    1 -
 arch/xtensa/kernel/process.c                       |    1 -
 arch/xtensa/kernel/ptrace.c                        |    1 -
 arch/xtensa/kernel/setup.c                         |    1 -
 arch/xtensa/mm/fault.c                             |    1 -
 arch/xtensa/mm/tlb.c                               |    1 -
 drivers/acpi/processor_driver.c                    |    1 -
 drivers/atm/eni.c                                  |    1 -
 drivers/atm/firestream.c                           |    1 -
 drivers/atm/horizon.c                              |    1 -
 drivers/atm/idt77105.c                             |    1 -
 drivers/atm/suni.c                                 |    1 -
 drivers/atm/zatm.c                                 |    1 -
 drivers/block/floppy.c                             |    1 -
 drivers/block/hd.c                                 |    1 -
 drivers/block/nbd.c                                |    1 -
 drivers/block/xd.c                                 |    1 -
 drivers/bluetooth/bt3c_cs.c                        |    1 -
 drivers/bluetooth/btuart_cs.c                      |    1 -
 drivers/bluetooth/dtl1_cs.c                        |    1 -
 drivers/char/apm-emulation.c                       |    1 -
 drivers/char/ds1302.c                              |    1 -
 drivers/char/efirtc.c                              |    1 -
 drivers/char/genrtc.c                              |    1 -
 drivers/char/hpet.c                                |    1 -
 drivers/char/ipmi/ipmi_devintf.c                   |    1 -
 drivers/char/ipmi/ipmi_msghandler.c                |    1 -
 drivers/char/ipmi/ipmi_si_intf.c                   |    1 -
 drivers/char/lp.c                                  |    1 -
 drivers/char/mbcs.c                                |    1 -
 drivers/char/mspec.c                               |    1 -
 drivers/char/mwave/3780i.c                         |    1 -
 drivers/char/nvram.c                               |    1 -
 drivers/char/nwflash.c                             |    1 -
 drivers/char/pcmcia/synclink_cs.c                  |    1 -
 drivers/char/rtc.c                                 |    1 -
 drivers/char/sonypi.c                              |    1 -
 drivers/char/xilinx_hwicap/xilinx_hwicap.c         |    1 -
 drivers/cpufreq/omap-cpufreq.c                     |    1 -
 drivers/cpufreq/powernow-k7.c                      |    1 -
 drivers/firewire/core-cdev.c                       |    1 -
 drivers/firewire/core-device.c                     |    1 -
 drivers/firewire/core-topology.c                   |    1 -
 drivers/firewire/ohci.c                            |    1 -
 drivers/firewire/sbp2.c                            |    1 -
 drivers/i2c/busses/i2c-acorn.c                     |    1 -
 drivers/ide/ide-cs.c                               |    1 -
 drivers/ide/qd65xx.c                               |    1 -
 drivers/infiniband/hw/ehca/ehca_reqs.c             |    1 -
 drivers/input/joydev.c                             |    1 -
 drivers/input/joystick/amijoy.c                    |    1 -
 drivers/input/mouse/amimouse.c                     |    1 -
 drivers/input/mouse/atarimouse.c                   |    1 -
 drivers/input/serio/hp_sdc.c                       |    1 -
 drivers/input/serio/maceps2.c                      |    1 -
 drivers/input/serio/rpckbd.c                       |    1 -
 drivers/input/serio/sa1111ps2.c                    |    1 -
 drivers/isdn/hardware/avm/avm_cs.c                 |    1 -
 drivers/isdn/hisax/avma1_cs.c                      |    1 -
 drivers/isdn/hisax/elsa_cs.c                       |    1 -
 drivers/isdn/hisax/sedlbauer_cs.c                  |    1 -
 drivers/isdn/hisax/teles_cs.c                      |    1 -
 drivers/isdn/i4l/isdn_bsdcomp.c                    |    1 -
 drivers/isdn/pcbit/layer2.c                        |    1 -
 drivers/macintosh/macio-adb.c                      |    1 -
 drivers/macintosh/therm_adt746x.c                  |    1 -
 drivers/macintosh/therm_pm72.c                     |    1 -
 drivers/macintosh/therm_windtunnel.c               |    1 -
 drivers/macintosh/via-cuda.c                       |    1 -
 drivers/macintosh/via-macii.c                      |    1 -
 drivers/macintosh/via-pmu.c                        |    1 -
 drivers/macintosh/via-pmu68k.c                     |    1 -
 drivers/macintosh/windfarm_lm75_sensor.c           |    1 -
 drivers/macintosh/windfarm_pm121.c                 |    1 -
 drivers/macintosh/windfarm_pm81.c                  |    1 -
 drivers/macintosh/windfarm_pm91.c                  |    1 -
 drivers/macintosh/windfarm_smu_controls.c          |    1 -
 drivers/macintosh/windfarm_smu_sensors.c           |    1 -
 drivers/media/dvb/dvb-core/dmxdev.c                |    1 -
 drivers/media/dvb/firewire/firedtv-fw.c            |    1 -
 drivers/media/dvb/ttpci/av7110.c                   |    1 -
 drivers/media/media-devnode.c                      |    1 -
 drivers/media/video/ivtv/ivtv-driver.h             |    1 -
 drivers/media/video/v4l2-common.c                  |    1 -
 drivers/media/video/v4l2-dev.c                     |    1 -
 drivers/message/i2o/i2o_scsi.c                     |    1 -
 drivers/mfd/mcp-core.c                             |    1 -
 drivers/mfd/mcp-sa11x0.c                           |    1 -
 drivers/misc/sgi-xp/xp.h                           |    1 -
 drivers/mmc/card/block.c                           |    1 -
 drivers/mtd/devices/pmc551.c                       |    1 -
 drivers/mtd/devices/slram.c                        |    1 -
 drivers/mtd/maps/pcmciamtd.c                       |    1 -
 drivers/mtd/nand/bcm_umi_nand.c                    |    1 -
 drivers/net/appletalk/cops.c                       |    1 -
 drivers/net/appletalk/ltpc.c                       |    1 -
 drivers/net/arcnet/com20020_cs.c                   |    1 -
 drivers/net/bonding/bond_main.c                    |    1 -
 drivers/net/can/slcan.c                            |    1 -
 drivers/net/cris/eth_v10.c                         |    1 -
 drivers/net/ethernet/3com/3c574_cs.c               |    1 -
 drivers/net/ethernet/3com/3c589_cs.c               |    1 -
 drivers/net/ethernet/8390/3c503.c                  |    1 -
 drivers/net/ethernet/8390/ac3200.c                 |    1 -
 drivers/net/ethernet/8390/apne.c                   |    1 -
 drivers/net/ethernet/8390/ax88796.c                |    1 -
 drivers/net/ethernet/8390/axnet_cs.c               |    1 -
 drivers/net/ethernet/8390/e2100.c                  |    1 -
 drivers/net/ethernet/8390/es3210.c                 |    1 -
 drivers/net/ethernet/8390/etherh.c                 |    1 -
 drivers/net/ethernet/8390/hp-plus.c                |    1 -
 drivers/net/ethernet/8390/hp.c                     |    1 -
 drivers/net/ethernet/8390/lib8390.c                |    1 -
 drivers/net/ethernet/8390/lne390.c                 |    1 -
 drivers/net/ethernet/8390/mac8390.c                |    1 -
 drivers/net/ethernet/8390/ne-h8300.c               |    1 -
 drivers/net/ethernet/8390/ne.c                     |    1 -
 drivers/net/ethernet/8390/ne2.c                    |    1 -
 drivers/net/ethernet/8390/ne2k-pci.c               |    1 -
 drivers/net/ethernet/8390/ne3210.c                 |    1 -
 drivers/net/ethernet/8390/pcnet_cs.c               |    1 -
 drivers/net/ethernet/8390/smc-mca.c                |    1 -
 drivers/net/ethernet/8390/smc-ultra.c              |    1 -
 drivers/net/ethernet/8390/smc-ultra32.c            |    1 -
 drivers/net/ethernet/8390/stnic.c                  |    1 -
 drivers/net/ethernet/8390/wd.c                     |    1 -
 drivers/net/ethernet/8390/zorro8390.c              |    1 -
 drivers/net/ethernet/alteon/acenic.c               |    1 -
 drivers/net/ethernet/amd/7990.c                    |    1 -
 drivers/net/ethernet/amd/am79c961a.c               |    1 -
 drivers/net/ethernet/amd/amd8111e.c                |    1 -
 drivers/net/ethernet/amd/declance.c                |    1 -
 drivers/net/ethernet/amd/hplance.c                 |    1 -
 drivers/net/ethernet/amd/mvme147.c                 |    1 -
 drivers/net/ethernet/amd/nmclan_cs.c               |    1 -
 drivers/net/ethernet/amd/sunlance.c                |    1 -
 drivers/net/ethernet/broadcom/tg3.c                |    1 -
 drivers/net/ethernet/cirrus/cs89x0.c               |    1 -
 drivers/net/ethernet/cirrus/mac89x0.c              |    1 -
 drivers/net/ethernet/dlink/de600.c                 |    1 -
 drivers/net/ethernet/dlink/de620.c                 |    1 -
 drivers/net/ethernet/fujitsu/at1700.c              |    1 -
 drivers/net/ethernet/fujitsu/eth16i.c              |    1 -
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |    1 -
 drivers/net/ethernet/i825xx/3c507.c                |    1 -
 drivers/net/ethernet/i825xx/3c527.c                |    1 -
 drivers/net/ethernet/i825xx/eepro.c                |    1 -
 drivers/net/ethernet/i825xx/eexpress.c             |    1 -
 drivers/net/ethernet/i825xx/ether1.c               |    1 -
 drivers/net/ethernet/i825xx/znet.c                 |    1 -
 drivers/net/ethernet/korina.c                      |    1 -
 drivers/net/ethernet/marvell/mv643xx_eth.c         |    1 -
 drivers/net/ethernet/marvell/pxa168_eth.c          |    1 -
 drivers/net/ethernet/natsemi/jazzsonic.c           |    1 -
 drivers/net/ethernet/natsemi/macsonic.c            |    1 -
 drivers/net/ethernet/natsemi/ns83820.c             |    1 -
 drivers/net/ethernet/neterion/s2io.c               |    1 -
 drivers/net/ethernet/nvidia/forcedeth.c            |    1 -
 drivers/net/ethernet/realtek/atp.c                 |    1 -
 drivers/net/ethernet/realtek/r8169.c               |    1 -
 drivers/net/ethernet/seeq/ether3.c                 |    1 -
 drivers/net/ethernet/seeq/seeq8005.c               |    1 -
 drivers/net/ethernet/smsc/smc91c92_cs.c            |    1 -
 drivers/net/ethernet/sun/cassini.c                 |    1 -
 drivers/net/ethernet/sun/sunbmac.c                 |    1 -
 drivers/net/ethernet/sun/sungem.c                  |    1 -
 drivers/net/ethernet/sun/sunhme.c                  |    1 -
 drivers/net/ethernet/sun/sunqe.c                   |    1 -
 drivers/net/ethernet/tundra/tsi108_eth.c           |    1 -
 drivers/net/ethernet/xircom/xirc2ps_cs.c           |    1 -
 drivers/net/hamradio/6pack.c                       |    1 -
 drivers/net/hamradio/baycom_par.c                  |    1 -
 drivers/net/hamradio/bpqether.c                    |    1 -
 drivers/net/hamradio/mkiss.c                       |    1 -
 drivers/net/hamradio/scc.c                         |    1 -
 drivers/net/hamradio/yam.c                         |    1 -
 drivers/net/hippi/rrunner.c                        |    1 -
 drivers/net/irda/donauboe.c                        |    1 -
 drivers/net/loopback.c                             |    1 -
 drivers/net/plip/plip.c                            |    1 -
 drivers/net/slip/slhc.c                            |    1 -
 drivers/net/slip/slip.c                            |    1 -
 drivers/net/tokenring/3c359.c                      |    1 -
 drivers/net/tokenring/abyss.c                      |    1 -
 drivers/net/tokenring/ibmtr_cs.c                   |    1 -
 drivers/net/tokenring/lanstreamer.c                |    1 -
 drivers/net/tokenring/madgemc.c                    |    1 -
 drivers/net/tokenring/olympic.c                    |    1 -
 drivers/net/tokenring/proteon.c                    |    1 -
 drivers/net/tokenring/skisa.c                      |    1 -
 drivers/net/tokenring/smctr.c                      |    1 -
 drivers/net/tokenring/tms380tr.c                   |    1 -
 drivers/net/tokenring/tmspci.c                     |    1 -
 drivers/net/tun.c                                  |    1 -
 drivers/net/wan/dlci.c                             |    1 -
 drivers/net/wan/dscc4.c                            |    1 -
 drivers/net/wan/hd64570.c                          |    1 -
 drivers/net/wan/hd64572.c                          |    1 -
 drivers/net/wan/lapbether.c                        |    1 -
 drivers/net/wan/sdla.c                             |    1 -
 drivers/net/wan/x25_asy.c                          |    1 -
 drivers/net/wireless/airo.c                        |    1 -
 drivers/net/wireless/airo_cs.c                     |    1 -
 drivers/net/wireless/atmel.c                       |    1 -
 drivers/net/wireless/atmel_cs.c                    |    1 -
 drivers/net/wireless/prism54/islpci_mgt.c          |    1 -
 drivers/net/wireless/ray_cs.c                      |    1 -
 drivers/net/wireless/wl3501_cs.c                   |    1 -
 drivers/nubus/nubus.c                              |    1 -
 drivers/parisc/dino.c                              |    1 -
 drivers/parisc/iosapic.c                           |    1 -
 drivers/parisc/lba_pci.c                           |    1 -
 drivers/pcmcia/cs.c                                |    1 -
 drivers/pcmcia/i82092.c                            |    1 -
 drivers/pcmcia/i82365.c                            |    1 -
 drivers/pcmcia/m32r_cfc.c                          |    1 -
 drivers/pcmcia/m32r_pcc.c                          |    1 -
 drivers/pcmcia/m8xx_pcmcia.c                       |    1 -
 drivers/pcmcia/pd6729.c                            |    1 -
 drivers/pcmcia/pxa2xx_base.c                       |    1 -
 drivers/pcmcia/sa11xx_base.c                       |    1 -
 drivers/pcmcia/soc_common.c                        |    1 -
 drivers/pcmcia/socket_sysfs.c                      |    1 -
 drivers/pcmcia/tcic.c                              |    1 -
 drivers/pcmcia/xxs1500_ss.c                        |    1 -
 drivers/pnp/pnpbios/bioscalls.c                    |    1 -
 drivers/pnp/pnpbios/core.c                         |    1 -
 drivers/s390/crypto/ap_bus.c                       |    1 -
 drivers/sbus/char/flash.c                          |    1 -
 drivers/sbus/char/openprom.c                       |    1 -
 drivers/sbus/char/uctrl.c                          |    1 -
 drivers/scsi/53c700.c                              |    1 -
 drivers/scsi/BusLogic.c                            |    1 -
 drivers/scsi/advansys.c                            |    1 -
 drivers/scsi/aha152x.c                             |    1 -
 drivers/scsi/aha1542.c                             |    1 -
 drivers/scsi/aha1740.c                             |    1 -
 drivers/scsi/arcmsr/arcmsr_hba.c                   |    1 -
 drivers/scsi/arm/acornscsi.c                       |    1 -
 drivers/scsi/arm/cumana_1.c                        |    1 -
 drivers/scsi/arm/oak.c                             |    1 -
 drivers/scsi/atp870u.c                             |    1 -
 drivers/scsi/dtc.c                                 |    1 -
 drivers/scsi/fd_mcs.c                              |    1 -
 drivers/scsi/fdomain.c                             |    1 -
 drivers/scsi/g_NCR5380.c                           |    1 -
 drivers/scsi/gdth.c                                |    1 -
 drivers/scsi/ibmmca.c                              |    1 -
 drivers/scsi/in2000.c                              |    1 -
 drivers/scsi/mac53c94.c                            |    1 -
 drivers/scsi/mac_scsi.c                            |    1 -
 drivers/scsi/mesh.c                                |    1 -
 drivers/scsi/ncr53c8xx.c                           |    1 -
 drivers/scsi/nsp32.c                               |    1 -
 drivers/scsi/osst.c                                |    1 -
 drivers/scsi/pas16.c                               |    1 -
 drivers/scsi/qla1280.c                             |    1 -
 drivers/scsi/qlogicpti.c                           |    1 -
 drivers/scsi/st.c                                  |    1 -
 drivers/scsi/sun3_scsi.c                           |    1 -
 drivers/scsi/sun3_scsi_vme.c                       |    1 -
 drivers/scsi/sym53c416.c                           |    1 -
 drivers/scsi/t128.c                                |    1 -
 drivers/scsi/u14-34f.c                             |    1 -
 drivers/scsi/ultrastor.c                           |    1 -
 drivers/scsi/wd7000.c                              |    1 -
 drivers/spi/spi-omap-uwire.c                       |    1 -
 drivers/staging/comedi/drivers.c                   |    1 -
 drivers/staging/comedi/drivers/cb_pcidas64.c       |    1 -
 drivers/staging/comedi/drivers/mite.c              |    1 -
 drivers/staging/crystalhd/crystalhd_lnx.h          |    1 -
 drivers/staging/crystalhd/crystalhd_misc.h         |    1 -
 drivers/staging/et131x/et131x.c                    |    1 -
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |    1 -
 drivers/staging/media/go7007/go7007-driver.c       |    1 -
 drivers/staging/media/go7007/go7007-i2c.c          |    1 -
 drivers/staging/media/go7007/go7007-v4l2.c         |    1 -
 drivers/staging/media/go7007/snd-go7007.c          |    1 -
 drivers/staging/media/lirc/lirc_serial.c           |    1 -
 drivers/staging/media/lirc/lirc_sir.c              |    1 -
 drivers/staging/panel/panel.c                      |    1 -
 drivers/staging/sbe-2t3e3/io.c                     |    1 -
 .../tidspbridge/include/dspbridge/host_os.h        |    1 -
 drivers/staging/wlags49_h2/wl_cs.c                 |    1 -
 drivers/staging/wlags49_h2/wl_main.c               |    3 +--
 drivers/staging/wlags49_h2/wl_netdev.c             |    3 +--
 drivers/staging/wlags49_h2/wl_pci.c                |    1 -
 drivers/staging/wlags49_h2/wl_util.c               |    3 +--
 drivers/telephony/phonedev.c                       |    1 -
 drivers/tty/amiserial.c                            |    1 -
 drivers/tty/isicom.c                               |    1 -
 drivers/tty/moxa.c                                 |    1 -
 drivers/tty/mxser.c                                |    1 -
 drivers/tty/n_hdlc.c                               |    1 -
 drivers/tty/n_tty.c                                |    1 -
 drivers/tty/pty.c                                  |    1 -
 drivers/tty/serial/68328serial.c                   |    1 -
 drivers/tty/serial/8250/serial_cs.c                |    1 -
 drivers/tty/serial/crisv10.c                       |    1 -
 drivers/tty/serial/dz.c                            |    1 -
 drivers/tty/serial/icom.c                          |    1 -
 drivers/tty/serial/msm_serial_hs.c                 |    1 -
 drivers/tty/serial/zs.c                            |    1 -
 drivers/tty/synclink.c                             |    1 -
 drivers/tty/synclink_gt.c                          |    1 -
 drivers/tty/synclinkmp.c                           |    1 -
 drivers/tty/tty_io.c                               |    1 -
 drivers/tty/tty_ioctl.c                            |    1 -
 drivers/tty/vt/vt.c                                |    1 -
 drivers/usb/gadget/amd5536udc.c                    |    1 -
 drivers/usb/gadget/at91_udc.c                      |    1 -
 drivers/usb/gadget/dummy_hcd.c                     |    1 -
 drivers/usb/gadget/fsl_udc_core.c                  |    1 -
 drivers/usb/gadget/goku_udc.c                      |    1 -
 drivers/usb/gadget/langwell_udc.c                  |    1 -
 drivers/usb/gadget/mv_udc_core.c                   |    1 -
 drivers/usb/gadget/net2272.c                       |    1 -
 drivers/usb/gadget/net2280.c                       |    1 -
 drivers/usb/gadget/omap_udc.c                      |    1 -
 drivers/usb/gadget/printer.c                       |    1 -
 drivers/usb/gadget/pxa25x_udc.c                    |    1 -
 drivers/usb/gadget/rndis.c                         |    1 -
 drivers/usb/gadget/s3c2410_udc.c                   |    1 -
 drivers/usb/host/ehci-hcd.c                        |    1 -
 drivers/usb/host/isp116x-hcd.c                     |    1 -
 drivers/usb/host/isp1362-hcd.c                     |    1 -
 drivers/usb/host/ohci-hcd.c                        |    1 -
 drivers/usb/host/oxu210hp-hcd.c                    |    1 -
 drivers/usb/host/sl811-hcd.c                       |    1 -
 drivers/usb/host/u132-hcd.c                        |    1 -
 drivers/usb/host/uhci-hcd.c                        |    1 -
 drivers/video/amifb.c                              |    1 -
 drivers/video/bt431.h                              |    1 -
 drivers/video/bt455.h                              |    1 -
 drivers/video/console/fbcon.c                      |    1 -
 drivers/video/console/newport_con.c                |    1 -
 drivers/video/cyber2000fb.c                        |    1 -
 drivers/video/dnfb.c                               |    1 -
 drivers/video/neofb.c                              |    1 -
 drivers/video/pmag-ba-fb.c                         |    1 -
 drivers/video/pmagb-b-fb.c                         |    1 -
 drivers/video/q40fb.c                              |    1 -
 drivers/video/savage/savagefb_driver.c             |    1 -
 drivers/virtio/config.c                            |    1 -
 drivers/watchdog/advantechwdt.c                    |    1 -
 drivers/watchdog/alim7101_wdt.c                    |    1 -
 drivers/watchdog/booke_wdt.c                       |    1 -
 drivers/watchdog/eurotechwdt.c                     |    1 -
 drivers/watchdog/ib700wdt.c                        |    1 -
 drivers/watchdog/it87_wdt.c                        |    1 -
 drivers/watchdog/machzwd.c                         |    1 -
 drivers/watchdog/pc87413_wdt.c                     |    1 -
 drivers/watchdog/sbc60xxwdt.c                      |    1 -
 drivers/watchdog/sbc7240_wdt.c                     |    1 -
 drivers/watchdog/sbc8360.c                         |    1 -
 drivers/watchdog/sbc_fitpc2_wdt.c                  |    1 -
 drivers/watchdog/sc520_wdt.c                       |    1 -
 drivers/watchdog/smsc37b787_wdt.c                  |    1 -
 drivers/watchdog/w83627hf_wdt.c                    |    1 -
 drivers/watchdog/w83697hf_wdt.c                    |    1 -
 drivers/watchdog/w83697ug_wdt.c                    |    1 -
 drivers/watchdog/w83877f_wdt.c                     |    1 -
 drivers/watchdog/w83977f_wdt.c                     |    1 -
 drivers/watchdog/wdt.c                             |    1 -
 drivers/watchdog/wdt977.c                          |    1 -
 drivers/watchdog/wdt_pci.c                         |    1 -
 fs/binfmt_aout.c                                   |    1 -
 fs/binfmt_flat.c                                   |    1 -
 fs/coda/inode.c                                    |    1 -
 fs/coda/psdev.c                                    |    1 -
 fs/coda/upcall.c                                   |    1 -
 fs/eventpoll.c                                     |    1 -
 fs/jbd2/commit.c                                   |    1 -
 fs/jbd2/journal.c                                  |    1 -
 fs/ncpfs/file.c                                    |    1 -
 fs/ncpfs/inode.c                                   |    1 -
 fs/ncpfs/mmap.c                                    |    1 -
 fs/nfs/client.c                                    |    1 -
 fs/nfs/direct.c                                    |    1 -
 fs/nfs/file.c                                      |    1 -
 fs/nfs/getroot.c                                   |    1 -
 fs/nfs/inode.c                                     |    1 -
 fs/nfs/read.c                                      |    1 -
 fs/nfs/super.c                                     |    1 -
 fs/proc/inode.c                                    |    1 -
 fs/reiserfs/journal.c                              |    1 -
 fs/ufs/inode.c                                     |    1 -
 fs/ufs/super.c                                     |    1 -
 fs/xfs/xfs_buf.h                                   |    1 -
 include/acpi/platform/aclinux.h                    |    1 -
 include/asm-generic/atomic.h                       |    1 -
 include/asm-generic/bitops/atomic.h                |    1 -
 include/linux/cnt32_to_63.h                        |    1 -
 include/linux/debug_locks.h                        |    1 -
 include/linux/efi.h                                |    1 -
 include/linux/ide.h                                |    1 -
 include/linux/interrupt.h                          |    1 -
 include/linux/llist.h                              |    1 -
 include/linux/lsm_audit.h                          |    1 -
 include/linux/mtd/map.h                            |    1 -
 include/linux/parport.h                            |    1 -
 include/linux/rwsem.h                              |    1 -
 include/linux/sched.h                              |    1 -
 include/linux/skbuff.h                             |    1 -
 include/linux/spinlock.h                           |    1 -
 include/linux/stop_machine.h                       |    1 -
 include/linux/tty.h                                |    1 -
 include/linux/wait.h                               |    1 -
 kernel/debug/debug_core.c                          |    1 -
 kernel/debug/kdb/kdb_bt.c                          |    1 -
 kernel/dma.c                                       |    1 -
 kernel/kexec.c                                     |    1 -
 kernel/rwsem.c                                     |    1 -
 kernel/sysctl.c                                    |    1 -
 lib/llist.c                                        |    1 -
 lib/raid6/altivec.uc                               |    1 -
 net/802/fc.c                                       |    1 -
 net/802/fddi.c                                     |    1 -
 net/802/hippi.c                                    |    1 -
 net/802/tr.c                                       |    1 -
 net/ax25/af_ax25.c                                 |    1 -
 net/ax25/ax25_addr.c                               |    1 -
 net/ax25/ax25_dev.c                                |    1 -
 net/ax25/ax25_ds_in.c                              |    1 -
 net/ax25/ax25_ds_subr.c                            |    1 -
 net/ax25/ax25_ds_timer.c                           |    1 -
 net/ax25/ax25_iface.c                              |    1 -
 net/ax25/ax25_in.c                                 |    1 -
 net/ax25/ax25_ip.c                                 |    1 -
 net/ax25/ax25_out.c                                |    1 -
 net/ax25/ax25_route.c                              |    1 -
 net/ax25/ax25_std_in.c                             |    1 -
 net/ax25/ax25_std_subr.c                           |    1 -
 net/ax25/ax25_std_timer.c                          |    1 -
 net/ax25/ax25_subr.c                               |    1 -
 net/ax25/ax25_timer.c                              |    1 -
 net/ax25/ax25_uid.c                                |    1 -
 net/bluetooth/bnep/sock.c                          |    1 -
 net/bluetooth/cmtp/sock.c                          |    1 -
 net/bluetooth/hci_conn.c                           |    1 -
 net/bluetooth/hci_core.c                           |    1 -
 net/bluetooth/hci_event.c                          |    1 -
 net/bluetooth/hci_sock.c                           |    1 -
 net/bluetooth/l2cap_core.c                         |    1 -
 net/bluetooth/rfcomm/sock.c                        |    1 -
 net/bluetooth/sco.c                                |    1 -
 net/core/datagram.c                                |    1 -
 net/core/dev.c                                     |    1 -
 net/core/filter.c                                  |    1 -
 net/core/gen_estimator.c                           |    1 -
 net/core/rtnetlink.c                               |    1 -
 net/core/scm.c                                     |    1 -
 net/core/skbuff.c                                  |    1 -
 net/core/sock.c                                    |    1 -
 net/core/utils.c                                   |    1 -
 net/decnet/af_decnet.c                             |    1 -
 net/decnet/dn_dev.c                                |    1 -
 net/decnet/dn_nsp_in.c                             |    1 -
 net/decnet/dn_nsp_out.c                            |    1 -
 net/econet/af_econet.c                             |    1 -
 net/ethernet/eth.c                                 |    1 -
 net/ipv4/af_inet.c                                 |    1 -
 net/ipv4/arp.c                                     |    1 -
 net/ipv4/devinet.c                                 |    1 -
 net/ipv4/fib_frontend.c                            |    1 -
 net/ipv4/fib_semantics.c                           |    1 -
 net/ipv4/fib_trie.c                                |    1 -
 net/ipv4/icmp.c                                    |    1 -
 net/ipv4/igmp.c                                    |    1 -
 net/ipv4/ip_input.c                                |    1 -
 net/ipv4/ip_output.c                               |    1 -
 net/ipv4/ipmr.c                                    |    1 -
 net/ipv4/ping.c                                    |    1 -
 net/ipv4/route.c                                   |    1 -
 net/ipv4/udp.c                                     |    1 -
 net/ipv6/af_inet6.c                                |    1 -
 net/ipv6/icmp.c                                    |    1 -
 net/ipv6/ip6mr.c                                   |    1 -
 net/irda/irlan/irlan_client.c                      |    1 -
 net/irda/irlan/irlan_common.c                      |    1 -
 net/irda/irlan/irlan_provider.c                    |    1 -
 net/irda/timer.c                                   |    1 -
 net/lapb/lapb_iface.c                              |    1 -
 net/lapb/lapb_in.c                                 |    1 -
 net/lapb/lapb_out.c                                |    1 -
 net/lapb/lapb_subr.c                               |    1 -
 net/lapb/lapb_timer.c                              |    1 -
 net/netfilter/ipvs/ip_vs_app.c                     |    1 -
 net/netfilter/ipvs/ip_vs_proto.c                   |    1 -
 net/netfilter/nfnetlink.c                          |    1 -
 net/netrom/af_netrom.c                             |    1 -
 net/netrom/nr_dev.c                                |    1 -
 net/netrom/nr_in.c                                 |    1 -
 net/netrom/nr_out.c                                |    1 -
 net/netrom/nr_route.c                              |    1 -
 net/netrom/nr_subr.c                               |    1 -
 net/netrom/nr_timer.c                              |    1 -
 net/openvswitch/datapath.c                         |    1 -
 net/packet/af_packet.c                             |    1 -
 net/rose/af_rose.c                                 |    1 -
 net/rose/rose_dev.c                                |    1 -
 net/rose/rose_in.c                                 |    1 -
 net/rose/rose_link.c                               |    1 -
 net/rose/rose_out.c                                |    1 -
 net/rose/rose_route.c                              |    1 -
 net/rose/rose_subr.c                               |    1 -
 net/rose/rose_timer.c                              |    1 -
 net/sunrpc/clnt.c                                  |    1 -
 security/selinux/include/avc.h                     |    1 -
 sound/oss/os.h                                     |    1 -
 sound/oss/vidc.c                                   |    1 -
 sound/oss/waveartist.c                             |    1 -
 sound/pci/asihpi/hpios.h                           |    1 -
 sound/pci/aw2/aw2-saa7146.c                        |    1 -
 1206 files changed, 3 insertions(+), 1210 deletions(-)

diff --git a/arch/alpha/boot/bootp.c b/arch/alpha/boot/bootp.c
index be61670..2a542a5 100644
--- a/arch/alpha/boot/bootp.c
+++ b/arch/alpha/boot/bootp.c
@@ -13,7 +13,6 @@
 #include <generated/utsrelease.h>
 #include <linux/mm.h>
 
-#include <asm/system.h>
 #include <asm/console.h>
 #include <asm/hwrpb.h>
 #include <asm/pgtable.h>
diff --git a/arch/alpha/boot/bootpz.c b/arch/alpha/boot/bootpz.c
index c98865f..d6ad191 100644
--- a/arch/alpha/boot/bootpz.c
+++ b/arch/alpha/boot/bootpz.c
@@ -15,7 +15,6 @@
 #include <generated/utsrelease.h>
 #include <linux/mm.h>
 
-#include <asm/system.h>
 #include <asm/console.h>
 #include <asm/hwrpb.h>
 #include <asm/pgtable.h>
diff --git a/arch/alpha/boot/head.S b/arch/alpha/boot/head.S
index f3d9808..b06812b 100644
--- a/arch/alpha/boot/head.S
+++ b/arch/alpha/boot/head.S
@@ -4,7 +4,6 @@
  * initial bootloader stuff..
  */
 
-#include <asm/system.h>
 
 	.set noreorder
 	.globl	__start
diff --git a/arch/alpha/boot/main.c b/arch/alpha/boot/main.c
index ded57d9..3baf2d1 100644
--- a/arch/alpha/boot/main.c
+++ b/arch/alpha/boot/main.c
@@ -11,7 +11,6 @@
 #include <generated/utsrelease.h>
 #include <linux/mm.h>
 
-#include <asm/system.h>
 #include <asm/console.h>
 #include <asm/hwrpb.h>
 #include <asm/pgtable.h>
diff --git a/arch/alpha/include/asm/atomic.h b/arch/alpha/include/asm/atomic.h
index 640f909..bd4eabd 100644
--- a/arch/alpha/include/asm/atomic.h
+++ b/arch/alpha/include/asm/atomic.h
@@ -3,7 +3,6 @@
 
 #include <linux/types.h>
 #include <asm/barrier.h>
-#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff --git a/arch/alpha/include/asm/core_lca.h b/arch/alpha/include/asm/core_lca.h
index f7cb4b4..69d60fe 100644
--- a/arch/alpha/include/asm/core_lca.h
+++ b/arch/alpha/include/asm/core_lca.h
@@ -1,7 +1,6 @@
 #ifndef __ALPHA_LCA__H__
 #define __ALPHA_LCA__H__
 
-#include <asm/system.h>
 #include <asm/compiler.h>
 
 /*
diff --git a/arch/alpha/include/asm/core_t2.h b/arch/alpha/include/asm/core_t2.h
index 91b4680..ade9d92 100644
--- a/arch/alpha/include/asm/core_t2.h
+++ b/arch/alpha/include/asm/core_t2.h
@@ -7,7 +7,6 @@
 #include <linux/types.h>
 #include <linux/spinlock.h>
 #include <asm/compiler.h>
-#include <asm/system.h>
 
 /*
  * T2 is the internal name for the core logic chipset which provides
diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index 56ff965..7a3d38d 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -6,7 +6,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <asm/compiler.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/machvec.h>
 #include <asm/hwrpb.h>
diff --git a/arch/alpha/include/asm/irqflags.h b/arch/alpha/include/asm/irqflags.h
index 299bbc7..afb3be3 100644
--- a/arch/alpha/include/asm/irqflags.h
+++ b/arch/alpha/include/asm/irqflags.h
@@ -1,7 +1,6 @@
 #ifndef __ALPHA_IRQFLAGS_H
 #define __ALPHA_IRQFLAGS_H
 
-#include <asm/system.h>
 
 #define IPL_MIN		0
 #define IPL_SW0		1
diff --git a/arch/alpha/include/asm/mmu_context.h b/arch/alpha/include/asm/mmu_context.h
index 86c08a0..4c51c05 100644
--- a/arch/alpha/include/asm/mmu_context.h
+++ b/arch/alpha/include/asm/mmu_context.h
@@ -7,7 +7,6 @@
  * Copyright (C) 1996, Linus Torvalds
  */
 
-#include <asm/system.h>
 #include <asm/machvec.h>
 #include <asm/compiler.h>
 #include <asm-generic/mm_hooks.h>
diff --git a/arch/alpha/include/asm/spinlock.h b/arch/alpha/include/asm/spinlock.h
index d0faca1..3bba21e 100644
--- a/arch/alpha/include/asm/spinlock.h
+++ b/arch/alpha/include/asm/spinlock.h
@@ -1,7 +1,6 @@
 #ifndef _ALPHA_SPINLOCK_H
 #define _ALPHA_SPINLOCK_H
 
-#include <asm/system.h>
 #include <linux/kernel.h>
 #include <asm/current.h>
 
diff --git a/arch/alpha/kernel/head.S b/arch/alpha/kernel/head.S
index 4bdd1d2..3f6dcba 100644
--- a/arch/alpha/kernel/head.S
+++ b/arch/alpha/kernel/head.S
@@ -8,7 +8,6 @@
  */
 
 #include <linux/init.h>
-#include <asm/system.h>
 #include <asm/asm-offsets.h>
 
 __HEAD
diff --git a/arch/alpha/kernel/irq.c b/arch/alpha/kernel/irq.c
index 381431a..2872acc 100644
--- a/arch/alpha/kernel/irq.c
+++ b/arch/alpha/kernel/irq.c
@@ -26,7 +26,6 @@
 #include <linux/profile.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index 01e8715..49ee319 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -40,7 +40,6 @@
 #include <asm/fpu.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/sysinfo.h>
 #include <asm/thread_info.h>
 #include <asm/hwrpb.h>
diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 89bbe5b..153d3fc 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -31,7 +31,6 @@
 
 #include <asm/reg.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/hwrpb.h>
diff --git a/arch/alpha/kernel/ptrace.c b/arch/alpha/kernel/ptrace.c
index e2af5eb..54616f4 100644
--- a/arch/alpha/kernel/ptrace.c
+++ b/arch/alpha/kernel/ptrace.c
@@ -16,7 +16,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/fpu.h>
 
 #include "proto.h"
diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
index 32de560..9e3107cc5 100644
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -55,7 +55,6 @@ static struct notifier_block alpha_panic_block = {
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/hwrpb.h>
 #include <asm/dma.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_alcor.c b/arch/alpha/kernel/sys_alcor.c
index 8606d77..118dc6a 100644
--- a/arch/alpha/kernel/sys_alcor.c
+++ b/arch/alpha/kernel/sys_alcor.c
@@ -18,7 +18,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_cabriolet.c b/arch/alpha/kernel/sys_cabriolet.c
index 1029619..4c50f8f 100644
--- a/arch/alpha/kernel/sys_cabriolet.c
+++ b/arch/alpha/kernel/sys_cabriolet.c
@@ -18,7 +18,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index bb7f0c7..1447d21 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -21,7 +21,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_eb64p.c b/arch/alpha/kernel/sys_eb64p.c
index 3c6c13c..ad40a42 100644
--- a/arch/alpha/kernel/sys_eb64p.c
+++ b/arch/alpha/kernel/sys_eb64p.c
@@ -17,7 +17,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_eiger.c b/arch/alpha/kernel/sys_eiger.c
index 35f480d..79d69d7 100644
--- a/arch/alpha/kernel/sys_eiger.c
+++ b/arch/alpha/kernel/sys_eiger.c
@@ -18,7 +18,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_jensen.c b/arch/alpha/kernel/sys_jensen.c
index 7f1a87f1..5a0af11 100644
--- a/arch/alpha/kernel/sys_jensen.c
+++ b/arch/alpha/kernel/sys_jensen.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 
 #define __EXTERN_INLINE inline
 #include <asm/io.h>
diff --git a/arch/alpha/kernel/sys_marvel.c b/arch/alpha/kernel/sys_marvel.c
index 95cfc83..e8b4f6f 100644
--- a/arch/alpha/kernel/sys_marvel.c
+++ b/arch/alpha/kernel/sys_marvel.c
@@ -13,7 +13,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_miata.c b/arch/alpha/kernel/sys_miata.c
index 258da68..d5b9776 100644
--- a/arch/alpha/kernel/sys_miata.c
+++ b/arch/alpha/kernel/sys_miata.c
@@ -17,7 +17,6 @@
 #include <linux/reboot.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_mikasa.c b/arch/alpha/kernel/sys_mikasa.c
index c0fd728..21c8ce4 100644
--- a/arch/alpha/kernel/sys_mikasa.c
+++ b/arch/alpha/kernel/sys_mikasa.c
@@ -17,7 +17,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_nautilus.c b/arch/alpha/kernel/sys_nautilus.c
index 4112200..4d4c046 100644
--- a/arch/alpha/kernel/sys_nautilus.c
+++ b/arch/alpha/kernel/sys_nautilus.c
@@ -35,7 +35,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_noritake.c b/arch/alpha/kernel/sys_noritake.c
index 2172528..c5404a5 100644
--- a/arch/alpha/kernel/sys_noritake.c
+++ b/arch/alpha/kernel/sys_noritake.c
@@ -18,7 +18,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_rawhide.c b/arch/alpha/kernel/sys_rawhide.c
index a125d6b..dfd510a 100644
--- a/arch/alpha/kernel/sys_rawhide.c
+++ b/arch/alpha/kernel/sys_rawhide.c
@@ -16,7 +16,6 @@
 #include <linux/init.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_ruffian.c b/arch/alpha/kernel/sys_ruffian.c
index 2581cbe..a3f4852 100644
--- a/arch/alpha/kernel/sys_ruffian.c
+++ b/arch/alpha/kernel/sys_ruffian.c
@@ -18,7 +18,6 @@
 #include <linux/init.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_rx164.c b/arch/alpha/kernel/sys_rx164.c
index b172b27..08ee737 100644
--- a/arch/alpha/kernel/sys_rx164.c
+++ b/arch/alpha/kernel/sys_rx164.c
@@ -17,7 +17,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_sable.c b/arch/alpha/kernel/sys_sable.c
index 98d1dbf..8a0aa6d 100644
--- a/arch/alpha/kernel/sys_sable.c
+++ b/arch/alpha/kernel/sys_sable.c
@@ -16,7 +16,6 @@
 #include <linux/init.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_sio.c b/arch/alpha/kernel/sys_sio.c
index 47bec1e..febd24e 100644
--- a/arch/alpha/kernel/sys_sio.c
+++ b/arch/alpha/kernel/sys_sio.c
@@ -20,7 +20,6 @@
 
 #include <asm/compiler.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_sx164.c b/arch/alpha/kernel/sys_sx164.c
index 73e1c31..2b78a15 100644
--- a/arch/alpha/kernel/sys_sx164.c
+++ b/arch/alpha/kernel/sys_sx164.c
@@ -17,7 +17,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_takara.c b/arch/alpha/kernel/sys_takara.c
index 2ae99ad..dd0f1ea 100644
--- a/arch/alpha/kernel/sys_takara.c
+++ b/arch/alpha/kernel/sys_takara.c
@@ -16,7 +16,6 @@
 #include <linux/init.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index f47b30a..9de928c 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -21,7 +21,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/kernel/sys_wildfire.c b/arch/alpha/kernel/sys_wildfire.c
index 17c85a6..ee18748 100644
--- a/arch/alpha/kernel/sys_wildfire.c
+++ b/arch/alpha/kernel/sys_wildfire.c
@@ -15,7 +15,6 @@
 #include <linux/bitops.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/alpha/lib/stacktrace.c b/arch/alpha/lib/stacktrace.c
index 6d432e4..5e83216 100644
--- a/arch/alpha/lib/stacktrace.c
+++ b/arch/alpha/lib/stacktrace.c
@@ -1,5 +1,4 @@
 #include <linux/kernel.h>
-#include <asm/system.h>
 
 typedef unsigned int instr;
 
diff --git a/arch/alpha/mm/fault.c b/arch/alpha/mm/fault.c
index fadd5f8..5eecab1 100644
--- a/arch/alpha/mm/fault.c
+++ b/arch/alpha/mm/fault.c
@@ -24,7 +24,6 @@
 #include <linux/interrupt.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 extern void die_if_kernel(char *,struct pt_regs *,long, unsigned long *);
diff --git a/arch/alpha/mm/init.c b/arch/alpha/mm/init.c
index 69d0c57..69a6c21 100644
--- a/arch/alpha/mm/init.c
+++ b/arch/alpha/mm/init.c
@@ -22,7 +22,6 @@
 #include <linux/vmalloc.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/arch/alpha/oprofile/common.c b/arch/alpha/oprofile/common.c
index bd8ac53..a0a5d27 100644
--- a/arch/alpha/oprofile/common.c
+++ b/arch/alpha/oprofile/common.c
@@ -12,7 +12,6 @@
 #include <linux/smp.h>
 #include <linux/errno.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 
 #include "op_impl.h"
 
diff --git a/arch/alpha/oprofile/op_model_ev4.c b/arch/alpha/oprofile/op_model_ev4.c
index 80d764d..18aa9b4 100644
--- a/arch/alpha/oprofile/op_model_ev4.c
+++ b/arch/alpha/oprofile/op_model_ev4.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 
 #include "op_impl.h"
 
diff --git a/arch/alpha/oprofile/op_model_ev5.c b/arch/alpha/oprofile/op_model_ev5.c
index ceea6e1..c32f8a0 100644
--- a/arch/alpha/oprofile/op_model_ev5.c
+++ b/arch/alpha/oprofile/op_model_ev5.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 
 #include "op_impl.h"
 
diff --git a/arch/alpha/oprofile/op_model_ev6.c b/arch/alpha/oprofile/op_model_ev6.c
index 0869f85..1c84cc2 100644
--- a/arch/alpha/oprofile/op_model_ev6.c
+++ b/arch/alpha/oprofile/op_model_ev6.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 
 #include "op_impl.h"
 
diff --git a/arch/alpha/oprofile/op_model_ev67.c b/arch/alpha/oprofile/op_model_ev67.c
index 5b9d178..34a57a1 100644
--- a/arch/alpha/oprofile/op_model_ev67.c
+++ b/arch/alpha/oprofile/op_model_ev67.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 
 #include "op_impl.h"
 
diff --git a/arch/arm/common/via82c505.c b/arch/arm/common/via82c505.c
index 67dd2af..1171a50 100644
--- a/arch/arm/common/via82c505.c
+++ b/arch/arm/common/via82c505.c
@@ -6,7 +6,6 @@
 #include <linux/ioport.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 
 #include <asm/mach/pci.h>
 
diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
index 86976d0..cadb012 100644
--- a/arch/arm/include/asm/atomic.h
+++ b/arch/arm/include/asm/atomic.h
@@ -13,7 +13,6 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
diff --git a/arch/arm/include/asm/bitops.h b/arch/arm/include/asm/bitops.h
index f7419ef..2c56593 100644
--- a/arch/arm/include/asm/bitops.h
+++ b/arch/arm/include/asm/bitops.h
@@ -24,7 +24,6 @@
 #endif
 
 #include <linux/compiler.h>
-#include <asm/system.h>
 
 #define smp_mb__before_clear_bit()	smp_mb()
 #define smp_mb__after_clear_bit()	smp_mb()
diff --git a/arch/arm/include/asm/div64.h b/arch/arm/include/asm/div64.h
index d3f0a9e..3427f44 100644
--- a/arch/arm/include/asm/div64.h
+++ b/arch/arm/include/asm/div64.h
@@ -1,7 +1,6 @@
 #ifndef __ASM_ARM_DIV64
 #define __ASM_ARM_DIV64
 
-#include <asm/system.h>
 #include <linux/types.h>
 
 /*
diff --git a/arch/arm/include/asm/dma.h b/arch/arm/include/asm/dma.h
index 69a5b0b..5694a0d 100644
--- a/arch/arm/include/asm/dma.h
+++ b/arch/arm/include/asm/dma.h
@@ -19,7 +19,6 @@
  * It should not be re-used except for that purpose.
  */
 #include <linux/spinlock.h>
-#include <asm/system.h>
 #include <asm/scatterlist.h>
 
 #include <mach/isa-dma.h>
diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 9275828..0a34bf7 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -26,7 +26,6 @@
 #include <linux/types.h>
 #include <asm/byteorder.h>
 #include <asm/memory.h>
-#include <asm/system.h>
 #include <asm-generic/pci_iomap.h>
 
 /*
diff --git a/arch/arm/include/asm/processor.h b/arch/arm/include/asm/processor.h
index cb8d638..ce280b8 100644
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -22,7 +22,6 @@
 #include <asm/hw_breakpoint.h>
 #include <asm/ptrace.h>
 #include <asm/types.h>
-#include <asm/system.h>
 
 #ifdef __KERNEL__
 #define STACK_TOP	((current->personality & ADDR_LIMIT_32BIT) ? \
diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 2958976..41820cf 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -16,7 +16,6 @@
 #include <asm/errno.h>
 #include <asm/memory.h>
 #include <asm/domain.h>
-#include <asm/system.h>
 #include <asm/unified.h>
 
 #define VERIFY_READ 0
diff --git a/arch/arm/kernel/armksyms.c b/arch/arm/kernel/armksyms.c
index 5b0bce6..b57c75e 100644
--- a/arch/arm/kernel/armksyms.c
+++ b/arch/arm/kernel/armksyms.c
@@ -18,7 +18,6 @@
 #include <linux/io.h>
 
 #include <asm/checksum.h>
-#include <asm/system.h>
 #include <asm/ftrace.h>
 
 /*
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index be16a48..0260594 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -24,7 +24,6 @@
 #include <asm/unwind.h>
 #include <asm/unistd.h>
 #include <asm/tls.h>
-#include <asm/system.h>
 
 #include "entry-header.S"
 #include <asm/entry-macro-multi.S>
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 4c164ec..0b484c2 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -44,7 +44,6 @@
 #include <asm/cacheflush.h>
 #include <asm/fiq.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 static unsigned long no_fiq_insn;
diff --git a/arch/arm/kernel/head-nommu.S b/arch/arm/kernel/head-nommu.S
index d46f259..601d2fd 100644
--- a/arch/arm/kernel/head-nommu.S
+++ b/arch/arm/kernel/head-nommu.S
@@ -18,7 +18,6 @@
 #include <asm/ptrace.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
-#include <asm/system.h>
 
 /*
  * Kernel startup entry point.
diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 6d57911..4559f32 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -20,7 +20,6 @@
 #include <asm/asm-offsets.h>
 #include <asm/memory.h>
 #include <asm/thread_info.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 
 #ifdef CONFIG_DEBUG_LL
diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index d6a95ef..ba386bd 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -34,7 +34,6 @@
 #include <asm/current.h>
 #include <asm/hw_breakpoint.h>
 #include <asm/kdebug.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 /* Breakpoint currently in use for each BRP. */
diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 3efd82c..6a6a097 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -36,7 +36,6 @@
 #include <linux/proc_fs.h>
 
 #include <asm/exception.h>
-#include <asm/system.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/kernel/machine_kexec.c b/arch/arm/kernel/machine_kexec.c
index 764bd45..e097865 100644
--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -12,7 +12,6 @@
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 
 extern const unsigned char relocate_new_kernel[];
 extern const unsigned int relocate_new_kernel_size;
diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index 971d65c..784222c 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -35,7 +35,6 @@
 #include <asm/cacheflush.h>
 #include <asm/leds.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/thread_notify.h>
 #include <asm/stacktrace.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index ede6443..45956c9 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -26,7 +26,6 @@
 #include <linux/audit.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #define REG_PC	15
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index a255c39..d481833 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -44,7 +44,6 @@
 #include <asm/cacheflush.h>
 #include <asm/cachetype.h>
 #include <asm/tlbflush.h>
-#include <asm/system.h>
 
 #include <asm/prom.h>
 #include <asm/mach/arch.h>
diff --git a/arch/arm/kernel/sleep.S b/arch/arm/kernel/sleep.S
index 1f268bd..987dcf3 100644
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@ -4,7 +4,6 @@
 #include <asm/assembler.h>
 #include <asm/glue-cache.h>
 #include <asm/glue-proc.h>
-#include <asm/system.h>
 	.text
 
 /*
diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index f84dfe6..11da4dd 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -29,7 +29,6 @@
 #include <linux/atomic.h>
 #include <asm/cacheflush.h>
 #include <asm/exception.h>
-#include <asm/system.h>
 #include <asm/unistd.h>
 #include <asm/traps.h>
 #include <asm/unwind.h>
diff --git a/arch/arm/mach-clps711x/p720t-leds.c b/arch/arm/mach-clps711x/p720t-leds.c
index 1512144..dd9a6cd 100644
--- a/arch/arm/mach-clps711x/p720t-leds.c
+++ b/arch/arm/mach-clps711x/p720t-leds.c
@@ -25,7 +25,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 #include <asm/hardware/clps7111.h>
diff --git a/arch/arm/mach-ebsa110/core.c b/arch/arm/mach-ebsa110/core.c
index 294aad0..e43dcc0 100644
--- a/arch/arm/mach-ebsa110/core.c
+++ b/arch/arm/mach-ebsa110/core.c
@@ -22,7 +22,6 @@
 #include <asm/mach-types.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
diff --git a/arch/arm/mach-ebsa110/leds.c b/arch/arm/mach-ebsa110/leds.c
index 6a6ea57..101a320 100644
--- a/arch/arm/mach-ebsa110/leds.c
+++ b/arch/arm/mach-ebsa110/leds.c
@@ -17,7 +17,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 static spinlock_t leds_lock;
diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
index f685650..94a7087 100644
--- a/arch/arm/mach-footbridge/dc21285.c
+++ b/arch/arm/mach-footbridge/dc21285.c
@@ -21,7 +21,6 @@
 #include <video/vga.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <asm/hardware/dec21285.h>
 
diff --git a/arch/arm/mach-footbridge/ebsa285-leds.c b/arch/arm/mach-footbridge/ebsa285-leds.c
index 4e10090..5bd2667 100644
--- a/arch/arm/mach-footbridge/ebsa285-leds.c
+++ b/arch/arm/mach-footbridge/ebsa285-leds.c
@@ -24,7 +24,6 @@
 #include <mach/hardware.h>
 #include <asm/leds.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 
 #define LED_STATE_ENABLED	1
 #define LED_STATE_CLAIMED	2
diff --git a/arch/arm/mach-footbridge/netwinder-leds.c b/arch/arm/mach-footbridge/netwinder-leds.c
index e57102e..5a2bd89 100644
--- a/arch/arm/mach-footbridge/netwinder-leds.c
+++ b/arch/arm/mach-footbridge/netwinder-leds.c
@@ -24,7 +24,6 @@
 #include <mach/hardware.h>
 #include <asm/leds.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 
 #define LED_STATE_ENABLED	1
 #define LED_STATE_CLAIMED	2
diff --git a/arch/arm/mach-imx/dma-v1.c b/arch/arm/mach-imx/dma-v1.c
index 42afc29..3189a60 100644
--- a/arch/arm/mach-imx/dma-v1.c
+++ b/arch/arm/mach-imx/dma-v1.c
@@ -32,7 +32,6 @@
 #include <linux/scatterlist.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <mach/dma-v1.h>
diff --git a/arch/arm/mach-integrator/core.c b/arch/arm/mach-integrator/core.c
index 019f0ab..d2fd9f3 100644
--- a/arch/arm/mach-integrator/core.c
+++ b/arch/arm/mach-integrator/core.c
@@ -27,7 +27,6 @@
 #include <mach/platform.h>
 #include <asm/irq.h>
 #include <mach/cm.h>
-#include <asm/system.h>
 #include <asm/leds.h>
 #include <asm/mach-types.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/mach-integrator/leds.c b/arch/arm/mach-integrator/leds.c
index 28be186..466defa 100644
--- a/arch/arm/mach-integrator/leds.c
+++ b/arch/arm/mach-integrator/leds.c
@@ -29,7 +29,6 @@
 #include <mach/hardware.h>
 #include <mach/platform.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 #include <mach/cm.h>
 
diff --git a/arch/arm/mach-integrator/pci.c b/arch/arm/mach-integrator/pci.c
index 520b6bf..36068f4 100644
--- a/arch/arm/mach-integrator/pci.c
+++ b/arch/arm/mach-integrator/pci.c
@@ -27,7 +27,6 @@
 #include <linux/init.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-integrator/pci_v3.c b/arch/arm/mach-integrator/pci_v3.c
index 3c82566..9d47b4c 100644
--- a/arch/arm/mach-integrator/pci_v3.c
+++ b/arch/arm/mach-integrator/pci_v3.c
@@ -32,7 +32,6 @@
 #include <mach/platform.h>
 #include <asm/irq.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <asm/irq_regs.h>
 
diff --git a/arch/arm/mach-iop33x/uart.c b/arch/arm/mach-iop33x/uart.c
index cdae24e..bbf54d7 100644
--- a/arch/arm/mach-iop33x/uart.c
+++ b/arch/arm/mach-iop33x/uart.c
@@ -22,7 +22,6 @@
 #include <asm/page.h>
 #include <asm/mach/map.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/memory.h>
 #include <mach/hardware.h>
 #include <asm/hardware/iop3xx.h>
diff --git a/arch/arm/mach-ixp2000/core.c b/arch/arm/mach-ixp2000/core.c
index 81c4537..f214cdf 100644
--- a/arch/arm/mach-ixp2000/core.c
+++ b/arch/arm/mach-ixp2000/core.c
@@ -32,7 +32,6 @@
 #include <asm/memory.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/arm/mach-ixp2000/enp2611.c b/arch/arm/mach-ixp2000/enp2611.c
index e872d23..4867f40 100644
--- a/arch/arm/mach-ixp2000/enp2611.c
+++ b/arch/arm/mach-ixp2000/enp2611.c
@@ -36,7 +36,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-ixp2000/ixdp2400.c b/arch/arm/mach-ixp2000/ixdp2400.c
index f53e911..558f5f8 100644
--- a/arch/arm/mach-ixp2000/ixdp2400.c
+++ b/arch/arm/mach-ixp2000/ixdp2400.c
@@ -29,7 +29,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-ixp2000/ixdp2800.c b/arch/arm/mach-ixp2000/ixdp2800.c
index a2e7c39..33c6d5f 100644
--- a/arch/arm/mach-ixp2000/ixdp2800.c
+++ b/arch/arm/mach-ixp2000/ixdp2800.c
@@ -29,7 +29,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-ixp2000/ixdp2x00.c b/arch/arm/mach-ixp2000/ixdp2x00.c
index 634b6c8..910426a 100644
--- a/arch/arm/mach-ixp2000/ixdp2x00.c
+++ b/arch/arm/mach-ixp2000/ixdp2x00.c
@@ -30,7 +30,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-ixp2000/ixdp2x01.c b/arch/arm/mach-ixp2000/ixdp2x01.c
index 7632bea..5196c39 100644
--- a/arch/arm/mach-ixp2000/ixdp2x01.c
+++ b/arch/arm/mach-ixp2000/ixdp2x01.c
@@ -34,7 +34,6 @@
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-ixp2000/pci.c b/arch/arm/mach-ixp2000/pci.c
index 626fda4..7e9a1f3 100644
--- a/arch/arm/mach-ixp2000/pci.c
+++ b/arch/arm/mach-ixp2000/pci.c
@@ -26,7 +26,6 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 
 #include <asm/mach/pci.h>
diff --git a/arch/arm/mach-ixp23xx/core.c b/arch/arm/mach-ixp23xx/core.c
index 0923bb9..ccdec42 100644
--- a/arch/arm/mach-ixp23xx/core.c
+++ b/arch/arm/mach-ixp23xx/core.c
@@ -34,7 +34,6 @@
 #include <asm/memory.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/arm/mach-ixp23xx/espresso.c b/arch/arm/mach-ixp23xx/espresso.c
index 8f2487e..d142d45 100644
--- a/arch/arm/mach-ixp23xx/espresso.c
+++ b/arch/arm/mach-ixp23xx/espresso.c
@@ -32,7 +32,6 @@
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/arm/mach-ixp23xx/ixdp2351.c b/arch/arm/mach-ixp23xx/ixdp2351.c
index 5d5dd3e..b0e07db 100644
--- a/arch/arm/mach-ixp23xx/ixdp2351.c
+++ b/arch/arm/mach-ixp23xx/ixdp2351.c
@@ -36,7 +36,6 @@
 #include <asm/memory.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/arm/mach-ixp23xx/pci.c b/arch/arm/mach-ixp23xx/pci.c
index 25b5c46..bdf2866 100644
--- a/arch/arm/mach-ixp23xx/pci.c
+++ b/arch/arm/mach-ixp23xx/pci.c
@@ -28,7 +28,6 @@
 
 #include <asm/irq.h>
 #include <asm/sizes.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-ixp23xx/roadrunner.c b/arch/arm/mach-ixp23xx/roadrunner.c
index 377283f..eaaa3fa 100644
--- a/arch/arm/mach-ixp23xx/roadrunner.c
+++ b/arch/arm/mach-ixp23xx/roadrunner.c
@@ -36,7 +36,6 @@
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/arm/mach-ixp4xx/common-pci.c b/arch/arm/mach-ixp4xx/common-pci.c
index 5eff15f..0f445d3 100644
--- a/arch/arm/mach-ixp4xx/common-pci.c
+++ b/arch/arm/mach-ixp4xx/common-pci.c
@@ -32,7 +32,6 @@
 #include <asm/cputype.h>
 #include <asm/irq.h>
 #include <asm/sizes.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-ixp4xx/goramo_mlr.c b/arch/arm/mach-ixp4xx/goramo_mlr.c
index c0e3d69..78ae12c 100644
--- a/arch/arm/mach-ixp4xx/goramo_mlr.c
+++ b/arch/arm/mach-ixp4xx/goramo_mlr.c
@@ -12,7 +12,6 @@
 #include <linux/pci.h>
 #include <linux/serial_8250.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
 #include <asm/mach/pci.h>
diff --git a/arch/arm/mach-msm/board-sapphire.c b/arch/arm/mach-msm/board-sapphire.c
index 97b8191..4a8ea0d 100644
--- a/arch/arm/mach-msm/board-sapphire.c
+++ b/arch/arm/mach-msm/board-sapphire.c
@@ -27,7 +27,6 @@
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
 #include <asm/mach/flash.h>
-#include <asm/system.h>
 #include <mach/system.h>
 #include <mach/vreg.h>
 #include <mach/board.h>
diff --git a/arch/arm/mach-mxs/system.c b/arch/arm/mach-mxs/system.c
index 54f91ad..32fe638 100644
--- a/arch/arm/mach-mxs/system.c
+++ b/arch/arm/mach-mxs/system.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 
 #include <asm/proc-fns.h>
-#include <asm/system.h>
 
 #include <mach/mxs.h>
 #include <mach/common.h>
diff --git a/arch/arm/mach-omap1/leds-h2p2-debug.c b/arch/arm/mach-omap1/leds-h2p2-debug.c
index 4b818eb..f6b14a1 100644
--- a/arch/arm/mach-omap1/leds-h2p2-debug.c
+++ b/arch/arm/mach-omap1/leds-h2p2-debug.c
@@ -17,7 +17,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 #include <plat/fpga.h>
diff --git a/arch/arm/mach-omap1/leds-innovator.c b/arch/arm/mach-omap1/leds-innovator.c
index 9b99c28..3a066ee 100644
--- a/arch/arm/mach-omap1/leds-innovator.c
+++ b/arch/arm/mach-omap1/leds-innovator.c
@@ -5,7 +5,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-omap1/leds-osk.c b/arch/arm/mach-omap1/leds-osk.c
index da09f43..936ed42 100644
--- a/arch/arm/mach-omap1/leds-osk.c
+++ b/arch/arm/mach-omap1/leds-osk.c
@@ -8,7 +8,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-omap1/mux.c b/arch/arm/mach-omap1/mux.c
index 5fdef7a..087dba0 100644
--- a/arch/arm/mach-omap1/mux.c
+++ b/arch/arm/mach-omap1/mux.c
@@ -27,7 +27,6 @@
 #include <linux/io.h>
 #include <linux/spinlock.h>
 
-#include <asm/system.h>
 
 #include <plat/mux.h>
 
diff --git a/arch/arm/mach-omap1/time.c b/arch/arm/mach-omap1/time.c
index b8faffa..7595e0a 100644
--- a/arch/arm/mach-omap1/time.c
+++ b/arch/arm/mach-omap1/time.c
@@ -44,7 +44,6 @@
 #include <linux/clockchips.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/leds.h>
 #include <asm/irq.h>
diff --git a/arch/arm/mach-omap1/timer32k.c b/arch/arm/mach-omap1/timer32k.c
index 9a54ef4..10bcd13 100644
--- a/arch/arm/mach-omap1/timer32k.c
+++ b/arch/arm/mach-omap1/timer32k.c
@@ -46,7 +46,6 @@
 #include <linux/clockchips.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/leds.h>
 #include <asm/irq.h>
diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 611a0e3..e974d33 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -35,7 +35,6 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 
-#include <asm/system.h>
 
 #include <plat/omap_hwmod.h>
 
diff --git a/arch/arm/mach-omap2/omap-mpuss-lowpower.c b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
index 1d5d010..069f8fc 100644
--- a/arch/arm/mach-omap2/omap-mpuss-lowpower.c
+++ b/arch/arm/mach-omap2/omap-mpuss-lowpower.c
@@ -46,7 +46,6 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/smp_scu.h>
-#include <asm/system.h>
 #include <asm/pgalloc.h>
 #include <asm/suspend.h>
 #include <asm/hardware/cache-l2x0.h>
diff --git a/arch/arm/mach-omap2/sleep44xx.S b/arch/arm/mach-omap2/sleep44xx.S
index abd2834..9f6b83d 100644
--- a/arch/arm/mach-omap2/sleep44xx.S
+++ b/arch/arm/mach-omap2/sleep44xx.S
@@ -10,7 +10,6 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/system.h>
 #include <asm/smp_scu.h>
 #include <asm/memory.h>
 #include <asm/hardware/cache-l2x0.h>
diff --git a/arch/arm/mach-orion5x/ls-chl-setup.c b/arch/arm/mach-orion5x/ls-chl-setup.c
index 5272131..0c9e413 100644
--- a/arch/arm/mach-orion5x/ls-chl-setup.c
+++ b/arch/arm/mach-orion5x/ls-chl-setup.c
@@ -22,7 +22,6 @@
 #include <linux/gpio.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
-#include <asm/system.h>
 #include <mach/orion5x.h>
 #include "common.h"
 #include "mpp.h"
diff --git a/arch/arm/mach-orion5x/ls_hgl-setup.c b/arch/arm/mach-orion5x/ls_hgl-setup.c
index 9a8697b..c1b5d8a 100644
--- a/arch/arm/mach-orion5x/ls_hgl-setup.c
+++ b/arch/arm/mach-orion5x/ls_hgl-setup.c
@@ -21,7 +21,6 @@
 #include <linux/gpio.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
-#include <asm/system.h>
 #include <mach/orion5x.h>
 #include "common.h"
 #include "mpp.h"
diff --git a/arch/arm/mach-orion5x/lsmini-setup.c b/arch/arm/mach-orion5x/lsmini-setup.c
index 09c7365..949eaa8 100644
--- a/arch/arm/mach-orion5x/lsmini-setup.c
+++ b/arch/arm/mach-orion5x/lsmini-setup.c
@@ -21,7 +21,6 @@
 #include <linux/gpio.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
-#include <asm/system.h>
 #include <mach/orion5x.h>
 #include "common.h"
 #include "mpp.h"
diff --git a/arch/arm/mach-pnx4008/core.c b/arch/arm/mach-pnx4008/core.c
index 4cfb40b..977538f 100644
--- a/arch/arm/mach-pnx4008/core.c
+++ b/arch/arm/mach-pnx4008/core.c
@@ -32,7 +32,6 @@
 #include <asm/mach-types.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-pnx4008/dma.c b/arch/arm/mach-pnx4008/dma.c
index 7fa4bf2..a4739e9 100644
--- a/arch/arm/mach-pnx4008/dma.c
+++ b/arch/arm/mach-pnx4008/dma.c
@@ -24,7 +24,6 @@
 #include <linux/io.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <mach/dma.h>
 #include <asm/dma-mapping.h>
diff --git a/arch/arm/mach-pnx4008/irq.c b/arch/arm/mach-pnx4008/irq.c
index 7608c7a..41e4201 100644
--- a/arch/arm/mach-pnx4008/irq.c
+++ b/arch/arm/mach-pnx4008/irq.c
@@ -28,7 +28,6 @@
 #include <asm/setup.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-pnx4008/time.c b/arch/arm/mach-pnx4008/time.c
index 0c8aad4..0cfe8af 100644
--- a/arch/arm/mach-pnx4008/time.c
+++ b/arch/arm/mach-pnx4008/time.c
@@ -24,7 +24,6 @@
 #include <linux/irq.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/leds.h>
 #include <asm/mach/time.h>
diff --git a/arch/arm/mach-pxa/corgi.c b/arch/arm/mach-pxa/corgi.c
index 11f1e73..de9d45e 100644
--- a/arch/arm/mach-pxa/corgi.c
+++ b/arch/arm/mach-pxa/corgi.c
@@ -40,7 +40,6 @@
 #include <asm/mach-types.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-pxa/generic.c b/arch/arm/mach-pxa/generic.c
index 5432ecb..4225417 100644
--- a/arch/arm/mach-pxa/generic.c
+++ b/arch/arm/mach-pxa/generic.c
@@ -22,7 +22,6 @@
 #include <linux/init.h>
 
 #include <mach/hardware.h>
-#include <asm/system.h>
 #include <asm/mach/map.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/arm/mach-pxa/leds-idp.c b/arch/arm/mach-pxa/leds-idp.c
index 8b9c171..06b0600 100644
--- a/arch/arm/mach-pxa/leds-idp.c
+++ b/arch/arm/mach-pxa/leds-idp.c
@@ -16,7 +16,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include <mach/pxa25x.h>
 #include <mach/idp.h>
diff --git a/arch/arm/mach-pxa/leds-lubbock.c b/arch/arm/mach-pxa/leds-lubbock.c
index e26d5ef..0bd85c8 100644
--- a/arch/arm/mach-pxa/leds-lubbock.c
+++ b/arch/arm/mach-pxa/leds-lubbock.c
@@ -15,7 +15,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <mach/pxa25x.h>
 #include <mach/lubbock.h>
 
diff --git a/arch/arm/mach-pxa/leds-mainstone.c b/arch/arm/mach-pxa/leds-mainstone.c
index db4af5e..4058ab3 100644
--- a/arch/arm/mach-pxa/leds-mainstone.c
+++ b/arch/arm/mach-pxa/leds-mainstone.c
@@ -14,7 +14,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include <mach/pxa27x.h>
 #include <mach/mainstone.h>
diff --git a/arch/arm/mach-pxa/poodle.c b/arch/arm/mach-pxa/poodle.c
index 744baee..89d98c8 100644
--- a/arch/arm/mach-pxa/poodle.c
+++ b/arch/arm/mach-pxa/poodle.c
@@ -34,7 +34,6 @@
 #include <asm/mach-types.h>
 #include <asm/irq.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
diff --git a/arch/arm/mach-realview/core.c b/arch/arm/mach-realview/core.c
index acd329a..45868bb 100644
--- a/arch/arm/mach-realview/core.c
+++ b/arch/arm/mach-realview/core.c
@@ -33,7 +33,6 @@
 #include <linux/clkdev.h>
 #include <linux/mtd/physmap.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/irq.h>
 #include <asm/leds.h>
diff --git a/arch/arm/mach-sa1100/dma.c b/arch/arm/mach-sa1100/dma.c
index ad66035..56e1333 100644
--- a/arch/arm/mach-sa1100/dma.c
+++ b/arch/arm/mach-sa1100/dma.c
@@ -16,7 +16,6 @@
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <mach/dma.h>
diff --git a/arch/arm/mach-sa1100/generic.c b/arch/arm/mach-sa1100/generic.c
index bb10ee2..17caece 100644
--- a/arch/arm/mach-sa1100/generic.c
+++ b/arch/arm/mach-sa1100/generic.c
@@ -21,7 +21,6 @@
 
 #include <asm/div64.h>
 #include <mach/hardware.h>
-#include <asm/system.h>
 #include <asm/mach/map.h>
 #include <asm/mach/flash.h>
 #include <asm/irq.h>
diff --git a/arch/arm/mach-sa1100/leds-assabet.c b/arch/arm/mach-sa1100/leds-assabet.c
index 64e9b4b..3699176 100644
--- a/arch/arm/mach-sa1100/leds-assabet.c
+++ b/arch/arm/mach-sa1100/leds-assabet.c
@@ -13,7 +13,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <mach/assabet.h>
 
 #include "leds.h"
diff --git a/arch/arm/mach-sa1100/leds-badge4.c b/arch/arm/mach-sa1100/leds-badge4.c
index cf1e384..f99fac3 100644
--- a/arch/arm/mach-sa1100/leds-badge4.c
+++ b/arch/arm/mach-sa1100/leds-badge4.c
@@ -14,7 +14,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-sa1100/leds-cerf.c b/arch/arm/mach-sa1100/leds-cerf.c
index 259b48e..040540f 100644
--- a/arch/arm/mach-sa1100/leds-cerf.c
+++ b/arch/arm/mach-sa1100/leds-cerf.c
@@ -7,7 +7,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-sa1100/leds-hackkit.c b/arch/arm/mach-sa1100/leds-hackkit.c
index 2bce137..6a23524 100644
--- a/arch/arm/mach-sa1100/leds-hackkit.c
+++ b/arch/arm/mach-sa1100/leds-hackkit.c
@@ -13,7 +13,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-sa1100/leds-lart.c b/arch/arm/mach-sa1100/leds-lart.c
index 0505a1f..a51830c 100644
--- a/arch/arm/mach-sa1100/leds-lart.c
+++ b/arch/arm/mach-sa1100/leds-lart.c
@@ -13,7 +13,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #include "leds.h"
 
diff --git a/arch/arm/mach-sa1100/pm.c b/arch/arm/mach-sa1100/pm.c
index bf85b8b..2fa499e 100644
--- a/arch/arm/mach-sa1100/pm.c
+++ b/arch/arm/mach-sa1100/pm.c
@@ -30,7 +30,6 @@
 #include <mach/hardware.h>
 #include <asm/memory.h>
 #include <asm/suspend.h>
-#include <asm/system.h>
 #include <asm/mach/time.h>
 
 extern int sa1100_finish_suspend(unsigned long);
diff --git a/arch/arm/mach-shark/leds.c b/arch/arm/mach-shark/leds.c
index ccd4918..2560907 100644
--- a/arch/arm/mach-shark/leds.c
+++ b/arch/arm/mach-shark/leds.c
@@ -23,7 +23,6 @@
 #include <linux/io.h>
 
 #include <asm/leds.h>
-#include <asm/system.h>
 
 #define LED_STATE_ENABLED	1
 #define LED_STATE_CLAIMED	2
diff --git a/arch/arm/mach-shmobile/cpuidle.c b/arch/arm/mach-shmobile/cpuidle.c
index 1b23342..21b09b6 100644
--- a/arch/arm/mach-shmobile/cpuidle.c
+++ b/arch/arm/mach-shmobile/cpuidle.c
@@ -13,7 +13,6 @@
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 static void shmobile_enter_wfi(void)
diff --git a/arch/arm/mach-shmobile/pm-r8a7779.c b/arch/arm/mach-shmobile/pm-r8a7779.c
index c38ba7b..a18a4ae 100644
--- a/arch/arm/mach-shmobile/pm-r8a7779.c
+++ b/arch/arm/mach-shmobile/pm-r8a7779.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/console.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <mach/common.h>
 #include <mach/r8a7779.h>
diff --git a/arch/arm/mach-shmobile/pm-sh7372.c b/arch/arm/mach-shmobile/pm-sh7372.c
index fcf8b17..a3bdb12 100644
--- a/arch/arm/mach-shmobile/pm-sh7372.c
+++ b/arch/arm/mach-shmobile/pm-sh7372.c
@@ -21,7 +21,6 @@
 #include <linux/irq.h>
 #include <linux/bitrev.h>
 #include <linux/console.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/tlbflush.h>
 #include <asm/suspend.h>
diff --git a/arch/arm/mach-shmobile/suspend.c b/arch/arm/mach-shmobile/suspend.c
index c1febe1..12d760c 100644
--- a/arch/arm/mach-shmobile/suspend.c
+++ b/arch/arm/mach-shmobile/suspend.c
@@ -12,7 +12,6 @@
 #include <linux/suspend.h>
 #include <linux/module.h>
 #include <linux/err.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 static int shmobile_suspend_default_enter(suspend_state_t suspend_state)
diff --git a/arch/arm/mach-tegra/cpu-tegra.c b/arch/arm/mach-tegra/cpu-tegra.c
index bb5ce39..7a065f0 100644
--- a/arch/arm/mach-tegra/cpu-tegra.c
+++ b/arch/arm/mach-tegra/cpu-tegra.c
@@ -30,7 +30,6 @@
 #include <linux/io.h>
 #include <linux/suspend.h>
 
-#include <asm/system.h>
 
 #include <mach/clk.h>
 
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index 02b7b93..f0932b5 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -36,7 +36,6 @@
 #include <linux/clkdev.h>
 #include <linux/mtd/physmap.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/leds.h>
 #include <asm/hardware/arm_timer.h>
diff --git a/arch/arm/mach-versatile/pci.c b/arch/arm/mach-versatile/pci.c
index 90069bc..787cf5f 100644
--- a/arch/arm/mach-versatile/pci.c
+++ b/arch/arm/mach-versatile/pci.c
@@ -24,7 +24,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/mach/pci.h>
 
 /*
diff --git a/arch/arm/mach-vexpress/hotplug.c b/arch/arm/mach-vexpress/hotplug.c
index 3034a4d..e352494 100644
--- a/arch/arm/mach-vexpress/hotplug.c
+++ b/arch/arm/mach-vexpress/hotplug.c
@@ -14,7 +14,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
-#include <asm/system.h>
 
 extern volatile int pen_release;
 
diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index caf14dc..193cadf 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -22,7 +22,6 @@
 #include <linux/sched.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include "fault.h"
diff --git a/arch/arm/mm/cache-xsc3l2.c b/arch/arm/mm/cache-xsc3l2.c
index 5a32020..c4ae2b4 100644
--- a/arch/arm/mm/cache-xsc3l2.c
+++ b/arch/arm/mm/cache-xsc3l2.c
@@ -18,7 +18,6 @@
  */
 #include <linux/init.h>
 #include <linux/highmem.h>
-#include <asm/system.h>
 #include <asm/cputype.h>
 #include <asm/cacheflush.h>
 
diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index bb7eac3..699522c 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -21,7 +21,6 @@
 #include <linux/perf_event.h>
 
 #include <asm/exception.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
diff --git a/arch/arm/mm/flush.c b/arch/arm/mm/flush.c
index 1a8d4aa..062d61a 100644
--- a/arch/arm/mm/flush.c
+++ b/arch/arm/mm/flush.c
@@ -16,7 +16,6 @@
 #include <asm/cachetype.h>
 #include <asm/highmem.h>
 #include <asm/smp_plat.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 
 #include "mm.h"
diff --git a/arch/arm/mm/proc-fa526.S b/arch/arm/mm/proc-fa526.S
index 272558a..d217e97 100644
--- a/arch/arm/mm/proc-fa526.S
+++ b/arch/arm/mm/proc-fa526.S
@@ -22,7 +22,6 @@
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 
 #include "proc-macros.S"
 
diff --git a/arch/arm/nwfpe/fpa11.c b/arch/arm/nwfpe/fpa11.c
index cc60acd..2782ebc 100644
--- a/arch/arm/nwfpe/fpa11.c
+++ b/arch/arm/nwfpe/fpa11.c
@@ -28,7 +28,6 @@
 
 #include <linux/compiler.h>
 #include <linux/string.h>
-#include <asm/system.h>
 
 /* Reset the FPA11 chip.  Called to initialize and reset the emulator. */
 static void resetFPA11(void)
diff --git a/arch/arm/plat-iop/i2c.c b/arch/arm/plat-iop/i2c.c
index 4efe392..88215ad 100644
--- a/arch/arm/plat-iop/i2c.c
+++ b/arch/arm/plat-iop/i2c.c
@@ -23,7 +23,6 @@
 #include <asm/page.h>
 #include <asm/mach/map.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/memory.h>
 #include <mach/hardware.h>
 #include <asm/hardware/iop3xx.h>
diff --git a/arch/arm/plat-iop/pci.c b/arch/arm/plat-iop/pci.c
index f4d40a2..bb26981 100644
--- a/arch/arm/plat-iop/pci.c
+++ b/arch/arm/plat-iop/pci.c
@@ -20,7 +20,6 @@
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <asm/mach/pci.h>
 #include <asm/hardware/iop3xx.h>
diff --git a/arch/arm/plat-mxc/system.c b/arch/arm/plat-mxc/system.c
index 3599bf2..8f12074 100644
--- a/arch/arm/plat-mxc/system.c
+++ b/arch/arm/plat-mxc/system.c
@@ -26,7 +26,6 @@
 #include <mach/hardware.h>
 #include <mach/common.h>
 #include <asm/proc-fns.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 void __iomem *(*imx_ioremap)(unsigned long, size_t, unsigned int) = NULL;
diff --git a/arch/arm/plat-omap/debug-leds.c b/arch/arm/plat-omap/debug-leds.c
index 61a1ec2..39407cb 100644
--- a/arch/arm/plat-omap/debug-leds.c
+++ b/arch/arm/plat-omap/debug-leds.c
@@ -15,7 +15,6 @@
 
 #include <mach/hardware.h>
 #include <asm/leds.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 #include <plat/fpga.h>
diff --git a/arch/arm/plat-omap/dma.c b/arch/arm/plat-omap/dma.c
index 002fb4d..dbb1049 100644
--- a/arch/arm/plat-omap/dma.c
+++ b/arch/arm/plat-omap/dma.c
@@ -36,7 +36,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 #include <plat/dma.h>
 
diff --git a/arch/arm/plat-omap/mux.c b/arch/arm/plat-omap/mux.c
index 0d4aa0d..976fc80 100644
--- a/arch/arm/plat-omap/mux.c
+++ b/arch/arm/plat-omap/mux.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <linux/spinlock.h>
 #include <plat/mux.h>
 
diff --git a/arch/arm/plat-pxa/dma.c b/arch/arm/plat-pxa/dma.c
index 2d3c19d..79ef102 100644
--- a/arch/arm/plat-pxa/dma.c
+++ b/arch/arm/plat-pxa/dma.c
@@ -20,7 +20,6 @@
 #include <linux/errno.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/memory.h>
 #include <mach/hardware.h>
diff --git a/arch/arm/plat-s3c24xx/dma.c b/arch/arm/plat-s3c24xx/dma.c
index 9fe3534..c57e1e8 100644
--- a/arch/arm/plat-s3c24xx/dma.c
+++ b/arch/arm/plat-s3c24xx/dma.c
@@ -27,7 +27,6 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <mach/dma.h>
diff --git a/arch/arm/plat-samsung/cpu.c b/arch/arm/plat-samsung/cpu.c
index 81c06d4..46b426e 100644
--- a/arch/arm/plat-samsung/cpu.c
+++ b/arch/arm/plat-samsung/cpu.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 
 #include <mach/map.h>
 #include <plat/cpu.h>
diff --git a/arch/arm/plat-samsung/time.c b/arch/arm/plat-samsung/time.c
index e3bb806..4dcb11c 100644
--- a/arch/arm/plat-samsung/time.c
+++ b/arch/arm/plat-samsung/time.c
@@ -28,7 +28,6 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/leds.h>
 #include <asm/mach-types.h>
 
diff --git a/arch/avr32/include/asm/atomic.h b/arch/avr32/include/asm/atomic.h
index e0ac263..2fc18fe 100644
--- a/arch/avr32/include/asm/atomic.h
+++ b/arch/avr32/include/asm/atomic.h
@@ -15,7 +15,6 @@
 #define __ASM_AVR32_ATOMIC_H
 
 #include <linux/types.h>
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)  { (i) }
 
diff --git a/arch/avr32/include/asm/bitops.h b/arch/avr32/include/asm/bitops.h
index b70c19b..ebe7ad3 100644
--- a/arch/avr32/include/asm/bitops.h
+++ b/arch/avr32/include/asm/bitops.h
@@ -13,7 +13,6 @@
 #endif
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 /*
  * clear_bit() doesn't provide any barrier for the compiler
diff --git a/arch/avr32/mach-at32ap/cpufreq.c b/arch/avr32/mach-at32ap/cpufreq.c
index 6277433..18b7656 100644
--- a/arch/avr32/mach-at32ap/cpufreq.c
+++ b/arch/avr32/mach-at32ap/cpufreq.c
@@ -19,7 +19,6 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/export.h>
-#include <asm/system.h>
 
 static struct clk *cpuclk;
 
diff --git a/arch/avr32/oprofile/op_model_avr32.c b/arch/avr32/oprofile/op_model_avr32.c
index a3e9b3c..f74b780 100644
--- a/arch/avr32/oprofile/op_model_avr32.c
+++ b/arch/avr32/oprofile/op_model_avr32.c
@@ -17,7 +17,6 @@
 #include <linux/types.h>
 
 #include <asm/sysreg.h>
-#include <asm/system.h>
 
 #define AVR32_PERFCTR_IRQ_GROUP	0
 #define AVR32_PERFCTR_IRQ_LINE	1
diff --git a/arch/blackfin/kernel/ipipe.c b/arch/blackfin/kernel/ipipe.c
index dbe1122..f657b38 100644
--- a/arch/blackfin/kernel/ipipe.c
+++ b/arch/blackfin/kernel/ipipe.c
@@ -31,7 +31,6 @@
 #include <linux/kthread.h>
 #include <linux/unistd.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/irq_handler.h>
 
diff --git a/arch/blackfin/kernel/kgdb_test.c b/arch/blackfin/kernel/kgdb_test.c
index 4a7dcfe..18ab004 100644
--- a/arch/blackfin/kernel/kgdb_test.c
+++ b/arch/blackfin/kernel/kgdb_test.c
@@ -13,7 +13,6 @@
 
 #include <asm/current.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <asm/blackfin.h>
 
diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index 75089f8..e1f88e0 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -20,7 +20,6 @@
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/asm-offsets.h>
 #include <asm/dma.h>
diff --git a/arch/blackfin/kernel/reboot.c b/arch/blackfin/kernel/reboot.c
index c4c0081..b0434f8 100644
--- a/arch/blackfin/kernel/reboot.c
+++ b/arch/blackfin/kernel/reboot.c
@@ -9,7 +9,6 @@
 #include <linux/interrupt.h>
 #include <asm/bfin-global.h>
 #include <asm/reboot.h>
-#include <asm/system.h>
 #include <asm/bfrom.h>
 
 /* A system soft reset makes external memory unusable so force
diff --git a/arch/c6x/include/asm/bitops.h b/arch/c6x/include/asm/bitops.h
index 39ab7e8..0bec7e5 100644
--- a/arch/c6x/include/asm/bitops.h
+++ b/arch/c6x/include/asm/bitops.h
@@ -15,7 +15,6 @@
 
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 /*
diff --git a/arch/c6x/kernel/soc.c b/arch/c6x/kernel/soc.c
index dd45bc3..0748c94 100644
--- a/arch/c6x/kernel/soc.c
+++ b/arch/c6x/kernel/soc.c
@@ -11,7 +11,6 @@
 #include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/etherdevice.h>
-#include <asm/system.h>
 #include <asm/setup.h>
 #include <asm/soc.h>
 
diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
index 3d655dc..74f99c6 100644
--- a/arch/cris/arch-v10/drivers/ds1302.c
+++ b/arch/cris/arch-v10/drivers/ds1302.c
@@ -24,7 +24,6 @@
 #include <linux/capability.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <arch/svinto.h>
 #include <asm/io.h>
 #include <asm/rtc.h>
diff --git a/arch/cris/arch-v10/drivers/gpio.c b/arch/cris/arch-v10/drivers/gpio.c
index a276f08..609d551 100644
--- a/arch/cris/arch-v10/drivers/gpio.c
+++ b/arch/cris/arch-v10/drivers/gpio.c
@@ -24,7 +24,6 @@
 #include <asm/etraxgpio.h>
 #include <arch/svinto.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <arch/io_interface_mux.h>
 
diff --git a/arch/cris/arch-v10/drivers/i2c.c b/arch/cris/arch-v10/drivers/i2c.c
index c413539..b3d1f9e 100644
--- a/arch/cris/arch-v10/drivers/i2c.c
+++ b/arch/cris/arch-v10/drivers/i2c.c
@@ -22,7 +22,6 @@
 
 #include <asm/etraxi2c.h>
 
-#include <asm/system.h>
 #include <arch/svinto.h>
 #include <asm/io.h>
 #include <asm/delay.h>
diff --git a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
index 1391b73..9da0568 100644
--- a/arch/cris/arch-v10/drivers/pcf8563.c
+++ b/arch/cris/arch-v10/drivers/pcf8563.c
@@ -29,7 +29,6 @@
 #include <linux/mutex.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/rtc.h>
 
diff --git a/arch/cris/arch-v10/drivers/sync_serial.c b/arch/cris/arch-v10/drivers/sync_serial.c
index 466af40..c4b7171 100644
--- a/arch/cris/arch-v10/drivers/sync_serial.c
+++ b/arch/cris/arch-v10/drivers/sync_serial.c
@@ -27,7 +27,6 @@
 #include <asm/io.h>
 #include <arch/svinto.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/sync_serial.h>
 #include <arch/io_interface_mux.h>
 
diff --git a/arch/cris/arch-v10/kernel/debugport.c b/arch/cris/arch-v10/kernel/debugport.c
index 99851ba..f932c85 100644
--- a/arch/cris/arch-v10/kernel/debugport.c
+++ b/arch/cris/arch-v10/kernel/debugport.c
@@ -18,7 +18,6 @@
 #include <linux/major.h>
 #include <linux/delay.h>
 #include <linux/tty.h>
-#include <asm/system.h>
 #include <arch/svinto.h>
 #include <asm/io.h>             /* Get SIMCOUT. */
 
diff --git a/arch/cris/arch-v10/kernel/ptrace.c b/arch/cris/arch-v10/kernel/ptrace.c
index 320065f..bfddfb9 100644
--- a/arch/cris/arch-v10/kernel/ptrace.c
+++ b/arch/cris/arch-v10/kernel/ptrace.c
@@ -15,7 +15,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 
 /* 
diff --git a/arch/cris/arch-v32/drivers/i2c.c b/arch/cris/arch-v32/drivers/i2c.c
index ddb2399..3b2c82c 100644
--- a/arch/cris/arch-v32/drivers/i2c.c
+++ b/arch/cris/arch-v32/drivers/i2c.c
@@ -36,7 +36,6 @@
 
 #include <asm/etraxi2c.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/delay.h>
 
diff --git a/arch/cris/arch-v32/drivers/mach-a3/gpio.c b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
index c845831..0b86dee 100644
--- a/arch/cris/arch-v32/drivers/mach-a3/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-a3/gpio.c
@@ -31,7 +31,6 @@
 #include <hwregs/gio_defs.h>
 #include <hwregs/intr_vect_defs.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/pinmux.h>
 
diff --git a/arch/cris/arch-v32/drivers/mach-fs/gpio.c b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
index ee90d26..a2ac091 100644
--- a/arch/cris/arch-v32/drivers/mach-fs/gpio.c
+++ b/arch/cris/arch-v32/drivers/mach-fs/gpio.c
@@ -30,7 +30,6 @@
 #include <hwregs/gio_defs.h>
 #include <hwregs/intr_vect_defs.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 
 #ifdef CONFIG_ETRAX_VIRTUAL_GPIO
diff --git a/arch/cris/arch-v32/kernel/debugport.c b/arch/cris/arch-v32/kernel/debugport.c
index 794b364..610909b 100644
--- a/arch/cris/arch-v32/kernel/debugport.c
+++ b/arch/cris/arch-v32/kernel/debugport.c
@@ -4,7 +4,6 @@
 
 #include <linux/console.h>
 #include <linux/init.h>
-#include <asm/system.h>
 #include <hwregs/reg_rdwr.h>
 #include <hwregs/reg_map.h>
 #include <hwregs/ser_defs.h>
diff --git a/arch/cris/arch-v32/kernel/fasttimer.c b/arch/cris/arch-v32/kernel/fasttimer.c
index 111caa1..ab1551e 100644
--- a/arch/cris/arch-v32/kernel/fasttimer.c
+++ b/arch/cris/arch-v32/kernel/fasttimer.c
@@ -17,7 +17,6 @@
 #include <linux/delay.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include <hwregs/reg_map.h>
 #include <hwregs/reg_rdwr.h>
diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index 511ece9..f7ad9e8 100644
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -15,7 +15,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <arch/hwregs/supp_reg.h>
 
diff --git a/arch/cris/arch-v32/mach-a3/dma.c b/arch/cris/arch-v32/mach-a3/dma.c
index f35e4f6..47c64bf 100644
--- a/arch/cris/arch-v32/mach-a3/dma.c
+++ b/arch/cris/arch-v32/mach-a3/dma.c
@@ -9,7 +9,6 @@
 #include <hwregs/clkgen_defs.h>
 #include <hwregs/strmux_defs.h>
 #include <linux/errno.h>
-#include <asm/system.h>
 #include <arbiter.h>
 
 static char used_dma_channels[MAX_DMA_CHANNELS];
diff --git a/arch/cris/arch-v32/mach-fs/dma.c b/arch/cris/arch-v32/mach-fs/dma.c
index 2d970d7..fc6416a 100644
--- a/arch/cris/arch-v32/mach-fs/dma.c
+++ b/arch/cris/arch-v32/mach-fs/dma.c
@@ -9,7 +9,6 @@
 #include <hwregs/config_defs.h>
 #include <hwregs/strmux_defs.h>
 #include <linux/errno.h>
-#include <asm/system.h>
 #include <mach/arbiter.h>
 
 static char used_dma_channels[MAX_DMA_CHANNELS];
diff --git a/arch/cris/include/asm/atomic.h b/arch/cris/include/asm/atomic.h
index bbf0938..62760f8 100644
--- a/arch/cris/include/asm/atomic.h
+++ b/arch/cris/include/asm/atomic.h
@@ -5,7 +5,6 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <asm/system.h>
 #include <arch/atomic.h>
 
 /*
diff --git a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
index a78a2d7..184066c 100644
--- a/arch/cris/include/asm/bitops.h
+++ b/arch/cris/include/asm/bitops.h
@@ -19,7 +19,6 @@
 #endif
 
 #include <arch/bitops.h>
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <linux/compiler.h>
 
diff --git a/arch/cris/include/asm/processor.h b/arch/cris/include/asm/processor.h
index 3f7248f..b43c9bb 100644
--- a/arch/cris/include/asm/processor.h
+++ b/arch/cris/include/asm/processor.h
@@ -10,7 +10,6 @@
 #ifndef __ASM_CRIS_PROCESSOR_H
 #define __ASM_CRIS_PROCESSOR_H
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include <arch/processor.h>
diff --git a/arch/cris/kernel/process.c b/arch/cris/kernel/process.c
index aa585e4..41a973b 100644
--- a/arch/cris/kernel/process.c
+++ b/arch/cris/kernel/process.c
@@ -16,7 +16,6 @@
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/init_task.h>
diff --git a/arch/cris/kernel/ptrace.c b/arch/cris/kernel/ptrace.c
index 48b0f39..d114ad3 100644
--- a/arch/cris/kernel/ptrace.c
+++ b/arch/cris/kernel/ptrace.c
@@ -21,7 +21,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 
 
diff --git a/arch/frv/include/asm/atomic.h b/arch/frv/include/asm/atomic.h
index 0d8a7d6..9491575 100644
--- a/arch/frv/include/asm/atomic.h
+++ b/arch/frv/include/asm/atomic.h
@@ -16,7 +16,6 @@
 
 #include <linux/types.h>
 #include <asm/spr-regs.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_SMP
 #error not SMP safe
diff --git a/arch/frv/kernel/debug-stub.c b/arch/frv/kernel/debug-stub.c
index 2845139..a0228f7 100644
--- a/arch/frv/kernel/debug-stub.c
+++ b/arch/frv/kernel/debug-stub.c
@@ -17,7 +17,6 @@
 #include <linux/serial_reg.h>
 #include <linux/start_kernel.h>
 
-#include <asm/system.h>
 #include <asm/serial-regs.h>
 #include <asm/timer-regs.h>
 #include <asm/irc-regs.h>
diff --git a/arch/frv/kernel/gdb-io.c b/arch/frv/kernel/gdb-io.c
index 2ca641d..0707d35 100644
--- a/arch/frv/kernel/gdb-io.c
+++ b/arch/frv/kernel/gdb-io.c
@@ -19,7 +19,6 @@
 #include <linux/serial_reg.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/irc-regs.h>
 #include <asm/timer-regs.h>
 #include <asm/gdb-stub.h>
diff --git a/arch/frv/kernel/gdb-stub.c b/arch/frv/kernel/gdb-stub.c
index a6d5381..bbe78b0 100644
--- a/arch/frv/kernel/gdb-stub.c
+++ b/arch/frv/kernel/gdb-stub.c
@@ -126,7 +126,6 @@
 
 #include <asm/asm-offsets.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/gdb-stub.h>
 
 #define LEDS(x) do { /* *(u32*)0xe1200004 = ~(x); mb(); */ } while(0)
diff --git a/arch/frv/kernel/irq-mb93091.c b/arch/frv/kernel/irq-mb93091.c
index 9afc2ea..2cc327a 100644
--- a/arch/frv/kernel/irq-mb93091.c
+++ b/arch/frv/kernel/irq-mb93091.c
@@ -20,7 +20,6 @@
 #include <linux/bitops.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/irc-regs.h>
diff --git a/arch/frv/kernel/irq-mb93093.c b/arch/frv/kernel/irq-mb93093.c
index 4d4ad09..95e4eb4 100644
--- a/arch/frv/kernel/irq-mb93093.c
+++ b/arch/frv/kernel/irq-mb93093.c
@@ -20,7 +20,6 @@
 #include <linux/bitops.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/irc-regs.h>
diff --git a/arch/frv/kernel/irq-mb93493.c b/arch/frv/kernel/irq-mb93493.c
index 4d034c7..ba648da 100644
--- a/arch/frv/kernel/irq-mb93493.c
+++ b/arch/frv/kernel/irq-mb93493.c
@@ -20,7 +20,6 @@
 #include <linux/bitops.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/irq.h>
 #include <asm/irc-regs.h>
diff --git a/arch/frv/kernel/irq.c b/arch/frv/kernel/irq.c
index 3facbc2..2239346 100644
--- a/arch/frv/kernel/irq.c
+++ b/arch/frv/kernel/irq.c
@@ -28,7 +28,6 @@
 #include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/delay.h>
diff --git a/arch/frv/kernel/process.c b/arch/frv/kernel/process.c
index 3901df1..8b6df6f 100644
--- a/arch/frv/kernel/process.c
+++ b/arch/frv/kernel/process.c
@@ -28,7 +28,6 @@
 
 #include <asm/asm-offsets.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/setup.h>
 #include <asm/pgtable.h>
 #include <asm/tlb.h>
diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index 9d68f7f..3987ff8 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -26,7 +26,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/unistd.h>
 
diff --git a/arch/frv/kernel/traps.c b/arch/frv/kernel/traps.c
index 1d2dfe6..5cfd142 100644
--- a/arch/frv/kernel/traps.c
+++ b/arch/frv/kernel/traps.c
@@ -23,7 +23,6 @@
 #include <asm/asm-offsets.h>
 #include <asm/setup.h>
 #include <asm/fpu.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/siginfo.h>
diff --git a/arch/frv/mm/fault.c b/arch/frv/mm/fault.c
index a325d57..331c1e2 100644
--- a/arch/frv/mm/fault.c
+++ b/arch/frv/mm/fault.c
@@ -20,7 +20,6 @@
 #include <linux/ptrace.h>
 #include <linux/hardirq.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/gdb-stub.h>
diff --git a/arch/frv/mm/init.c b/arch/frv/mm/init.c
index fbe5f0d..a19effc 100644
--- a/arch/frv/mm/init.c
+++ b/arch/frv/mm/init.c
@@ -33,7 +33,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/virtconvert.h>
 #include <asm/sections.h>
diff --git a/arch/frv/mm/kmap.c b/arch/frv/mm/kmap.c
index fb78be3..e9217e6 100644
--- a/arch/frv/mm/kmap.c
+++ b/arch/frv/mm/kmap.c
@@ -21,7 +21,6 @@
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #undef DEBUG
 
diff --git a/arch/h8300/include/asm/atomic.h b/arch/h8300/include/asm/atomic.h
index f5a38c1..fbc8517 100644
--- a/arch/h8300/include/asm/atomic.h
+++ b/arch/h8300/include/asm/atomic.h
@@ -13,7 +13,6 @@
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic_set(v, i)	(((v)->counter) = i)
 
-#include <asm/system.h>
 #include <linux/kernel.h>
 
 static __inline__ int atomic_add_return(int i, atomic_t *v)
diff --git a/arch/h8300/include/asm/bitops.h b/arch/h8300/include/asm/bitops.h
index e856c1b..eb34e0c 100644
--- a/arch/h8300/include/asm/bitops.h
+++ b/arch/h8300/include/asm/bitops.h
@@ -7,7 +7,6 @@
  */
 
 #include <linux/compiler.h>
-#include <asm/system.h>
 
 #ifdef __KERNEL__
 
diff --git a/arch/h8300/kernel/irq.c b/arch/h8300/kernel/irq.c
index 1f67fed..2fa8ac7 100644
--- a/arch/h8300/kernel/irq.c
+++ b/arch/h8300/kernel/irq.c
@@ -16,7 +16,6 @@
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/io.h>
 #include <asm/setup.h>
diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
index 933bd38..c5d0ba9 100644
--- a/arch/h8300/kernel/process.c
+++ b/arch/h8300/kernel/process.c
@@ -38,7 +38,6 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/setup.h>
 #include <asm/pgtable.h>
diff --git a/arch/h8300/kernel/ptrace.c b/arch/h8300/kernel/ptrace.c
index 497fa89..748cf65 100644
--- a/arch/h8300/kernel/ptrace.c
+++ b/arch/h8300/kernel/ptrace.c
@@ -27,7 +27,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/signal.h>
 
diff --git a/arch/h8300/kernel/traps.c b/arch/h8300/kernel/traps.c
index dfa05bd..7833aa3 100644
--- a/arch/h8300/kernel/traps.c
+++ b/arch/h8300/kernel/traps.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/bug.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/page.h>
diff --git a/arch/h8300/mm/fault.c b/arch/h8300/mm/fault.c
index 1d092ab..4725359 100644
--- a/arch/h8300/mm/fault.c
+++ b/arch/h8300/mm/fault.c
@@ -17,7 +17,6 @@
 #include <linux/kernel.h>
 #include <linux/ptrace.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 
 /*
diff --git a/arch/h8300/mm/init.c b/arch/h8300/mm/init.c
index 7cc3380..973369c 100644
--- a/arch/h8300/mm/init.c
+++ b/arch/h8300/mm/init.c
@@ -36,7 +36,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 #undef DEBUG
 
diff --git a/arch/h8300/mm/kmap.c b/arch/h8300/mm/kmap.c
index 944a502..f79edcd 100644
--- a/arch/h8300/mm/kmap.c
+++ b/arch/h8300/mm/kmap.c
@@ -19,7 +19,6 @@
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #undef DEBUG
 
diff --git a/arch/h8300/mm/memory.c b/arch/h8300/mm/memory.c
index 5552ddf..06e3646 100644
--- a/arch/h8300/mm/memory.c
+++ b/arch/h8300/mm/memory.c
@@ -26,7 +26,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/io.h>
 
diff --git a/arch/hexagon/include/asm/bitops.h b/arch/hexagon/include/asm/bitops.h
index d23461e..4caa649 100644
--- a/arch/hexagon/include/asm/bitops.h
+++ b/arch/hexagon/include/asm/bitops.h
@@ -24,7 +24,6 @@
 
 #include <linux/compiler.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/atomic.h>
 
 #ifdef __KERNEL__
diff --git a/arch/hexagon/kernel/ptrace.c b/arch/hexagon/kernel/ptrace.c
index bea3f08..32342de 100644
--- a/arch/hexagon/kernel/ptrace.c
+++ b/arch/hexagon/kernel/ptrace.c
@@ -29,7 +29,6 @@
 #include <linux/regset.h>
 #include <linux/user.h>
 
-#include <asm/system.h>
 #include <asm/user.h>
 
 static int genregs_get(struct task_struct *target,
diff --git a/arch/hexagon/kernel/vm_events.c b/arch/hexagon/kernel/vm_events.c
index 986a081..591fc1b 100644
--- a/arch/hexagon/kernel/vm_events.c
+++ b/arch/hexagon/kernel/vm_events.c
@@ -22,7 +22,6 @@
 #include <asm/registers.h>
 #include <linux/irq.h>
 #include <linux/hardirq.h>
-#include <asm/system.h>
 
 /*
  * show_regs - print pt_regs structure
diff --git a/arch/ia64/dig/setup.c b/arch/ia64/dig/setup.c
index 9196b33..cdce2e2 100644
--- a/arch/ia64/dig/setup.c
+++ b/arch/ia64/dig/setup.c
@@ -22,7 +22,6 @@
 
 #include <asm/io.h>
 #include <asm/machvec.h>
-#include <asm/system.h>
 
 void __init
 dig_setup (char **cmdline_p)
diff --git a/arch/ia64/hp/sim/boot/bootloader.c b/arch/ia64/hp/sim/boot/bootloader.c
index c5e9baa..28f4b23 100644
--- a/arch/ia64/hp/sim/boot/bootloader.c
+++ b/arch/ia64/hp/sim/boot/bootloader.c
@@ -20,7 +20,6 @@ struct task_struct;	/* forward declaration for elf.h */
 #include <asm/pal.h>
 #include <asm/pgtable.h>
 #include <asm/sal.h>
-#include <asm/system.h>
 
 #include "ssc.h"
 
diff --git a/arch/ia64/hp/sim/simeth.c b/arch/ia64/hp/sim/simeth.c
index 47afcc6..be8ddc5 100644
--- a/arch/ia64/hp/sim/simeth.c
+++ b/arch/ia64/hp/sim/simeth.c
@@ -20,7 +20,6 @@
 #include <linux/skbuff.h>
 #include <linux/notifier.h>
 #include <linux/bitops.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/hpsim.h>
 
diff --git a/arch/ia64/include/asm/acpi.h b/arch/ia64/include/asm/acpi.h
index a06dfb1..301609c 100644
--- a/arch/ia64/include/asm/acpi.h
+++ b/arch/ia64/include/asm/acpi.h
@@ -32,7 +32,6 @@
 
 #include <linux/init.h>
 #include <linux/numa.h>
-#include <asm/system.h>
 #include <asm/numa.h>
 
 #define COMPILER_DEPENDENT_INT64	long
diff --git a/arch/ia64/include/asm/atomic.h b/arch/ia64/include/asm/atomic.h
index 3fad89e..7d91166 100644
--- a/arch/ia64/include/asm/atomic.h
+++ b/arch/ia64/include/asm/atomic.h
@@ -15,7 +15,6 @@
 #include <linux/types.h>
 
 #include <asm/intrinsics.h>
-#include <asm/system.h>
 
 
 #define ATOMIC_INIT(i)		((atomic_t) { (i) })
diff --git a/arch/ia64/include/asm/futex.h b/arch/ia64/include/asm/futex.h
index 8428525..0ab82cc 100644
--- a/arch/ia64/include/asm/futex.h
+++ b/arch/ia64/include/asm/futex.h
@@ -4,7 +4,6 @@
 #include <linux/futex.h>
 #include <linux/uaccess.h>
 #include <asm/errno.h>
-#include <asm/system.h>
 
 #define __futex_atomic_op1(insn, ret, oldval, uaddr, oparg) \
 do {									\
diff --git a/arch/ia64/include/asm/io.h b/arch/ia64/include/asm/io.h
index e5a6c35..2c26321 100644
--- a/arch/ia64/include/asm/io.h
+++ b/arch/ia64/include/asm/io.h
@@ -71,7 +71,6 @@ extern unsigned int num_io_spaces;
 #include <asm/intrinsics.h>
 #include <asm/machvec.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm-generic/iomap.h>
 
 /*
diff --git a/arch/ia64/include/asm/pgtable.h b/arch/ia64/include/asm/pgtable.h
index 1a97af3..815810c 100644
--- a/arch/ia64/include/asm/pgtable.h
+++ b/arch/ia64/include/asm/pgtable.h
@@ -16,7 +16,6 @@
 #include <asm/mman.h>
 #include <asm/page.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/types.h>
 
 #define IA64_MAX_PHYS_BITS	50	/* max. number of physical address bits (architected) */
diff --git a/arch/ia64/include/asm/sal.h b/arch/ia64/include/asm/sal.h
index d19ddba..e504f38 100644
--- a/arch/ia64/include/asm/sal.h
+++ b/arch/ia64/include/asm/sal.h
@@ -40,7 +40,6 @@
 #include <linux/efi.h>
 
 #include <asm/pal.h>
-#include <asm/system.h>
 #include <asm/fpu.h>
 
 extern spinlock_t sal_lock;
diff --git a/arch/ia64/include/asm/sn/pda.h b/arch/ia64/include/asm/sn/pda.h
index 1c5108d..22ae358 100644
--- a/arch/ia64/include/asm/sn/pda.h
+++ b/arch/ia64/include/asm/sn/pda.h
@@ -10,7 +10,6 @@
 
 #include <linux/cache.h>
 #include <asm/percpu.h>
-#include <asm/system.h>
 
 
 /*
diff --git a/arch/ia64/include/asm/spinlock.h b/arch/ia64/include/asm/spinlock.h
index b77768d..54ff557 100644
--- a/arch/ia64/include/asm/spinlock.h
+++ b/arch/ia64/include/asm/spinlock.h
@@ -15,7 +15,6 @@
 
 #include <linux/atomic.h>
 #include <asm/intrinsics.h>
-#include <asm/system.h>
 
 #define arch_spin_lock_init(x)			((x)->lock = 0)
 
diff --git a/arch/ia64/include/asm/uv/uv.h b/arch/ia64/include/asm/uv/uv.h
index 61b5bdf..8f6cbaa 100644
--- a/arch/ia64/include/asm/uv/uv.h
+++ b/arch/ia64/include/asm/uv/uv.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_IA64_UV_UV_H
 #define _ASM_IA64_UV_UV_H
 
-#include <asm/system.h>
 #include <asm/sn/simulator.h>
 
 static inline int is_uv_system(void)
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index 5207035..93c6488 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -50,7 +50,6 @@
 #include <asm/iosapic.h>
 #include <asm/machvec.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/numa.h>
 #include <asm/sal.h>
 #include <asm/cyclone.h>
diff --git a/arch/ia64/kernel/fsys.S b/arch/ia64/kernel/fsys.S
index 331d42b..f15d860 100644
--- a/arch/ia64/kernel/fsys.S
+++ b/arch/ia64/kernel/fsys.S
@@ -21,7 +21,6 @@
 #include <asm/thread_info.h>
 #include <asm/sal.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/unistd.h>
 
 #include "entry.h"
diff --git a/arch/ia64/kernel/gate.S b/arch/ia64/kernel/gate.S
index 245d3e1..d3b33c9 100644
--- a/arch/ia64/kernel/gate.S
+++ b/arch/ia64/kernel/gate.S
@@ -11,7 +11,6 @@
 #include <asm/errno.h>
 #include <asm/asm-offsets.h>
 #include <asm/sigcontext.h>
-#include <asm/system.h>
 #include <asm/unistd.h>
 #include "paravirt_inst.h"
 
diff --git a/arch/ia64/kernel/gate.lds.S b/arch/ia64/kernel/gate.lds.S
index d32b085..5f90a86 100644
--- a/arch/ia64/kernel/gate.lds.S
+++ b/arch/ia64/kernel/gate.lds.S
@@ -6,7 +6,6 @@
  */
 
 
-#include <asm/system.h>
 #include "paravirt_patchlist.h"
 
 SECTIONS
diff --git a/arch/ia64/kernel/head.S b/arch/ia64/kernel/head.S
index 17a9fba..629a250 100644
--- a/arch/ia64/kernel/head.S
+++ b/arch/ia64/kernel/head.S
@@ -30,7 +30,6 @@
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/mca_asm.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index b0f9afe..ef4b5d8 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -98,7 +98,6 @@
 #include <asm/machvec.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 
 #undef DEBUG_INTERRUPT_ROUTING
 
diff --git a/arch/ia64/kernel/irq_ia64.c b/arch/ia64/kernel/irq_ia64.c
index 782c3a35..08113b1 100644
--- a/arch/ia64/kernel/irq_ia64.c
+++ b/arch/ia64/kernel/irq_ia64.c
@@ -39,7 +39,6 @@
 #include <asm/hw_irq.h>
 #include <asm/machvec.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 
 #ifdef CONFIG_PERFMON
diff --git a/arch/ia64/kernel/ivt.S b/arch/ia64/kernel/ivt.S
index d93e396..fa25689 100644
--- a/arch/ia64/kernel/ivt.S
+++ b/arch/ia64/kernel/ivt.S
@@ -54,7 +54,6 @@
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/thread_info.h>
 #include <asm/unistd.h>
 #include <asm/errno.h>
diff --git a/arch/ia64/kernel/machvec.c b/arch/ia64/kernel/machvec.c
index d41a40e..f5a1e52 100644
--- a/arch/ia64/kernel/machvec.c
+++ b/arch/ia64/kernel/machvec.c
@@ -1,7 +1,6 @@
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <asm/machvec.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_IA64_GENERIC
 
diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index 84fb405..9198a79 100644
--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -92,7 +92,6 @@
 #include <asm/meminit.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/sal.h>
 #include <asm/mca.h>
 #include <asm/kexec.h>
diff --git a/arch/ia64/kernel/mca_drv.c b/arch/ia64/kernel/mca_drv.c
index 09b4d68..1c2e894 100644
--- a/arch/ia64/kernel/mca_drv.c
+++ b/arch/ia64/kernel/mca_drv.c
@@ -28,7 +28,6 @@
 #include <asm/machvec.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/sal.h>
 #include <asm/mca.h>
 
diff --git a/arch/ia64/kernel/patch.c b/arch/ia64/kernel/patch.c
index 68a1311..1cf0917 100644
--- a/arch/ia64/kernel/patch.c
+++ b/arch/ia64/kernel/patch.c
@@ -11,7 +11,6 @@
 #include <asm/patch.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/unistd.h>
 
 /*
diff --git a/arch/ia64/kernel/pci-dma.c b/arch/ia64/kernel/pci-dma.c
index eb11757..7cdc89b 100644
--- a/arch/ia64/kernel/pci-dma.c
+++ b/arch/ia64/kernel/pci-dma.c
@@ -12,7 +12,6 @@
 #include <asm/machvec.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/system.h>
 
 #ifdef CONFIG_INTEL_IOMMU
 
diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index b2c65e0..9d0fd7d 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -49,7 +49,6 @@
 #include <asm/perfmon.h>
 #include <asm/processor.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/delay.h>
 
diff --git a/arch/ia64/kernel/ptrace.c b/arch/ia64/kernel/ptrace.c
index dad9166..4265ff6 100644
--- a/arch/ia64/kernel/ptrace.c
+++ b/arch/ia64/kernel/ptrace.c
@@ -26,7 +26,6 @@
 #include <asm/processor.h>
 #include <asm/ptrace_offsets.h>
 #include <asm/rse.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/unwind.h>
 #ifdef CONFIG_PERFMON
diff --git a/arch/ia64/kernel/setup.c b/arch/ia64/kernel/setup.c
index cd57d73..c45e6dd 100644
--- a/arch/ia64/kernel/setup.c
+++ b/arch/ia64/kernel/setup.c
@@ -59,7 +59,6 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/unistd.h>
 #include <asm/hpsim.h>
diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
index 0bd537b..e27f925 100644
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -44,7 +44,6 @@
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/sal.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/unistd.h>
 #include <asm/mca.h>
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index 5590979..fb7927b 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -55,7 +55,6 @@
 #include <asm/processor.h>
 #include <asm/ptrace.h>
 #include <asm/sal.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/unistd.h>
 #include <asm/sn/arch.h>
diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 43920de..aa94bdd 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -29,7 +29,6 @@
 #include <asm/ptrace.h>
 #include <asm/sal.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 
 #include "fsyscall_gtod_data.h"
 
diff --git a/arch/ia64/kernel/uncached.c b/arch/ia64/kernel/uncached.c
index 6a867dc..a96bcf8 100644
--- a/arch/ia64/kernel/uncached.c
+++ b/arch/ia64/kernel/uncached.c
@@ -23,7 +23,6 @@
 #include <linux/gfp.h>
 #include <asm/page.h>
 #include <asm/pal.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <linux/atomic.h>
 #include <asm/tlbflush.h>
diff --git a/arch/ia64/kernel/unwind.c b/arch/ia64/kernel/unwind.c
index fed6afa..8f66195 100644
--- a/arch/ia64/kernel/unwind.c
+++ b/arch/ia64/kernel/unwind.c
@@ -41,7 +41,6 @@
 #include <asm/ptrace_offsets.h>
 #include <asm/rse.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "entry.h"
diff --git a/arch/ia64/kernel/vmlinux.lds.S b/arch/ia64/kernel/vmlinux.lds.S
index 53c0ba0..0ccb28f 100644
--- a/arch/ia64/kernel/vmlinux.lds.S
+++ b/arch/ia64/kernel/vmlinux.lds.S
@@ -1,7 +1,6 @@
 
 #include <asm/cache.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 
 #include <asm-generic/vmlinux.lds.h>
diff --git a/arch/ia64/mm/fault.c b/arch/ia64/mm/fault.c
index 20b3593..02d29c2 100644
--- a/arch/ia64/mm/fault.c
+++ b/arch/ia64/mm/fault.c
@@ -14,7 +14,6 @@
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 extern int die(char *, struct pt_regs *, long);
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 13df239d..0eab454 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -30,7 +30,6 @@
 #include <asm/pgalloc.h>
 #include <asm/sal.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/tlb.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
diff --git a/arch/ia64/oprofile/backtrace.c b/arch/ia64/oprofile/backtrace.c
index f7b7989..6a219a9 100644
--- a/arch/ia64/oprofile/backtrace.c
+++ b/arch/ia64/oprofile/backtrace.c
@@ -14,7 +14,6 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 
 /*
  * For IA64 we need to perform a complex little dance to get both
diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index f82f5d4..9462792 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -24,7 +24,6 @@
 
 #include <asm/machvec.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/sal.h>
 #include <asm/smp.h>
diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index 77db0b5..cc2667e 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -33,7 +33,6 @@
 #include <asm/io.h>
 #include <asm/sal.h>
 #include <asm/machvec.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/vga.h>
 #include <asm/sn/arch.h>
diff --git a/arch/ia64/sn/kernel/sn2/prominfo_proc.c b/arch/ia64/sn/kernel/sn2/prominfo_proc.c
index e633288..20b88cb 100644
--- a/arch/ia64/sn/kernel/sn2/prominfo_proc.c
+++ b/arch/ia64/sn/kernel/sn2/prominfo_proc.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
 #include <linux/nodemask.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/sn/sn_sal.h>
 #include <asm/sn/sn_cpuid.h>
diff --git a/arch/ia64/sn/kernel/sn2/sn2_smp.c b/arch/ia64/sn/kernel/sn2/sn2_smp.c
index e884ba4..68c8454 100644
--- a/arch/ia64/sn/kernel/sn2/sn2_smp.c
+++ b/arch/ia64/sn/kernel/sn2/sn2_smp.c
@@ -26,7 +26,6 @@
 #include <asm/processor.h>
 #include <asm/irq.h>
 #include <asm/sal.h>
-#include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/io.h>
 #include <asm/smp.h>
diff --git a/arch/ia64/sn/kernel/sn2/timer.c b/arch/ia64/sn/kernel/sn2/timer.c
index 0f8844e..abab8f9 100644
--- a/arch/ia64/sn/kernel/sn2/timer.c
+++ b/arch/ia64/sn/kernel/sn2/timer.c
@@ -14,7 +14,6 @@
 #include <linux/clocksource.h>
 
 #include <asm/hw_irq.h>
-#include <asm/system.h>
 #include <asm/timex.h>
 
 #include <asm/sn/leds.h>
diff --git a/arch/ia64/sn/kernel/tiocx.c b/arch/ia64/sn/kernel/tiocx.c
index c1bd1cf..26aeccb 100644
--- a/arch/ia64/sn/kernel/tiocx.c
+++ b/arch/ia64/sn/kernel/tiocx.c
@@ -14,7 +14,6 @@
 #include <linux/capability.h>
 #include <linux/device.h>
 #include <linux/delay.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/sn/sn_sal.h>
 #include <asm/sn/addrs.h>
diff --git a/arch/ia64/xen/xensetup.S b/arch/ia64/xen/xensetup.S
index b820ed0..e29519e 100644
--- a/arch/ia64/xen/xensetup.S
+++ b/arch/ia64/xen/xensetup.S
@@ -7,7 +7,6 @@
 #include <asm/processor.h>
 #include <asm/asmmacro.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/paravirt.h>
 #include <asm/xen/privop.h>
 #include <linux/elfnote.h>
diff --git a/arch/m32r/include/asm/atomic.h b/arch/m32r/include/asm/atomic.h
index 1e7f29f..c80b519 100644
--- a/arch/m32r/include/asm/atomic.h
+++ b/arch/m32r/include/asm/atomic.h
@@ -11,7 +11,6 @@
 
 #include <linux/types.h>
 #include <asm/assembler.h>
-#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff --git a/arch/m32r/include/asm/bitops.h b/arch/m32r/include/asm/bitops.h
index 6300f22..87cd5beb 100644
--- a/arch/m32r/include/asm/bitops.h
+++ b/arch/m32r/include/asm/bitops.h
@@ -17,7 +17,6 @@
 
 #include <linux/compiler.h>
 #include <asm/assembler.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/types.h>
 
diff --git a/arch/m32r/include/asm/local.h b/arch/m32r/include/asm/local.h
index 734bca8..4045db3 100644
--- a/arch/m32r/include/asm/local.h
+++ b/arch/m32r/include/asm/local.h
@@ -12,7 +12,6 @@
 
 #include <linux/percpu.h>
 #include <asm/assembler.h>
-#include <asm/system.h>
 #include <asm/local.h>
 
 /*
diff --git a/arch/m32r/kernel/ptrace.c b/arch/m32r/kernel/ptrace.c
index 2074375..4c03361 100644
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -29,7 +29,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/mmu_context.h>
 
diff --git a/arch/m32r/kernel/traps.c b/arch/m32r/kernel/traps.c
index ee6a919..3bcb207 100644
--- a/arch/m32r/kernel/traps.c
+++ b/arch/m32r/kernel/traps.c
@@ -18,7 +18,6 @@
 #include <asm/page.h>
 #include <asm/processor.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/arch/m32r/mm/fault-nommu.c b/arch/m32r/mm/fault-nommu.c
index 888aab1..80f18cc 100644
--- a/arch/m32r/mm/fault-nommu.c
+++ b/arch/m32r/mm/fault-nommu.c
@@ -22,7 +22,6 @@
 #include <linux/vt_kern.h>              /* For unblank_screen() */
 
 #include <asm/m32r.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff --git a/arch/m32r/mm/fault.c b/arch/m32r/mm/fault.c
index 2c9aeb4..3cdfa9c 100644
--- a/arch/m32r/mm/fault.c
+++ b/arch/m32r/mm/fault.c
@@ -26,7 +26,6 @@
 #include <linux/module.h>
 
 #include <asm/m32r.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/m32r/platforms/m32104ut/setup.c b/arch/m32r/platforms/m32104ut/setup.c
index 34671d3..e2dd778 100644
--- a/arch/m32r/platforms/m32104ut/setup.c
+++ b/arch/m32r/platforms/m32104ut/setup.c
@@ -13,7 +13,6 @@
 #include <linux/init.h>
 #include <linux/device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/m32700ut/setup.c b/arch/m32r/platforms/m32700ut/setup.c
index 1053e1c..9a4ba8a 100644
--- a/arch/m32r/platforms/m32700ut/setup.c
+++ b/arch/m32r/platforms/m32700ut/setup.c
@@ -16,7 +16,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/mappi/setup.c b/arch/m32r/platforms/mappi/setup.c
index 35130ac..767d2f4 100644
--- a/arch/m32r/platforms/mappi/setup.c
+++ b/arch/m32r/platforms/mappi/setup.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/mappi2/setup.c b/arch/m32r/platforms/mappi2/setup.c
index f3ed6b6..76d665a 100644
--- a/arch/m32r/platforms/mappi2/setup.c
+++ b/arch/m32r/platforms/mappi2/setup.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/mappi3/setup.c b/arch/m32r/platforms/mappi3/setup.c
index 2408e35..a3646d4 100644
--- a/arch/m32r/platforms/mappi3/setup.c
+++ b/arch/m32r/platforms/mappi3/setup.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/oaks32r/setup.c b/arch/m32r/platforms/oaks32r/setup.c
index 83b46b0..f8373c0 100644
--- a/arch/m32r/platforms/oaks32r/setup.c
+++ b/arch/m32r/platforms/oaks32r/setup.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/opsput/setup.c b/arch/m32r/platforms/opsput/setup.c
index 3266070..cd01704 100644
--- a/arch/m32r/platforms/opsput/setup.c
+++ b/arch/m32r/platforms/opsput/setup.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m32r/platforms/usrv/setup.c b/arch/m32r/platforms/usrv/setup.c
index 0c7a1e8..dcde0ec 100644
--- a/arch/m32r/platforms/usrv/setup.c
+++ b/arch/m32r/platforms/usrv/setup.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/m32r.h>
 #include <asm/io.h>
 
diff --git a/arch/m68k/amiga/amisound.c b/arch/m68k/amiga/amisound.c
index 61e5c54..2559eef 100644
--- a/arch/m68k/amiga/amisound.c
+++ b/arch/m68k/amiga/amisound.c
@@ -14,7 +14,6 @@
 #include <linux/string.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/amigahw.h>
 
 static unsigned short *snd_data;
diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index b95a451..ee01b7a 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -29,7 +29,6 @@
 
 #include <asm/bootinfo.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
diff --git a/arch/m68k/apollo/config.c b/arch/m68k/apollo/config.c
index 8d3eafa..0a30406 100644
--- a/arch/m68k/apollo/config.c
+++ b/arch/m68k/apollo/config.c
@@ -9,7 +9,6 @@
 
 #include <asm/setup.h>
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/apollohw.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 8048e1b..783d8f0 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -42,7 +42,6 @@
 #include <linux/seq_file.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #include <asm/atarihw.h>
diff --git a/arch/m68k/atari/atasound.c b/arch/m68k/atari/atasound.c
index d266fe8..1c1181e 100644
--- a/arch/m68k/atari/atasound.c
+++ b/arch/m68k/atari/atasound.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 
 #include <asm/atarihw.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
 #include <asm/atariints.h>
diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
index c4ac15c..d8eb327 100644
--- a/arch/m68k/atari/config.c
+++ b/arch/m68k/atari/config.c
@@ -39,7 +39,6 @@
 #include <asm/atarihw.h>
 #include <asm/atariints.h>
 #include <asm/atari_stram.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/hwtest.h>
 #include <asm/io.h>
diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index 8128647..0bf850a 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -28,7 +28,6 @@
 #include <linux/bcd.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/bvme6000/rtc.c b/arch/m68k/bvme6000/rtc.c
index 1c4d4c7..cf12a17 100644
--- a/arch/m68k/bvme6000/rtc.c
+++ b/arch/m68k/bvme6000/rtc.c
@@ -21,7 +21,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/setup.h>
 
 /*
diff --git a/arch/m68k/hp300/time.c b/arch/m68k/hp300/time.c
index c87fe69..29a71be 100644
--- a/arch/m68k/hp300/time.c
+++ b/arch/m68k/hp300/time.c
@@ -15,7 +15,6 @@
 #include <asm/machdep.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/blinken.h>
 
diff --git a/arch/m68k/include/asm/atomic.h b/arch/m68k/include/asm/atomic.h
index 4eba796..bf7c809 100644
--- a/arch/m68k/include/asm/atomic.h
+++ b/arch/m68k/include/asm/atomic.h
@@ -2,7 +2,6 @@
 #define __ARCH_M68K_ATOMIC__
 
 #include <linux/types.h>
-#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff --git a/arch/m68k/include/asm/sun3xflop.h b/arch/m68k/include/asm/sun3xflop.h
index 32c45f8..95231e2 100644
--- a/arch/m68k/include/asm/sun3xflop.h
+++ b/arch/m68k/include/asm/sun3xflop.h
@@ -11,7 +11,6 @@
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/sun3x.h>
 
diff --git a/arch/m68k/kernel/ints.c b/arch/m68k/kernel/ints.c
index 74fefac..6b32b64 100644
--- a/arch/m68k/kernel/ints.c
+++ b/arch/m68k/kernel/ints.c
@@ -15,7 +15,6 @@
 #include <linux/init.h>
 
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/traps.h>
 #include <asm/page.h>
diff --git a/arch/m68k/kernel/irq.c b/arch/m68k/kernel/irq.c
index c73988c..9ab4f55 100644
--- a/arch/m68k/kernel/irq.c
+++ b/arch/m68k/kernel/irq.c
@@ -15,7 +15,6 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/seq_file.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 asmlinkage void do_IRQ(int irq, struct pt_regs *regs)
diff --git a/arch/m68k/kernel/process_mm.c b/arch/m68k/kernel/process_mm.c
index 099283e..a4ecd7e 100644
--- a/arch/m68k/kernel/process_mm.c
+++ b/arch/m68k/kernel/process_mm.c
@@ -27,7 +27,6 @@
 #include <linux/mqueue.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/setup.h>
diff --git a/arch/m68k/kernel/process_no.c b/arch/m68k/kernel/process_no.c
index 5e1078c..2b24672 100644
--- a/arch/m68k/kernel/process_no.c
+++ b/arch/m68k/kernel/process_no.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/setup.h>
diff --git a/arch/m68k/kernel/ptrace_mm.c b/arch/m68k/kernel/ptrace_mm.c
index 7bc999b..e853a05 100644
--- a/arch/m68k/kernel/ptrace_mm.c
+++ b/arch/m68k/kernel/ptrace_mm.c
@@ -23,7 +23,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 
 /*
diff --git a/arch/m68k/kernel/ptrace_no.c b/arch/m68k/kernel/ptrace_no.c
index 6709fb7..92851d8 100644
--- a/arch/m68k/kernel/ptrace_no.c
+++ b/arch/m68k/kernel/ptrace_no.c
@@ -23,7 +23,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 
 /*
diff --git a/arch/m68k/kernel/traps.c b/arch/m68k/kernel/traps.c
index daaa918..388e5cc 100644
--- a/arch/m68k/kernel/traps.c
+++ b/arch/m68k/kernel/traps.c
@@ -32,7 +32,6 @@
 
 #include <asm/setup.h>
 #include <asm/fpu.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/traps.h>
 #include <asm/pgalloc.h>
diff --git a/arch/m68k/kernel/vectors.c b/arch/m68k/kernel/vectors.c
index 147b03f..322c977 100644
--- a/arch/m68k/kernel/vectors.c
+++ b/arch/m68k/kernel/vectors.c
@@ -25,7 +25,6 @@
 
 #include <asm/setup.h>
 #include <asm/fpu.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 /* assembler routines */
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index f60ff5f..96fa6ed 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -30,7 +30,6 @@
 #include <asm/setup.h>
 #include <asm/bootinfo.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
diff --git a/arch/m68k/mac/misc.c b/arch/m68k/mac/misc.c
index eb91555..5e08555 100644
--- a/arch/m68k/mac/misc.c
+++ b/arch/m68k/mac/misc.c
@@ -19,7 +19,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/rtc.h>
-#include <asm/system.h>
 #include <asm/segment.h>
 #include <asm/setup.h>
 #include <asm/macintosh.h>
diff --git a/arch/m68k/mm/fault.c b/arch/m68k/mm/fault.c
index 2db6099..6b020a8 100644
--- a/arch/m68k/mm/fault.c
+++ b/arch/m68k/mm/fault.c
@@ -13,7 +13,6 @@
 
 #include <asm/setup.h>
 #include <asm/traps.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 
diff --git a/arch/m68k/mm/init_mm.c b/arch/m68k/mm/init_mm.c
index 89f3b20..f77f258 100644
--- a/arch/m68k/mm/init_mm.c
+++ b/arch/m68k/mm/init_mm.c
@@ -23,7 +23,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
diff --git a/arch/m68k/mm/init_no.c b/arch/m68k/mm/init_no.c
index 1e33d39..345ec0d 100644
--- a/arch/m68k/mm/init_no.c
+++ b/arch/m68k/mm/init_no.c
@@ -36,7 +36,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 
 /*
diff --git a/arch/m68k/mm/kmap.c b/arch/m68k/mm/kmap.c
index 1cc2bed..568cfad 100644
--- a/arch/m68k/mm/kmap.c
+++ b/arch/m68k/mm/kmap.c
@@ -20,7 +20,6 @@
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #undef DEBUG
 
diff --git a/arch/m68k/mm/memory.c b/arch/m68k/mm/memory.c
index a5dbb74..250b8b7 100644
--- a/arch/m68k/mm/memory.c
+++ b/arch/m68k/mm/memory.c
@@ -17,7 +17,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/machdep.h>
 
diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index 8b3db1c..0dafa69 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -24,7 +24,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
 #include <asm/dma.h>
diff --git a/arch/m68k/mm/sun3mmu.c b/arch/m68k/mm/sun3mmu.c
index 1b902db..e080406 100644
--- a/arch/m68k/mm/sun3mmu.c
+++ b/arch/m68k/mm/sun3mmu.c
@@ -21,7 +21,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
 
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 5de924e..a41c091 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -26,7 +26,6 @@
 #include <linux/interrupt.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index c3fb3bd..b6d7d8a 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -29,7 +29,6 @@
 #include <linux/module.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/mvme16x/rtc.c b/arch/m68k/mvme16x/rtc.c
index 39c79eb..6ef7a81 100644
--- a/arch/m68k/mvme16x/rtc.c
+++ b/arch/m68k/mvme16x/rtc.c
@@ -20,7 +20,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/setup.h>
 
 /*
diff --git a/arch/m68k/platform/68328/config.c b/arch/m68k/platform/68328/config.c
index d70bf26..856d945 100644
--- a/arch/m68k/platform/68328/config.c
+++ b/arch/m68k/platform/68328/config.c
@@ -17,7 +17,6 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/MC68328.h>
 #if defined(CONFIG_PILOT) || defined(CONFIG_INIT_LCD)
diff --git a/arch/m68k/platform/68328/timers.c b/arch/m68k/platform/68328/timers.c
index f267886..2b4c912 100644
--- a/arch/m68k/platform/68328/timers.c
+++ b/arch/m68k/platform/68328/timers.c
@@ -21,7 +21,6 @@
 #include <linux/irq.h>
 #include <linux/clocksource.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/MC68VZ328.h>
diff --git a/arch/m68k/platform/68360/config.c b/arch/m68k/platform/68360/config.c
index 9dd5bca..624dafc 100644
--- a/arch/m68k/platform/68360/config.c
+++ b/arch/m68k/platform/68360/config.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/m68360.h>
diff --git a/arch/m68k/platform/68EZ328/config.c b/arch/m68k/platform/68EZ328/config.c
index 1be1a16..080ad05 100644
--- a/arch/m68k/platform/68EZ328/config.c
+++ b/arch/m68k/platform/68EZ328/config.c
@@ -15,7 +15,6 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/MC68EZ328.h>
diff --git a/arch/m68k/platform/68VZ328/config.c b/arch/m68k/platform/68VZ328/config.c
index eabaabe..ef4ceda 100644
--- a/arch/m68k/platform/68VZ328/config.c
+++ b/arch/m68k/platform/68VZ328/config.c
@@ -21,7 +21,6 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
 #include <asm/MC68VZ328.h>
diff --git a/arch/m68k/q40/config.c b/arch/m68k/q40/config.c
index ad10fec..4c346ec 100644
--- a/arch/m68k/q40/config.c
+++ b/arch/m68k/q40/config.c
@@ -28,7 +28,6 @@
 #include <asm/io.h>
 #include <asm/rtc.h>
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
diff --git a/arch/m68k/q40/q40ints.c b/arch/m68k/q40/q40ints.c
index 2b88849..513f9bb 100644
--- a/arch/m68k/q40/q40ints.c
+++ b/arch/m68k/q40/q40ints.c
@@ -18,7 +18,6 @@
 #include <linux/irq.h>
 
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #include <asm/q40_master.h>
diff --git a/arch/m68k/sun3/intersil.c b/arch/m68k/sun3/intersil.c
index 0116d20..94fe801 100644
--- a/arch/m68k/sun3/intersil.c
+++ b/arch/m68k/sun3/intersil.c
@@ -14,7 +14,6 @@
 #include <linux/rtc.h>
 
 #include <asm/errno.h>
-#include <asm/system.h>
 #include <asm/rtc.h>
 #include <asm/intersil.h>
 
diff --git a/arch/m68k/sun3/mmu_emu.c b/arch/m68k/sun3/mmu_emu.c
index 94f81ec..8edc510 100644
--- a/arch/m68k/sun3/mmu_emu.c
+++ b/arch/m68k/sun3/mmu_emu.c
@@ -17,7 +17,6 @@
 
 #include <asm/setup.h>
 #include <asm/traps.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/arch/m68k/sun3/prom/console.c b/arch/m68k/sun3/prom/console.c
index 2bcb6e4..e923643 100644
--- a/arch/m68k/sun3/prom/console.c
+++ b/arch/m68k/sun3/prom/console.c
@@ -10,7 +10,6 @@
 #include <linux/sched.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <linux/string.h>
 
 /* Non blocking get character from console input device, returns -1
diff --git a/arch/m68k/sun3x/config.c b/arch/m68k/sun3x/config.c
index fc599fa..dd306c8 100644
--- a/arch/m68k/sun3x/config.c
+++ b/arch/m68k/sun3x/config.c
@@ -12,7 +12,6 @@
 #include <linux/console.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/irq.h>
 #include <asm/sun3xprom.h>
diff --git a/arch/m68k/sun3x/time.c b/arch/m68k/sun3x/time.c
index 536a04a..1d0a724 100644
--- a/arch/m68k/sun3x/time.c
+++ b/arch/m68k/sun3x/time.c
@@ -15,7 +15,6 @@
 
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/sun3x.h>
 #include <asm/sun3ints.h>
diff --git a/arch/microblaze/kernel/cpu/pvr.c b/arch/microblaze/kernel/cpu/pvr.c
index 488c1ed..3a749d5 100644
--- a/arch/microblaze/kernel/cpu/pvr.c
+++ b/arch/microblaze/kernel/cpu/pvr.c
@@ -12,7 +12,6 @@
 
 #include <linux/kernel.h>
 #include <linux/compiler.h>
-#include <asm/system.h>
 #include <asm/exceptions.h>
 #include <asm/pvr.h>
 
diff --git a/arch/microblaze/kernel/microblaze_ksyms.c b/arch/microblaze/kernel/microblaze_ksyms.c
index 49faeb4..bb4907c 100644
--- a/arch/microblaze/kernel/microblaze_ksyms.c
+++ b/arch/microblaze/kernel/microblaze_ksyms.c
@@ -18,7 +18,6 @@
 #include <asm/cacheflush.h>
 #include <linux/io.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <linux/ftrace.h>
 #include <linux/uaccess.h>
 
diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
index 7dcb5bf..831c960 100644
--- a/arch/microblaze/kernel/process.c
+++ b/arch/microblaze/kernel/process.c
@@ -13,7 +13,6 @@
 #include <linux/pm.h>
 #include <linux/tick.h>
 #include <linux/bitops.h>
-#include <asm/system.h>
 #include <asm/pgalloc.h>
 #include <asm/uaccess.h> /* for USER_DS macros */
 #include <asm/cacheflush.h>
diff --git a/arch/microblaze/kernel/prom.c b/arch/microblaze/kernel/prom.c
index 80d314e..4a764cc 100644
--- a/arch/microblaze/kernel/prom.c
+++ b/arch/microblaze/kernel/prom.c
@@ -36,7 +36,6 @@
 #include <asm/processor.h>
 #include <asm/irq.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <asm/mmu.h>
 #include <asm/pgtable.h>
 #include <asm/sections.h>
diff --git a/arch/microblaze/kernel/setup.c b/arch/microblaze/kernel/setup.c
index 604cd9d..a953788 100644
--- a/arch/microblaze/kernel/setup.c
+++ b/arch/microblaze/kernel/setup.c
@@ -30,7 +30,6 @@
 #include <asm/entry.h>
 #include <asm/cpuinfo.h>
 
-#include <asm/system.h>
 #include <asm/prom.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/microblaze/kernel/timer.c b/arch/microblaze/kernel/timer.c
index 3cb0bf6..d3a38ec 100644
--- a/arch/microblaze/kernel/timer.c
+++ b/arch/microblaze/kernel/timer.c
@@ -27,7 +27,6 @@
 #include <asm/setup.h>
 #include <asm/prom.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <linux/cnt32_to_63.h>
 
 #ifdef CONFIG_SELFMOD_TIMER
diff --git a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
index ba034d4..5541ac5 100644
--- a/arch/microblaze/kernel/traps.c
+++ b/arch/microblaze/kernel/traps.c
@@ -15,7 +15,6 @@
 #include <linux/debug_locks.h>
 
 #include <asm/exceptions.h>
-#include <asm/system.h>
 #include <asm/unwind.h>
 
 void trap_init(void)
diff --git a/arch/microblaze/lib/memcpy.c b/arch/microblaze/lib/memcpy.c
index 52746e7..fe9c53f 100644
--- a/arch/microblaze/lib/memcpy.c
+++ b/arch/microblaze/lib/memcpy.c
@@ -30,7 +30,6 @@
 #include <linux/module.h>
 
 #include <linux/string.h>
-#include <asm/system.h>
 
 #ifdef __HAVE_ARCH_MEMCPY
 #ifndef CONFIG_OPT_LIB_FUNCTION
diff --git a/arch/microblaze/mm/fault.c b/arch/microblaze/mm/fault.c
index ae97d2c..c38a265 100644
--- a/arch/microblaze/mm/fault.c
+++ b/arch/microblaze/mm/fault.c
@@ -33,7 +33,6 @@
 #include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/exceptions.h>
 
diff --git a/arch/mips/cavium-octeon/setup.c b/arch/mips/cavium-octeon/setup.c
index 260b273..d3a9f012 100644
--- a/arch/mips/cavium-octeon/setup.c
+++ b/arch/mips/cavium-octeon/setup.c
@@ -24,7 +24,6 @@
 #include <asm/processor.h>
 #include <asm/reboot.h>
 #include <asm/smp-ops.h>
-#include <asm/system.h>
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/cavium-octeon/smp.c b/arch/mips/cavium-octeon/smp.c
index b1535fe..599a6db 100644
--- a/arch/mips/cavium-octeon/smp.c
+++ b/arch/mips/cavium-octeon/smp.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/time.h>
 
 #include <asm/octeon/octeon.h>
diff --git a/arch/mips/dec/ecc-berr.c b/arch/mips/dec/ecc-berr.c
index 7abce66..5abf4e8 100644
--- a/arch/mips/dec/ecc-berr.c
+++ b/arch/mips/dec/ecc-berr.c
@@ -24,7 +24,6 @@
 #include <asm/irq_regs.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #include <asm/dec/ecc.h>
diff --git a/arch/mips/dec/kn01-berr.c b/arch/mips/dec/kn01-berr.c
index 94d23b4..44d8a87 100644
--- a/arch/mips/dec/kn01-berr.c
+++ b/arch/mips/dec/kn01-berr.c
@@ -22,7 +22,6 @@
 #include <asm/mipsregs.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/uaccess.h>
 
diff --git a/arch/mips/dec/kn02xa-berr.c b/arch/mips/dec/kn02xa-berr.c
index 07ca540..ebb73c5 100644
--- a/arch/mips/dec/kn02xa-berr.c
+++ b/arch/mips/dec/kn02xa-berr.c
@@ -21,7 +21,6 @@
 #include <asm/addrspace.h>
 #include <asm/irq_regs.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #include <asm/dec/kn02ca.h>
diff --git a/arch/mips/dec/wbflush.c b/arch/mips/dec/wbflush.c
index 925c052..46ef903 100644
--- a/arch/mips/dec/wbflush.c
+++ b/arch/mips/dec/wbflush.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/wbflush.h>
 
 static void wbflush_kn01(void);
diff --git a/arch/mips/emma/markeins/irq.c b/arch/mips/emma/markeins/irq.c
index 7798887..b5f0825 100644
--- a/arch/mips/emma/markeins/irq.c
+++ b/arch/mips/emma/markeins/irq.c
@@ -27,7 +27,6 @@
 #include <linux/delay.h>
 
 #include <asm/irq_cpu.h>
-#include <asm/system.h>
 #include <asm/mipsregs.h>
 #include <asm/addrspace.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/fw/arc/misc.c b/arch/mips/fw/arc/misc.c
index 29627fb..7cf80ca 100644
--- a/arch/mips/fw/arc/misc.c
+++ b/arch/mips/fw/arc/misc.c
@@ -17,7 +17,6 @@
 #include <asm/fw/arc/types.h>
 #include <asm/sgialib.h>
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 
 VOID
 ArcHalt(VOID)
diff --git a/arch/mips/include/asm/atomic.h b/arch/mips/include/asm/atomic.h
index 1d93f81..802fa4d 100644
--- a/arch/mips/include/asm/atomic.h
+++ b/arch/mips/include/asm/atomic.h
@@ -19,7 +19,6 @@
 #include <asm/barrier.h>
 #include <asm/cpu-features.h>
 #include <asm/war.h>
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)    { (i) }
 
diff --git a/arch/mips/include/asm/dma.h b/arch/mips/include/asm/dma.h
index 2d47da6..f5097f6 100644
--- a/arch/mips/include/asm/dma.h
+++ b/arch/mips/include/asm/dma.h
@@ -15,7 +15,6 @@
 #include <asm/io.h>			/* need byte IO */
 #include <linux/spinlock.h>		/* And spinlocks */
 #include <linux/delay.h>
-#include <asm/system.h>
 
 
 #ifdef HAVE_REALLY_SLOW_DMA_CONTROLLER
diff --git a/arch/mips/include/asm/mach-au1x00/au1000_dma.h b/arch/mips/include/asm/mach-au1x00/au1000_dma.h
index 59f5b55..ba4cf0e 100644
--- a/arch/mips/include/asm/mach-au1x00/au1000_dma.h
+++ b/arch/mips/include/asm/mach-au1x00/au1000_dma.h
@@ -33,7 +33,6 @@
 #include <linux/io.h>		/* need byte IO */
 #include <linux/spinlock.h>	/* And spinlocks */
 #include <linux/delay.h>
-#include <asm/system.h>
 
 #define NUM_AU1000_DMA_CHANNELS	8
 
diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index c104f10..9903e4b 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -19,7 +19,6 @@
 #include <asm/cpu-info.h>
 #include <asm/mipsregs.h>
 #include <asm/prefetch.h>
-#include <asm/system.h>
 
 /*
  * Return current * instruction pointer ("program counter").
diff --git a/arch/mips/include/asm/txx9/jmr3927.h b/arch/mips/include/asm/txx9/jmr3927.h
index a409c44..8808d7f 100644
--- a/arch/mips/include/asm/txx9/jmr3927.h
+++ b/arch/mips/include/asm/txx9/jmr3927.h
@@ -12,7 +12,6 @@
 
 #include <asm/txx9/tx3927.h>
 #include <asm/addrspace.h>
-#include <asm/system.h>
 #include <asm/txx9irq.h>
 
 /* CS */
diff --git a/arch/mips/kernel/cpu-bugs64.c b/arch/mips/kernel/cpu-bugs64.c
index f305ca1..bc794f7 100644
--- a/arch/mips/kernel/cpu-bugs64.c
+++ b/arch/mips/kernel/cpu-bugs64.c
@@ -16,7 +16,6 @@
 #include <asm/cpu.h>
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 static char bug64hit[] __initdata =
 	"reliable operation impossible!\n%s";
diff --git a/arch/mips/kernel/cpu-probe.c b/arch/mips/kernel/cpu-probe.c
index 0bab464..5099201 100644
--- a/arch/mips/kernel/cpu-probe.c
+++ b/arch/mips/kernel/cpu-probe.c
@@ -22,7 +22,6 @@
 #include <asm/cpu.h>
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 #include <asm/watch.h>
 #include <asm/elf.h>
 #include <asm/spram.h>
diff --git a/arch/mips/kernel/irq-rm7000.c b/arch/mips/kernel/irq-rm7000.c
index a8a8977..b0662cf 100644
--- a/arch/mips/kernel/irq-rm7000.c
+++ b/arch/mips/kernel/irq-rm7000.c
@@ -16,7 +16,6 @@
 
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 static inline void unmask_rm7k_irq(struct irq_data *d)
 {
diff --git a/arch/mips/kernel/irq-rm9000.c b/arch/mips/kernel/irq-rm9000.c
index 38874a4..1282b9a 100644
--- a/arch/mips/kernel/irq-rm9000.c
+++ b/arch/mips/kernel/irq-rm9000.c
@@ -17,7 +17,6 @@
 
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 static inline void unmask_rm9k_irq(struct irq_data *d)
 {
diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
index 7f50318..a5aa43d 100644
--- a/arch/mips/kernel/irq.c
+++ b/arch/mips/kernel/irq.c
@@ -23,7 +23,6 @@
 #include <linux/ftrace.h>
 
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #ifdef CONFIG_KGDB
diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
index 191eb52..972263b 100644
--- a/arch/mips/kernel/irq_cpu.c
+++ b/arch/mips/kernel/irq_cpu.c
@@ -35,7 +35,6 @@
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
-#include <asm/system.h>
 
 static inline void unmask_mips_irq(struct irq_data *d)
 {
diff --git a/arch/mips/kernel/mips-mt.c b/arch/mips/kernel/mips-mt.c
index c23d11f..7f3376b 100644
--- a/arch/mips/kernel/mips-mt.c
+++ b/arch/mips/kernel/mips-mt.c
@@ -13,7 +13,6 @@
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
 #include <asm/mipsmtregs.h>
diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index 7955409..5bfaea8 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -32,7 +32,6 @@
 #include <asm/dsp.h>
 #include <asm/fpu.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/mipsregs.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 7786b60..7c24c29 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -34,7 +34,6 @@
 #include <asm/mipsmtregs.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/bootinfo.h>
 #include <asm/reg.h>
diff --git a/arch/mips/kernel/ptrace32.c b/arch/mips/kernel/ptrace32.c
index 32644b4..a3b0178 100644
--- a/arch/mips/kernel/ptrace32.c
+++ b/arch/mips/kernel/ptrace32.c
@@ -32,7 +32,6 @@
 #include <asm/mipsmtregs.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/bootinfo.h>
 
diff --git a/arch/mips/kernel/rtlx.c b/arch/mips/kernel/rtlx.c
index a9d801d..b8c18dc 100644
--- a/arch/mips/kernel/rtlx.c
+++ b/arch/mips/kernel/rtlx.c
@@ -38,7 +38,6 @@
 #include <linux/atomic.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/vpe.h>
 #include <asm/rtlx.h>
 
diff --git a/arch/mips/kernel/setup.c b/arch/mips/kernel/setup.c
index 058e964..c504b21 100644
--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -31,7 +31,6 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/smp-ops.h>
-#include <asm/system.h>
 #include <asm/prom.h>
 
 struct cpuinfo_mips cpu_data[NR_CPUS] __read_mostly;
diff --git a/arch/mips/kernel/signal32.c b/arch/mips/kernel/signal32.c
index aae9866..e5ee38e 100644
--- a/arch/mips/kernel/signal32.c
+++ b/arch/mips/kernel/signal32.c
@@ -29,7 +29,6 @@
 #include <asm/cacheflush.h>
 #include <asm/sim.h>
 #include <asm/ucontext.h>
-#include <asm/system.h>
 #include <asm/fpu.h>
 #include <asm/war.h>
 #include <asm/vdso.h>
diff --git a/arch/mips/kernel/signal_n32.c b/arch/mips/kernel/signal_n32.c
index ee24d81..ae29e89 100644
--- a/arch/mips/kernel/signal_n32.c
+++ b/arch/mips/kernel/signal_n32.c
@@ -35,7 +35,6 @@
 #include <asm/sim.h>
 #include <asm/uaccess.h>
 #include <asm/ucontext.h>
-#include <asm/system.h>
 #include <asm/fpu.h>
 #include <asm/cpu-features.h>
 #include <asm/war.h>
diff --git a/arch/mips/kernel/smp-bmips.c b/arch/mips/kernel/smp-bmips.c
index d5e950a..ca67356 100644
--- a/arch/mips/kernel/smp-bmips.c
+++ b/arch/mips/kernel/smp-bmips.c
@@ -28,7 +28,6 @@
 #include <asm/time.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/bootinfo.h>
 #include <asm/pmon.h>
 #include <asm/cacheflush.h>
diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
index fe30951..e7e03ec 100644
--- a/arch/mips/kernel/smp-cmp.c
+++ b/arch/mips/kernel/smp-cmp.c
@@ -29,7 +29,6 @@
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
 #include <asm/smp.h>
diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
index ce9e286..ff17868 100644
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -28,7 +28,6 @@
 #include <asm/cacheflush.h>
 #include <asm/cpu.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
 #include <asm/time.h>
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 32c1e95..a37b082 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -38,7 +38,6 @@
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <asm/r4k-timer.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/time.h>
 
diff --git a/arch/mips/kernel/smtc-proc.c b/arch/mips/kernel/smtc-proc.c
index 928a5a6..145771c 100644
--- a/arch/mips/kernel/smtc-proc.c
+++ b/arch/mips/kernel/smtc-proc.c
@@ -11,7 +11,6 @@
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/mmu_context.h>
 #include <asm/mipsregs.h>
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index 0a42ff3..c4f75bb 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -31,7 +31,6 @@
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/hardirq.h>
 #include <asm/hazards.h>
 #include <asm/irq.h>
diff --git a/arch/mips/kernel/spram.c b/arch/mips/kernel/spram.c
index 1821d12..6af08d8 100644
--- a/arch/mips/kernel/spram.c
+++ b/arch/mips/kernel/spram.c
@@ -15,7 +15,6 @@
 
 #include <asm/fpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 #include <asm/r4kcache.h>
 #include <asm/hazards.h>
 
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index d79ae54..cfdaaa4 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -45,7 +45,6 @@
 #include <asm/pgtable.h>
 #include <asm/ptrace.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/tlbdebug.h>
 #include <asm/traps.h>
 #include <asm/uaccess.h>
diff --git a/arch/mips/kernel/unaligned.c b/arch/mips/kernel/unaligned.c
index aedb894..9c58bdf 100644
--- a/arch/mips/kernel/unaligned.c
+++ b/arch/mips/kernel/unaligned.c
@@ -85,7 +85,6 @@
 #include <asm/cop2.h>
 #include <asm/inst.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #define STR(x)  __STR(x)
 #define __STR(x)  #x
diff --git a/arch/mips/kernel/vpe.c b/arch/mips/kernel/vpe.c
index bfa12a4..f6f9152 100644
--- a/arch/mips/kernel/vpe.c
+++ b/arch/mips/kernel/vpe.c
@@ -49,7 +49,6 @@
 #include <asm/cpu.h>
 #include <asm/mips_mt.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/vpe.h>
 #include <asm/kspd.h>
 
diff --git a/arch/mips/lasat/reset.c b/arch/mips/lasat/reset.c
index b1e7a89..e21f0b9 100644
--- a/arch/mips/lasat/reset.c
+++ b/arch/mips/lasat/reset.c
@@ -21,7 +21,6 @@
 #include <linux/pm.h>
 
 #include <asm/reboot.h>
-#include <asm/system.h>
 #include <asm/lasat/lasat.h>
 
 #include "picvue.h"
diff --git a/arch/mips/math-emu/dsemul.c b/arch/mips/math-emu/dsemul.c
index 3c4a8c5..384a3b0 100644
--- a/arch/mips/math-emu/dsemul.c
+++ b/arch/mips/math-emu/dsemul.c
@@ -12,7 +12,6 @@
 #include <asm/uaccess.h>
 #include <asm/branch.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 
 #include <asm/fpu_emulator.h>
diff --git a/arch/mips/mipssim/sim_smtc.c b/arch/mips/mipssim/sim_smtc.c
index 9150639..3c104ab 100644
--- a/arch/mips/mipssim/sim_smtc.c
+++ b/arch/mips/mipssim/sim_smtc.c
@@ -28,7 +28,6 @@
 #include <asm/cpu.h>
 #include <asm/processor.h>
 #include <asm/smtc.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/smtc_ipi.h>
 
diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
index cf7895d..1f9ca07 100644
--- a/arch/mips/mm/c-octeon.c
+++ b/arch/mips/mm/c-octeon.c
@@ -21,7 +21,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/r4kcache.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/war.h>
 
diff --git a/arch/mips/mm/c-r3k.c b/arch/mips/mm/c-r3k.c
index 0765583..031c4c2 100644
--- a/arch/mips/mm/c-r3k.c
+++ b/arch/mips/mm/c-r3k.c
@@ -18,7 +18,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/isadep.h>
 #include <asm/io.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/mm/c-r4k.c b/arch/mips/mm/c-r4k.c
index 4f9eb0b..f62d64f 100644
--- a/arch/mips/mm/c-r4k.c
+++ b/arch/mips/mm/c-r4k.c
@@ -29,7 +29,6 @@
 #include <asm/pgtable.h>
 #include <asm/r4kcache.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/war.h>
 #include <asm/cacheflush.h> /* for run_uncached() */
diff --git a/arch/mips/mm/c-tx39.c b/arch/mips/mm/c-tx39.c
index a43c197c..87d23ca 100644
--- a/arch/mips/mm/c-tx39.c
+++ b/arch/mips/mm/c-tx39.c
@@ -18,7 +18,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/isadep.h>
 #include <asm/io.h>
 #include <asm/bootinfo.h>
diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
index 69ebd58..c14f6df 100644
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -22,7 +22,6 @@
 
 #include <asm/branch.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/highmem.h>		/* For VMALLOC_END */
diff --git a/arch/mips/mm/page.c b/arch/mips/mm/page.c
index 36272f7..cc0b626 100644
--- a/arch/mips/mm/page.c
+++ b/arch/mips/mm/page.c
@@ -22,7 +22,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/prefetch.h>
-#include <asm/system.h>
 #include <asm/bootinfo.h>
 #include <asm/mipsregs.h>
 #include <asm/mmu_context.h>
diff --git a/arch/mips/mm/sc-ip22.c b/arch/mips/mm/sc-ip22.c
index a6bd11f..1eb708e 100644
--- a/arch/mips/mm/sc-ip22.c
+++ b/arch/mips/mm/sc-ip22.c
@@ -12,7 +12,6 @@
 #include <asm/bcache.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/bootinfo.h>
 #include <asm/sgi/ip22.h>
 #include <asm/sgi/mc.h>
diff --git a/arch/mips/mm/sc-mips.c b/arch/mips/mm/sc-mips.c
index 9cca8de..93d937b 100644
--- a/arch/mips/mm/sc-mips.c
+++ b/arch/mips/mm/sc-mips.c
@@ -11,7 +11,6 @@
 #include <asm/cacheops.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/r4kcache.h>
 
diff --git a/arch/mips/mm/sc-r5k.c b/arch/mips/mm/sc-r5k.c
index ae1e533..8d90ff2 100644
--- a/arch/mips/mm/sc-r5k.c
+++ b/arch/mips/mm/sc-r5k.c
@@ -12,7 +12,6 @@
 #include <asm/cacheops.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/r4kcache.h>
 
diff --git a/arch/mips/mm/tlb-r3k.c b/arch/mips/mm/tlb-r3k.c
index ed1fa46..a63d1ed 100644
--- a/arch/mips/mm/tlb-r3k.c
+++ b/arch/mips/mm/tlb-r3k.c
@@ -19,7 +19,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/tlbmisc.h>
 #include <asm/isadep.h>
 #include <asm/io.h>
diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
index 2dc6253..d2572cb 100644
--- a/arch/mips/mm/tlb-r4k.c
+++ b/arch/mips/mm/tlb-r4k.c
@@ -18,7 +18,6 @@
 #include <asm/bootinfo.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/tlbmisc.h>
 
 extern void build_tlb_refill_handler(void);
diff --git a/arch/mips/mm/tlb-r8k.c b/arch/mips/mm/tlb-r8k.c
index 3d95f76..91c2499 100644
--- a/arch/mips/mm/tlb-r8k.c
+++ b/arch/mips/mm/tlb-r8k.c
@@ -17,7 +17,6 @@
 #include <asm/bootinfo.h>
 #include <asm/mmu_context.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 extern void build_tlb_refill_handler(void);
 
diff --git a/arch/mips/mti-malta/malta-init.c b/arch/mips/mti-malta/malta-init.c
index 4b988b9..27a6cdb 100644
--- a/arch/mips/mti-malta/malta-init.c
+++ b/arch/mips/mti-malta/malta-init.c
@@ -26,7 +26,6 @@
 #include <asm/bootinfo.h>
 #include <asm/gt64120.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 #include <asm/smp-ops.h>
 #include <asm/traps.h>
diff --git a/arch/mips/netlogic/common/irq.c b/arch/mips/netlogic/common/irq.c
index 49a4f6c..e52bfcb 100644
--- a/arch/mips/netlogic/common/irq.c
+++ b/arch/mips/netlogic/common/irq.c
@@ -43,7 +43,6 @@
 
 #include <asm/errno.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/mipsregs.h>
 #include <asm/thread_info.h>
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c b/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
index c4fa2d7..2e6f7ca 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_irq_cic.c
@@ -16,7 +16,6 @@
 #include <linux/irq.h>
 
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <msp_cic_int.h>
 #include <msp_regs.h>
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_irq_per.c b/arch/mips/pmc-sierra/msp71xx/msp_irq_per.c
index 98fd009..598b6a6 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_irq_per.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_irq_per.c
@@ -16,7 +16,6 @@
 #include <linux/bitops.h>
 
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <msp_cic_int.h>
 #include <msp_regs.h>
diff --git a/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c b/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
index 5bbcc47..83a1c5e 100644
--- a/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
+++ b/arch/mips/pmc-sierra/msp71xx/msp_irq_slp.c
@@ -16,7 +16,6 @@
 #include <linux/bitops.h>
 
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <msp_slp_int.h>
 #include <msp_regs.h>
diff --git a/arch/mips/pmc-sierra/yosemite/irq.c b/arch/mips/pmc-sierra/yosemite/irq.c
index 25bbbf4..6590812 100644
--- a/arch/mips/pmc-sierra/yosemite/irq.c
+++ b/arch/mips/pmc-sierra/yosemite/irq.c
@@ -44,7 +44,6 @@
 #include <asm/irq.h>
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 #include <asm/titan_dep.h>
 
 /* Hypertransport specific */
diff --git a/arch/mips/pmc-sierra/yosemite/prom.c b/arch/mips/pmc-sierra/yosemite/prom.c
index dcc926e..6a2754c 100644
--- a/arch/mips/pmc-sierra/yosemite/prom.c
+++ b/arch/mips/pmc-sierra/yosemite/prom.c
@@ -20,7 +20,6 @@
 #include <asm/processor.h>
 #include <asm/reboot.h>
 #include <asm/smp-ops.h>
-#include <asm/system.h>
 #include <asm/bootinfo.h>
 #include <asm/pmon.h>
 
diff --git a/arch/mips/powertv/asic/irq_asic.c b/arch/mips/powertv/asic/irq_asic.c
index 7fb97fb..fa9ae95 100644
--- a/arch/mips/powertv/asic/irq_asic.c
+++ b/arch/mips/powertv/asic/irq_asic.c
@@ -17,7 +17,6 @@
 
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <asm/mach-powertv/asic_regs.h>
 
diff --git a/arch/mips/powertv/init.c b/arch/mips/powertv/init.c
index 8355228..1cf5abb 100644
--- a/arch/mips/powertv/init.c
+++ b/arch/mips/powertv/init.c
@@ -26,7 +26,6 @@
 
 #include <asm/bootinfo.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 #include <asm/traps.h>
 
diff --git a/arch/mips/rb532/irq.c b/arch/mips/rb532/irq.c
index 7c6db74..f298430 100644
--- a/arch/mips/rb532/irq.c
+++ b/arch/mips/rb532/irq.c
@@ -42,7 +42,6 @@
 #include <asm/bootinfo.h>
 #include <asm/time.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <asm/mach-rc32434/irq.h>
 #include <asm/mach-rc32434/gpio.h>
diff --git a/arch/mips/sgi-ip22/ip22-berr.c b/arch/mips/sgi-ip22/ip22-berr.c
index 911d399..3f6ccd5 100644
--- a/arch/mips/sgi-ip22/ip22-berr.c
+++ b/arch/mips/sgi-ip22/ip22-berr.c
@@ -9,7 +9,6 @@
 #include <linux/sched.h>
 
 #include <asm/addrspace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/branch.h>
 #include <asm/irq_regs.h>
diff --git a/arch/mips/sgi-ip22/ip22-reset.c b/arch/mips/sgi-ip22/ip22-reset.c
index 45b6694..20363d2 100644
--- a/arch/mips/sgi-ip22/ip22-reset.c
+++ b/arch/mips/sgi-ip22/ip22-reset.c
@@ -18,7 +18,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/reboot.h>
 #include <asm/sgialib.h>
 #include <asm/sgi/ioc.h>
diff --git a/arch/mips/sgi-ip22/ip28-berr.c b/arch/mips/sgi-ip22/ip28-berr.c
index 88c684e..0626555 100644
--- a/arch/mips/sgi-ip22/ip28-berr.c
+++ b/arch/mips/sgi-ip22/ip28-berr.c
@@ -11,7 +11,6 @@
 #include <linux/seq_file.h>
 
 #include <asm/addrspace.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/branch.h>
 #include <asm/irq_regs.h>
diff --git a/arch/mips/sgi-ip27/ip27-irq.c b/arch/mips/sgi-ip27/ip27-irq.c
index 2364223..69a939a 100644
--- a/arch/mips/sgi-ip27/ip27-irq.c
+++ b/arch/mips/sgi-ip27/ip27-irq.c
@@ -27,7 +27,6 @@
 #include <asm/bootinfo.h>
 #include <asm/io.h>
 #include <asm/mipsregs.h>
-#include <asm/system.h>
 
 #include <asm/processor.h>
 #include <asm/pci/bridge.h>
diff --git a/arch/mips/sgi-ip27/ip27-reset.c b/arch/mips/sgi-ip27/ip27-reset.c
index c170761..f347bc6 100644
--- a/arch/mips/sgi-ip27/ip27-reset.c
+++ b/arch/mips/sgi-ip27/ip27-reset.c
@@ -19,7 +19,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/reboot.h>
-#include <asm/system.h>
 #include <asm/sgialib.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/arch.h>
diff --git a/arch/mips/sgi-ip32/ip32-irq.c b/arch/mips/sgi-ip32/ip32-irq.c
index a092860..e7d5054 100644
--- a/arch/mips/sgi-ip32/ip32-irq.c
+++ b/arch/mips/sgi-ip32/ip32-irq.c
@@ -22,7 +22,6 @@
 #include <asm/irq_cpu.h>
 #include <asm/mipsregs.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/ip32/crime.h>
 #include <asm/ip32/mace.h>
diff --git a/arch/mips/sgi-ip32/ip32-reset.c b/arch/mips/sgi-ip32/ip32-reset.c
index 9b95d80..1f823da 100644
--- a/arch/mips/sgi-ip32/ip32-reset.c
+++ b/arch/mips/sgi-ip32/ip32-reset.c
@@ -20,7 +20,6 @@
 #include <asm/addrspace.h>
 #include <asm/irq.h>
 #include <asm/reboot.h>
-#include <asm/system.h>
 #include <asm/wbflush.h>
 #include <asm/ip32/mace.h>
 #include <asm/ip32/crime.h>
diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index 09740d6..215713e 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -27,7 +27,6 @@
 #include <asm/errno.h>
 #include <asm/irq_regs.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <asm/sibyte/bcm1480_regs.h>
diff --git a/arch/mips/sibyte/common/sb_tbprof.c b/arch/mips/sibyte/common/sb_tbprof.c
index 48853ab..e8c4538 100644
--- a/arch/mips/sibyte/common/sb_tbprof.c
+++ b/arch/mips/sibyte/common/sb_tbprof.c
@@ -53,7 +53,6 @@
 #define K_INT_PERF_CNT K_BCM1480_INT_PERF_CNT
 #endif
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #define SBPROF_TB_MAJOR 240
diff --git a/arch/mips/sibyte/sb1250/bus_watcher.c b/arch/mips/sibyte/sb1250/bus_watcher.c
index 45274bd..86e6e54 100644
--- a/arch/mips/sibyte/sb1250/bus_watcher.c
+++ b/arch/mips/sibyte/sb1250/bus_watcher.c
@@ -30,7 +30,6 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/proc_fs.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <asm/sibyte/sb1250.h>
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index 76ee045..340aaf6 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -26,7 +26,6 @@
 
 #include <asm/errno.h>
 #include <asm/signal.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/io.h>
 
diff --git a/arch/mips/sni/reset.c b/arch/mips/sni/reset.c
index 79f8d70..244f942 100644
--- a/arch/mips/sni/reset.c
+++ b/arch/mips/sni/reset.c
@@ -5,7 +5,6 @@
  */
 #include <asm/io.h>
 #include <asm/reboot.h>
-#include <asm/system.h>
 #include <asm/sni.h>
 
 /*
diff --git a/arch/mips/vr41xx/common/irq.c b/arch/mips/vr41xx/common/irq.c
index fad2bef..ae0e4ee 100644
--- a/arch/mips/vr41xx/common/irq.c
+++ b/arch/mips/vr41xx/common/irq.c
@@ -22,7 +22,6 @@
 #include <linux/irq.h>
 
 #include <asm/irq_cpu.h>
-#include <asm/system.h>
 #include <asm/vr41xx/irq.h>
 
 typedef struct irq_cascade {
diff --git a/arch/mips/vr41xx/common/pmu.c b/arch/mips/vr41xx/common/pmu.c
index 692b4e8..9fbf5f0 100644
--- a/arch/mips/vr41xx/common/pmu.c
+++ b/arch/mips/vr41xx/common/pmu.c
@@ -30,7 +30,6 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/reboot.h>
-#include <asm/system.h>
 
 #define PMU_TYPE1_BASE	0x0b0000a0UL
 #define PMU_TYPE1_SIZE	0x0eUL
diff --git a/arch/mn10300/include/asm/dma.h b/arch/mn10300/include/asm/dma.h
index 098df2e..10b77d4 100644
--- a/arch/mn10300/include/asm/dma.h
+++ b/arch/mn10300/include/asm/dma.h
@@ -11,7 +11,6 @@
 #ifndef _ASM_DMA_H
 #define _ASM_DMA_H
 
-#include <asm/system.h>
 #include <linux/spinlock.h>
 #include <asm/io.h>
 #include <linux/delay.h>
diff --git a/arch/mn10300/kernel/entry.S b/arch/mn10300/kernel/entry.S
index 3e3620d..8e11f9f 100644
--- a/arch/mn10300/kernel/entry.S
+++ b/arch/mn10300/kernel/entry.S
@@ -15,7 +15,6 @@
 #include <linux/sys.h>
 #include <linux/linkage.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/irqflags.h>
 #include <asm/thread_info.h>
 #include <asm/intctl-regs.h>
diff --git a/arch/mn10300/kernel/fpu.c b/arch/mn10300/kernel/fpu.c
index bb5fa7d..064fa19 100644
--- a/arch/mn10300/kernel/fpu.c
+++ b/arch/mn10300/kernel/fpu.c
@@ -12,7 +12,6 @@
 #include <asm/fpu.h>
 #include <asm/elf.h>
 #include <asm/exceptions.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_LAZY_SAVE_FPU
 struct task_struct *fpu_state_owner;
diff --git a/arch/mn10300/kernel/gdb-io-serial.c b/arch/mn10300/kernel/gdb-io-serial.c
index f28dc99..df51242 100644
--- a/arch/mn10300/kernel/gdb-io-serial.c
+++ b/arch/mn10300/kernel/gdb-io-serial.c
@@ -18,7 +18,6 @@
 #include <linux/nmi.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/gdb-stub.h>
 #include <asm/exceptions.h>
 #include <asm/serial-regs.h>
diff --git a/arch/mn10300/kernel/gdb-io-ttysm.c b/arch/mn10300/kernel/gdb-io-ttysm.c
index c859cac..caae8ca 100644
--- a/arch/mn10300/kernel/gdb-io-ttysm.c
+++ b/arch/mn10300/kernel/gdb-io-ttysm.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/tty.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/gdb-stub.h>
 #include <asm/exceptions.h>
 #include <unit/clock.h>
diff --git a/arch/mn10300/kernel/gdb-stub.c b/arch/mn10300/kernel/gdb-stub.c
index 522eb8a..a128c57 100644
--- a/arch/mn10300/kernel/gdb-stub.c
+++ b/arch/mn10300/kernel/gdb-stub.c
@@ -130,7 +130,6 @@
 #include <linux/bug.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/gdb-stub.h>
 #include <asm/exceptions.h>
 #include <asm/debugger.h>
diff --git a/arch/mn10300/kernel/mn10300-serial.c b/arch/mn10300/kernel/mn10300-serial.c
index 94901c5..339cef4 100644
--- a/arch/mn10300/kernel/mn10300-serial.c
+++ b/arch/mn10300/kernel/mn10300-serial.c
@@ -36,7 +36,6 @@ static const char serial_revdate[] = "2007-11-06";
 #include <linux/console.h>
 #include <linux/sysrq.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/bitops.h>
diff --git a/arch/mn10300/kernel/mn10300-watchdog.c b/arch/mn10300/kernel/mn10300-watchdog.c
index a45f0c7..db64a71 100644
--- a/arch/mn10300/kernel/mn10300-watchdog.c
+++ b/arch/mn10300/kernel/mn10300-watchdog.c
@@ -18,7 +18,6 @@
 #include <linux/kernel_stat.h>
 #include <linux/nmi.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/intctl-regs.h>
 #include <asm/rtc-regs.h>
diff --git a/arch/mn10300/kernel/process.c b/arch/mn10300/kernel/process.c
index 28eec31..906cd47 100644
--- a/arch/mn10300/kernel/process.c
+++ b/arch/mn10300/kernel/process.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/mmu_context.h>
diff --git a/arch/mn10300/kernel/ptrace.c b/arch/mn10300/kernel/ptrace.c
index 5c0b07e..5bd5851 100644
--- a/arch/mn10300/kernel/ptrace.c
+++ b/arch/mn10300/kernel/ptrace.c
@@ -21,7 +21,6 @@
 #include <linux/tracehook.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cacheflush.h>
 #include <asm/fpu.h>
diff --git a/arch/mn10300/kernel/setup.c b/arch/mn10300/kernel/setup.c
index 9e7a320..33c3bd1 100644
--- a/arch/mn10300/kernel/setup.c
+++ b/arch/mn10300/kernel/setup.c
@@ -26,7 +26,6 @@
 #include <asm/processor.h>
 #include <linux/console.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/setup.h>
 #include <asm/io.h>
 #include <asm/smp.h>
diff --git a/arch/mn10300/kernel/smp-low.S b/arch/mn10300/kernel/smp-low.S
index 72938ce..f1845e9 100644
--- a/arch/mn10300/kernel/smp-low.S
+++ b/arch/mn10300/kernel/smp-low.S
@@ -13,7 +13,6 @@
 #include <linux/sys.h>
 #include <linux/linkage.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/thread_info.h>
 #include <asm/cpu-regs.h>
 #include <proc/smp-regs.h>
diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 9242e9f..910dddf 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -25,7 +25,6 @@
 #include <linux/profile.h>
 #include <linux/smp.h>
 #include <asm/tlbflush.h>
-#include <asm/system.h>
 #include <asm/bitops.h>
 #include <asm/processor.h>
 #include <asm/bug.h>
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index 9220a75..94a9c6d 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -27,7 +27,6 @@
 #include <linux/bug.h>
 #include <linux/irq.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/arch/mn10300/lib/bitops.c b/arch/mn10300/lib/bitops.c
index a66c6cd..37309cd 100644
--- a/arch/mn10300/lib/bitops.c
+++ b/arch/mn10300/lib/bitops.c
@@ -10,7 +10,6 @@
  */
 #include <linux/module.h>
 #include <asm/bitops.h>
-#include <asm/system.h>
 
 /*
  * try flipping a bit using BSET and BCLR
diff --git a/arch/mn10300/mm/fault.c b/arch/mn10300/mm/fault.c
index 0945409..90f346f 100644
--- a/arch/mn10300/mm/fault.c
+++ b/arch/mn10300/mm/fault.c
@@ -24,7 +24,6 @@
 #include <linux/init.h>
 #include <linux/vt_kern.h>		/* For unblank_screen() */
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/hardirq.h>
diff --git a/arch/mn10300/mm/init.c b/arch/mn10300/mm/init.c
index 1380182..e57e5bc 100644
--- a/arch/mn10300/mm/init.c
+++ b/arch/mn10300/mm/init.c
@@ -29,7 +29,6 @@
 #include <linux/gfp.h>
 
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/arch/mn10300/mm/misalignment.c b/arch/mn10300/mm/misalignment.c
index f9bb8cb..b9920b1 100644
--- a/arch/mn10300/mm/misalignment.c
+++ b/arch/mn10300/mm/misalignment.c
@@ -23,7 +23,6 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/arch/mn10300/mm/pgtable.c b/arch/mn10300/mm/pgtable.c
index 450f7ba..4ebf117 100644
--- a/arch/mn10300/mm/pgtable.c
+++ b/arch/mn10300/mm/pgtable.c
@@ -21,7 +21,6 @@
 #include <linux/spinlock.h>
 #include <linux/quicklist.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
diff --git a/arch/mn10300/mm/tlb-smp.c b/arch/mn10300/mm/tlb-smp.c
index 9a77749..3e57faf 100644
--- a/arch/mn10300/mm/tlb-smp.c
+++ b/arch/mn10300/mm/tlb-smp.c
@@ -24,7 +24,6 @@
 #include <linux/profile.h>
 #include <linux/smp.h>
 #include <asm/tlbflush.h>
-#include <asm/system.h>
 #include <asm/bitops.h>
 #include <asm/processor.h>
 #include <asm/bug.h>
diff --git a/arch/mn10300/proc-mn2ws0050/proc-init.c b/arch/mn10300/proc-mn2ws0050/proc-init.c
index fe6e249..ee6d03d 100644
--- a/arch/mn10300/proc-mn2ws0050/proc-init.c
+++ b/arch/mn10300/proc-mn2ws0050/proc-init.c
@@ -15,7 +15,6 @@
 #include <linux/interrupt.h>
 
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/arch/openrisc/kernel/idle.c b/arch/openrisc/kernel/idle.c
index e5fc7887..7d618fe 100644
--- a/arch/openrisc/kernel/idle.c
+++ b/arch/openrisc/kernel/idle.c
@@ -31,7 +31,6 @@
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
index e4209af..55210f3 100644
--- a/arch/openrisc/kernel/process.c
+++ b/arch/openrisc/kernel/process.c
@@ -38,7 +38,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/spr_defs.h>
diff --git a/arch/openrisc/kernel/prom.c b/arch/openrisc/kernel/prom.c
index 3d4478f..5869e3f 100644
--- a/arch/openrisc/kernel/prom.c
+++ b/arch/openrisc/kernel/prom.c
@@ -42,7 +42,6 @@
 #include <asm/processor.h>
 #include <asm/irq.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <asm/mmu.h>
 #include <asm/pgtable.h>
 #include <asm/sections.h>
diff --git a/arch/openrisc/kernel/ptrace.c b/arch/openrisc/kernel/ptrace.c
index 7259047..967d499 100644
--- a/arch/openrisc/kernel/ptrace.c
+++ b/arch/openrisc/kernel/ptrace.c
@@ -33,7 +33,6 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 /*
  * Copy the thread state to a regset that can be interpreted by userspace.
diff --git a/arch/openrisc/kernel/setup.c b/arch/openrisc/kernel/setup.c
index 1422f74..ad2c290 100644
--- a/arch/openrisc/kernel/setup.c
+++ b/arch/openrisc/kernel/setup.c
@@ -41,7 +41,6 @@
 #include <linux/of_platform.h>
 
 #include <asm/segment.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/types.h>
 #include <asm/setup.h>
diff --git a/arch/openrisc/kernel/traps.c b/arch/openrisc/kernel/traps.c
index a4ec44a..52ca32b 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -33,7 +33,6 @@
 #include <linux/kallsyms.h>
 #include <asm/uaccess.h>
 
-#include <asm/system.h>
 #include <asm/segment.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff --git a/arch/openrisc/mm/init.c b/arch/openrisc/mm/init.c
index 359dcb2..1cf3a8a 100644
--- a/arch/openrisc/mm/init.c
+++ b/arch/openrisc/mm/init.c
@@ -33,7 +33,6 @@
 #include <linux/pagemap.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <asm/segment.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff --git a/arch/openrisc/mm/tlb.c b/arch/openrisc/mm/tlb.c
index 56b0b89..683bd4d 100644
--- a/arch/openrisc/mm/tlb.c
+++ b/arch/openrisc/mm/tlb.c
@@ -26,7 +26,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/segment.h>
 #include <asm/tlbflush.h>
 #include <asm/pgtable.h>
diff --git a/arch/parisc/include/asm/atomic.h b/arch/parisc/include/asm/atomic.h
index 4054b31..3ae5607 100644
--- a/arch/parisc/include/asm/atomic.h
+++ b/arch/parisc/include/asm/atomic.h
@@ -6,7 +6,6 @@
 #define _ASM_PARISC_ATOMIC_H_
 
 #include <linux/types.h>
-#include <asm/system.h>
 
 /*
  * Atomic operations that C can't guarantee us.  Useful for
diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index 7213ec9..1f9e484 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -16,7 +16,6 @@
 #include <asm/pdc.h>
 #include <asm/ptrace.h>
 #include <asm/types.h>
-#include <asm/system.h>
 #include <asm/percpu.h>
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/parisc/include/asm/spinlock.h b/arch/parisc/include/asm/spinlock.h
index 74036f4..804aa28 100644
--- a/arch/parisc/include/asm/spinlock.h
+++ b/arch/parisc/include/asm/spinlock.h
@@ -1,7 +1,6 @@
 #ifndef __ASM_SPINLOCK_H
 #define __ASM_SPINLOCK_H
 
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/spinlock_types.h>
 
diff --git a/arch/parisc/include/asm/timex.h b/arch/parisc/include/asm/timex.h
index 3b68d77..2bd51f6 100644
--- a/arch/parisc/include/asm/timex.h
+++ b/arch/parisc/include/asm/timex.h
@@ -6,7 +6,6 @@
 #ifndef _ASMPARISC_TIMEX_H
 #define _ASMPARISC_TIMEX_H
 
-#include <asm/system.h>
 
 #define CLOCK_TICK_RATE	1193180 /* Underlying HZ */
 
diff --git a/arch/parisc/include/asm/uaccess.h b/arch/parisc/include/asm/uaccess.h
index ff4cf9d..9ac0660 100644
--- a/arch/parisc/include/asm/uaccess.h
+++ b/arch/parisc/include/asm/uaccess.h
@@ -5,7 +5,6 @@
  * User space memory access functions
  */
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/cache.h>
 #include <asm/errno.h>
 #include <asm-generic/uaccess-unaligned.h>
diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index 83335f3..9d18189 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -22,7 +22,6 @@
 #include <asm/cache.h>
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/processor.h>
diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index 4896ed0..f65fa48 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -67,7 +67,6 @@
 #include <asm/page.h>
 #include <asm/pdc.h>
 #include <asm/pdcpat.h>
-#include <asm/system.h>
 #include <asm/processor.h>	/* for boot_cpu_data */
 
 static DEFINE_SPINLOCK(pdc_lock);
diff --git a/arch/parisc/kernel/pci.c b/arch/parisc/kernel/pci.c
index 9efd974..4f0cf0c 100644
--- a/arch/parisc/kernel/pci.c
+++ b/arch/parisc/kernel/pci.c
@@ -16,7 +16,6 @@
 #include <linux/types.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/superio.h>
 
 #define DEBUG_RESOURCES 0
diff --git a/arch/parisc/kernel/ptrace.c b/arch/parisc/kernel/ptrace.c
index 2905b1f..857c2f5 100644
--- a/arch/parisc/kernel/ptrace.c
+++ b/arch/parisc/kernel/ptrace.c
@@ -22,7 +22,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/asm-offsets.h>
 
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 32d5884..5006e8e 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -32,7 +32,6 @@
 #include <linux/bitops.h>
 #include <linux/ftrace.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/current.h>
 #include <asm/delay.h>
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index f19e660..45ba99f 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -27,7 +27,6 @@
 #include <linux/bug.h>
 
 #include <asm/assembly.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/arch/parisc/lib/bitops.c b/arch/parisc/lib/bitops.c
index a8bffd8..1871188 100644
--- a/arch/parisc/lib/bitops.c
+++ b/arch/parisc/lib/bitops.c
@@ -8,7 +8,6 @@
 
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
-#include <asm/system.h>
 #include <linux/atomic.h>
 
 #ifdef CONFIG_SMP
diff --git a/arch/powerpc/include/asm/atomic.h b/arch/powerpc/include/asm/atomic.h
index 02e41b5..357a3ef 100644
--- a/arch/powerpc/include/asm/atomic.h
+++ b/arch/powerpc/include/asm/atomic.h
@@ -11,7 +11,6 @@
 #include <linux/compiler.h>
 #include <asm/synch.h>
 #include <asm/asm-compat.h>
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 
diff --git a/arch/powerpc/include/asm/dma.h b/arch/powerpc/include/asm/dma.h
index a7e06e2..2f3511a 100644
--- a/arch/powerpc/include/asm/dma.h
+++ b/arch/powerpc/include/asm/dma.h
@@ -24,7 +24,6 @@
 
 #include <asm/io.h>
 #include <linux/spinlock.h>
-#include <asm/system.h>
 
 #ifndef MAX_DMA_CHANNELS
 #define MAX_DMA_CHANNELS	8
diff --git a/arch/powerpc/include/asm/hw_breakpoint.h b/arch/powerpc/include/asm/hw_breakpoint.h
index 80fd4d2..bc4f7ef 100644
--- a/arch/powerpc/include/asm/hw_breakpoint.h
+++ b/arch/powerpc/include/asm/hw_breakpoint.h
@@ -35,7 +35,6 @@ struct arch_hw_breakpoint {
 
 #include <linux/kdebug.h>
 #include <asm/reg.h>
-#include <asm/system.h>
 
 struct perf_event;
 struct pmu;
diff --git a/arch/powerpc/kernel/align.c b/arch/powerpc/kernel/align.c
index 8184ee9..5aad9aa 100644
--- a/arch/powerpc/kernel/align.c
+++ b/arch/powerpc/kernel/align.c
@@ -21,7 +21,6 @@
 #include <linux/mm.h>
 #include <asm/processor.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/cache.h>
 #include <asm/cputable.h>
 #include <asm/emulated_ops.h>
diff --git a/arch/powerpc/kernel/crash.c b/arch/powerpc/kernel/crash.c
index abef751..b6b6fba 100644
--- a/arch/powerpc/kernel/crash.c
+++ b/arch/powerpc/kernel/crash.c
@@ -27,7 +27,6 @@
 #include <asm/kdump.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/setjmp.h>
 
 /*
diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 0a48bf5..b84d0a4 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -26,7 +26,6 @@
 #include <linux/sysctl.h>
 #include <linux/tick.h>
 
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/time.h>
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 01e2877..422d87c 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -57,7 +57,6 @@
 #include <linux/of_irq.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/irq.h>
diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
index bc47352..e88c643 100644
--- a/arch/powerpc/kernel/kprobes.c
+++ b/arch/powerpc/kernel/kprobes.c
@@ -35,7 +35,6 @@
 #include <asm/cacheflush.h>
 #include <asm/sstep.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_PPC_ADV_DEBUG_REGS
 #define MSR_SINGLESTEP	(MSR_DE)
diff --git a/arch/powerpc/kernel/lparcfg.c b/arch/powerpc/kernel/lparcfg.c
index 578f35f..4190e80 100644
--- a/arch/powerpc/kernel/lparcfg.c
+++ b/arch/powerpc/kernel/lparcfg.c
@@ -31,7 +31,6 @@
 #include <asm/hvcall.h>
 #include <asm/firmware.h>
 #include <asm/rtas.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/prom.h>
 #include <asm/vdso_datapage.h>
diff --git a/arch/powerpc/kernel/ppc_ksyms.c b/arch/powerpc/kernel/ppc_ksyms.c
index d3114a7..298eb9d 100644
--- a/arch/powerpc/kernel/ppc_ksyms.c
+++ b/arch/powerpc/kernel/ppc_ksyms.c
@@ -26,7 +26,6 @@
 #include <linux/cuda.h>
 #include <linux/pmu.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/pci-bridge.h>
 #include <asm/irq.h>
 #include <asm/pmac_feature.h>
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index d817ab0..d76021d 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -41,7 +41,6 @@
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index abe405d..7f4eb14 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -41,7 +41,6 @@
 #include <asm/io.h>
 #include <asm/kdump.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/mmu.h>
 #include <asm/paca.h>
 #include <asm/pgtable.h>
diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_init.c
index eca626e..ba30059 100644
--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -35,7 +35,6 @@
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/mmu.h>
 #include <asm/pgtable.h>
 #include <asm/pci.h>
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 5b43325..4b9f5a3 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -36,7 +36,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/syscalls.h>
diff --git a/arch/powerpc/kernel/ptrace32.c b/arch/powerpc/kernel/ptrace32.c
index 69c4be9..24352e2 100644
--- a/arch/powerpc/kernel/ptrace32.c
+++ b/arch/powerpc/kernel/ptrace32.c
@@ -32,7 +32,6 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 /*
  * does not yet catch signals sent when the child dies.
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 9f843cd..3dc6799 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -33,7 +33,6 @@
 #include <asm/firmware.h>
 #include <asm/page.h>
 #include <asm/param.h>
-#include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/uaccess.h>
 #include <asm/udbg.h>
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 77bb77d..9a25543 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -51,7 +51,6 @@
 #include <asm/btext.h>
 #include <asm/nvram.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/rtas.h>
 #include <asm/iommu.h>
 #include <asm/serial.h>
diff --git a/arch/powerpc/kernel/setup_32.c b/arch/powerpc/kernel/setup_32.c
index ac76108..9825f29 100644
--- a/arch/powerpc/kernel/setup_32.c
+++ b/arch/powerpc/kernel/setup_32.c
@@ -30,7 +30,6 @@
 #include <asm/btext.h>
 #include <asm/machdep.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/pmac_feature.h>
 #include <asm/sections.h>
 #include <asm/nvram.h>
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 4cb8f1e..6d639b2 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -52,7 +52,6 @@
 #include <asm/btext.h>
 #include <asm/nvram.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/rtas.h>
 #include <asm/iommu.h>
 #include <asm/serial.h>
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 46695fe..c7d33c5 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -43,7 +43,6 @@
 #include <asm/machdep.h>
 #include <asm/cputhreads.h>
 #include <asm/cputable.h>
-#include <asm/system.h>
 #include <asm/mpic.h>
 #include <asm/vdso_datapage.h>
 #ifdef CONFIG_PPC64
diff --git a/arch/powerpc/kernel/softemu8xx.c b/arch/powerpc/kernel/softemu8xx.c
index af0e829..29b2f81 100644
--- a/arch/powerpc/kernel/softemu8xx.c
+++ b/arch/powerpc/kernel/softemu8xx.c
@@ -26,7 +26,6 @@
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 /* Eventually we may need a look-up table, but this works for now.
diff --git a/arch/powerpc/kernel/swsusp.c b/arch/powerpc/kernel/swsusp.c
index 641f9ad..3d4c59a 100644
--- a/arch/powerpc/kernel/swsusp.c
+++ b/arch/powerpc/kernel/swsusp.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/sched.h>
-#include <asm/system.h>
 #include <asm/current.h>
 #include <asm/mmu_context.h>
 
diff --git a/arch/powerpc/kernel/swsusp_64.c b/arch/powerpc/kernel/swsusp_64.c
index 168e884..0e899e4 100644
--- a/arch/powerpc/kernel/swsusp_64.c
+++ b/arch/powerpc/kernel/swsusp_64.c
@@ -6,7 +6,6 @@
  * GPLv2
  */
 
-#include <asm/system.h>
 #include <asm/iommu.h>
 #include <linux/irq.h>
 #include <linux/sched.h>
diff --git a/arch/powerpc/kernel/sysfs.c b/arch/powerpc/kernel/sysfs.c
index 883e74c..bf6af0d 100644
--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -18,7 +18,6 @@
 #include <asm/machdep.h>
 #include <asm/smp.h>
 #include <asm/pmc.h>
-#include <asm/system.h>
 
 #include "cacheinfo.h"
 
diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
index c091527..cffc683 100644
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -39,7 +39,6 @@
 #include <asm/emulated_ops.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/machdep.h>
 #include <asm/rtas.h>
diff --git a/arch/powerpc/kernel/vdso.c b/arch/powerpc/kernel/vdso.c
index 7d14bb6..1ce1ec4 100644
--- a/arch/powerpc/kernel/vdso.c
+++ b/arch/powerpc/kernel/vdso.c
@@ -24,7 +24,6 @@
 #include <linux/memblock.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
diff --git a/arch/powerpc/lib/alloc.c b/arch/powerpc/lib/alloc.c
index 13b676c..d8d7806 100644
--- a/arch/powerpc/lib/alloc.c
+++ b/arch/powerpc/lib/alloc.c
@@ -4,7 +4,6 @@
 #include <linux/bootmem.h>
 #include <linux/string.h>
 
-#include <asm/system.h>
 
 void * __init_refok zalloc_maybe_bootmem(size_t size, gfp_t mask)
 {
diff --git a/arch/powerpc/mm/44x_mmu.c b/arch/powerpc/mm/44x_mmu.c
index 388b95e..2c9441e 100644
--- a/arch/powerpc/mm/44x_mmu.c
+++ b/arch/powerpc/mm/44x_mmu.c
@@ -27,7 +27,6 @@
 #include <linux/memblock.h>
 
 #include <asm/mmu.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/cacheflush.h>
 
diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 2f0d1b0..b402733 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -38,7 +38,6 @@
 #include <asm/pgtable.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
 #include <asm/siginfo.h>
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 2d28218..e43a231 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -40,7 +40,6 @@
 #include <asm/mmu_context.h>
 #include <asm/page.h>
 #include <asm/types.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/machdep.h>
 #include <asm/prom.h>
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index 6157be2..01e2db9 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -45,7 +45,6 @@
 #include <asm/btext.h>
 #include <asm/tlb.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/hugetlb.h>
 
 #include "mmu_decl.h"
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index e94b57f..620b7ac 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -61,7 +61,6 @@
 #include <asm/mmzone.h>
 #include <asm/cputable.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/iommu.h>
 #include <asm/abs_addr.h>
 #include <asm/vdso.h>
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 3feefc3..69bad1a 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -24,7 +24,6 @@
 #include <linux/node.h>
 #include <asm/sparsemem.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/smp.h>
 #include <asm/firmware.h>
 #include <asm/paca.h>
diff --git a/arch/powerpc/mm/pgtable_64.c b/arch/powerpc/mm/pgtable_64.c
index ad36ede..249a063 100644
--- a/arch/powerpc/mm/pgtable_64.c
+++ b/arch/powerpc/mm/pgtable_64.c
@@ -51,7 +51,6 @@
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/abs_addr.h>
 #include <asm/firmware.h>
 
diff --git a/arch/powerpc/oprofile/common.c b/arch/powerpc/oprofile/common.c
index d65e68f..7056dc9 100644
--- a/arch/powerpc/oprofile/common.c
+++ b/arch/powerpc/oprofile/common.c
@@ -18,7 +18,6 @@
 #include <linux/smp.h>
 #include <linux/errno.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/pmc.h>
 #include <asm/cputable.h>
 #include <asm/oprofile_impl.h>
diff --git a/arch/powerpc/oprofile/op_model_7450.c b/arch/powerpc/oprofile/op_model_7450.c
index f8d36f9..ff61724 100644
--- a/arch/powerpc/oprofile/op_model_7450.c
+++ b/arch/powerpc/oprofile/op_model_7450.c
@@ -19,7 +19,6 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/page.h>
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index cb515cf..b9589c1 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -34,7 +34,6 @@
 #include <asm/ptrace.h>
 #include <asm/reg.h>
 #include <asm/rtas.h>
-#include <asm/system.h>
 #include <asm/cell-regs.h>
 
 #include "../platforms/cell/interrupt.h"
diff --git a/arch/powerpc/oprofile/op_model_fsl_emb.c b/arch/powerpc/oprofile/op_model_fsl_emb.c
index d4e6507..ccc1daa 100644
--- a/arch/powerpc/oprofile/op_model_fsl_emb.c
+++ b/arch/powerpc/oprofile/op_model_fsl_emb.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/reg_fsl_emb.h>
diff --git a/arch/powerpc/oprofile/op_model_power4.c b/arch/powerpc/oprofile/op_model_power4.c
index e6bec74..95ae77d 100644
--- a/arch/powerpc/oprofile/op_model_power4.c
+++ b/arch/powerpc/oprofile/op_model_power4.c
@@ -14,7 +14,6 @@
 #include <linux/smp.h>
 #include <asm/firmware.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/rtas.h>
diff --git a/arch/powerpc/oprofile/op_model_rs64.c b/arch/powerpc/oprofile/op_model_rs64.c
index a20afe4..9b801b8 100644
--- a/arch/powerpc/oprofile/op_model_rs64.c
+++ b/arch/powerpc/oprofile/op_model_rs64.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/smp.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/cputable.h>
 #include <asm/oprofile_impl.h>
diff --git a/arch/powerpc/platforms/82xx/pq2.c b/arch/powerpc/platforms/82xx/pq2.c
index d111b02..fb94d10 100644
--- a/arch/powerpc/platforms/82xx/pq2.c
+++ b/arch/powerpc/platforms/82xx/pq2.c
@@ -17,7 +17,6 @@
 #include <asm/cpm2.h>
 #include <asm/io.h>
 #include <asm/pci-bridge.h>
-#include <asm/system.h>
 
 #include <platforms/82xx/pq2.h>
 
diff --git a/arch/powerpc/platforms/83xx/km83xx.c b/arch/powerpc/platforms/83xx/km83xx.c
index 65eb792..a266ba8 100644
--- a/arch/powerpc/platforms/83xx/km83xx.c
+++ b/arch/powerpc/platforms/83xx/km83xx.c
@@ -27,7 +27,6 @@
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/83xx/mpc832x_mds.c b/arch/powerpc/platforms/83xx/mpc832x_mds.c
index e36bc61..d440435 100644
--- a/arch/powerpc/platforms/83xx/mpc832x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc832x_mds.c
@@ -26,7 +26,6 @@
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/83xx/mpc834x_itx.c b/arch/powerpc/platforms/83xx/mpc834x_itx.c
index 39849dd..a494fa5 100644
--- a/arch/powerpc/platforms/83xx/mpc834x_itx.c
+++ b/arch/powerpc/platforms/83xx/mpc834x_itx.c
@@ -25,7 +25,6 @@
 #include <linux/root_dev.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/83xx/mpc834x_mds.c b/arch/powerpc/platforms/83xx/mpc834x_mds.c
index 5828d8e..553e793 100644
--- a/arch/powerpc/platforms/83xx/mpc834x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc834x_mds.c
@@ -25,7 +25,6 @@
 #include <linux/root_dev.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/83xx/mpc836x_mds.c b/arch/powerpc/platforms/83xx/mpc836x_mds.c
index ad8e4bc..1b1f6c8 100644
--- a/arch/powerpc/platforms/83xx/mpc836x_mds.c
+++ b/arch/powerpc/platforms/83xx/mpc836x_mds.c
@@ -33,7 +33,6 @@
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/83xx/sbc834x.c b/arch/powerpc/platforms/83xx/sbc834x.c
index 8a81d76..26cb3e9 100644
--- a/arch/powerpc/platforms/83xx/sbc834x.c
+++ b/arch/powerpc/platforms/83xx/sbc834x.c
@@ -27,7 +27,6 @@
 #include <linux/root_dev.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
index 07e3e6c..d517d9e 100644
--- a/arch/powerpc/platforms/85xx/corenet_ds.c
+++ b/arch/powerpc/platforms/85xx/corenet_ds.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/ksi8560.c b/arch/powerpc/platforms/85xx/ksi8560.c
index 20f75d7..8bc1be1 100644
--- a/arch/powerpc/platforms/85xx/ksi8560.c
+++ b/arch/powerpc/platforms/85xx/ksi8560.c
@@ -20,7 +20,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/platforms/85xx/mpc8536_ds.c
index cf26682..77b84d9 100644
--- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
@@ -19,7 +19,6 @@
 #include <linux/of_platform.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ads.c b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
index 3bebb51..f26aae2 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ads.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ads.c
@@ -19,7 +19,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index 40f03da..b43c45b 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -27,7 +27,6 @@
 #include <linux/fsl_devices.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <linux/atomic.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
index eefbb91..4fc46b4 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
@@ -22,7 +22,6 @@
 #include <linux/of_platform.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
index 1d15a0c..53f102c 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
@@ -34,7 +34,6 @@
 #include <linux/phy.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/time.h>
 #include <asm/io.h>
diff --git a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
index ccf520e..fcf3317 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_rdb.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p1010rdb.c b/arch/powerpc/platforms/85xx/p1010rdb.c
index 538bc3f..462066a 100644
--- a/arch/powerpc/platforms/85xx/p1010rdb.c
+++ b/arch/powerpc/platforms/85xx/p1010rdb.c
@@ -16,7 +16,6 @@
 #include <linux/interrupt.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p1023_rds.c b/arch/powerpc/platforms/85xx/p1023_rds.c
index d951e70..01e8da5 100644
--- a/arch/powerpc/platforms/85xx/p1023_rds.c
+++ b/arch/powerpc/platforms/85xx/p1023_rds.c
@@ -22,7 +22,6 @@
 #include <linux/of_platform.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p2041_rdb.c b/arch/powerpc/platforms/85xx/p2041_rdb.c
index eda6ed5..6541fa2 100644
--- a/arch/powerpc/platforms/85xx/p2041_rdb.c
+++ b/arch/powerpc/platforms/85xx/p2041_rdb.c
@@ -16,7 +16,6 @@
 #include <linux/interrupt.h>
 #include <linux/phy.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p3041_ds.c b/arch/powerpc/platforms/85xx/p3041_ds.c
index 96d99a3..f238efa 100644
--- a/arch/powerpc/platforms/85xx/p3041_ds.c
+++ b/arch/powerpc/platforms/85xx/p3041_ds.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <linux/phy.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p4080_ds.c b/arch/powerpc/platforms/85xx/p4080_ds.c
index d1b21d7..c92417d 100644
--- a/arch/powerpc/platforms/85xx/p4080_ds.c
+++ b/arch/powerpc/platforms/85xx/p4080_ds.c
@@ -17,7 +17,6 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/p5020_ds.c b/arch/powerpc/platforms/85xx/p5020_ds.c
index e8cba50..17bef15 100644
--- a/arch/powerpc/platforms/85xx/p5020_ds.c
+++ b/arch/powerpc/platforms/85xx/p5020_ds.c
@@ -18,7 +18,6 @@
 #include <linux/interrupt.h>
 #include <linux/phy.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/sbc8548.c b/arch/powerpc/platforms/85xx/sbc8548.c
index 184a507..3f6b3dc 100644
--- a/arch/powerpc/platforms/85xx/sbc8548.c
+++ b/arch/powerpc/platforms/85xx/sbc8548.c
@@ -30,7 +30,6 @@
 #include <linux/fsl_devices.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
 #include <linux/atomic.h>
diff --git a/arch/powerpc/platforms/85xx/sbc8560.c b/arch/powerpc/platforms/85xx/sbc8560.c
index 940752e..f863c35 100644
--- a/arch/powerpc/platforms/85xx/sbc8560.c
+++ b/arch/powerpc/platforms/85xx/sbc8560.c
@@ -21,7 +21,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/socrates.c b/arch/powerpc/platforms/85xx/socrates.c
index 18f6359..278022a 100644
--- a/arch/powerpc/platforms/85xx/socrates.c
+++ b/arch/powerpc/platforms/85xx/socrates.c
@@ -29,7 +29,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/stx_gp3.c b/arch/powerpc/platforms/85xx/stx_gp3.c
index e9e5234..cc681dc 100644
--- a/arch/powerpc/platforms/85xx/stx_gp3.c
+++ b/arch/powerpc/platforms/85xx/stx_gp3.c
@@ -28,7 +28,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/tqm85xx.c b/arch/powerpc/platforms/85xx/tqm85xx.c
index bf7c89f..b451f54 100644
--- a/arch/powerpc/platforms/85xx/tqm85xx.c
+++ b/arch/powerpc/platforms/85xx/tqm85xx.c
@@ -26,7 +26,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/85xx/xes_mpc85xx.c b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
index 3a69f8b..8085d34 100644
--- a/arch/powerpc/platforms/85xx/xes_mpc85xx.c
+++ b/arch/powerpc/platforms/85xx/xes_mpc85xx.c
@@ -21,7 +21,6 @@
 #include <linux/interrupt.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/gef_ppc9a.c b/arch/powerpc/platforms/86xx/gef_ppc9a.c
index 60ce07e..09e56c3 100644
--- a/arch/powerpc/platforms/86xx/gef_ppc9a.c
+++ b/arch/powerpc/platforms/86xx/gef_ppc9a.c
@@ -24,7 +24,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/gef_sbc310.c b/arch/powerpc/platforms/86xx/gef_sbc310.c
index 3ecee25..e49365a 100644
--- a/arch/powerpc/platforms/86xx/gef_sbc310.c
+++ b/arch/powerpc/platforms/86xx/gef_sbc310.c
@@ -24,7 +24,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/gef_sbc610.c b/arch/powerpc/platforms/86xx/gef_sbc610.c
index 5090d60..4b34bee 100644
--- a/arch/powerpc/platforms/86xx/gef_sbc610.c
+++ b/arch/powerpc/platforms/86xx/gef_sbc610.c
@@ -24,7 +24,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
index 13fa9a6..bbc6152 100644
--- a/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
+++ b/arch/powerpc/platforms/86xx/mpc8610_hpcd.c
@@ -25,7 +25,6 @@
 #include <linux/seq_file.h>
 #include <linux/of.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
index 569262c..3755e61 100644
--- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
+++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
@@ -21,7 +21,6 @@
 #include <linux/of_platform.h>
 #include <linux/memblock.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/86xx/pic.c b/arch/powerpc/platforms/86xx/pic.c
index 52bbfa0..962e6b7 100644
--- a/arch/powerpc/platforms/86xx/pic.c
+++ b/arch/powerpc/platforms/86xx/pic.c
@@ -12,7 +12,6 @@
 #include <linux/interrupt.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/mpic.h>
 #include <asm/i8259.h>
 
diff --git a/arch/powerpc/platforms/86xx/sbc8641d.c b/arch/powerpc/platforms/86xx/sbc8641d.c
index 51c8f33..e7007d0 100644
--- a/arch/powerpc/platforms/86xx/sbc8641d.c
+++ b/arch/powerpc/platforms/86xx/sbc8641d.c
@@ -21,7 +21,6 @@
 #include <linux/seq_file.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/8xx/mpc86xads_setup.c b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
index caaec29..866feff 100644
--- a/arch/powerpc/platforms/8xx/mpc86xads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc86xads_setup.c
@@ -19,7 +19,6 @@
 
 #include <asm/io.h>
 #include <asm/machdep.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/8xx_immap.h>
 #include <asm/cpm1.h>
diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
index 45ed6cd..5d98398 100644
--- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
+++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
@@ -32,7 +32,6 @@
 #include <asm/machdep.h>
 #include <asm/page.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/mpc8xx.h>
 #include <asm/8xx_immap.h>
diff --git a/arch/powerpc/platforms/8xx/tqm8xx_setup.c b/arch/powerpc/platforms/8xx/tqm8xx_setup.c
index 528e00d..8d21ab7 100644
--- a/arch/powerpc/platforms/8xx/tqm8xx_setup.c
+++ b/arch/powerpc/platforms/8xx/tqm8xx_setup.c
@@ -35,7 +35,6 @@
 #include <asm/machdep.h>
 #include <asm/page.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/mpc8xx.h>
 #include <asm/8xx_immap.h>
diff --git a/arch/powerpc/platforms/cell/smp.c b/arch/powerpc/platforms/cell/smp.c
index 4a255cf..49a65e2 100644
--- a/arch/powerpc/platforms/cell/smp.c
+++ b/arch/powerpc/platforms/cell/smp.c
@@ -38,7 +38,6 @@
 #include <asm/machdep.h>
 #include <asm/cputable.h>
 #include <asm/firmware.h>
-#include <asm/system.h>
 #include <asm/rtas.h>
 #include <asm/cputhreads.h>
 
diff --git a/arch/powerpc/platforms/embedded6xx/c2k.c b/arch/powerpc/platforms/embedded6xx/c2k.c
index 8cab573..ebd3963 100644
--- a/arch/powerpc/platforms/embedded6xx/c2k.c
+++ b/arch/powerpc/platforms/embedded6xx/c2k.c
@@ -23,7 +23,6 @@
 
 #include <asm/machdep.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/time.h>
 
 #include <mm/mmu_decl.h>
diff --git a/arch/powerpc/platforms/embedded6xx/holly.c b/arch/powerpc/platforms/embedded6xx/holly.c
index 9cfcf20..a7cd6a2 100644
--- a/arch/powerpc/platforms/embedded6xx/holly.c
+++ b/arch/powerpc/platforms/embedded6xx/holly.c
@@ -28,7 +28,6 @@
 #include <linux/of_platform.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/prom.h>
diff --git a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
index f3350d7..916c6d2 100644
--- a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
+++ b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -32,7 +32,6 @@
 #include <linux/tty.h>
 #include <linux/serial_core.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/prom.h>
diff --git a/arch/powerpc/platforms/embedded6xx/prpmc2800.c b/arch/powerpc/platforms/embedded6xx/prpmc2800.c
index 670035f..d455f08 100644
--- a/arch/powerpc/platforms/embedded6xx/prpmc2800.c
+++ b/arch/powerpc/platforms/embedded6xx/prpmc2800.c
@@ -17,7 +17,6 @@
 
 #include <asm/machdep.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/time.h>
 
 #include <mm/mmu_decl.h>
diff --git a/arch/powerpc/platforms/embedded6xx/storcenter.c b/arch/powerpc/platforms/embedded6xx/storcenter.c
index afa6388..999b0ea 100644
--- a/arch/powerpc/platforms/embedded6xx/storcenter.c
+++ b/arch/powerpc/platforms/embedded6xx/storcenter.c
@@ -16,7 +16,6 @@
 #include <linux/initrd.h>
 #include <linux/of_platform.h>
 
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/prom.h>
 #include <asm/mpic.h>
diff --git a/arch/powerpc/platforms/fsl_uli1575.c b/arch/powerpc/platforms/fsl_uli1575.c
index 8b0c208..64fde05 100644
--- a/arch/powerpc/platforms/fsl_uli1575.c
+++ b/arch/powerpc/platforms/fsl_uli1575.c
@@ -15,7 +15,6 @@
 #include <linux/interrupt.h>
 #include <linux/mc146818rtc.h>
 
-#include <asm/system.h>
 #include <asm/pci-bridge.h>
 
 #define ULI_PIRQA	0x08
diff --git a/arch/powerpc/platforms/iseries/dt.c b/arch/powerpc/platforms/iseries/dt.c
index f0491cc..75adf10 100644
--- a/arch/powerpc/platforms/iseries/dt.c
+++ b/arch/powerpc/platforms/iseries/dt.c
@@ -30,7 +30,6 @@
 #include <asm/lppaca.h>
 #include <asm/cputable.h>
 #include <asm/abs_addr.h>
-#include <asm/system.h>
 #include <asm/iseries/hv_types.h>
 #include <asm/iseries/hv_lp_config.h>
 #include <asm/iseries/hv_call_xm.h>
diff --git a/arch/powerpc/platforms/iseries/lpevents.c b/arch/powerpc/platforms/iseries/lpevents.c
index 202e227..e305d62 100644
--- a/arch/powerpc/platforms/iseries/lpevents.c
+++ b/arch/powerpc/platforms/iseries/lpevents.c
@@ -15,7 +15,6 @@
 #include <linux/proc_fs.h>
 #include <linux/export.h>
 
-#include <asm/system.h>
 #include <asm/paca.h>
 #include <asm/firmware.h>
 #include <asm/iseries/it_lp_queue.h>
diff --git a/arch/powerpc/platforms/iseries/setup.c b/arch/powerpc/platforms/iseries/setup.c
index 8fc6258..3799f2f 100644
--- a/arch/powerpc/platforms/iseries/setup.c
+++ b/arch/powerpc/platforms/iseries/setup.c
@@ -41,7 +41,6 @@
 #include <asm/sections.h>
 #include <asm/iommu.h>
 #include <asm/firmware.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/paca.h>
 #include <asm/cache.h>
diff --git a/arch/powerpc/platforms/iseries/smp.c b/arch/powerpc/platforms/iseries/smp.c
index 02df49f..5100bc7 100644
--- a/arch/powerpc/platforms/iseries/smp.c
+++ b/arch/powerpc/platforms/iseries/smp.c
@@ -39,7 +39,6 @@
 #include <asm/time.h>
 #include <asm/machdep.h>
 #include <asm/cputable.h>
-#include <asm/system.h>
 
 static void smp_iSeries_cause_ipi(int cpu, unsigned long data)
 {
diff --git a/arch/powerpc/platforms/iseries/viopath.c b/arch/powerpc/platforms/iseries/viopath.c
index 40dad08..51c38b0 100644
--- a/arch/powerpc/platforms/iseries/viopath.c
+++ b/arch/powerpc/platforms/iseries/viopath.c
@@ -40,7 +40,6 @@
 #include <linux/interrupt.h>
 #include <linux/completion.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/prom.h>
 #include <asm/firmware.h>
diff --git a/arch/powerpc/platforms/maple/setup.c b/arch/powerpc/platforms/maple/setup.c
index 0bcbfe7..0d05f09 100644
--- a/arch/powerpc/platforms/maple/setup.c
+++ b/arch/powerpc/platforms/maple/setup.c
@@ -47,7 +47,6 @@
 #include <asm/processor.h>
 #include <asm/sections.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/maple/time.c b/arch/powerpc/platforms/maple/time.c
index eac569d..b4a369d 100644
--- a/arch/powerpc/platforms/maple/time.c
+++ b/arch/powerpc/platforms/maple/time.c
@@ -27,7 +27,6 @@
 
 #include <asm/sections.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index 98b7a7c..35fa6d2 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -32,7 +32,6 @@
 #include <linux/gfp.h>
 
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/iommu.h>
 #include <asm/machdep.h>
 #include <asm/mpic.h>
diff --git a/arch/powerpc/platforms/powermac/cpufreq_32.c b/arch/powerpc/platforms/powermac/cpufreq_32.c
index 1fc386a..4d34687 100644
--- a/arch/powerpc/platforms/powermac/cpufreq_32.c
+++ b/arch/powerpc/platforms/powermac/cpufreq_32.c
@@ -33,7 +33,6 @@
 #include <asm/sections.h>
 #include <asm/cputable.h>
 #include <asm/time.h>
-#include <asm/system.h>
 #include <asm/mpic.h>
 #include <asm/keylargo.h>
 
diff --git a/arch/powerpc/platforms/powermac/nvram.c b/arch/powerpc/platforms/powermac/nvram.c
index 54d2271..bf0a2cc 100644
--- a/arch/powerpc/platforms/powermac/nvram.c
+++ b/arch/powerpc/platforms/powermac/nvram.c
@@ -23,7 +23,6 @@
 #include <linux/spinlock.h>
 #include <asm/sections.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/nvram.h>
diff --git a/arch/powerpc/platforms/powermac/setup.c b/arch/powerpc/platforms/powermac/setup.c
index 970ea1d..141f889 100644
--- a/arch/powerpc/platforms/powermac/setup.c
+++ b/arch/powerpc/platforms/powermac/setup.c
@@ -57,7 +57,6 @@
 #include <asm/reg.h>
 #include <asm/sections.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/pci-bridge.h>
diff --git a/arch/powerpc/platforms/powermac/time.c b/arch/powerpc/platforms/powermac/time.c
index 11c9fce..8680bb6 100644
--- a/arch/powerpc/platforms/powermac/time.c
+++ b/arch/powerpc/platforms/powermac/time.c
@@ -26,7 +26,6 @@
 
 #include <asm/sections.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/machdep.h>
diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index 17210c5..3ef4625 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -25,7 +25,6 @@
 #include <asm/machdep.h>
 #include <asm/cputable.h>
 #include <asm/firmware.h>
-#include <asm/system.h>
 #include <asm/rtas.h>
 #include <asm/vdso_datapage.h>
 #include <asm/cputhreads.h>
diff --git a/arch/powerpc/platforms/pseries/dtl.c b/arch/powerpc/platforms/pseries/dtl.c
index 0e86563..0ef143d 100644
--- a/arch/powerpc/platforms/pseries/dtl.c
+++ b/arch/powerpc/platforms/pseries/dtl.c
@@ -25,7 +25,6 @@
 #include <linux/debugfs.h>
 #include <linux/spinlock.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/firmware.h>
 #include <asm/lppaca.h>
diff --git a/arch/powerpc/platforms/pseries/hotplug-cpu.c b/arch/powerpc/platforms/pseries/hotplug-cpu.c
index c986d08..64c97d8 100644
--- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
+++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
@@ -23,7 +23,6 @@
 #include <linux/delay.h>
 #include <linux/sched.h>	/* for idle_task_exit */
 #include <linux/cpu.h>
-#include <asm/system.h>
 #include <asm/prom.h>
 #include <asm/rtas.h>
 #include <asm/firmware.h>
diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
index 085fd3f..f4cf675 100644
--- a/arch/powerpc/platforms/pseries/processor_idle.c
+++ b/arch/powerpc/platforms/pseries/processor_idle.c
@@ -14,7 +14,6 @@
 
 #include <asm/paca.h>
 #include <asm/reg.h>
-#include <asm/system.h>
 #include <asm/machdep.h>
 #include <asm/firmware.h>
 
diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index 086d2ae..9e248ef 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -37,7 +37,6 @@
 #include <linux/bitops.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/irq.h>
diff --git a/arch/powerpc/platforms/pseries/smp.c b/arch/powerpc/platforms/pseries/smp.c
index eadba95..e16bb8d 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -37,7 +37,6 @@
 #include <asm/machdep.h>
 #include <asm/cputable.h>
 #include <asm/firmware.h>
-#include <asm/system.h>
 #include <asm/rtas.h>
 #include <asm/pSeries_reconfig.h>
 #include <asm/mpic.h>
diff --git a/arch/powerpc/platforms/wsp/chroma.c b/arch/powerpc/platforms/wsp/chroma.c
index ca6fa26..8ef53bc 100644
--- a/arch/powerpc/platforms/wsp/chroma.c
+++ b/arch/powerpc/platforms/wsp/chroma.c
@@ -17,7 +17,6 @@
 #include <linux/time.h>
 
 #include <asm/machdep.h>
-#include <asm/system.h>
 #include <asm/udbg.h>
 
 #include "ics.h"
diff --git a/arch/powerpc/platforms/wsp/psr2.c b/arch/powerpc/platforms/wsp/psr2.c
index 0c1ae06..508ec82 100644
--- a/arch/powerpc/platforms/wsp/psr2.c
+++ b/arch/powerpc/platforms/wsp/psr2.c
@@ -17,7 +17,6 @@
 #include <linux/time.h>
 
 #include <asm/machdep.h>
-#include <asm/system.h>
 #include <asm/udbg.h>
 
 #include "ics.h"
diff --git a/arch/powerpc/sysdev/cpm_common.c b/arch/powerpc/sysdev/cpm_common.c
index bf6c7cc..4dd5341 100644
--- a/arch/powerpc/sysdev/cpm_common.c
+++ b/arch/powerpc/sysdev/cpm_common.c
@@ -26,7 +26,6 @@
 
 #include <asm/udbg.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/rheap.h>
 #include <asm/cpm.h>
 
diff --git a/arch/powerpc/sysdev/fsl_soc.c b/arch/powerpc/sysdev/fsl_soc.c
index e8f385f..c449dbd 100644
--- a/arch/powerpc/sysdev/fsl_soc.c
+++ b/arch/powerpc/sysdev/fsl_soc.c
@@ -31,7 +31,6 @@
 #include <linux/fs_enet_pd.h>
 #include <linux/fs_uart_pd.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/arch/powerpc/sysdev/tsi108_dev.c b/arch/powerpc/sysdev/tsi108_dev.c
index 2370e1c..1fd0717 100644
--- a/arch/powerpc/sysdev/tsi108_dev.c
+++ b/arch/powerpc/sysdev/tsi108_dev.c
@@ -22,7 +22,6 @@
 #include <linux/of_net.h>
 #include <asm/tsi108.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/io.h>
 #include <asm/irq.h>
diff --git a/arch/s390/include/asm/atomic.h b/arch/s390/include/asm/atomic.h
index 8517d2a..1a77c09 100644
--- a/arch/s390/include/asm/atomic.h
+++ b/arch/s390/include/asm/atomic.h
@@ -15,7 +15,6 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)  { (i) }
 
diff --git a/arch/s390/include/asm/sigp.h b/arch/s390/include/asm/sigp.h
index 7040b85..06faf6a 100644
--- a/arch/s390/include/asm/sigp.h
+++ b/arch/s390/include/asm/sigp.h
@@ -10,7 +10,6 @@
 #ifndef __ASM_SIGP_H
 #define __ASM_SIGP_H
 
-#include <asm/system.h>
 
 /* Get real cpu address from logical cpu number. */
 extern unsigned short __cpu_logical_map[];
diff --git a/arch/s390/include/asm/smp.h b/arch/s390/include/asm/smp.h
index c32e912..369c4ff 100644
--- a/arch/s390/include/asm/smp.h
+++ b/arch/s390/include/asm/smp.h
@@ -9,7 +9,6 @@
 
 #ifdef CONFIG_SMP
 
-#include <asm/system.h>
 #include <asm/sigp.h>
 
 extern void machine_restart_smp(char *);
diff --git a/arch/s390/kernel/cpcmd.c b/arch/s390/kernel/cpcmd.c
index 3e8b881..e3dd886 100644
--- a/arch/s390/kernel/cpcmd.c
+++ b/arch/s390/kernel/cpcmd.c
@@ -18,7 +18,6 @@
 #include <linux/string.h>
 #include <asm/ebcdic.h>
 #include <asm/cpcmd.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 static DEFINE_SPINLOCK(cpcmd_lock);
diff --git a/arch/s390/kernel/dis.c b/arch/s390/kernel/dis.c
index e2f8475..3221c6f 100644
--- a/arch/s390/kernel/dis.c
+++ b/arch/s390/kernel/dis.c
@@ -24,7 +24,6 @@
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/arch/s390/kernel/machine_kexec.c b/arch/s390/kernel/machine_kexec.c
index 47b168f..da57fbe 100644
--- a/arch/s390/kernel/machine_kexec.c
+++ b/arch/s390/kernel/machine_kexec.c
@@ -18,7 +18,6 @@
 #include <asm/setup.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
-#include <asm/system.h>
 #include <asm/smp.h>
 #include <asm/reset.h>
 #include <asm/ipl.h>
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index e795933..9672514 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -23,7 +23,6 @@
 #include <linux/kprobes.h>
 #include <linux/random.h>
 #include <linux/module.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/irq.h>
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 61f9548..441b5ada 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -26,7 +26,6 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "entry.h"
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 3b2efc8..b7bcd21 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -50,7 +50,6 @@
 
 #include <asm/ipl.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/smp.h>
 #include <asm/mmu_context.h>
 #include <asm/cpcmd.h>
diff --git a/arch/s390/kernel/suspend.c b/arch/s390/kernel/suspend.c
index 47df775..3d8ab80 100644
--- a/arch/s390/kernel/suspend.c
+++ b/arch/s390/kernel/suspend.c
@@ -9,7 +9,6 @@
 #include <linux/pfn.h>
 #include <linux/suspend.h>
 #include <linux/mm.h>
-#include <asm/system.h>
 
 /*
  * References to section boundaries
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 5ce3750..e7ffe8d 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -33,7 +33,6 @@
 #include <linux/kprobes.h>
 #include <linux/bug.h>
 #include <linux/utsname.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index d73630b..8187da6 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -25,7 +25,6 @@
 #include <linux/compat.h>
 #include <asm/asm-offsets.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/mmu.h>
 #include <asm/mmu_context.h>
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d1c44573..78d3f8a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -27,7 +27,6 @@
 #include <asm/lowcore.h>
 #include <asm/pgtable.h>
 #include <asm/nmi.h>
-#include <asm/system.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
 
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index e8fcd92..7620f61 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -32,7 +32,6 @@
 #include <linux/uaccess.h>
 #include <linux/hugetlb.h>
 #include <asm/asm-offsets.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/irq.h>
 #include <asm/mmu_context.h>
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 5023661..2e4870e 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -29,7 +29,6 @@
 #include <linux/export.h>
 #include <linux/gfp.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 1cb8427..6ea70a0 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -12,7 +12,6 @@
 #include <linux/types.h>
 #include <linux/errno.h>
 #include <linux/gfp.h>
-#include <asm/system.h>
 
 /*
  * This function writes to kernel memory bypassing DAT and possible
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 51b0738..373adf6 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -18,7 +18,6 @@
 #include <linux/rcupdate.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
diff --git a/arch/sh/boards/mach-microdev/irq.c b/arch/sh/boards/mach-microdev/irq.c
index 4fb0036..9a8aff3 100644
--- a/arch/sh/boards/mach-microdev/irq.c
+++ b/arch/sh/boards/mach-microdev/irq.c
@@ -12,7 +12,6 @@
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <mach/microdev.h>
 
diff --git a/arch/sh/include/asm/atomic.h b/arch/sh/include/asm/atomic.h
index 63a27db..31f4a9a 100644
--- a/arch/sh/include/asm/atomic.h
+++ b/arch/sh/include/asm/atomic.h
@@ -9,7 +9,6 @@
 
 #include <linux/compiler.h>
 #include <linux/types.h>
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)	( (atomic_t) { (i) } )
 
diff --git a/arch/sh/include/asm/bitops.h b/arch/sh/include/asm/bitops.h
index 90fa3e4..ea8706d 100644
--- a/arch/sh/include/asm/bitops.h
+++ b/arch/sh/include/asm/bitops.h
@@ -7,7 +7,6 @@
 #error only <linux/bitops.h> can be included directly
 #endif
 
-#include <asm/system.h>
 /* For __swab32 */
 #include <asm/byteorder.h>
 
diff --git a/arch/sh/include/asm/futex-irq.h b/arch/sh/include/asm/futex-irq.h
index 6cb9f19..63d3312 100644
--- a/arch/sh/include/asm/futex-irq.h
+++ b/arch/sh/include/asm/futex-irq.h
@@ -1,7 +1,6 @@
 #ifndef __ASM_SH_FUTEX_IRQ_H
 #define __ASM_SH_FUTEX_IRQ_H
 
-#include <asm/system.h>
 
 static inline int atomic_futex_op_xchg_set(int oparg, u32 __user *uaddr,
 					   int *oldval)
diff --git a/arch/sh/include/asm/io.h b/arch/sh/include/asm/io.h
index 28c5aa5..35fc8b0 100644
--- a/arch/sh/include/asm/io.h
+++ b/arch/sh/include/asm/io.h
@@ -14,7 +14,6 @@
  */
 #include <linux/errno.h>
 #include <asm/cache.h>
-#include <asm/system.h>
 #include <asm/addrspace.h>
 #include <asm/machvec.h>
 #include <asm/pgtable.h>
diff --git a/arch/sh/include/asm/ptrace.h b/arch/sh/include/asm/ptrace.h
index 2d3679b..c7b7e1e 100644
--- a/arch/sh/include/asm/ptrace.h
+++ b/arch/sh/include/asm/ptrace.h
@@ -37,7 +37,6 @@
 #include <linux/thread_info.h>
 #include <asm/addrspace.h>
 #include <asm/page.h>
-#include <asm/system.h>
 
 #define user_mode(regs)			(((regs)->sr & 0x40000000)==0)
 #define kernel_stack_pointer(_regs)	((unsigned long)(_regs)->regs[15])
diff --git a/arch/sh/kernel/cpu/init.c b/arch/sh/kernel/cpu/init.c
index fac742e..b95f84c 100644
--- a/arch/sh/kernel/cpu/init.c
+++ b/arch/sh/kernel/cpu/init.c
@@ -18,7 +18,6 @@
 #include <asm/processor.h>
 #include <asm/uaccess.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 #include <asm/cache.h>
 #include <asm/elf.h>
diff --git a/arch/sh/kernel/cpu/irq/imask.c b/arch/sh/kernel/cpu/irq/imask.c
index 39b6a24..e7f1745 100644
--- a/arch/sh/kernel/cpu/irq/imask.c
+++ b/arch/sh/kernel/cpu/irq/imask.c
@@ -19,7 +19,6 @@
 #include <linux/cache.h>
 #include <linux/irq.h>
 #include <linux/bitmap.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 
 /* Bitmap of IRQ masked */
diff --git a/arch/sh/kernel/cpu/sh2a/opcode_helper.c b/arch/sh/kernel/cpu/sh2a/opcode_helper.c
index 9704b79..72aa61c 100644
--- a/arch/sh/kernel/cpu/sh2a/opcode_helper.c
+++ b/arch/sh/kernel/cpu/sh2a/opcode_helper.c
@@ -10,7 +10,6 @@
  * for more details.
  */
 #include <linux/kernel.h>
-#include <asm/system.h>
 
 /*
  * Instructions on SH are generally fixed at 16-bits, however, SH-2A
diff --git a/arch/sh/kernel/cpu/sh4/fpu.c b/arch/sh/kernel/cpu/sh4/fpu.c
index 447482d..e74cd6c 100644
--- a/arch/sh/kernel/cpu/sh4/fpu.c
+++ b/arch/sh/kernel/cpu/sh4/fpu.c
@@ -15,7 +15,6 @@
 #include <linux/io.h>
 #include <cpu/fpu.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/fpu.h>
 
 /* The PR (precision) bit in the FP Status Register must be clear when
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 406508d..17ad04f 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -18,7 +18,6 @@
 #include <linux/smp.h>
 #include <linux/cpuidle.h>
 #include <asm/pgalloc.h>
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/smp.h>
 
diff --git a/arch/sh/kernel/io_trapped.c b/arch/sh/kernel/io_trapped.c
index 0f62f46..c0a9761 100644
--- a/arch/sh/kernel/io_trapped.c
+++ b/arch/sh/kernel/io_trapped.c
@@ -15,7 +15,6 @@
 #include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/init.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index 7ec6651..f72e3a9 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -24,7 +24,6 @@
 #include <linux/prefetch.h>
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
-#include <asm/system.h>
 #include <asm/fpu.h>
 #include <asm/syscalls.h>
 
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index a3e6515..9698671 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -28,7 +28,6 @@
 #include <linux/hw_breakpoint.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/mmu_context.h>
 #include <asm/syscalls.h>
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index 3d0080b..663c9ae 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -34,7 +34,6 @@
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/mmu_context.h>
 #include <asm/syscalls.h>
diff --git a/arch/sh/kernel/reboot.c b/arch/sh/kernel/reboot.c
index ca6a5ca..7cc034b 100644
--- a/arch/sh/kernel/reboot.c
+++ b/arch/sh/kernel/reboot.c
@@ -8,7 +8,6 @@
 #endif
 #include <asm/addrspace.h>
 #include <asm/reboot.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 
 void (*pm_power_off)(void);
diff --git a/arch/sh/kernel/signal_32.c b/arch/sh/kernel/signal_32.c
index a7a55ed..0bc5886 100644
--- a/arch/sh/kernel/signal_32.c
+++ b/arch/sh/kernel/signal_32.c
@@ -25,7 +25,6 @@
 #include <linux/freezer.h>
 #include <linux/io.h>
 #include <linux/tracehook.h>
-#include <asm/system.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index f624174..a17a14d 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -23,7 +23,6 @@
 #include <linux/sched.h>
 #include <linux/atomic.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
diff --git a/arch/sh/kernel/traps.c b/arch/sh/kernel/traps.c
index 0830c2a..931baa8 100644
--- a/arch/sh/kernel/traps.c
+++ b/arch/sh/kernel/traps.c
@@ -7,7 +7,6 @@
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
 #include <asm/unwinder.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_GENERIC_BUG
 static void handle_BUG(struct pt_regs *regs)
diff --git a/arch/sh/kernel/traps_32.c b/arch/sh/kernel/traps_32.c
index 7bbef95..227c21a 100644
--- a/arch/sh/kernel/traps_32.c
+++ b/arch/sh/kernel/traps_32.c
@@ -27,7 +27,6 @@
 #include <linux/sysfs.h>
 #include <linux/uaccess.h>
 #include <linux/perf_event.h>
-#include <asm/system.h>
 #include <asm/alignment.h>
 #include <asm/fpu.h>
 #include <asm/kprobes.h>
diff --git a/arch/sh/kernel/traps_64.c b/arch/sh/kernel/traps_64.c
index cd3a404..6c04860 100644
--- a/arch/sh/kernel/traps_64.c
+++ b/arch/sh/kernel/traps_64.c
@@ -25,7 +25,6 @@
 #include <linux/sysctl.h>
 #include <linux/module.h>
 #include <linux/perf_event.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/arch/sh/math-emu/math.c b/arch/sh/math-emu/math.c
index 9771952..b876780 100644
--- a/arch/sh/math-emu/math.c
+++ b/arch/sh/math-emu/math.c
@@ -14,7 +14,6 @@
 #include <linux/signal.h>
 #include <linux/perf_event.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/io.h>
diff --git a/arch/sh/mm/fault_32.c b/arch/sh/mm/fault_32.c
index 7bebd04..ddbc2d4 100644
--- a/arch/sh/mm/fault_32.c
+++ b/arch/sh/mm/fault_32.c
@@ -17,7 +17,6 @@
 #include <linux/kprobes.h>
 #include <linux/perf_event.h>
 #include <asm/io_trapped.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
 
diff --git a/arch/sh/mm/fault_64.c b/arch/sh/mm/fault_64.c
index 2b356ce..44a3410 100644
--- a/arch/sh/mm/fault_64.c
+++ b/arch/sh/mm/fault_64.c
@@ -33,7 +33,6 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/interrupt.h>
-#include <asm/system.h>
 #include <asm/tlb.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
diff --git a/arch/sh/mm/pmb.c b/arch/sh/mm/pmb.c
index fad52f1..7160c9f 100644
--- a/arch/sh/mm/pmb.c
+++ b/arch/sh/mm/pmb.c
@@ -25,7 +25,6 @@
 #include <linux/vmalloc.h>
 #include <asm/cacheflush.h>
 #include <asm/sizes.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
diff --git a/arch/sh/mm/tlb-pteaex.c b/arch/sh/mm/tlb-pteaex.c
index b71db6a..4db21ad 100644
--- a/arch/sh/mm/tlb-pteaex.c
+++ b/arch/sh/mm/tlb-pteaex.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 
diff --git a/arch/sh/mm/tlb-sh3.c b/arch/sh/mm/tlb-sh3.c
index 7a940db..6554fb4 100644
--- a/arch/sh/mm/tlb-sh3.c
+++ b/arch/sh/mm/tlb-sh3.c
@@ -20,7 +20,6 @@
 #include <linux/smp.h>
 #include <linux/interrupt.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
diff --git a/arch/sh/mm/tlb-sh4.c b/arch/sh/mm/tlb-sh4.c
index cfdf793..d42dd7e 100644
--- a/arch/sh/mm/tlb-sh4.c
+++ b/arch/sh/mm/tlb-sh4.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <asm/mmu_context.h>
 #include <asm/cacheflush.h>
 
diff --git a/arch/sh/mm/tlbflush_64.c b/arch/sh/mm/tlbflush_64.c
index e3430e0..11c5a18 100644
--- a/arch/sh/mm/tlbflush_64.c
+++ b/arch/sh/mm/tlbflush_64.c
@@ -22,7 +22,6 @@
 #include <linux/smp.h>
 #include <linux/perf_event.h>
 #include <linux/interrupt.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/tlb.h>
 #include <asm/uaccess.h>
diff --git a/arch/sparc/include/asm/atomic_32.h b/arch/sparc/include/asm/atomic_32.h
index 9dd0a76..e6d75af 100644
--- a/arch/sparc/include/asm/atomic_32.h
+++ b/arch/sparc/include/asm/atomic_32.h
@@ -15,7 +15,6 @@
 
 #include <asm-generic/atomic64.h>
 
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)  { (i) }
 
diff --git a/arch/sparc/include/asm/atomic_64.h b/arch/sparc/include/asm/atomic_64.h
index 9f421df..5ab4e89 100644
--- a/arch/sparc/include/asm/atomic_64.h
+++ b/arch/sparc/include/asm/atomic_64.h
@@ -8,7 +8,6 @@
 #define __ARCH_SPARC64_ATOMIC__
 
 #include <linux/types.h>
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)		{ (i) }
 #define ATOMIC64_INIT(i)	{ (i) }
diff --git a/arch/sparc/include/asm/auxio_32.h b/arch/sparc/include/asm/auxio_32.h
index e03e088..3a31977 100644
--- a/arch/sparc/include/asm/auxio_32.h
+++ b/arch/sparc/include/asm/auxio_32.h
@@ -6,7 +6,6 @@
 #ifndef _SPARC_AUXIO_H
 #define _SPARC_AUXIO_H
 
-#include <asm/system.h>
 #include <asm/vaddrs.h>
 
 /* This register is an unsigned char in IO space.  It does two things.
diff --git a/arch/sparc/include/asm/floppy_32.h b/arch/sparc/include/asm/floppy_32.h
index 7440915..698d955 100644
--- a/arch/sparc/include/asm/floppy_32.h
+++ b/arch/sparc/include/asm/floppy_32.h
@@ -11,7 +11,6 @@
 
 #include <asm/page.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/idprom.h>
 #include <asm/machines.h>
 #include <asm/oplib.h>
diff --git a/arch/sparc/include/asm/futex_64.h b/arch/sparc/include/asm/futex_64.h
index 444e7be..4e899b0 100644
--- a/arch/sparc/include/asm/futex_64.h
+++ b/arch/sparc/include/asm/futex_64.h
@@ -4,7 +4,6 @@
 #include <linux/futex.h>
 #include <linux/uaccess.h>
 #include <asm/errno.h>
-#include <asm/system.h>
 
 #define __futex_cas_op(insn, ret, oldval, uaddr, oparg)	\
 	__asm__ __volatile__(				\
diff --git a/arch/sparc/include/asm/io_32.h b/arch/sparc/include/asm/io_32.h
index 2006e5d..c1acbd8 100644
--- a/arch/sparc/include/asm/io_32.h
+++ b/arch/sparc/include/asm/io_32.h
@@ -6,7 +6,6 @@
 #include <linux/ioport.h>  /* struct resource */
 
 #include <asm/page.h>      /* IO address mapping routines need this */
-#include <asm/system.h>
 #include <asm-generic/pci_iomap.h>
 
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index 9481e5a..09b0b88 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -6,7 +6,6 @@
 #include <linux/types.h>
 
 #include <asm/page.h>      /* IO address mapping routines need this */
-#include <asm/system.h>
 #include <asm/asi.h>
 #include <asm-generic/pci_iomap.h>
 
diff --git a/arch/sparc/include/asm/mmu_context_64.h b/arch/sparc/include/asm/mmu_context_64.h
index 666a73f..a97fd08 100644
--- a/arch/sparc/include/asm/mmu_context_64.h
+++ b/arch/sparc/include/asm/mmu_context_64.h
@@ -6,7 +6,6 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/spinlock.h>
-#include <asm/system.h>
 #include <asm/spitfire.h>
 #include <asm-generic/mm_hooks.h>
 
diff --git a/arch/sparc/include/asm/ns87303.h b/arch/sparc/include/asm/ns87303.h
index af75548..6b947ee 100644
--- a/arch/sparc/include/asm/ns87303.h
+++ b/arch/sparc/include/asm/ns87303.h
@@ -79,7 +79,6 @@
 
 #include <linux/spinlock.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 extern spinlock_t ns87303_lock;
diff --git a/arch/sparc/include/asm/pgtable_32.h b/arch/sparc/include/asm/pgtable_32.h
index a790cc6..496664b 100644
--- a/arch/sparc/include/asm/pgtable_32.h
+++ b/arch/sparc/include/asm/pgtable_32.h
@@ -21,7 +21,6 @@
 #include <asm/vac-ops.h>
 #include <asm/oplib.h>
 #include <asm/btfixup.h>
-#include <asm/system.h>
 
 
 struct vm_area_struct;
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 38ebb2c..6fa2f79 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -19,7 +19,6 @@
 #include <asm/types.h>
 #include <asm/spitfire.h>
 #include <asm/asi.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/processor.h>
 
diff --git a/arch/sparc/include/asm/ptrace.h b/arch/sparc/include/asm/ptrace.h
index c00c3b5..0495388 100644
--- a/arch/sparc/include/asm/ptrace.h
+++ b/arch/sparc/include/asm/ptrace.h
@@ -163,7 +163,6 @@ struct sparc_stackf {
 #ifdef __KERNEL__
 
 #include <linux/threads.h>
-#include <asm/system.h>
 
 static inline int pt_regs_trap_type(struct pt_regs *regs)
 {
@@ -240,7 +239,6 @@ extern unsigned long profile_pc(struct pt_regs *);
 
 #ifdef __KERNEL__
 
-#include <asm/system.h>
 
 static inline bool pt_regs_is_syscall(struct pt_regs *regs)
 {
diff --git a/arch/sparc/include/asm/uaccess_64.h b/arch/sparc/include/asm/uaccess_64.h
index 3e1449f..a1091afb 100644
--- a/arch/sparc/include/asm/uaccess_64.h
+++ b/arch/sparc/include/asm/uaccess_64.h
@@ -11,7 +11,6 @@
 #include <linux/string.h>
 #include <linux/thread_info.h>
 #include <asm/asi.h>
-#include <asm/system.h>
 #include <asm/spitfire.h>
 #include <asm-generic/uaccess-unaligned.h>
 #endif
diff --git a/arch/sparc/kernel/devices.c b/arch/sparc/kernel/devices.c
index 113c052..876c9f6 100644
--- a/arch/sparc/kernel/devices.c
+++ b/arch/sparc/kernel/devices.c
@@ -17,7 +17,6 @@
 #include <asm/oplib.h>
 #include <asm/prom.h>
 #include <asm/smp.h>
-#include <asm/system.h>
 #include <asm/cpudata.h>
 
 extern void clock_stop_probe(void); /* tadpole.c */
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index d45b710..dff2c3d 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -26,7 +26,6 @@
 #include <asm/ptrace.h>
 #include <asm/processor.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/iommu.h>
diff --git a/arch/sparc/kernel/muldiv.c b/arch/sparc/kernel/muldiv.c
index 6ce1021..f7db516 100644
--- a/arch/sparc/kernel/muldiv.c
+++ b/arch/sparc/kernel/muldiv.c
@@ -14,7 +14,6 @@
 #include <linux/mm.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "kernel.h"
diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
index f793742..a2050b3 100644
--- a/arch/sparc/kernel/process_32.c
+++ b/arch/sparc/kernel/process_32.c
@@ -28,7 +28,6 @@
 #include <asm/auxio.h>
 #include <asm/oplib.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index 39d8b05..5099c6d 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -32,7 +32,6 @@
 #include <linux/nmi.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff --git a/arch/sparc/kernel/ptrace_32.c b/arch/sparc/kernel/ptrace_32.c
index 27b9e93..38af4a8 100644
--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -23,7 +23,6 @@
 #include <linux/tracehook.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 /* #define ALLOW_INIT_TRACING */
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index 9388844..6f97c07 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -29,7 +29,6 @@
 
 #include <asm/asi.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/psrcompat.h>
 #include <asm/visasm.h>
diff --git a/arch/sparc/kernel/reboot.c b/arch/sparc/kernel/reboot.c
index 006a42d..5384d56 100644
--- a/arch/sparc/kernel/reboot.c
+++ b/arch/sparc/kernel/reboot.c
@@ -7,7 +7,6 @@
 #include <linux/export.h>
 #include <linux/pm.h>
 
-#include <asm/system.h>
 #include <asm/oplib.h>
 #include <asm/prom.h>
 
diff --git a/arch/sparc/kernel/setup_32.c b/arch/sparc/kernel/setup_32.c
index ffb883d..010f719 100644
--- a/arch/sparc/kernel/setup_32.c
+++ b/arch/sparc/kernel/setup_32.c
@@ -33,7 +33,6 @@
 #include <linux/kdebug.h>
 #include <linux/export.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/oplib.h>
diff --git a/arch/sparc/kernel/setup_64.c b/arch/sparc/kernel/setup_64.c
index a854a1c..0a6b078 100644
--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -31,7 +31,6 @@
 #include <linux/initrd.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/oplib.h>
diff --git a/arch/sparc/kernel/sparc_ksyms_64.c b/arch/sparc/kernel/sparc_ksyms_64.c
index 12ff098..af39e3f 100644
--- a/arch/sparc/kernel/sparc_ksyms_64.c
+++ b/arch/sparc/kernel/sparc_ksyms_64.c
@@ -10,7 +10,6 @@
 #include <linux/init.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/cpudata.h>
 #include <asm/uaccess.h>
 #include <asm/spitfire.h>
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 1060e06..7d0c088 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -37,7 +37,6 @@
 #include <asm/oplib.h>
 #include <asm/timex.h>
 #include <asm/timer.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/idprom.h>
diff --git a/arch/sparc/kernel/traps_32.c b/arch/sparc/kernel/traps_32.c
index 591f20c..d2de213 100644
--- a/arch/sparc/kernel/traps_32.c
+++ b/arch/sparc/kernel/traps_32.c
@@ -17,7 +17,6 @@
 #include <linux/export.h>
 
 #include <asm/delay.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/oplib.h>
 #include <asm/page.h>
diff --git a/arch/sparc/kernel/traps_64.c b/arch/sparc/kernel/traps_64.c
index 0cbdaa4..bd3d285 100644
--- a/arch/sparc/kernel/traps_64.c
+++ b/arch/sparc/kernel/traps_64.c
@@ -22,7 +22,6 @@
 
 #include <asm/smp.h>
 #include <asm/delay.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/oplib.h>
 #include <asm/page.h>
diff --git a/arch/sparc/kernel/unaligned_32.c b/arch/sparc/kernel/unaligned_32.c
index 4d043a1..c0ec897 100644
--- a/arch/sparc/kernel/unaligned_32.c
+++ b/arch/sparc/kernel/unaligned_32.c
@@ -12,7 +12,6 @@
 #include <linux/mm.h>
 #include <asm/ptrace.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/smp.h>
 #include <linux/perf_event.h>
diff --git a/arch/sparc/kernel/unaligned_64.c b/arch/sparc/kernel/unaligned_64.c
index 76e4ac1..622f653 100644
--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -16,7 +16,6 @@
 #include <asm/ptrace.h>
 #include <asm/pstate.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/smp.h>
 #include <linux/bitops.h>
diff --git a/arch/sparc/kernel/visemul.c b/arch/sparc/kernel/visemul.c
index 7337067..8573025 100644
--- a/arch/sparc/kernel/visemul.c
+++ b/arch/sparc/kernel/visemul.c
@@ -9,7 +9,6 @@
 
 #include <asm/ptrace.h>
 #include <asm/pstate.h>
-#include <asm/system.h>
 #include <asm/fpumacro.h>
 #include <asm/uaccess.h>
 
diff --git a/arch/sparc/mm/btfixup.c b/arch/sparc/mm/btfixup.c
index 8a7f817..09d6af2 100644
--- a/arch/sparc/mm/btfixup.c
+++ b/arch/sparc/mm/btfixup.c
@@ -12,7 +12,6 @@
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 
 #define BTFIXUP_OPTIMIZE_NOP
diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
index 8023fd7..7705c67 100644
--- a/arch/sparc/mm/fault_32.c
+++ b/arch/sparc/mm/fault_32.c
@@ -22,7 +22,6 @@
 #include <linux/interrupt.h>
 #include <linux/kdebug.h>
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/memreg.h>
diff --git a/arch/sparc/mm/init_32.c b/arch/sparc/mm/init_32.c
index 7b00de6..c5f9021 100644
--- a/arch/sparc/mm/init_32.c
+++ b/arch/sparc/mm/init_32.c
@@ -27,7 +27,6 @@
 #include <linux/gfp.h>
 
 #include <asm/sections.h>
-#include <asm/system.h>
 #include <asm/vac-ops.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index b3f5e7d..21faaee 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -28,7 +28,6 @@
 #include <linux/gfp.h>
 
 #include <asm/head.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgalloc.h>
 #include <asm/pgtable.h>
diff --git a/arch/sparc/mm/loadmmu.c b/arch/sparc/mm/loadmmu.c
index 82ec8f6..c5bf2a6 100644
--- a/arch/sparc/mm/loadmmu.c
+++ b/arch/sparc/mm/loadmmu.c
@@ -11,7 +11,6 @@
 #include <linux/mm.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mmu_context.h>
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index 536412d..c52add7 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -6,7 +6,6 @@
 #include <linux/kernel.h>
 #include <linux/preempt.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
diff --git a/arch/sparc/prom/console_32.c b/arch/sparc/prom/console_32.c
index a00f47b..1cfb50f 100644
--- a/arch/sparc/prom/console_32.c
+++ b/arch/sparc/prom/console_32.c
@@ -11,7 +11,6 @@
 #include <linux/sched.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <linux/string.h>
 
 extern void restore_current(void);
diff --git a/arch/sparc/prom/console_64.c b/arch/sparc/prom/console_64.c
index 9de6c8c..f95edcc 100644
--- a/arch/sparc/prom/console_64.c
+++ b/arch/sparc/prom/console_64.c
@@ -10,7 +10,6 @@
 #include <linux/sched.h>
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <linux/string.h>
 
 static int __prom_console_write_buf(const char *buf, int len)
diff --git a/arch/sparc/prom/misc_32.c b/arch/sparc/prom/misc_32.c
index 677b6a1..8dc0b6b 100644
--- a/arch/sparc/prom/misc_32.c
+++ b/arch/sparc/prom/misc_32.c
@@ -13,7 +13,6 @@
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/auxio.h>
-#include <asm/system.h>
 
 extern void restore_current(void);
 
diff --git a/arch/sparc/prom/misc_64.c b/arch/sparc/prom/misc_64.c
index e4f31d4..f178b9d 100644
--- a/arch/sparc/prom/misc_64.c
+++ b/arch/sparc/prom/misc_64.c
@@ -15,7 +15,6 @@
 
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <asm/ldc.h>
 
 static int prom_service_exists(const char *service_name)
diff --git a/arch/sparc/prom/p1275.c b/arch/sparc/prom/p1275.c
index d9850c2..04a4540 100644
--- a/arch/sparc/prom/p1275.c
+++ b/arch/sparc/prom/p1275.c
@@ -13,7 +13,6 @@
 
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <asm/spitfire.h>
 #include <asm/pstate.h>
 #include <asm/ldc.h>
diff --git a/arch/sparc/prom/ranges.c b/arch/sparc/prom/ranges.c
index 0857aa9..ad143c1 100644
--- a/arch/sparc/prom/ranges.c
+++ b/arch/sparc/prom/ranges.c
@@ -11,7 +11,6 @@
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/types.h>
-#include <asm/system.h>
 
 static struct linux_prom_ranges promlib_obio_ranges[PROMREG_MAX];
 static int num_obio_ranges;
diff --git a/arch/tile/include/asm/atomic.h b/arch/tile/include/asm/atomic.h
index 921dbeb..9fce9a4 100644
--- a/arch/tile/include/asm/atomic.h
+++ b/arch/tile/include/asm/atomic.h
@@ -20,7 +20,6 @@
 #ifndef __ASSEMBLY__
 
 #include <linux/compiler.h>
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
diff --git a/arch/tile/include/asm/bitops_32.h b/arch/tile/include/asm/bitops_32.h
index 571b118..ddc4c1e 100644
--- a/arch/tile/include/asm/bitops_32.h
+++ b/arch/tile/include/asm/bitops_32.h
@@ -17,7 +17,6 @@
 
 #include <linux/compiler.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 /* Tile-specific routines to support <asm/bitops.h>. */
 unsigned long _atomic_or(volatile unsigned long *p, unsigned long mask);
diff --git a/arch/tile/include/asm/bitops_64.h b/arch/tile/include/asm/bitops_64.h
index e9c8e38..58d021a 100644
--- a/arch/tile/include/asm/bitops_64.h
+++ b/arch/tile/include/asm/bitops_64.h
@@ -17,7 +17,6 @@
 
 #include <linux/compiler.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 /* See <asm/bitops.h> for API comments. */
 
diff --git a/arch/tile/include/asm/cacheflush.h b/arch/tile/include/asm/cacheflush.h
index e925f4b..c2e0fda 100644
--- a/arch/tile/include/asm/cacheflush.h
+++ b/arch/tile/include/asm/cacheflush.h
@@ -20,7 +20,6 @@
 /* Keep includes the same across arches.  */
 #include <linux/mm.h>
 #include <linux/cache.h>
-#include <asm/system.h>
 #include <arch/icache.h>
 
 /* Caches are physically-indexed and so don't need special treatment */
diff --git a/arch/tile/include/asm/pgtable.h b/arch/tile/include/asm/pgtable.h
index 1a20b7e..6749091 100644
--- a/arch/tile/include/asm/pgtable.h
+++ b/arch/tile/include/asm/pgtable.h
@@ -29,7 +29,6 @@
 #include <linux/spinlock.h>
 #include <asm/processor.h>
 #include <asm/fixmap.h>
-#include <asm/system.h>
 
 struct mm_struct;
 struct vm_area_struct;
diff --git a/arch/tile/include/asm/spinlock_32.h b/arch/tile/include/asm/spinlock_32.h
index a5e4208..c0a77b3 100644
--- a/arch/tile/include/asm/spinlock_32.h
+++ b/arch/tile/include/asm/spinlock_32.h
@@ -19,7 +19,6 @@
 
 #include <linux/atomic.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <linux/compiler.h>
 
 /*
diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 4c1ac6e..3f7890c 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/tracehook.h>
 #include <linux/signal.h>
-#include <asm/system.h>
 #include <asm/stack.h>
 #include <asm/homecache.h>
 #include <asm/syscalls.h>
diff --git a/arch/tile/kernel/regs_32.S b/arch/tile/kernel/regs_32.S
index caa1310..a4ab747 100644
--- a/arch/tile/kernel/regs_32.S
+++ b/arch/tile/kernel/regs_32.S
@@ -13,7 +13,6 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/asm-offsets.h>
 #include <arch/spr_def.h>
diff --git a/arch/tile/kernel/regs_64.S b/arch/tile/kernel/regs_64.S
index f748c1e..187d60e 100644
--- a/arch/tile/kernel/regs_64.S
+++ b/arch/tile/kernel/regs_64.S
@@ -13,7 +13,6 @@
  */
 
 #include <linux/linkage.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/asm-offsets.h>
 #include <arch/spr_def.h>
diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
index c1eaaa1..cba30e9 100644
--- a/arch/tile/mm/fault.c
+++ b/arch/tile/mm/fault.c
@@ -35,7 +35,6 @@
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 #include <asm/pgalloc.h>
 #include <asm/sections.h>
 #include <asm/traps.h>
diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
index 7309988..830c490 100644
--- a/arch/tile/mm/init.c
+++ b/arch/tile/mm/init.c
@@ -38,7 +38,6 @@
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/dma.h>
diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
index de7d8e2..8730369 100644
--- a/arch/tile/mm/pgtable.c
+++ b/arch/tile/mm/pgtable.c
@@ -27,7 +27,6 @@
 #include <linux/vmalloc.h>
 #include <linux/smp.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/fixmap.h>
diff --git a/arch/um/include/asm/fixmap.h b/arch/um/include/asm/fixmap.h
index 69c0252..21a423b 100644
--- a/arch/um/include/asm/fixmap.h
+++ b/arch/um/include/asm/fixmap.h
@@ -2,7 +2,6 @@
 #define __UM_FIXMAP_H
 
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/kmap_types.h>
 #include <asm/archparam.h>
 #include <asm/page.h>
diff --git a/arch/unicore32/include/asm/io.h b/arch/unicore32/include/asm/io.h
index adddf6d..39decb6 100644
--- a/arch/unicore32/include/asm/io.h
+++ b/arch/unicore32/include/asm/io.h
@@ -16,7 +16,6 @@
 
 #include <asm/byteorder.h>
 #include <asm/memory.h>
-#include <asm/system.h>
 
 #define PCI_IOBASE	PKUNITY_PCILIO_BASE
 #include <asm-generic/io.h>
diff --git a/arch/unicore32/include/asm/uaccess.h b/arch/unicore32/include/asm/uaccess.h
index 2acda50..897e11ad 100644
--- a/arch/unicore32/include/asm/uaccess.h
+++ b/arch/unicore32/include/asm/uaccess.h
@@ -16,7 +16,6 @@
 #include <linux/errno.h>
 
 #include <asm/memory.h>
-#include <asm/system.h>
 
 #define __copy_from_user	__copy_from_user
 #define __copy_to_user		__copy_to_user
diff --git a/arch/unicore32/kernel/dma.c b/arch/unicore32/kernel/dma.c
index ae441bc..ed2d4d7 100644
--- a/arch/unicore32/kernel/dma.c
+++ b/arch/unicore32/kernel/dma.c
@@ -18,7 +18,6 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <mach/dma.h>
diff --git a/arch/unicore32/kernel/head.S b/arch/unicore32/kernel/head.S
index 8caf322..fb1eb5c 100644
--- a/arch/unicore32/kernel/head.S
+++ b/arch/unicore32/kernel/head.S
@@ -17,7 +17,6 @@
 #include <generated/asm-offsets.h>
 #include <asm/memory.h>
 #include <asm/thread_info.h>
-#include <asm/system.h>
 #include <asm/pgtable-hwdef.h>
 
 #if (PHYS_OFFSET & 0x003fffff)
diff --git a/arch/unicore32/kernel/hibernate.c b/arch/unicore32/kernel/hibernate.c
index 7d0f0b7..d75ef8b 100644
--- a/arch/unicore32/kernel/hibernate.c
+++ b/arch/unicore32/kernel/hibernate.c
@@ -15,7 +15,6 @@
 #include <linux/suspend.h>
 #include <linux/bootmem.h>
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/arch/unicore32/kernel/irq.c b/arch/unicore32/kernel/irq.c
index d4efa7d..0be5ccd 100644
--- a/arch/unicore32/kernel/irq.c
+++ b/arch/unicore32/kernel/irq.c
@@ -26,7 +26,6 @@
 #include <linux/syscore_ops.h>
 #include <linux/gpio.h>
 
-#include <asm/system.h>
 #include <mach/hardware.h>
 
 #include "setup.h"
diff --git a/arch/unicore32/kernel/ksyms.c b/arch/unicore32/kernel/ksyms.c
index d98bd81..d285d71 100644
--- a/arch/unicore32/kernel/ksyms.c
+++ b/arch/unicore32/kernel/ksyms.c
@@ -20,7 +20,6 @@
 #include <linux/io.h>
 
 #include <asm/checksum.h>
-#include <asm/system.h>
 
 #include "ksyms.h"
 
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 52edc2b..1b3f152 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -34,7 +34,6 @@
 
 #include <asm/cacheflush.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/stacktrace.h>
 
 #include "setup.h"
diff --git a/arch/unicore32/kernel/traps.c b/arch/unicore32/kernel/traps.c
index b9a2646..2054f0d 100644
--- a/arch/unicore32/kernel/traps.c
+++ b/arch/unicore32/kernel/traps.c
@@ -26,7 +26,6 @@
 #include <linux/unistd.h>
 
 #include <asm/cacheflush.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 
 #include "setup.h"
diff --git a/arch/unicore32/mm/fault.c b/arch/unicore32/mm/fault.c
index 283aa4b..2eeb9c0 100644
--- a/arch/unicore32/mm/fault.c
+++ b/arch/unicore32/mm/fault.c
@@ -20,7 +20,6 @@
 #include <linux/sched.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
diff --git a/arch/unicore32/mm/flush.c b/arch/unicore32/mm/flush.c
index 93478cc..6d4c096 100644
--- a/arch/unicore32/mm/flush.c
+++ b/arch/unicore32/mm/flush.c
@@ -14,7 +14,6 @@
 #include <linux/pagemap.h>
 
 #include <asm/cacheflush.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 
 void flush_cache_mm(struct mm_struct *mm)
diff --git a/arch/x86/ia32/ia32_aout.c b/arch/x86/ia32/ia32_aout.c
index 39e4909..18b2561 100644
--- a/arch/x86/ia32/ia32_aout.c
+++ b/arch/x86/ia32/ia32_aout.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgalloc.h>
 #include <asm/cacheflush.h>
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 3ab9bdd..108246d 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -11,7 +11,6 @@
 #include <linux/atomic.h>
 #include <asm/fixmap.h>
 #include <asm/mpspec.h>
-#include <asm/system.h>
 #include <asm/msr.h>
 
 #define ARCH_APICTIMER_STOPS_ON_C3	1
diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 5f962df..f27f79a 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -84,7 +84,6 @@ extern unsigned int vdso_enabled;
 	(((x)->e_machine == EM_386) || ((x)->e_machine == EM_486))
 
 #include <asm/processor.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_X86_32
 #include <asm/desc.h>
diff --git a/arch/x86/include/asm/futex.h b/arch/x86/include/asm/futex.h
index d09bb03..71ecbcb 100644
--- a/arch/x86/include/asm/futex.h
+++ b/arch/x86/include/asm/futex.h
@@ -9,7 +9,6 @@
 #include <asm/asm.h>
 #include <asm/errno.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 
 #define __futex_atomic_op1(insn, ret, oldval, uaddr, oparg)	\
 	asm volatile("1:\t" insn "\n"				\
diff --git a/arch/x86/include/asm/local.h b/arch/x86/include/asm/local.h
index 9cdae5d..c8bed0d 100644
--- a/arch/x86/include/asm/local.h
+++ b/arch/x86/include/asm/local.h
@@ -3,7 +3,6 @@
 
 #include <linux/percpu.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/asm.h>
 
diff --git a/arch/x86/include/asm/mc146818rtc.h b/arch/x86/include/asm/mc146818rtc.h
index 0e8e85b..d354fb7 100644
--- a/arch/x86/include/asm/mc146818rtc.h
+++ b/arch/x86/include/asm/mc146818rtc.h
@@ -5,7 +5,6 @@
 #define _ASM_X86_MC146818RTC_H
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <linux/mc146818rtc.h>
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 58545c9..d395527 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -14,7 +14,6 @@ struct mm_struct;
 #include <asm/sigcontext.h>
 #include <asm/current.h>
 #include <asm/cpufeature.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable_types.h>
 #include <asm/percpu.h>
diff --git a/arch/x86/include/asm/stackprotector.h b/arch/x86/include/asm/stackprotector.h
index 1575177..b5d9533 100644
--- a/arch/x86/include/asm/stackprotector.h
+++ b/arch/x86/include/asm/stackprotector.h
@@ -38,7 +38,6 @@
 #include <asm/tsc.h>
 #include <asm/processor.h>
 #include <asm/percpu.h>
-#include <asm/system.h>
 #include <asm/desc.h>
 #include <linux/random.h>
 
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 169be89..02a4c04 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -5,7 +5,6 @@
 #include <linux/sched.h>
 
 #include <asm/processor.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index e0f9aa1..5da71c2 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -16,7 +16,6 @@
 #define _ASM_X86_VIRTEX_H
 
 #include <asm/processor.h>
-#include <asm/system.h>
 
 #include <asm/vmx.h>
 #include <asm/svm.h>
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index f76623c..56585a5 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -231,7 +231,6 @@
 #include <linux/syscore_ops.h>
 #include <linux/i8253.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/desc.h>
 #include <asm/olpc.h>
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index 5c0e653..2d5454c 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -9,7 +9,6 @@
 #include <linux/smp.h>
 
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 67bb17a..47a1870 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -25,7 +25,6 @@
 #include <linux/cpu.h>
 
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/apic.h>
 #include <asm/idle.h>
 #include <asm/mce.h>
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index 54060f5..2d7998f 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -8,7 +8,6 @@
 #include <linux/init.h>
 
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 97b2635..75772ae 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -12,7 +12,6 @@
 #include <asm/processor-flags.h>
 #include <asm/cpufeature.h>
 #include <asm/tlbflush.h>
-#include <asm/system.h>
 #include <asm/mtrr.h>
 #include <asm/msr.h>
 #include <asm/pat.h>
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index a524353..39472dd 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -43,7 +43,6 @@
 
 #include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/system.h>
 
 static struct class *cpuid_class;
 
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 6104852..36d1853 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -15,7 +15,6 @@
 #include <linux/delay.h>
 
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 313fb5c..99b85b4 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -16,7 +16,6 @@
 #include <linux/delay.h>
 
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/timer.h>
 #include <asm/hw_irq.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index faba577..4425a12 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -46,7 +46,6 @@
 
 #include <asm/debugreg.h>
 #include <asm/apicdef.h>
-#include <asm/system.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
 
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index ea69726..ebc9873 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -15,7 +15,6 @@
 #include <linux/vmalloc.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 #include <asm/ldt.h>
 #include <asm/desc.h>
 #include <asm/mmu_context.h>
diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
index a3fa43b..5b19e4d 100644
--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -23,7 +23,6 @@
 #include <asm/apic.h>
 #include <asm/cpufeature.h>
 #include <asm/desc.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 #include <asm/debugreg.h>
 
diff --git a/arch/x86/kernel/mca_32.c b/arch/x86/kernel/mca_32.c
index 177183c..7eb1e2b 100644
--- a/arch/x86/kernel/mca_32.c
+++ b/arch/x86/kernel/mca_32.c
@@ -43,7 +43,6 @@
 #include <linux/mca.h>
 #include <linux/kprobes.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <linux/proc_fs.h>
 #include <linux/mman.h>
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index 925179f..f21fd94 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -26,7 +26,6 @@
 #include <linux/gfp.h>
 #include <linux/jump_label.h>
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 9635676..eb11369 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -40,7 +40,6 @@
 
 #include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/system.h>
 
 static struct class *msr_class;
 
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 726494b..6ac5782 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -42,7 +42,6 @@
 #include <asm/calgary.h>
 #include <asm/tce.h>
 #include <asm/pci-direct.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/rio.h>
 #include <asm/bios_ebda.h>
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 15763af..e01ed8b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -15,7 +15,6 @@
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
 #include <asm/cpu.h>
-#include <asm/system.h>
 #include <asm/apic.h>
 #include <asm/syscalls.h>
 #include <asm/idle.h>
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index c08d1ff..82ad568 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -41,7 +41,6 @@
 #include <linux/cpuidle.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/ldt.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index cfa5c90..ea5d771 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -40,7 +40,6 @@
 #include <linux/cpuidle.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/mmu_context.h>
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 5026738..e7d573b 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -24,7 +24,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
 #include <asm/debugreg.h>
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d7d5099..b7f71ad 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -90,7 +90,6 @@
 #include <asm/processor.h>
 #include <asm/bugs.h>
 
-#include <asm/system.h>
 #include <asm/vsyscall.h>
 #include <asm/cpu.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index 6bb7b85..73920e4 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -6,7 +6,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/desc.h>
-#include <asm/system.h>
 #include <asm/ldt.h>
 #include <asm/processor.h>
 #include <asm/proto.h>
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4bbe04d..e88ed30 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -50,7 +50,6 @@
 #include <asm/processor.h>
 #include <asm/debugreg.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6cabf65..4f0cec7 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -12,7 +12,6 @@
 #include <asm/page_types.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include <asm/proto.h>
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 8663f6c..575d86f 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -35,7 +35,6 @@
 #include <asm/asm.h>
 #include <asm/bios_ebda.h>
 #include <asm/processor.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/dma.h>
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 436a030..fc18be0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -35,7 +35,6 @@
 
 #include <asm/processor.h>
 #include <asm/bios_ebda.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
diff --git a/arch/x86/mm/pgtable_32.c b/arch/x86/mm/pgtable_32.c
index cac7184..a69bcb8 100644
--- a/arch/x86/mm/pgtable_32.c
+++ b/arch/x86/mm/pgtable_32.c
@@ -10,7 +10,6 @@
 #include <linux/spinlock.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/fixmap.h>
diff --git a/arch/x86/power/hibernate_32.c b/arch/x86/power/hibernate_32.c
index 3769079..74202c1 100644
--- a/arch/x86/power/hibernate_32.c
+++ b/arch/x86/power/hibernate_32.c
@@ -10,7 +10,6 @@
 #include <linux/suspend.h>
 #include <linux/bootmem.h>
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/mmzone.h>
diff --git a/arch/xtensa/include/asm/atomic.h b/arch/xtensa/include/asm/atomic.h
index 23592ef..6f2e4da 100644
--- a/arch/xtensa/include/asm/atomic.h
+++ b/arch/xtensa/include/asm/atomic.h
@@ -18,7 +18,6 @@
 
 #ifdef __KERNEL__
 #include <asm/processor.h>
-#include <asm/system.h>
 
 #define ATOMIC_INIT(i)	{ (i) }
 
diff --git a/arch/xtensa/include/asm/bitops.h b/arch/xtensa/include/asm/bitops.h
index 40aa7fe..5270197 100644
--- a/arch/xtensa/include/asm/bitops.h
+++ b/arch/xtensa/include/asm/bitops.h
@@ -21,7 +21,6 @@
 
 #include <asm/processor.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_SMP
 # error SMP not supported on this architecture
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index 47041e7..c00c72c 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -34,7 +34,6 @@
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/platform.h>
diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index 2dff698..33eea4c 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -24,7 +24,6 @@
 
 #include <asm/pgtable.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/ptrace.h>
 #include <asm/elf.h>
diff --git a/arch/xtensa/kernel/setup.c b/arch/xtensa/kernel/setup.c
index 1e5a034..17e746f 100644
--- a/arch/xtensa/kernel/setup.c
+++ b/arch/xtensa/kernel/setup.c
@@ -34,7 +34,6 @@
 # include <linux/seq_file.h>
 #endif
 
-#include <asm/system.h>
 #include <asm/bootparam.h>
 #include <asm/pgtable.h>
 #include <asm/processor.h>
diff --git a/arch/xtensa/mm/fault.c b/arch/xtensa/mm/fault.c
index e367e30..b17885a 100644
--- a/arch/xtensa/mm/fault.c
+++ b/arch/xtensa/mm/fault.c
@@ -19,7 +19,6 @@
 #include <asm/cacheflush.h>
 #include <asm/hardirq.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/pgalloc.h>
 
 unsigned long asid_cache = ASID_USER_FIRST;
diff --git a/arch/xtensa/mm/tlb.c b/arch/xtensa/mm/tlb.c
index 239461d..e2700b2 100644
--- a/arch/xtensa/mm/tlb.c
+++ b/arch/xtensa/mm/tlb.c
@@ -18,7 +18,6 @@
 #include <asm/processor.h>
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 
 
diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 8ae05ce..28b3f24 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -46,7 +46,6 @@
 #include <linux/slab.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/cpu.h>
 #include <asm/delay.h>
 #include <asm/uaccess.h>
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 956e9ac..0f3068b 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -19,7 +19,6 @@
 #include <linux/atm_eni.h>
 #include <linux/bitops.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
 #include <asm/uaccess.h>
diff --git a/drivers/atm/firestream.c b/drivers/atm/firestream.c
index 5072f8a..86fed1b 100644
--- a/drivers/atm/firestream.c
+++ b/drivers/atm/firestream.c
@@ -49,7 +49,6 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/string.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index b812103..75fd691 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -43,7 +43,6 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
 #include <asm/uaccess.h>
diff --git a/drivers/atm/idt77105.c b/drivers/atm/idt77105.c
index 487a547..45d5063 100644
--- a/drivers/atm/idt77105.c
+++ b/drivers/atm/idt77105.c
@@ -16,7 +16,6 @@
 #include <linux/atm_idt77105.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <asm/param.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/atm/suni.c b/drivers/atm/suni.c
index 90f1ccc..0215934 100644
--- a/drivers/atm/suni.c
+++ b/drivers/atm/suni.c
@@ -22,7 +22,6 @@
 #include <linux/capability.h>
 #include <linux/atm_suni.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <asm/param.h>
 #include <asm/uaccess.h>
 #include <linux/atomic.h>
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index d889f56..abe4e20 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -24,7 +24,6 @@
 #include <linux/wait.h>
 #include <linux/slab.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/string.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 744f078..76a0823 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -202,7 +202,6 @@ static int slow_floppy;
 
 #include <asm/dma.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 static int FLOPPY_IRQ = 6;
 static int FLOPPY_DMA = 2;
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index b52c9ca..bf397bf 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -44,7 +44,6 @@
 #define HD_IRQ 14
 
 #define REALLY_SLOW_IO
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index c3f0ee1..c7ba11f 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -34,7 +34,6 @@
 #include <linux/kthread.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/types.h>
 
 #include <linux/nbd.h>
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 51a9727..ff54052 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -52,7 +52,6 @@
 #include <linux/io.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/dma.h>
 
diff --git a/drivers/bluetooth/bt3c_cs.c b/drivers/bluetooth/bt3c_cs.c
index 0c97e5d..6bed9ae 100644
--- a/drivers/bluetooth/bt3c_cs.c
+++ b/drivers/bluetooth/bt3c_cs.c
@@ -39,7 +39,6 @@
 #include <linux/serial.h>
 #include <linux/serial_reg.h>
 #include <linux/bitops.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <linux/device.h>
diff --git a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
index 200b3a2..5b52cd3 100644
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -38,7 +38,6 @@
 #include <linux/serial.h>
 #include <linux/serial_reg.h>
 #include <linux/bitops.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <pcmcia/cistpl.h>
diff --git a/drivers/bluetooth/dtl1_cs.c b/drivers/bluetooth/dtl1_cs.c
index 969bb22..b5bf4ed 100644
--- a/drivers/bluetooth/dtl1_cs.c
+++ b/drivers/bluetooth/dtl1_cs.c
@@ -38,7 +38,6 @@
 #include <linux/serial.h>
 #include <linux/serial_reg.h>
 #include <linux/bitops.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <pcmcia/cistpl.h>
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index f4837a8..57501ca 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -31,7 +31,6 @@
 #include <linux/kthread.h>
 #include <linux/delay.h>
 
-#include <asm/system.h>
 
 /*
  * The apm_bios device is one of the misc char devices.
diff --git a/drivers/char/ds1302.c b/drivers/char/ds1302.c
index ed8303f9..7d34b20 100644
--- a/drivers/char/ds1302.c
+++ b/drivers/char/ds1302.c
@@ -24,7 +24,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/rtc.h>
 #if defined(CONFIG_M32R)
 #include <asm/m32r.h>
diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index 53c524e..a082d00 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -37,7 +37,6 @@
 #include <linux/efi.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define EFI_RTC_VERSION		"0.4"
 
diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index f773a9d..21cb980 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -56,7 +56,6 @@
 #include <linux/workqueue.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/rtc.h>
 
 /*
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 0833896..3845ab4 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -36,7 +36,6 @@
 #include <linux/io.h>
 
 #include <asm/current.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/div64.h>
 
diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index 2aa3977..9eb360f 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -34,7 +34,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
-#include <asm/system.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 58c0e63..c90e939 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -33,7 +33,6 @@
 
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <asm/system.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 50fcf9c..f9fdc11 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -41,7 +41,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <asm/system.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/timer.h>
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index f434856..0fbf1a7 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -135,7 +135,6 @@
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 /* if you have more than 8 printers, remember to increase LP_NO */
 #define LP_NO 8
diff --git a/drivers/char/mbcs.c b/drivers/char/mbcs.c
index 1aeaaba..47ff7e4 100644
--- a/drivers/char/mbcs.c
+++ b/drivers/char/mbcs.c
@@ -28,7 +28,6 @@
 #include <linux/slab.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/intr.h>
diff --git a/drivers/char/mspec.c b/drivers/char/mspec.c
index 5c0d96a..8b78750 100644
--- a/drivers/char/mspec.c
+++ b/drivers/char/mspec.c
@@ -44,7 +44,6 @@
 #include <linux/slab.h>
 #include <linux/numa.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <linux/atomic.h>
 #include <asm/tlbflush.h>
diff --git a/drivers/char/mwave/3780i.c b/drivers/char/mwave/3780i.c
index 492dbfb..881c9e5 100644
--- a/drivers/char/mwave/3780i.c
+++ b/drivers/char/mwave/3780i.c
@@ -56,7 +56,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include "smapi.h"
 #include "mwavedd.h"
diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index da3cfee..c8be0b2 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -111,7 +111,6 @@
 #include <linux/uaccess.h>
 #include <linux/mutex.h>
 
-#include <asm/system.h>
 
 static DEFINE_MUTEX(nvram_mutex);
 static DEFINE_SPINLOCK(nvram_state_lock);
diff --git a/drivers/char/nwflash.c b/drivers/char/nwflash.c
index bf586ae..d45c334 100644
--- a/drivers/char/nwflash.c
+++ b/drivers/char/nwflash.c
@@ -32,7 +32,6 @@
 #include <asm/io.h>
 #include <asm/leds.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 /*****************************************************************************/
diff --git a/drivers/char/pcmcia/synclink_cs.c b/drivers/char/pcmcia/synclink_cs.c
index 07f6a5a..9dc49f6 100644
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -60,7 +60,6 @@
 #include <linux/ioctl.h>
 #include <linux/synclink.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index ccd124a..3bef48e 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -83,7 +83,6 @@
 #include <linux/ratelimit.h>
 
 #include <asm/current.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_X86
 #include <asm/hpet.h>
diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 1ee8ce7..45713f0 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -54,7 +54,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <linux/sonypi.h>
 
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index e90e1c7..31ba11c 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -89,7 +89,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_OF
 /* For open firmware. */
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 5d04c57..3093ca6 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -26,7 +26,6 @@
 #include <linux/cpu.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/smp_plat.h>
 #include <asm/cpu.h>
 
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index d71d9f3..a02956f 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -27,7 +27,6 @@
 
 #include <asm/timer.h>		/* Needed for recalibrate_cpu_khz() */
 #include <asm/msr.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_X86_POWERNOW_K7_ACPI
 #include <linux/acpi.h>
diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 4799393..1d6681b 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -44,7 +44,6 @@
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 
-#include <asm/system.h>
 
 #include "core.h"
 
diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index f3b890d..4c5ae39 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -40,7 +40,6 @@
 
 #include <linux/atomic.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 #include "core.h"
 
diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index 94d3b49..00be322 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -31,7 +31,6 @@
 
 #include <linux/atomic.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 #include "core.h"
 
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 7f5f0da..c7ce8a8 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -46,7 +46,6 @@
 
 #include <asm/byteorder.h>
 #include <asm/page.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_PPC_PMAC
 #include <asm/pmac_feature.h>
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 80e95aa..054bae4 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -52,7 +52,6 @@
 #include <linux/workqueue.h>
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/i2c/busses/i2c-acorn.c b/drivers/i2c/busses/i2c-acorn.c
index 8679648..ed9f48d 100644
--- a/drivers/i2c/busses/i2c-acorn.c
+++ b/drivers/i2c/busses/i2c-acorn.c
@@ -19,7 +19,6 @@
 
 #include <mach/hardware.h>
 #include <asm/hardware/ioc.h>
-#include <asm/system.h>
 
 #define FORCE_ONES	0xdc
 #define SCL		0x02
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index d2f3db3..28e344e 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -41,7 +41,6 @@
 #include <linux/major.h>
 #include <linux/delay.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
diff --git a/drivers/ide/qd65xx.c b/drivers/ide/qd65xx.c
index 8bbfe55..e03f4f1 100644
--- a/drivers/ide/qd65xx.c
+++ b/drivers/ide/qd65xx.c
@@ -29,7 +29,6 @@
 #include <linux/blkdev.h>
 #include <linux/ide.h>
 #include <linux/init.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #define DRV_NAME "qd65xx"
diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
index 9a3fbfc..fd05f48 100644
--- a/drivers/infiniband/hw/ehca/ehca_reqs.c
+++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
@@ -42,7 +42,6 @@
  */
 
 
-#include <asm/system.h>
 #include "ehca_classes.h"
 #include "ehca_tools.h"
 #include "ehca_qes.h"
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index c24ec2d..26043cc 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -13,7 +13,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/joystick.h>
diff --git a/drivers/input/joystick/amijoy.c b/drivers/input/joystick/amijoy.c
index 0bc8620..24044da 100644
--- a/drivers/input/joystick/amijoy.c
+++ b/drivers/input/joystick/amijoy.c
@@ -35,7 +35,6 @@
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
 
-#include <asm/system.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
 
diff --git a/drivers/input/mouse/amimouse.c b/drivers/input/mouse/amimouse.c
index ff5f61a..5fa9934 100644
--- a/drivers/input/mouse/amimouse.c
+++ b/drivers/input/mouse/amimouse.c
@@ -25,7 +25,6 @@
 
 #include <asm/irq.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
diff --git a/drivers/input/mouse/atarimouse.c b/drivers/input/mouse/atarimouse.c
index 5c4a692..d1c4323 100644
--- a/drivers/input/mouse/atarimouse.c
+++ b/drivers/input/mouse/atarimouse.c
@@ -47,7 +47,6 @@
 
 #include <asm/irq.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/atarihw.h>
 #include <asm/atarikb.h>
diff --git a/drivers/input/serio/hp_sdc.c b/drivers/input/serio/hp_sdc.c
index be33160..09a0899 100644
--- a/drivers/input/serio/hp_sdc.c
+++ b/drivers/input/serio/hp_sdc.c
@@ -71,7 +71,6 @@
 #include <linux/slab.h>
 #include <linux/hil.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 /* Machine-specific abstraction */
 
diff --git a/drivers/input/serio/maceps2.c b/drivers/input/serio/maceps2.c
index 558200e..61da763 100644
--- a/drivers/input/serio/maceps2.c
+++ b/drivers/input/serio/maceps2.c
@@ -21,7 +21,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/ip32/mace.h>
 #include <asm/ip32/ip32_ints.h>
 
diff --git a/drivers/input/serio/rpckbd.c b/drivers/input/serio/rpckbd.c
index 8b44ddc..d8aac17 100644
--- a/drivers/input/serio/rpckbd.c
+++ b/drivers/input/serio/rpckbd.c
@@ -39,7 +39,6 @@
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <asm/hardware/iomd.h>
-#include <asm/system.h>
 
 MODULE_AUTHOR("Vojtech Pavlik, Russell King");
 MODULE_DESCRIPTION("Acorn RiscPC PS/2 keyboard controller driver");
diff --git a/drivers/input/serio/sa1111ps2.c b/drivers/input/serio/sa1111ps2.c
index 44fc8b4..e3c85fa 100644
--- a/drivers/input/serio/sa1111ps2.c
+++ b/drivers/input/serio/sa1111ps2.c
@@ -20,7 +20,6 @@
 #include <linux/spinlock.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <asm/hardware/sa1111.h>
 
diff --git a/drivers/isdn/hardware/avm/avm_cs.c b/drivers/isdn/hardware/avm/avm_cs.c
index 61f516f..c263ce6 100644
--- a/drivers/isdn/hardware/avm/avm_cs.c
+++ b/drivers/isdn/hardware/avm/avm_cs.c
@@ -18,7 +18,6 @@
 #include <linux/serial.h>
 #include <linux/major.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ciscode.h>
diff --git a/drivers/isdn/hisax/avma1_cs.c b/drivers/isdn/hisax/avma1_cs.c
index 8f0ad2a..568e6dc 100644
--- a/drivers/isdn/hisax/avma1_cs.c
+++ b/drivers/isdn/hisax/avma1_cs.c
@@ -18,7 +18,6 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
diff --git a/drivers/isdn/hisax/elsa_cs.c b/drivers/isdn/hisax/elsa_cs.c
index f0b6c0e..4a57e9a 100644
--- a/drivers/isdn/hisax/elsa_cs.c
+++ b/drivers/isdn/hisax/elsa_cs.c
@@ -44,7 +44,6 @@
 #include <linux/timer.h>
 #include <linux/ioport.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
diff --git a/drivers/isdn/hisax/sedlbauer_cs.c b/drivers/isdn/hisax/sedlbauer_cs.c
index 06473f8..cb59b40 100644
--- a/drivers/isdn/hisax/sedlbauer_cs.c
+++ b/drivers/isdn/hisax/sedlbauer_cs.c
@@ -44,7 +44,6 @@
 #include <linux/timer.h>
 #include <linux/ioport.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
diff --git a/drivers/isdn/hisax/teles_cs.c b/drivers/isdn/hisax/teles_cs.c
index 161a193..81832a3 100644
--- a/drivers/isdn/hisax/teles_cs.c
+++ b/drivers/isdn/hisax/teles_cs.c
@@ -25,7 +25,6 @@
 #include <linux/timer.h>
 #include <linux/ioport.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/cisreg.h>
diff --git a/drivers/isdn/i4l/isdn_bsdcomp.c b/drivers/isdn/i4l/isdn_bsdcomp.c
index aa0b6a6..9f72702 100644
--- a/drivers/isdn/i4l/isdn_bsdcomp.c
+++ b/drivers/isdn/i4l/isdn_bsdcomp.c
@@ -69,7 +69,6 @@
 #include <linux/signal.h>	/* used in new tty drivers */
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/types.h>
 
diff --git a/drivers/isdn/pcbit/layer2.c b/drivers/isdn/pcbit/layer2.c
index 30f0f45..13e2c37 100644
--- a/drivers/isdn/pcbit/layer2.c
+++ b/drivers/isdn/pcbit/layer2.c
@@ -36,7 +36,6 @@
 
 #include <linux/isdnif.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 
diff --git a/drivers/macintosh/macio-adb.c b/drivers/macintosh/macio-adb.c
index b6ef8f5..87de8d9 100644
--- a/drivers/macintosh/macio-adb.c
+++ b/drivers/macintosh/macio-adb.c
@@ -14,7 +14,6 @@
 #include <asm/pgtable.h>
 #include <asm/hydra.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
 
diff --git a/drivers/macintosh/therm_adt746x.c b/drivers/macintosh/therm_adt746x.c
index c60d025..fc71723 100644
--- a/drivers/macintosh/therm_adt746x.c
+++ b/drivers/macintosh/therm_adt746x.c
@@ -29,7 +29,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 
 #undef DEBUG
diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index 0ff92c2..97cfc5a 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -127,7 +127,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/macio.h>
 
diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index 46c4e95..3b4a157 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -41,7 +41,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/macio.h>
 
diff --git a/drivers/macintosh/via-cuda.c b/drivers/macintosh/via-cuda.c
index 971bc95..86511c5 100644
--- a/drivers/macintosh/via-cuda.c
+++ b/drivers/macintosh/via-cuda.c
@@ -26,7 +26,6 @@
 #include <asm/mac_via.h>
 #endif
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/init.h>
 
 static volatile unsigned char __iomem *via;
diff --git a/drivers/macintosh/via-macii.c b/drivers/macintosh/via-macii.c
index c9570fc..3725f08 100644
--- a/drivers/macintosh/via-macii.c
+++ b/drivers/macintosh/via-macii.c
@@ -34,7 +34,6 @@
 #include <asm/macintosh.h>
 #include <asm/macints.h>
 #include <asm/mac_via.h>
-#include <asm/system.h>
 
 static volatile unsigned char *via;
 
diff --git a/drivers/macintosh/via-pmu.c b/drivers/macintosh/via-pmu.c
index 6cccd60..22b8ce4 100644
--- a/drivers/macintosh/via-pmu.c
+++ b/drivers/macintosh/via-pmu.c
@@ -50,7 +50,6 @@
 #include <asm/machdep.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/irq.h>
 #include <asm/pmac_feature.h>
diff --git a/drivers/macintosh/via-pmu68k.c b/drivers/macintosh/via-pmu68k.c
index aeb30d0..a00ee41 100644
--- a/drivers/macintosh/via-pmu68k.c
+++ b/drivers/macintosh/via-pmu68k.c
@@ -37,7 +37,6 @@
 #include <asm/mac_via.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/macintosh/windfarm_lm75_sensor.c b/drivers/macintosh/windfarm_lm75_sensor.c
index 647c6ad..4d6a90a 100644
--- a/drivers/macintosh/windfarm_lm75_sensor.c
+++ b/drivers/macintosh/windfarm_lm75_sensor.c
@@ -18,7 +18,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/pmac_low_i2c.h>
 
diff --git a/drivers/macintosh/windfarm_pm121.c b/drivers/macintosh/windfarm_pm121.c
index 30e6195..04067e0 100644
--- a/drivers/macintosh/windfarm_pm121.c
+++ b/drivers/macintosh/windfarm_pm121.c
@@ -215,7 +215,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/smu.h>
 
diff --git a/drivers/macintosh/windfarm_pm81.c b/drivers/macintosh/windfarm_pm81.c
index 749d174..fc13d0f 100644
--- a/drivers/macintosh/windfarm_pm81.c
+++ b/drivers/macintosh/windfarm_pm81.c
@@ -107,7 +107,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/smu.h>
 
diff --git a/drivers/macintosh/windfarm_pm91.c b/drivers/macintosh/windfarm_pm91.c
index 3442732..a9430ed 100644
--- a/drivers/macintosh/windfarm_pm91.c
+++ b/drivers/macintosh/windfarm_pm91.c
@@ -41,7 +41,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/smu.h>
 
diff --git a/drivers/macintosh/windfarm_smu_controls.c b/drivers/macintosh/windfarm_smu_controls.c
index 43137b4..3c2be51 100644
--- a/drivers/macintosh/windfarm_smu_controls.c
+++ b/drivers/macintosh/windfarm_smu_controls.c
@@ -18,7 +18,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/smu.h>
 
diff --git a/drivers/macintosh/windfarm_smu_sensors.c b/drivers/macintosh/windfarm_smu_sensors.c
index 3c19350..1cc4e49 100644
--- a/drivers/macintosh/windfarm_smu_sensors.c
+++ b/drivers/macintosh/windfarm_smu_sensors.c
@@ -18,7 +18,6 @@
 #include <asm/prom.h>
 #include <asm/machdep.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 #include <asm/smu.h>
 
diff --git a/drivers/media/dvb/dvb-core/dmxdev.c b/drivers/media/dvb/dvb-core/dmxdev.c
index e4b5c03..73970cd 100644
--- a/drivers/media/dvb/dvb-core/dmxdev.c
+++ b/drivers/media/dvb/dvb-core/dmxdev.c
@@ -29,7 +29,6 @@
 #include <linux/ioctl.h>
 #include <linux/wait.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include "dmxdev.h"
 
 static int debug;
diff --git a/drivers/media/dvb/firewire/firedtv-fw.c b/drivers/media/dvb/firewire/firedtv-fw.c
index 864b627..e24ec53 100644
--- a/drivers/media/dvb/firewire/firedtv-fw.c
+++ b/drivers/media/dvb/firewire/firedtv-fw.c
@@ -20,7 +20,6 @@
 #include <linux/workqueue.h>
 
 #include <asm/page.h>
-#include <asm/system.h>
 
 #include <dvb_demux.h>
 
diff --git a/drivers/media/dvb/ttpci/av7110.c b/drivers/media/dvb/ttpci/av7110.c
index 6ecbcf6..4bd8bd5 100644
--- a/drivers/media/dvb/ttpci/av7110.c
+++ b/drivers/media/dvb/ttpci/av7110.c
@@ -53,7 +53,6 @@
 #include <asm/unaligned.h>
 #include <asm/byteorder.h>
 
-#include <asm/system.h>
 
 #include <linux/dvb/frontend.h>
 
diff --git a/drivers/media/media-devnode.c b/drivers/media/media-devnode.c
index 7b42ace..04d6d54 100644
--- a/drivers/media/media-devnode.c
+++ b/drivers/media/media-devnode.c
@@ -40,7 +40,6 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #include <media/media-devnode.h>
 
diff --git a/drivers/media/video/ivtv/ivtv-driver.h b/drivers/media/video/ivtv/ivtv-driver.h
index 06f3d78..52d5dd7 100644
--- a/drivers/media/video/ivtv/ivtv-driver.h
+++ b/drivers/media/video/ivtv/ivtv-driver.h
@@ -54,7 +54,6 @@
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include <linux/dvb/video.h>
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 5c6100f..1baec83 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -55,7 +55,6 @@
 #include <linux/spi/spi.h>
 #endif
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/div64.h>
diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
index 96e9615..8546f81 100644
--- a/drivers/media/video/v4l2-dev.c
+++ b/drivers/media/video/v4l2-dev.c
@@ -26,7 +26,6 @@
 #include <linux/kmod.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index c8ed7b6..1d31d72 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -57,7 +57,6 @@
 #include <linux/scatterlist.h>
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <linux/atomic.h>
 
diff --git a/drivers/mfd/mcp-core.c b/drivers/mfd/mcp-core.c
index 86cc3f7..32c82de 100644
--- a/drivers/mfd/mcp-core.c
+++ b/drivers/mfd/mcp-core.c
@@ -20,7 +20,6 @@
 #include <linux/mfd/mcp.h>
 
 #include <mach/dma.h>
-#include <asm/system.h>
 
 
 #define to_mcp(d)		container_of(d, struct mcp, attached_device)
diff --git a/drivers/mfd/mcp-sa11x0.c b/drivers/mfd/mcp-sa11x0.c
index 02c53a0..4a27c2b 100644
--- a/drivers/mfd/mcp-sa11x0.c
+++ b/drivers/mfd/mcp-sa11x0.c
@@ -23,7 +23,6 @@
 #include <mach/dma.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/system.h>
 #include <mach/mcp.h>
 
 #include <mach/assabet.h>
diff --git a/drivers/misc/sgi-xp/xp.h b/drivers/misc/sgi-xp/xp.h
index 851b2f2..c862cd4 100644
--- a/drivers/misc/sgi-xp/xp.h
+++ b/drivers/misc/sgi-xp/xp.h
@@ -25,7 +25,6 @@
 #endif
 
 #if defined CONFIG_IA64
-#include <asm/system.h>
 #include <asm/sn/arch.h>	/* defines is_shub1() and is_shub2() */
 #define is_shub()	ia64_platform_is("sn2")
 #endif
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index c6a383d..b869dfb 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -41,7 +41,6 @@
 #include <linux/mmc/mmc.h>
 #include <linux/mmc/sd.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "queue.h"
diff --git a/drivers/mtd/devices/pmc551.c b/drivers/mtd/devices/pmc551.c
index ecff765..5d53c57 100644
--- a/drivers/mtd/devices/pmc551.c
+++ b/drivers/mtd/devices/pmc551.c
@@ -93,7 +93,6 @@
 #include <linux/fs.h>
 #include <linux/ioctl.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/pci.h>
 
 #include <linux/mtd/mtd.h>
diff --git a/drivers/mtd/devices/slram.c b/drivers/mtd/devices/slram.c
index e585263..2885941 100644
--- a/drivers/mtd/devices/slram.c
+++ b/drivers/mtd/devices/slram.c
@@ -42,7 +42,6 @@
 #include <linux/ioctl.h>
 #include <linux/init.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <linux/mtd/mtd.h>
 
diff --git a/drivers/mtd/maps/pcmciamtd.c b/drivers/mtd/maps/pcmciamtd.c
index e8e9fec..0259cf5 100644
--- a/drivers/mtd/maps/pcmciamtd.c
+++ b/drivers/mtd/maps/pcmciamtd.c
@@ -14,7 +14,6 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ds.h>
diff --git a/drivers/mtd/nand/bcm_umi_nand.c b/drivers/mtd/nand/bcm_umi_nand.c
index 50387fd..64c9cba 100644
--- a/drivers/mtd/nand/bcm_umi_nand.c
+++ b/drivers/mtd/nand/bcm_umi_nand.c
@@ -31,7 +31,6 @@
 #include <linux/mtd/partitions.h>
 
 #include <asm/mach-types.h>
-#include <asm/system.h>
 
 #include <mach/reg_nand.h>
 #include <mach/reg_umi.h>
diff --git a/drivers/net/appletalk/cops.c b/drivers/net/appletalk/cops.c
index 9abd4eb..dd5e048 100644
--- a/drivers/net/appletalk/cops.c
+++ b/drivers/net/appletalk/cops.c
@@ -70,7 +70,6 @@ static const char *version =
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/appletalk/ltpc.c b/drivers/net/appletalk/ltpc.c
index 6057b30..0910dce 100644
--- a/drivers/net/appletalk/ltpc.c
+++ b/drivers/net/appletalk/ltpc.c
@@ -229,7 +229,6 @@ static int dma;
 #include <linux/bitops.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/io.h>
 
diff --git a/drivers/net/arcnet/com20020_cs.c b/drivers/net/arcnet/com20020_cs.c
index 980e65c..5bed4c4 100644
--- a/drivers/net/arcnet/com20020_cs.c
+++ b/drivers/net/arcnet/com20020_cs.c
@@ -47,7 +47,6 @@
 #include <pcmcia/ds.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #define VERSION "arcnet: COM20020 PCMCIA support loaded.\n"
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 435984a..5306c2b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -54,7 +54,6 @@
 #include <linux/inet.h>
 #include <linux/bitops.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <linux/uaccess.h>
 #include <linux/errno.h>
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 3f1ebcc..48377da 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -40,7 +40,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
diff --git a/drivers/net/cris/eth_v10.c b/drivers/net/cris/eth_v10.c
index 7cb2785..ec03b40 100644
--- a/drivers/net/cris/eth_v10.c
+++ b/drivers/net/cris/eth_v10.c
@@ -35,7 +35,6 @@
 #include <asm/io.h>         /* CRIS_LED_* I/O functions */
 #include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/ethernet.h>
 #include <asm/cache.h>
 #include <arch/io_interface_mux.h>
diff --git a/drivers/net/ethernet/3com/3c574_cs.c b/drivers/net/ethernet/3com/3c574_cs.c
index 9c01bc9..4638d66 100644
--- a/drivers/net/ethernet/3com/3c574_cs.c
+++ b/drivers/net/ethernet/3com/3c574_cs.c
@@ -95,7 +95,6 @@ earlier 3Com products.
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 /*====================================================================*/
 
diff --git a/drivers/net/ethernet/3com/3c589_cs.c b/drivers/net/ethernet/3com/3c589_cs.c
index da410f0..61c0f22 100644
--- a/drivers/net/ethernet/3com/3c589_cs.c
+++ b/drivers/net/ethernet/3com/3c589_cs.c
@@ -50,7 +50,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 /* To minimize the size of the driver source I only define operating
    constants if they are used several times.  You'll need the manual
diff --git a/drivers/net/ethernet/8390/3c503.c b/drivers/net/ethernet/8390/3c503.c
index fbab136..49d76bd 100644
--- a/drivers/net/ethernet/8390/3c503.c
+++ b/drivers/net/ethernet/8390/3c503.c
@@ -54,7 +54,6 @@ static const char version[] =
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include "8390.h"
diff --git a/drivers/net/ethernet/8390/ac3200.c b/drivers/net/ethernet/8390/ac3200.c
index 5337dd0..ccf0794 100644
--- a/drivers/net/ethernet/8390/ac3200.c
+++ b/drivers/net/ethernet/8390/ac3200.c
@@ -34,7 +34,6 @@ static const char version[] =
 #include <linux/init.h>
 #include <linux/interrupt.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
index 3ad5d2f..9239592 100644
--- a/drivers/net/ethernet/8390/apne.c
+++ b/drivers/net/ethernet/8390/apne.c
@@ -39,7 +39,6 @@
 #include <linux/interrupt.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/setup.h>
 #include <asm/amigaints.h>
diff --git a/drivers/net/ethernet/8390/ax88796.c b/drivers/net/ethernet/8390/ax88796.c
index 0f92e35..a0d654d 100644
--- a/drivers/net/ethernet/8390/ax88796.c
+++ b/drivers/net/ethernet/8390/ax88796.c
@@ -31,7 +31,6 @@
 
 #include <net/ax88796.h>
 
-#include <asm/system.h>
 
 /* Rename the lib8390.c functions to show that they are in this driver */
 #define __ei_open ax_ei_open
diff --git a/drivers/net/ethernet/8390/axnet_cs.c b/drivers/net/ethernet/8390/axnet_cs.c
index bba51cd..631aafd 100644
--- a/drivers/net/ethernet/8390/axnet_cs.c
+++ b/drivers/net/ethernet/8390/axnet_cs.c
@@ -46,7 +46,6 @@
 #include <pcmcia/cisreg.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/net/ethernet/8390/e2100.c b/drivers/net/ethernet/8390/e2100.c
index d16dc53..ed55ce8 100644
--- a/drivers/net/ethernet/8390/e2100.c
+++ b/drivers/net/ethernet/8390/e2100.c
@@ -48,7 +48,6 @@ static const char version[] =
 #include <linux/delay.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/es3210.c b/drivers/net/ethernet/8390/es3210.c
index 6428f9e..ba1b5c9 100644
--- a/drivers/net/ethernet/8390/es3210.c
+++ b/drivers/net/ethernet/8390/es3210.c
@@ -59,7 +59,6 @@ static const char version[] =
 #include <linux/etherdevice.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/etherh.c b/drivers/net/ethernet/8390/etherh.c
index 48c4948..cdbf4df 100644
--- a/drivers/net/ethernet/8390/etherh.c
+++ b/drivers/net/ethernet/8390/etherh.c
@@ -45,7 +45,6 @@
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/ecard.h>
 #include <asm/io.h>
 
diff --git a/drivers/net/ethernet/8390/hp-plus.c b/drivers/net/ethernet/8390/hp-plus.c
index d42938b..52f70f9 100644
--- a/drivers/net/ethernet/8390/hp-plus.c
+++ b/drivers/net/ethernet/8390/hp-plus.c
@@ -33,7 +33,6 @@ static const char version[] =
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "8390.h"
diff --git a/drivers/net/ethernet/8390/hp.c b/drivers/net/ethernet/8390/hp.c
index 113f1e0..37fa89a 100644
--- a/drivers/net/ethernet/8390/hp.c
+++ b/drivers/net/ethernet/8390/hp.c
@@ -33,7 +33,6 @@ static const char version[] =
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "8390.h"
diff --git a/drivers/net/ethernet/8390/lib8390.c b/drivers/net/ethernet/8390/lib8390.c
index 05ae214..fda5348 100644
--- a/drivers/net/ethernet/8390/lib8390.c
+++ b/drivers/net/ethernet/8390/lib8390.c
@@ -57,7 +57,6 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/bitops.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <asm/irq.h>
diff --git a/drivers/net/ethernet/8390/lne390.c b/drivers/net/ethernet/8390/lne390.c
index 69490ae..479409b 100644
--- a/drivers/net/ethernet/8390/lne390.c
+++ b/drivers/net/ethernet/8390/lne390.c
@@ -46,7 +46,6 @@ static const char *version =
 #include <linux/etherdevice.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/mac8390.c b/drivers/net/ethernet/8390/mac8390.c
index af5d982..88ccc8b 100644
--- a/drivers/net/ethernet/8390/mac8390.c
+++ b/drivers/net/ethernet/8390/mac8390.c
@@ -37,7 +37,6 @@
 #include <linux/bitops.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/dma.h>
 #include <asm/hwtest.h>
 #include <asm/macints.h>
diff --git a/drivers/net/ethernet/8390/ne-h8300.c b/drivers/net/ethernet/8390/ne-h8300.c
index 9b9c77d..7fc28f2 100644
--- a/drivers/net/ethernet/8390/ne-h8300.c
+++ b/drivers/net/ethernet/8390/ne-h8300.c
@@ -29,7 +29,6 @@ static const char version1[] =
 #include <linux/etherdevice.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/ethernet/8390/ne.c b/drivers/net/ethernet/8390/ne.c
index f92ea2a..d04911d 100644
--- a/drivers/net/ethernet/8390/ne.c
+++ b/drivers/net/ethernet/8390/ne.c
@@ -53,7 +53,6 @@ static const char version2[] =
 #include <linux/jiffies.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "8390.h"
diff --git a/drivers/net/ethernet/8390/ne2.c b/drivers/net/ethernet/8390/ne2.c
index 922b320..ef85839 100644
--- a/drivers/net/ethernet/8390/ne2.c
+++ b/drivers/net/ethernet/8390/ne2.c
@@ -76,7 +76,6 @@ static const char *version = "ne2.c:v0.91 Nov 16 1998 Wim Dumon <wimpie@kotnet.o
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/8390/ne2k-pci.c b/drivers/net/ethernet/8390/ne2k-pci.c
index 3fab04a..5e8845f 100644
--- a/drivers/net/ethernet/8390/ne2k-pci.c
+++ b/drivers/net/ethernet/8390/ne2k-pci.c
@@ -54,7 +54,6 @@ static int options[MAX_UNITS];
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/ethernet/8390/ne3210.c b/drivers/net/ethernet/8390/ne3210.c
index 2a3e805..a2f8b2b 100644
--- a/drivers/net/ethernet/8390/ne3210.c
+++ b/drivers/net/ethernet/8390/ne3210.c
@@ -39,7 +39,6 @@
 #include <linux/mm.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/pcnet_cs.c b/drivers/net/ethernet/8390/pcnet_cs.c
index 053b255..e29d5f1 100644
--- a/drivers/net/ethernet/8390/pcnet_cs.c
+++ b/drivers/net/ethernet/8390/pcnet_cs.c
@@ -49,7 +49,6 @@
 #include <pcmcia/cisreg.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/net/ethernet/8390/smc-mca.c b/drivers/net/ethernet/8390/smc-mca.c
index 77efec4..7a68590 100644
--- a/drivers/net/ethernet/8390/smc-mca.c
+++ b/drivers/net/ethernet/8390/smc-mca.c
@@ -47,7 +47,6 @@
 #include <linux/etherdevice.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/smc-ultra.c b/drivers/net/ethernet/8390/smc-ultra.c
index 1cc306a..b0fbce3 100644
--- a/drivers/net/ethernet/8390/smc-ultra.c
+++ b/drivers/net/ethernet/8390/smc-ultra.c
@@ -69,7 +69,6 @@ static const char version[] =
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/smc-ultra32.c b/drivers/net/ethernet/8390/smc-ultra32.c
index bb87053..923e42a 100644
--- a/drivers/net/ethernet/8390/smc-ultra32.c
+++ b/drivers/net/ethernet/8390/smc-ultra32.c
@@ -57,7 +57,6 @@ static const char *version = "smc-ultra32.c: 06/97 v1.00\n";
 #include <linux/etherdevice.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/stnic.c b/drivers/net/ethernet/8390/stnic.c
index 3b90375..8df4c41 100644
--- a/drivers/net/ethernet/8390/stnic.c
+++ b/drivers/net/ethernet/8390/stnic.c
@@ -17,7 +17,6 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <mach-se/mach/se.h>
 #include <asm/machvec.h>
diff --git a/drivers/net/ethernet/8390/wd.c b/drivers/net/ethernet/8390/wd.c
index c175fad..03eb3ee 100644
--- a/drivers/net/ethernet/8390/wd.c
+++ b/drivers/net/ethernet/8390/wd.c
@@ -39,7 +39,6 @@ static const char version[] =
 #include <linux/etherdevice.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "8390.h"
 
diff --git a/drivers/net/ethernet/8390/zorro8390.c b/drivers/net/ethernet/8390/zorro8390.c
index bcd2732..7818e63 100644
--- a/drivers/net/ethernet/8390/zorro8390.c
+++ b/drivers/net/ethernet/8390/zorro8390.c
@@ -31,7 +31,6 @@
 #include <linux/zorro.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/amigaints.h>
 #include <asm/amigahw.h>
diff --git a/drivers/net/ethernet/alteon/acenic.c b/drivers/net/ethernet/alteon/acenic.c
index f872748..5a441e2 100644
--- a/drivers/net/ethernet/alteon/acenic.c
+++ b/drivers/net/ethernet/alteon/acenic.c
@@ -78,7 +78,6 @@
 #include <net/sock.h>
 #include <net/ip.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
diff --git a/drivers/net/ethernet/amd/7990.c b/drivers/net/ethernet/amd/7990.c
index 60b35fb..eafe266 100644
--- a/drivers/net/ethernet/amd/7990.c
+++ b/drivers/net/ethernet/amd/7990.c
@@ -33,7 +33,6 @@
 #include <linux/socket.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/pgtable.h>
diff --git a/drivers/net/ethernet/amd/am79c961a.c b/drivers/net/ethernet/amd/am79c961a.c
index 7d5ded8..6f7b4e8 100644
--- a/drivers/net/ethernet/amd/am79c961a.c
+++ b/drivers/net/ethernet/amd/am79c961a.c
@@ -30,7 +30,6 @@
 #include <linux/io.h>
 
 #include <mach/hardware.h>
-#include <asm/system.h>
 
 #define TX_BUFFERS 15
 #define RX_BUFFERS 25
diff --git a/drivers/net/ethernet/amd/amd8111e.c b/drivers/net/ethernet/amd/amd8111e.c
index 33e0a8c..135ddbe 100644
--- a/drivers/net/ethernet/amd/amd8111e.c
+++ b/drivers/net/ethernet/amd/amd8111e.c
@@ -88,7 +88,6 @@ Revision History:
 #include <linux/crc32.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/ethernet/amd/declance.c b/drivers/net/ethernet/amd/declance.c
index 73f8d4f..4b1fb99 100644
--- a/drivers/net/ethernet/amd/declance.c
+++ b/drivers/net/ethernet/amd/declance.c
@@ -64,7 +64,6 @@
 #include <linux/types.h>
 
 #include <asm/addrspace.h>
-#include <asm/system.h>
 
 #include <asm/dec/interrupts.h>
 #include <asm/dec/ioasic.h>
diff --git a/drivers/net/ethernet/amd/hplance.c b/drivers/net/ethernet/amd/hplance.c
index 86aa0d5..fd5babe 100644
--- a/drivers/net/ethernet/amd/hplance.c
+++ b/drivers/net/ethernet/amd/hplance.c
@@ -22,7 +22,6 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 
diff --git a/drivers/net/ethernet/amd/mvme147.c b/drivers/net/ethernet/amd/mvme147.c
index 56bc47a9..9af3c30 100644
--- a/drivers/net/ethernet/amd/mvme147.c
+++ b/drivers/net/ethernet/amd/mvme147.c
@@ -22,7 +22,6 @@
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/mvme147hw.h>
diff --git a/drivers/net/ethernet/amd/nmclan_cs.c b/drivers/net/ethernet/amd/nmclan_cs.c
index 6be0dd6..c636a18 100644
--- a/drivers/net/ethernet/amd/nmclan_cs.c
+++ b/drivers/net/ethernet/amd/nmclan_cs.c
@@ -154,7 +154,6 @@ Include Files
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 /* ----------------------------------------------------------------------------
 Defines
diff --git a/drivers/net/ethernet/amd/sunlance.c b/drivers/net/ethernet/amd/sunlance.c
index 7ea16d3..bbb73ba 100644
--- a/drivers/net/ethernet/amd/sunlance.c
+++ b/drivers/net/ethernet/amd/sunlance.c
@@ -95,7 +95,6 @@ static char lancestr[] = "LANCE";
 #include <linux/of_device.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/pgtable.h>
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 423d023..bc0e508 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -48,7 +48,6 @@
 #include <net/checksum.h>
 #include <net/ip.h>
 
-#include <asm/system.h>
 #include <linux/io.h>
 #include <asm/byteorder.h>
 #include <linux/uaccess.h>
diff --git a/drivers/net/ethernet/cirrus/cs89x0.c b/drivers/net/ethernet/cirrus/cs89x0.c
index f328da2..7b7c925 100644
--- a/drivers/net/ethernet/cirrus/cs89x0.c
+++ b/drivers/net/ethernet/cirrus/cs89x0.c
@@ -148,7 +148,6 @@
 #include <linux/delay.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #if ALLOW_DMA
diff --git a/drivers/net/ethernet/cirrus/mac89x0.c b/drivers/net/ethernet/cirrus/mac89x0.c
index 83781f3..966ac81 100644
--- a/drivers/net/ethernet/cirrus/mac89x0.c
+++ b/drivers/net/ethernet/cirrus/mac89x0.c
@@ -99,7 +99,6 @@ static char *version =
 #include <linux/bitops.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/hwtest.h>
 #include <asm/macints.h>
diff --git a/drivers/net/ethernet/dlink/de600.c b/drivers/net/ethernet/dlink/de600.c
index c24fab1..e3a3273 100644
--- a/drivers/net/ethernet/dlink/de600.c
+++ b/drivers/net/ethernet/dlink/de600.c
@@ -46,7 +46,6 @@ static const char version[] = "de600.c: $Revision: 1.41-2.5 $,  Bjorn Ekwall (bj
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/in.h>
-#include <asm/system.h>
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/delay.h>
diff --git a/drivers/net/ethernet/dlink/de620.c b/drivers/net/ethernet/dlink/de620.c
index 3b934ab..5a4513b 100644
--- a/drivers/net/ethernet/dlink/de620.c
+++ b/drivers/net/ethernet/dlink/de620.c
@@ -122,7 +122,6 @@ static const char version[] =
 #include <linux/skbuff.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 /* Constant definitions for the DE-620 registers, commands and bits */
 #include "de620.h"
diff --git a/drivers/net/ethernet/fujitsu/at1700.c b/drivers/net/ethernet/fujitsu/at1700.c
index 7c6c908..c8e92bc 100644
--- a/drivers/net/ethernet/fujitsu/at1700.c
+++ b/drivers/net/ethernet/fujitsu/at1700.c
@@ -52,7 +52,6 @@
 #include <linux/crc32.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/fujitsu/eth16i.c b/drivers/net/ethernet/fujitsu/eth16i.c
index b0e2313..2485e87 100644
--- a/drivers/net/ethernet/fujitsu/eth16i.c
+++ b/drivers/net/ethernet/fujitsu/eth16i.c
@@ -163,7 +163,6 @@ static char *version =
 #include <linux/jiffies.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/dma.h>
 
 
diff --git a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
index ee84b47..f4c2dd7 100644
--- a/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
+++ b/drivers/net/ethernet/fujitsu/fmvj18x_cs.c
@@ -57,7 +57,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 /*====================================================================*/
 
diff --git a/drivers/net/ethernet/i825xx/3c507.c b/drivers/net/ethernet/i825xx/3c507.c
index 1e94555..7e2a936 100644
--- a/drivers/net/ethernet/i825xx/3c507.c
+++ b/drivers/net/ethernet/i825xx/3c507.c
@@ -63,7 +63,6 @@ static const char version[] =
 
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 /* use 0 for production, 1 for verification, 2..7 for debug */
diff --git a/drivers/net/ethernet/i825xx/3c527.c b/drivers/net/ethernet/i825xx/3c527.c
index 474b5e7..c5ba6a2 100644
--- a/drivers/net/ethernet/i825xx/3c527.c
+++ b/drivers/net/ethernet/i825xx/3c527.c
@@ -106,7 +106,6 @@ DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE " Richard Procter <rnp@paradise.net.
 #include <linux/semaphore.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/i825xx/eepro.c b/drivers/net/ethernet/i825xx/eepro.c
index 114cda77..dac995d 100644
--- a/drivers/net/ethernet/i825xx/eepro.c
+++ b/drivers/net/ethernet/i825xx/eepro.c
@@ -148,7 +148,6 @@ static const char version[] =
 #include <linux/bitops.h>
 #include <linux/ethtool.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/i825xx/eexpress.c b/drivers/net/ethernet/i825xx/eexpress.c
index 3a9580f..31054f2 100644
--- a/drivers/net/ethernet/i825xx/eexpress.c
+++ b/drivers/net/ethernet/i825xx/eexpress.c
@@ -116,7 +116,6 @@
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/ethernet/i825xx/ether1.c b/drivers/net/ethernet/i825xx/ether1.c
index 42e90a9..b87eff6 100644
--- a/drivers/net/ethernet/i825xx/ether1.c
+++ b/drivers/net/ethernet/i825xx/ether1.c
@@ -48,7 +48,6 @@
 #include <linux/skbuff.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/ecard.h>
diff --git a/drivers/net/ethernet/i825xx/znet.c b/drivers/net/ethernet/i825xx/znet.c
index 962b4c4..f0ea476 100644
--- a/drivers/net/ethernet/i825xx/znet.c
+++ b/drivers/net/ethernet/i825xx/znet.c
@@ -100,7 +100,6 @@
 #include <linux/if_arp.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 6ad094f..e3198bc 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -55,7 +55,6 @@
 #include <linux/crc32.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/bitops.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 9edecfa..97b7709 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -57,7 +57,6 @@
 #include <linux/types.h>
 #include <linux/inet_lro.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 
 static char mv643xx_eth_driver_name[] = "mv643xx_eth";
 static char mv643xx_eth_driver_version[] = "1.4";
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 953ba58..44da3ec 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -43,7 +43,6 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <asm/cacheflush.h>
 #include <linux/pxa168_eth.h>
 
diff --git a/drivers/net/ethernet/natsemi/jazzsonic.c b/drivers/net/ethernet/natsemi/jazzsonic.c
index 5b89fd3..95dd39f 100644
--- a/drivers/net/ethernet/natsemi/jazzsonic.c
+++ b/drivers/net/ethernet/natsemi/jazzsonic.c
@@ -38,7 +38,6 @@
 #include <linux/slab.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/dma.h>
diff --git a/drivers/net/ethernet/natsemi/macsonic.c b/drivers/net/ethernet/natsemi/macsonic.c
index f1b8556..b8d2c34 100644
--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -53,7 +53,6 @@
 #include <linux/slab.h>
 
 #include <asm/bootinfo.h>
-#include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
 #include <asm/hwtest.h>
diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index c24b46c..d52728b 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -121,7 +121,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #define DRV_NAME "ns83820"
 
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 97f63e1..da472d8 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -81,7 +81,6 @@
 #include <linux/prefetch.h>
 #include <net/tcp.h>
 
-#include <asm/system.h>
 #include <asm/div64.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 4c4e7f4..33d551e 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -69,7 +69,6 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #define TX_WORK_PER_LOOP  64
 #define RX_WORK_PER_LOOP  64
diff --git a/drivers/net/ethernet/realtek/atp.c b/drivers/net/ethernet/realtek/atp.c
index e3f57fd..3049264 100644
--- a/drivers/net/ethernet/realtek/atp.c
+++ b/drivers/net/ethernet/realtek/atp.c
@@ -140,7 +140,6 @@ static int xcvr[NUM_UNITS]; 			/* The data transfer mode. */
 #include <linux/delay.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 1adf177..7f4c1639 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -29,7 +29,6 @@
 #include <linux/pci-aspm.h>
 #include <linux/prefetch.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/ethernet/seeq/ether3.c b/drivers/net/ethernet/seeq/ether3.c
index 893c880..4d511c2 100644
--- a/drivers/net/ethernet/seeq/ether3.c
+++ b/drivers/net/ethernet/seeq/ether3.c
@@ -64,7 +64,6 @@
 #include <linux/delay.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/ecard.h>
 #include <asm/io.h>
 
diff --git a/drivers/net/ethernet/seeq/seeq8005.c b/drivers/net/ethernet/seeq/seeq8005.c
index 6056145..7474e8c 100644
--- a/drivers/net/ethernet/seeq/seeq8005.c
+++ b/drivers/net/ethernet/seeq/seeq8005.c
@@ -47,7 +47,6 @@ static const char version[] =
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 
diff --git a/drivers/net/ethernet/smsc/smc91c92_cs.c b/drivers/net/ethernet/smsc/smc91c92_cs.c
index ada927a..210e6ee 100644
--- a/drivers/net/ethernet/smsc/smc91c92_cs.c
+++ b/drivers/net/ethernet/smsc/smc91c92_cs.c
@@ -53,7 +53,6 @@
 #include <pcmcia/ss.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 /*====================================================================*/
diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
index f10665f..b414f2f 100644
--- a/drivers/net/ethernet/sun/cassini.c
+++ b/drivers/net/ethernet/sun/cassini.c
@@ -99,7 +99,6 @@
 #include <net/checksum.h>
 
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/ethernet/sun/sunbmac.c b/drivers/net/ethernet/sun/sunbmac.c
index 220f724..14e6af9 100644
--- a/drivers/net/ethernet/sun/sunbmac.c
+++ b/drivers/net/ethernet/sun/sunbmac.c
@@ -35,7 +35,6 @@
 #include <asm/openprom.h>
 #include <asm/oplib.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 #include "sunbmac.h"
 
diff --git a/drivers/net/ethernet/sun/sungem.c b/drivers/net/ethernet/sun/sungem.c
index 31441a8..543c5f2 100644
--- a/drivers/net/ethernet/sun/sungem.c
+++ b/drivers/net/ethernet/sun/sungem.c
@@ -41,7 +41,6 @@
 #include <linux/mm.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
index 09c5186..f0f395e 100644
--- a/drivers/net/ethernet/sun/sunhme.c
+++ b/drivers/net/ethernet/sun/sunhme.c
@@ -36,7 +36,6 @@
 #include <linux/bitops.h>
 #include <linux/dma-mapping.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/byteorder.h>
diff --git a/drivers/net/ethernet/sun/sunqe.c b/drivers/net/ethernet/sun/sunqe.c
index b28f743..b02584c 100644
--- a/drivers/net/ethernet/sun/sunqe.c
+++ b/drivers/net/ethernet/sun/sunqe.c
@@ -28,7 +28,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/byteorder.h>
diff --git a/drivers/net/ethernet/tundra/tsi108_eth.c b/drivers/net/ethernet/tundra/tsi108_eth.c
index 164fb77..75cd722 100644
--- a/drivers/net/ethernet/tundra/tsi108_eth.c
+++ b/drivers/net/ethernet/tundra/tsi108_eth.c
@@ -50,7 +50,6 @@
 #include <linux/platform_device.h>
 #include <linux/gfp.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/tsi108.h>
 
diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index 33979c3..4f29ed2 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -89,7 +89,6 @@
 #include <pcmcia/ciscode.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #ifndef MANFID_COMPAQ
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 2a5a34d..64783a0 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -13,7 +13,6 @@
  */
 
 #include <linux/module.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
diff --git a/drivers/net/hamradio/baycom_par.c b/drivers/net/hamradio/baycom_par.c
index 279d229..3d73bf9 100644
--- a/drivers/net/hamradio/baycom_par.c
+++ b/drivers/net/hamradio/baycom_par.c
@@ -86,7 +86,6 @@
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 /* --------------------------------------------------------------------- */
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index 18d8aff..76d5477 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -69,7 +69,6 @@
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index bc02968..aed1a61 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -17,7 +17,6 @@
  * Copyright (C) 2004, 05 Thomas Osterried DL9SAU <thomas@x-berg.in-berlin.de>
  */
 #include <linux/module.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <asm/uaccess.h>
 #include <linux/crc16.h>
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index 3365581..efc6c97 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -177,7 +177,6 @@
 #include <net/ax25.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 96a98d2..bdb9750 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -52,7 +52,6 @@
 #include <linux/bitops.h>
 #include <linux/random.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
 #include <linux/firmware.h>
diff --git a/drivers/net/hippi/rrunner.c b/drivers/net/hippi/rrunner.c
index e68c941..4e689d3 100644
--- a/drivers/net/hippi/rrunner.c
+++ b/drivers/net/hippi/rrunner.c
@@ -43,7 +43,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <asm/cache.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
diff --git a/drivers/net/irda/donauboe.c b/drivers/net/irda/donauboe.c
index 64f403d..1569bca 100644
--- a/drivers/net/irda/donauboe.c
+++ b/drivers/net/irda/donauboe.c
@@ -156,7 +156,6 @@
 #include <linux/pci.h>
 #include <linux/rtnetlink.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <net/irda/wrapper.h>
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index b71998d..32eb94e 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -41,7 +41,6 @@
 #include <linux/in.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index a9e9ca8..5c4209b 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -113,7 +113,6 @@ static const char version[] = "NET3 PLIP version 2.4-parport gniibe@mri.co.jp\n"
 
 #include <net/neighbour.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
 
diff --git a/drivers/net/slip/slhc.c b/drivers/net/slip/slhc.c
index 0a0a664..1252d9c 100644
--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -75,7 +75,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <linux/timer.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <net/checksum.h>
 #include <asm/unaligned.h>
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index ba08341..0b08f3c 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -64,7 +64,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/sched.h>
diff --git a/drivers/net/tokenring/3c359.c b/drivers/net/tokenring/3c359.c
index ef9fdf3..fb99a0a 100644
--- a/drivers/net/tokenring/3c359.c
+++ b/drivers/net/tokenring/3c359.c
@@ -68,7 +68,6 @@
 #include <net/checksum.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "3c359.h"
 
diff --git a/drivers/net/tokenring/abyss.c b/drivers/net/tokenring/abyss.c
index 515f122..b715e6b 100644
--- a/drivers/net/tokenring/abyss.c
+++ b/drivers/net/tokenring/abyss.c
@@ -33,7 +33,6 @@
 #include <linux/netdevice.h>
 #include <linux/trdevice.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/tokenring/ibmtr_cs.c b/drivers/net/tokenring/ibmtr_cs.c
index 91b6846..356e28e 100644
--- a/drivers/net/tokenring/ibmtr_cs.c
+++ b/drivers/net/tokenring/ibmtr_cs.c
@@ -63,7 +63,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #define PCMCIA
 #include "ibmtr.c"
diff --git a/drivers/net/tokenring/lanstreamer.c b/drivers/net/tokenring/lanstreamer.c
index 8d71e0d..3e4b4f0 100644
--- a/drivers/net/tokenring/lanstreamer.c
+++ b/drivers/net/tokenring/lanstreamer.c
@@ -127,7 +127,6 @@
 #include <net/checksum.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "lanstreamer.h"
 
diff --git a/drivers/net/tokenring/madgemc.c b/drivers/net/tokenring/madgemc.c
index 6153cfd..ff78d5c 100644
--- a/drivers/net/tokenring/madgemc.c
+++ b/drivers/net/tokenring/madgemc.c
@@ -28,7 +28,6 @@ static const char version[] = "madgemc.c: v0.91 23/01/2000 by Adam Fritzler\n";
 #include <linux/netdevice.h>
 #include <linux/trdevice.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/tokenring/olympic.c b/drivers/net/tokenring/olympic.c
index fd8dce9..0e23474 100644
--- a/drivers/net/tokenring/olympic.c
+++ b/drivers/net/tokenring/olympic.c
@@ -106,7 +106,6 @@
 #include <net/net_namespace.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "olympic.h"
 
diff --git a/drivers/net/tokenring/proteon.c b/drivers/net/tokenring/proteon.c
index 8d362e6..62d90e4 100644
--- a/drivers/net/tokenring/proteon.c
+++ b/drivers/net/tokenring/proteon.c
@@ -31,7 +31,6 @@ static const char version[] = "proteon.c: v1.00 02/01/2003 by Jochen Friedrich\n
 #include <linux/trdevice.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/pci.h>
diff --git a/drivers/net/tokenring/skisa.c b/drivers/net/tokenring/skisa.c
index 46db5c5..ee11e93 100644
--- a/drivers/net/tokenring/skisa.c
+++ b/drivers/net/tokenring/skisa.c
@@ -38,7 +38,6 @@ static const char version[] = "skisa.c: v1.03 09/12/2002 by Jochen Friedrich\n";
 #include <linux/trdevice.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/pci.h>
diff --git a/drivers/net/tokenring/smctr.c b/drivers/net/tokenring/smctr.c
index 029846a..cb35fb7 100644
--- a/drivers/net/tokenring/smctr.c
+++ b/drivers/net/tokenring/smctr.c
@@ -49,7 +49,6 @@
 #include <linux/bitops.h>
 #include <linux/firmware.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
diff --git a/drivers/net/tokenring/tms380tr.c b/drivers/net/tokenring/tms380tr.c
index 65e9cf3..0c4303a 100644
--- a/drivers/net/tokenring/tms380tr.c
+++ b/drivers/net/tokenring/tms380tr.c
@@ -98,7 +98,6 @@ static const char version[] = "tms380tr.c: v1.10 30/12/2002 by Christoph Goos, A
 #include <linux/firmware.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/irq.h>
diff --git a/drivers/net/tokenring/tmspci.c b/drivers/net/tokenring/tmspci.c
index d3e788a..fb9918d 100644
--- a/drivers/net/tokenring/tmspci.c
+++ b/drivers/net/tokenring/tmspci.c
@@ -34,7 +34,6 @@
 #include <linux/netdevice.h>
 #include <linux/trdevice.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 93c5d72..49432bf 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -69,7 +69,6 @@
 #include <net/rtnetlink.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 /* Uncomment to enable debugging */
diff --git a/drivers/net/wan/dlci.c b/drivers/net/wan/dlci.c
index 48ab38a..147614e 100644
--- a/drivers/net/wan/dlci.c
+++ b/drivers/net/wan/dlci.c
@@ -50,7 +50,6 @@
 
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c
index 058e169..c31e7c0 100644
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -93,7 +93,6 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/cache.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/wan/hd64570.c b/drivers/net/wan/hd64570.c
index 33b67d8..cf49033 100644
--- a/drivers/net/wan/hd64570.c
+++ b/drivers/net/wan/hd64570.c
@@ -40,7 +40,6 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include "hd64570.h"
 
diff --git a/drivers/net/wan/hd64572.c b/drivers/net/wan/hd64572.c
index efc0db1..e2779fa 100644
--- a/drivers/net/wan/hd64572.c
+++ b/drivers/net/wan/hd64572.c
@@ -40,7 +40,6 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include "hd64572.h"
 
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 7beeb9b..a73b49e 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -35,7 +35,6 @@
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/drivers/net/wan/sdla.c b/drivers/net/wan/sdla.c
index c853161..de3bbf4 100644
--- a/drivers/net/wan/sdla.c
+++ b/drivers/net/wan/sdla.c
@@ -54,7 +54,6 @@
 #include <linux/sdla.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/dma.h>
 #include <asm/uaccess.h>
diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 8a10bb7..04581dc 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -18,7 +18,6 @@
 
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <linux/bitops.h>
 #include <linux/string.h>
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 1c008c6..5d3123c 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -37,7 +37,6 @@
 #include <linux/scatterlist.h>
 #include <linux/crypto.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/airo_cs.c b/drivers/net/wireless/airo_cs.c
index c983c10..630577d 100644
--- a/drivers/net/wireless/airo_cs.c
+++ b/drivers/net/wireless/airo_cs.c
@@ -37,7 +37,6 @@
 #include <pcmcia/ds.h>
 
 #include <linux/io.h>
-#include <asm/system.h>
 
 #include "airo.h"
 
diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index 7e45ca2..370f7ae 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -50,7 +50,6 @@
 #include <linux/timer.h>
 #include <asm/byteorder.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/atmel_cs.c b/drivers/net/wireless/atmel_cs.c
index ec295c4..ded03d2 100644
--- a/drivers/net/wireless/atmel_cs.c
+++ b/drivers/net/wireless/atmel_cs.c
@@ -48,7 +48,6 @@
 #include <pcmcia/ciscode.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/wireless.h>
 
 #include "atmel.h"
diff --git a/drivers/net/wireless/prism54/islpci_mgt.c b/drivers/net/wireless/prism54/islpci_mgt.c
index a5224f6..8be83e1 100644
--- a/drivers/net/wireless/prism54/islpci_mgt.c
+++ b/drivers/net/wireless/prism54/islpci_mgt.c
@@ -24,7 +24,6 @@
 #include <linux/slab.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <linux/if_arp.h>
 
 #include "prismcompat.h"
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 04fec1f..86a738b 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -53,7 +53,6 @@
 #include <net/iw_handler.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 98fbf54..00f6e69 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -53,7 +53,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include "wl3501.h"
 
diff --git a/drivers/nubus/nubus.c b/drivers/nubus/nubus.c
index b764ac22d..44d01af 100644
--- a/drivers/nubus/nubus.c
+++ b/drivers/nubus/nubus.c
@@ -17,7 +17,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/hwtest.h>
 #include <linux/proc_fs.h>
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 7ff10c1..9c5aae5 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -55,7 +55,6 @@
 
 #include <asm/pdc.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/hardware.h>
 
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 95930d0..1f9e9fe 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -140,7 +140,6 @@
 #include <asm/pdc.h>
 #include <asm/pdcpat.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <asm/io.h>		/* read/write functions */
 #ifdef CONFIG_SUPERIO
 #include <asm/superio.h>
diff --git a/drivers/parisc/lba_pci.c b/drivers/parisc/lba_pci.c
index d5f3d75..320e43a 100644
--- a/drivers/parisc/lba_pci.c
+++ b/drivers/parisc/lba_pci.c
@@ -43,7 +43,6 @@
 #include <asm/pdc.h>
 #include <asm/pdcpat.h>
 #include <asm/page.h>
-#include <asm/system.h>
 
 #include <asm/ropes.h>
 #include <asm/hardware.h>	/* for register_parisc_driver() stuff */
diff --git a/drivers/pcmcia/cs.c b/drivers/pcmcia/cs.c
index d9ea192..673c14e 100644
--- a/drivers/pcmcia/cs.c
+++ b/drivers/pcmcia/cs.c
@@ -29,7 +29,6 @@
 #include <linux/device.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 
 #include <pcmcia/ss.h>
diff --git a/drivers/pcmcia/i82092.c b/drivers/pcmcia/i82092.c
index 3e447d0..0b66bfc 100644
--- a/drivers/pcmcia/i82092.c
+++ b/drivers/pcmcia/i82092.c
@@ -17,7 +17,6 @@
 
 #include <pcmcia/ss.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "i82092aa.h"
diff --git a/drivers/pcmcia/i82365.c b/drivers/pcmcia/i82365.c
index 72a033a..e6f3d17 100644
--- a/drivers/pcmcia/i82365.c
+++ b/drivers/pcmcia/i82365.c
@@ -48,7 +48,6 @@
 #include <linux/bitops.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/ss.h>
 
diff --git a/drivers/pcmcia/m32r_cfc.c b/drivers/pcmcia/m32r_cfc.c
index 2adb010..a26f38c 100644
--- a/drivers/pcmcia/m32r_cfc.c
+++ b/drivers/pcmcia/m32r_cfc.c
@@ -24,7 +24,6 @@
 #include <linux/bitops.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/ss.h>
 
diff --git a/drivers/pcmcia/m32r_pcc.c b/drivers/pcmcia/m32r_pcc.c
index 1511ff7..2965141 100644
--- a/drivers/pcmcia/m32r_pcc.c
+++ b/drivers/pcmcia/m32r_pcc.c
@@ -24,7 +24,6 @@
 #include <linux/bitops.h>
 #include <asm/irq.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/addrspace.h>
 
 #include <pcmcia/ss.h>
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index 271a590..a317def 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -52,7 +52,6 @@
 #include <linux/of_platform.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/mpc8xx.h>
 #include <asm/8xx_immap.h>
diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index 96c72e9..0f8b70b 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -19,7 +19,6 @@
 
 #include <pcmcia/ss.h>
 
-#include <asm/system.h>
 
 #include "pd6729.h"
 #include "i82365.h"
diff --git a/drivers/pcmcia/pxa2xx_base.c b/drivers/pcmcia/pxa2xx_base.c
index 64d433e..85ac095 100644
--- a/drivers/pcmcia/pxa2xx_base.c
+++ b/drivers/pcmcia/pxa2xx_base.c
@@ -29,7 +29,6 @@
 #include <mach/smemc.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <mach/pxa2xx-regs.h>
 #include <asm/mach-types.h>
 
diff --git a/drivers/pcmcia/sa11xx_base.c b/drivers/pcmcia/sa11xx_base.c
index 0c62fe3..79ecc23 100644
--- a/drivers/pcmcia/sa11xx_base.c
+++ b/drivers/pcmcia/sa11xx_base.c
@@ -41,7 +41,6 @@
 
 #include <mach/hardware.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include "soc_common.h"
 #include "sa11xx_base.h"
diff --git a/drivers/pcmcia/soc_common.c b/drivers/pcmcia/soc_common.c
index a0a9c2a..5d22c6a 100644
--- a/drivers/pcmcia/soc_common.c
+++ b/drivers/pcmcia/soc_common.c
@@ -45,7 +45,6 @@
 #include <linux/timer.h>
 
 #include <mach/hardware.h>
-#include <asm/system.h>
 
 #include "soc_common.h"
 
diff --git a/drivers/pcmcia/socket_sysfs.c b/drivers/pcmcia/socket_sysfs.c
index 71aeed9..d688151 100644
--- a/drivers/pcmcia/socket_sysfs.c
+++ b/drivers/pcmcia/socket_sysfs.c
@@ -23,7 +23,6 @@
 #include <linux/pm.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 
 #include <pcmcia/ss.h>
diff --git a/drivers/pcmcia/tcic.c b/drivers/pcmcia/tcic.c
index 310160b..cbe15fc 100644
--- a/drivers/pcmcia/tcic.c
+++ b/drivers/pcmcia/tcic.c
@@ -47,7 +47,6 @@
 #include <linux/bitops.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/ss.h>
 #include "tcic.h"
diff --git a/drivers/pcmcia/xxs1500_ss.c b/drivers/pcmcia/xxs1500_ss.c
index 379f421..8f66980 100644
--- a/drivers/pcmcia/xxs1500_ss.c
+++ b/drivers/pcmcia/xxs1500_ss.c
@@ -21,7 +21,6 @@
 #include <pcmcia/cistpl.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/mach-au1x00/au1000.h>
 
 #define MEM_MAP_SIZE	0x400000
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index b859d16..769d265 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -17,7 +17,6 @@
 
 #include <asm/page.h>
 #include <asm/desc.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include "pnpbios.h"
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index cfe8685..9d42226 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -65,7 +65,6 @@
 
 #include <asm/page.h>
 #include <asm/desc.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include "../base.h"
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 96bbe9d..090ea2a 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -42,7 +42,6 @@
 #include <asm/reset.h>
 #include <asm/airq.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 #include <asm/isc.h>
 #include <linux/hrtimer.h>
 #include <linux/ktime.h>
diff --git a/drivers/sbus/char/flash.c b/drivers/sbus/char/flash.c
index 826157f..327657e 100644
--- a/drivers/sbus/char/flash.c
+++ b/drivers/sbus/char/flash.c
@@ -16,7 +16,6 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/io.h>
diff --git a/drivers/sbus/char/openprom.c b/drivers/sbus/char/openprom.c
index 8d6e508..2236aea 100644
--- a/drivers/sbus/char/openprom.c
+++ b/drivers/sbus/char/openprom.c
@@ -40,7 +40,6 @@
 #include <linux/fs.h>
 #include <asm/oplib.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/openpromio.h>
 #ifdef CONFIG_PCI
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index 0b31658..a9e468c 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -19,7 +19,6 @@
 
 #include <asm/openprom.h>
 #include <asm/oplib.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index f672491..a3adfb4 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -129,7 +129,6 @@
 #include <linux/interrupt.h>
 #include <linux/device.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/byteorder.h>
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index f66c33b..d4da370 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -47,7 +47,6 @@
 
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index bfd618a..374c4ed 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -41,7 +41,6 @@
 #include <linux/firmware.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f17c92c..19a3694 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -239,7 +239,6 @@
 #include <asm/irq.h>
 #include <linux/io.h>
 #include <linux/blkdev.h>
-#include <asm/system.h>
 #include <linux/completion.h>
 #include <linux/errno.h>
 #include <linux/string.h>
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index ed119ce..ede91f3 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -42,7 +42,6 @@
 #include <linux/slab.h>
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index 1c10b79..a3e6ed3 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -53,7 +53,6 @@
 #include <linux/gfp.h>
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f980600..013e17d 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -61,7 +61,6 @@
 #include <linux/aer.h>
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index c454e44..b330438 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -138,7 +138,6 @@
 #include <linux/stringify.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/ecard.h>
 
 #include "../scsi.h"
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index a3398fe..c3b99c9 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -12,7 +12,6 @@
 
 #include <asm/ecard.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "../scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index 849cdf8..d25f944 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -13,7 +13,6 @@
 
 #include <asm/ecard.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "../scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 7e6eca4..f29d512 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -30,7 +30,6 @@
 #include <linux/blkdev.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index c2677ba..4b11bb0 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -72,7 +72,6 @@
 #endif
 
 
-#include <asm/system.h>
 #include <linux/module.h>
 #include <linux/signal.h>
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index a2c6135..53bfcaa 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -93,7 +93,6 @@
 #include <linux/mca-legacy.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 643f6d5..1a2a1e5 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -282,7 +282,6 @@
 #include <linux/slab.h>
 #include <scsi/scsicam.h>
 
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 81182ba..1a5954f 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -100,7 +100,6 @@
 #undef NCR5380_STAT_LIMIT
 #endif
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <linux/signal.h>
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3242bca..609efa3 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -129,7 +129,6 @@
 #include <linux/reboot.h>
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <linux/spinlock.h>
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 67fc8ff..cd09132 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -32,7 +32,6 @@
 #include <linux/spinlock.h>
 #include <linux/init.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include "scsi.h"
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 112f1be..deb5b6d 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -123,7 +123,6 @@
 #include <linux/stat.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include "scsi.h"
 #include <scsi/scsi_host.h>
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index e617337..e5cd8d8 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -22,7 +22,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/pci-bridge.h>
 #include <asm/macio.h>
 
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 2bccfbe..24828b5 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -43,7 +43,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include <asm/macintosh.h>
 #include <asm/macints.h>
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 4944747..e8a04ae 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -33,7 +33,6 @@
 #include <asm/io.h>
 #include <asm/pgtable.h>
 #include <asm/prom.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/hydra.h>
 #include <asm/processor.h>
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 4b3b475..5982a58 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -115,7 +115,6 @@
 
 #include <asm/dma.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 0029249..62b6168 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -38,7 +38,6 @@
 #include <linux/dma-mapping.h>
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index de0b1a7..21883a2 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -54,7 +54,6 @@ static const char * osst_version = "0.99.4";
 #include <linux/mutex.h>
 #include <asm/uaccess.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 
 /* The driver prints some debugging information on the console if DEBUG
    is defined and non-zero. */
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
index f2018b4..2f72c98 100644
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -113,7 +113,6 @@
  
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <linux/signal.h>
 #include <linux/proc_fs.h>
 #include <asm/io.h>
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index d838205..6c6486f 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -359,7 +359,6 @@
 #include <asm/byteorder.h>
 #include <asm/processor.h>
 #include <asm/types.h>
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index e40dc1c..b191dd5 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -35,7 +35,6 @@
 #include "qlogicpti.h"
 
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 #include <asm/pgtable.h>
 #include <asm/oplib.h>
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 9b28f39..81d05d2 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -42,7 +42,6 @@ static const char *verstr = "20101219";
 
 #include <asm/uaccess.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_dbg.h>
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index baf7328..6e25889 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -63,7 +63,6 @@
 #include <linux/blkdev.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <asm/sun3ints.h>
 #include <asm/dvma.h>
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index fbba78e..a3dd55d 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -25,7 +25,6 @@
 #include <linux/blkdev.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <asm/sun3ints.h>
 #include <asm/dvma.h>
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 012c86e..ac4eca6 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -37,7 +37,6 @@
 #include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <linux/blkdev.h>
 #include <linux/isapnp.h>
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
index 041eaaa..d672d97 100644
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -106,7 +106,6 @@
  * $Log: t128.c,v $
  */
 
-#include <asm/system.h>
 #include <linux/signal.h>
 #include <linux/io.h>
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 90e104d..9c216e5 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -410,7 +410,6 @@
 #include <linux/ioport.h>
 #include <linux/delay.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index 7e22b73..14e0c40 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -141,7 +141,6 @@
 #include <linux/delay.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/dma.h>
 
 #define ULTRASTOR_PRIVATE	/* Get the private stuff from ultrastor.h */
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 9ee0afe..d89a5df 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -179,7 +179,6 @@
 #include <linux/stat.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 #include <asm/dma.h>
 
 #include <scsi/scsi.h>
diff --git a/drivers/spi/spi-omap-uwire.c b/drivers/spi/spi-omap-uwire.c
index 610f739..9b0d716 100644
--- a/drivers/spi/spi-omap-uwire.c
+++ b/drivers/spi/spi-omap-uwire.c
@@ -47,7 +47,6 @@
 #include <linux/spi/spi_bitbang.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <asm/io.h>
diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index db1fd63..bf185e2 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -42,7 +42,6 @@
 #include <linux/cdev.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
-#include <asm/system.h>
 
 #include "comedidev.h"
 #include "internal.h"
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index c9e8c47..915157d 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -86,7 +86,6 @@ TODO:
 #include "../comedidev.h"
 #include <linux/delay.h>
 #include <linux/interrupt.h>
-#include <asm/system.h>
 
 #include "comedi_pci.h"
 #include "8253.h"
diff --git a/drivers/staging/comedi/drivers/mite.c b/drivers/staging/comedi/drivers/mite.c
index fd274e9..13e9c80 100644
--- a/drivers/staging/comedi/drivers/mite.c
+++ b/drivers/staging/comedi/drivers/mite.c
@@ -55,7 +55,6 @@
 #include "comedi_pci.h"
 #include "../comedidev.h"
 
-#include <asm/system.h>
 
 #define PCI_MITE_SIZE		4096
 #define PCI_DAQ_SIZE		4096
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index a2b5a56..784d14b 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -45,7 +45,6 @@
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 
 #include "crystalhd_cmds.h"
diff --git a/drivers/staging/crystalhd/crystalhd_misc.h b/drivers/staging/crystalhd/crystalhd_misc.h
index 4d61723..d3d117d 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.h
+++ b/drivers/staging/crystalhd/crystalhd_misc.h
@@ -35,7 +35,6 @@
 #include <linux/ioctl.h>
 #include <linux/dma-mapping.h>
 #include <linux/sched.h>
-#include <asm/system.h>
 #include "bc_dts_glob_lnx.h"
 
 /* Global log level variable defined in crystal_misc.c file */
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 2c4069f..185b2e2 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -70,7 +70,6 @@
 #include <linux/delay.h>
 #include <linux/bitops.h>
 #include <linux/io.h>
-#include <asm/system.h>
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index 917bbb0..1a2475b 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -29,7 +29,6 @@
 #include <linux/interrupt.h>
 #include <linux/in.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/bitops.h>
 
 #include <linux/netdevice.h>
diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index 6c9279a..ece2dd1 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -30,7 +30,6 @@
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <linux/videodev2.h>
 #include <media/tuner.h>
 #include <media/v4l2-common.h>
diff --git a/drivers/staging/media/go7007/go7007-i2c.c b/drivers/staging/media/go7007/go7007-i2c.c
index b8cfa1a..6bc82aa 100644
--- a/drivers/staging/media/go7007/go7007-i2c.c
+++ b/drivers/staging/media/go7007/go7007-i2c.c
@@ -26,7 +26,6 @@
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #include "go7007-priv.h"
 #include "wis-i2c.h"
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 2b27d8d..c8c96e2 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -34,7 +34,6 @@
 #include <linux/i2c.h>
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #include "go7007.h"
 #include "go7007-priv.h"
diff --git a/drivers/staging/media/go7007/snd-go7007.c b/drivers/staging/media/go7007/snd-go7007.c
index d071c83..5af29ff 100644
--- a/drivers/staging/media/go7007/snd-go7007.c
+++ b/drivers/staging/media/go7007/snd-go7007.c
@@ -29,7 +29,6 @@
 #include <linux/mutex.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
-#include <asm/system.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
 #include <sound/initval.h>
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index 8dd8897..18a798c 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -66,7 +66,6 @@
 #include <linux/poll.h>
 #include <linux/platform_device.h>
 
-#include <asm/system.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/fcntl.h>
diff --git a/drivers/staging/media/lirc/lirc_sir.c b/drivers/staging/media/lirc/lirc_sir.c
index c94382b..945d962 100644
--- a/drivers/staging/media/lirc/lirc_sir.c
+++ b/drivers/staging/media/lirc/lirc_sir.c
@@ -49,7 +49,6 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/poll.h>
-#include <asm/system.h>
 #include <linux/io.h>
 #include <asm/irq.h>
 #include <linux/fcntl.h>
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 4683d5f..6183573 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -58,7 +58,6 @@
 
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #define LCD_MINOR		156
 #define KEYPAD_MINOR		185
diff --git a/drivers/staging/sbe-2t3e3/io.c b/drivers/staging/sbe-2t3e3/io.c
index b458ff0..9a50bcc 100644
--- a/drivers/staging/sbe-2t3e3/io.c
+++ b/drivers/staging/sbe-2t3e3/io.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/ip.h>
-#include <asm/system.h>
 #include "2t3e3.h"
 #include "ctrl.h"
 
diff --git a/drivers/staging/tidspbridge/include/dspbridge/host_os.h b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
index a2f31c6..ed00d3d 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/host_os.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/host_os.h
@@ -17,7 +17,6 @@
 #ifndef _HOST_OS_H_
 #define _HOST_OS_H_
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <linux/semaphore.h>
 #include <linux/uaccess.h>
diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index 2faee2d..6e169328 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -74,7 +74,6 @@
 #include <linux/in.h>
 #include <linux/delay.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/bitops.h>
 
 #include <linux/netdevice.h>
diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index dab603e..d5bf0a7 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -86,8 +86,7 @@
 // #include <linux/in.h>
 // #include <linux/delay.h>
 // #include <asm/io.h>
-// #include <asm/system.h>
-// #include <asm/bitops.h>
+// // #include <asm/bitops.h>
 #include <linux/unistd.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index 9c16f54..90820ff 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -79,8 +79,7 @@
 // #include <linux/delay.h>
 // #include <linux/skbuff.h>
 // #include <asm/io.h>
-// #include <asm/system.h>
-// #include <asm/bitops.h>
+// // #include <asm/bitops.h>
 
 #include <linux/netdevice.h>
 #include <linux/ethtool.h>
diff --git a/drivers/staging/wlags49_h2/wl_pci.c b/drivers/staging/wlags49_h2/wl_pci.c
index 2bd9b84..3df990c 100644
--- a/drivers/staging/wlags49_h2/wl_pci.c
+++ b/drivers/staging/wlags49_h2/wl_pci.c
@@ -77,7 +77,6 @@
 #include <linux/interrupt.h>
 #include <linux/in.h>
 #include <linux/delay.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/bitops.h>
diff --git a/drivers/staging/wlags49_h2/wl_util.c b/drivers/staging/wlags49_h2/wl_util.c
index b748a3f..f104e6f 100644
--- a/drivers/staging/wlags49_h2/wl_util.c
+++ b/drivers/staging/wlags49_h2/wl_util.c
@@ -73,8 +73,7 @@
 // #include <linux/in.h>
 // #include <linux/delay.h>
 // #include <asm/io.h>
-// #include <asm/system.h>
-// #include <asm/bitops.h>
+// // #include <asm/bitops.h>
 
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/telephony/phonedev.c b/drivers/telephony/phonedev.c
index 1915af2..1dd0b67 100644
--- a/drivers/telephony/phonedev.c
+++ b/drivers/telephony/phonedev.c
@@ -24,7 +24,6 @@
 #include <linux/phonedev.h>
 #include <linux/init.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/kmod.h>
 #include <linux/sem.h>
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index b84c834..35fc4b0 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -85,7 +85,6 @@ static char *serial_version = "4.30";
 
 #include <asm/setup.h>
 
-#include <asm/system.h>
 
 #include <asm/irq.h>
 
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index e5c295a..bffb73f 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -133,7 +133,6 @@
 
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <asm/system.h>
 
 #include <linux/pci.h>
 
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index d15a071..d0255e4 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -46,7 +46,6 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 8998d52..d605f2f 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -41,7 +41,6 @@
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
diff --git a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
index a09ce3e..1b2db9a 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -102,7 +102,6 @@
 #include <linux/if.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/termios.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index d2256d0..94b6eda 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -50,7 +50,6 @@
 #include <linux/uaccess.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 
 /* number of characters left in xmit buffer before select has we have room */
 #define WAKEUP_CHARS 256
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index d8653ab..5c3a467 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -28,7 +28,6 @@
 #include <linux/devpts_fs.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 
 #ifdef CONFIG_UNIX98_PTYS
 static struct tty_driver *ptm_driver;
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index a88ef97..c78230f 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -39,7 +39,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/delay.h>
 #include <asm/uaccess.h>
 
diff --git a/drivers/tty/serial/8250/serial_cs.c b/drivers/tty/serial/8250/serial_cs.c
index 8609060..29b695d 100644
--- a/drivers/tty/serial/8250/serial_cs.c
+++ b/drivers/tty/serial/8250/serial_cs.c
@@ -43,7 +43,6 @@
 #include <linux/delay.h>
 #include <linux/major.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <pcmcia/cistpl.h>
 #include <pcmcia/ciscode.h>
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 1dfba7b..d52cb25 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -34,7 +34,6 @@ static char *serial_version = "$Revision: 1.25 $";
 
 #include <asm/irq.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 
 #include <arch/svinto.h>
 
diff --git a/drivers/tty/serial/dz.c b/drivers/tty/serial/dz.c
index e3699a8..6491b86 100644
--- a/drivers/tty/serial/dz.c
+++ b/drivers/tty/serial/dz.c
@@ -52,7 +52,6 @@
 #include <linux/atomic.h>
 #include <asm/bootinfo.h>
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <asm/dec/interrupts.h>
 #include <asm/dec/kn01.h>
diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index d55709a..defc4e3 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -52,7 +52,6 @@
 #include <linux/firmware.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/uaccess.h>
diff --git a/drivers/tty/serial/msm_serial_hs.c b/drivers/tty/serial/msm_serial_hs.c
index 5e85e1e..fca13dc 100644
--- a/drivers/tty/serial/msm_serial_hs.c
+++ b/drivers/tty/serial/msm_serial_hs.c
@@ -50,7 +50,6 @@
 
 #include <linux/atomic.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include <mach/hardware.h>
 #include <mach/dma.h>
diff --git a/drivers/tty/serial/zs.c b/drivers/tty/serial/zs.c
index b7455b5..4001eee 100644
--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -67,7 +67,6 @@
 #include <linux/types.h>
 
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 #include <asm/dec/interrupts.h>
 #include <asm/dec/ioasic_addrs.h>
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index ff8017f..c3ec75e 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -86,7 +86,6 @@
 #include <linux/ioctl.h>
 #include <linux/synclink.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 18b48cd..e8d68a6 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -73,7 +73,6 @@
 #include <linux/hdlc.h>
 #include <linux/synclink.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index a7efe53..2e06260 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -58,7 +58,6 @@
 #include <linux/delay.h>
 #include <linux/ioctl.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/dma.h>
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index e41b9bb..a80d572 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -97,7 +97,6 @@
 #include <linux/ratelimit.h>
 
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/kbd_kern.h>
 #include <linux/vt_kern.h>
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 9314d93..a1b9a2f 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -23,7 +23,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #undef TTY_DEBUG_WAIT_UNTIL_SENT
 
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index e716839..ce43206 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -99,7 +99,6 @@
 #include <linux/notifier.h>
 #include <linux/device.h>
 #include <linux/io.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <linux/kdb.h>
 #include <linux/ctype.h>
diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index c16ff55..fe798e4 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -54,7 +54,6 @@
 #include <linux/prefetch.h>
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 /* gadget stack */
diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 143a725..a8c7ebf 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -35,7 +35,6 @@
 #include <mach/hardware.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/gpio.h>
 
 #include <mach/board.h>
diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
index db815c2..0af2615 100644
--- a/drivers/usb/gadget/dummy_hcd.c
+++ b/drivers/usb/gadget/dummy_hcd.c
@@ -43,7 +43,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index b04712f..dde4b2d 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -43,7 +43,6 @@
 
 #include <asm/byteorder.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 #include <asm/dma.h>
 
diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 5af70fc..d3b5736 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -43,7 +43,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index e2293c1..83849c8 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -32,7 +32,6 @@
 #include <linux/pm.h>
 #include <linux/io.h>
 #include <linux/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include "langwell_udc.h"
diff --git a/drivers/usb/gadget/mv_udc_core.c b/drivers/usb/gadget/mv_udc_core.c
index f97e737..9578055 100644
--- a/drivers/usb/gadget/mv_udc_core.c
+++ b/drivers/usb/gadget/mv_udc_core.c
@@ -34,7 +34,6 @@
 #include <linux/platform_device.h>
 #include <linux/clk.h>
 #include <linux/platform_data/mv_usb.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include "mv_udc.h"
diff --git a/drivers/usb/gadget/net2272.c b/drivers/usb/gadget/net2272.c
index 7322d29..bb10c97 100644
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@ -42,7 +42,6 @@
 #include <linux/usb/gadget.h>
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include "net2272.h"
diff --git a/drivers/usb/gadget/net2280.c b/drivers/usb/gadget/net2280.c
index cdedd13..a4a9383 100644
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@ -59,7 +59,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 
diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index 576cd85..fc97c31 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -40,7 +40,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 #include <asm/mach-types.h>
 
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index d83134b..4e4dc1f 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -34,7 +34,6 @@
 #include <asm/byteorder.h>
 #include <linux/io.h>
 #include <linux/irq.h>
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/usb/gadget/pxa25x_udc.c b/drivers/usb/gadget/pxa25x_udc.c
index dd47063..78458f3 100644
--- a/drivers/usb/gadget/pxa25x_udc.c
+++ b/drivers/usb/gadget/pxa25x_udc.c
@@ -41,7 +41,6 @@
 #include <asm/byteorder.h>
 #include <asm/dma.h>
 #include <asm/gpio.h>
-#include <asm/system.h>
 #include <asm/mach-types.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index d3cdffe..73a934a 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -34,7 +34,6 @@
 
 #include <asm/io.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 
diff --git a/drivers/usb/gadget/s3c2410_udc.c b/drivers/usb/gadget/s3c2410_udc.c
index 3f87cb9..060566c 100644
--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -37,7 +37,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 #include <mach/irqs.h>
 
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index a007a9f..62e3836 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -45,7 +45,6 @@
 #include <asm/byteorder.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #if defined(CONFIG_PPC_PS3)
diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index d91e5f2..5fd2955 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -70,7 +70,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include "isp116x.h"
diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index e5fd8aa..2385797 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -84,7 +84,6 @@
 #include <linux/prefetch.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 34b9edd..7407ae6 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -42,7 +42,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 #include <asm/byteorder.h>
 
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index 015c7c6..3b38030 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -40,7 +40,6 @@
 #include <linux/io.h>
 
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include <linux/irq.h>
diff --git a/drivers/usb/host/sl811-hcd.c b/drivers/usb/host/sl811-hcd.c
index 961d663..bf11cdb 100644
--- a/drivers/usb/host/sl811-hcd.c
+++ b/drivers/usb/host/sl811-hcd.c
@@ -51,7 +51,6 @@
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index 16dd6a6..dbbd1ba 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -55,7 +55,6 @@
 #include <linux/mutex.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 	/* FIXME ohci.h is ONLY for internal use by the OHCI driver.
diff --git a/drivers/usb/host/uhci-hcd.c b/drivers/usb/host/uhci-hcd.c
index 6b5eb10..3199af1 100644
--- a/drivers/usb/host/uhci-hcd.c
+++ b/drivers/usb/host/uhci-hcd.c
@@ -45,7 +45,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include "uhci-hcd.h"
 
diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index f23cae0..887df9d 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -53,7 +53,6 @@
 #include <linux/platform_device.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
diff --git a/drivers/video/bt431.h b/drivers/video/bt431.h
index c826f27..04e0cfb 100644
--- a/drivers/video/bt431.h
+++ b/drivers/video/bt431.h
@@ -8,7 +8,6 @@
  *	archive for more details.
  */
 #include <linux/types.h>
-#include <asm/system.h>
 
 /*
  * Bt431 cursor generator registers, 32-bit aligned.
diff --git a/drivers/video/bt455.h b/drivers/video/bt455.h
index b7591fe..80f61b0 100644
--- a/drivers/video/bt455.h
+++ b/drivers/video/bt455.h
@@ -8,7 +8,6 @@
  *	archive for more details.
  */
 #include <linux/types.h>
-#include <asm/system.h>
 
 /*
  * Bt455 byte-wide registers, 32-bit aligned.
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 8745637..2e471c2 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -77,7 +77,6 @@
 #include <linux/crc32.h> /* For counting font checksums */
 #include <asm/fb.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include "fbcon.h"
 
diff --git a/drivers/video/console/newport_con.c b/drivers/video/console/newport_con.c
index a122d92..6d15966 100644
--- a/drivers/video/console/newport_con.c
+++ b/drivers/video/console/newport_con.c
@@ -22,7 +22,6 @@
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/gio_device.h>
diff --git a/drivers/video/cyber2000fb.c b/drivers/video/cyber2000fb.c
index 8503807..c1527f5 100644
--- a/drivers/video/cyber2000fb.c
+++ b/drivers/video/cyber2000fb.c
@@ -51,7 +51,6 @@
 #include <linux/i2c-algo-bit.h>
 
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 #ifdef __arm__
 #include <asm/mach-types.h>
diff --git a/drivers/video/dnfb.c b/drivers/video/dnfb.c
index ec56d25..49e3dda 100644
--- a/drivers/video/dnfb.c
+++ b/drivers/video/dnfb.c
@@ -7,7 +7,6 @@
 #include <linux/platform_device.h>
 
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/irq.h>
 #include <asm/amigahw.h>
 #include <asm/amigaints.h>
diff --git a/drivers/video/neofb.c b/drivers/video/neofb.c
index fb3f673..afc9521 100644
--- a/drivers/video/neofb.c
+++ b/drivers/video/neofb.c
@@ -71,7 +71,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
diff --git a/drivers/video/pmag-ba-fb.c b/drivers/video/pmag-ba-fb.c
index 0c69fa2..9b4a60b 100644
--- a/drivers/video/pmag-ba-fb.c
+++ b/drivers/video/pmag-ba-fb.c
@@ -33,7 +33,6 @@
 #include <linux/types.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <video/pmag-ba-fb.h>
 
diff --git a/drivers/video/pmagb-b-fb.c b/drivers/video/pmagb-b-fb.c
index 22fcb9a..4e7a9c4 100644
--- a/drivers/video/pmagb-b-fb.c
+++ b/drivers/video/pmagb-b-fb.c
@@ -29,7 +29,6 @@
 #include <linux/types.h>
 
 #include <asm/io.h>
-#include <asm/system.h>
 
 #include <video/pmagb-b-fb.h>
 
diff --git a/drivers/video/q40fb.c b/drivers/video/q40fb.c
index f5a39f5..a104e8c 100644
--- a/drivers/video/q40fb.c
+++ b/drivers/video/q40fb.c
@@ -20,7 +20,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/setup.h>
-#include <asm/system.h>
 #include <asm/q40_master.h>
 #include <linux/fb.h>
 #include <linux/module.h>
diff --git a/drivers/video/savage/savagefb_driver.c b/drivers/video/savage/savagefb_driver.c
index beb4950..cee7803 100644
--- a/drivers/video/savage/savagefb_driver.c
+++ b/drivers/video/savage/savagefb_driver.c
@@ -56,7 +56,6 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/pgtable.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
diff --git a/drivers/virtio/config.c b/drivers/virtio/config.c
index 983d482..f70bcd2 100644
--- a/drivers/virtio/config.c
+++ b/drivers/virtio/config.c
@@ -9,5 +9,4 @@
 #include <linux/virtio.h>
 #include <linux/virtio_config.h>
 #include <linux/bug.h>
-#include <asm/system.h>
 
diff --git a/drivers/watchdog/advantechwdt.c b/drivers/watchdog/advantechwdt.c
index 4d40965..6112bef 100644
--- a/drivers/watchdog/advantechwdt.c
+++ b/drivers/watchdog/advantechwdt.c
@@ -40,7 +40,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define DRV_NAME "advantechwdt"
 #define PFX DRV_NAME ": "
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 46f4b85..4868418 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -34,7 +34,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define OUR_NAME "alim7101_wdt"
 #define PFX OUR_NAME ": "
diff --git a/drivers/watchdog/booke_wdt.c b/drivers/watchdog/booke_wdt.c
index 7c0fdfc..3a76e19 100644
--- a/drivers/watchdog/booke_wdt.c
+++ b/drivers/watchdog/booke_wdt.c
@@ -21,7 +21,6 @@
 #include <linux/uaccess.h>
 
 #include <asm/reg_booke.h>
-#include <asm/system.h>
 #include <asm/time.h>
 #include <asm/div64.h>
 
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index 3946c51..f507fe7 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -59,7 +59,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 static unsigned long eurwdt_is_open;
 static int eurwdt_timeout;
diff --git a/drivers/watchdog/ib700wdt.c b/drivers/watchdog/ib700wdt.c
index 0149d8d..9402c0b 100644
--- a/drivers/watchdog/ib700wdt.c
+++ b/drivers/watchdog/ib700wdt.c
@@ -44,7 +44,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 static struct platform_device *ibwdt_platform_device;
 static unsigned long ibwdt_is_open;
diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
index a2d9a12..d761c41 100644
--- a/drivers/watchdog/it87_wdt.c
+++ b/drivers/watchdog/it87_wdt.c
@@ -43,7 +43,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 
 #define WATCHDOG_VERSION	"1.14"
 #define WATCHDOG_NAME		"IT87 WDT"
diff --git a/drivers/watchdog/machzwd.c b/drivers/watchdog/machzwd.c
index 1332b83..b536111 100644
--- a/drivers/watchdog/machzwd.c
+++ b/drivers/watchdog/machzwd.c
@@ -43,7 +43,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 /* ports */
 #define ZF_IOBASE	0x218
diff --git a/drivers/watchdog/pc87413_wdt.c b/drivers/watchdog/pc87413_wdt.c
index e78d899..669e562 100644
--- a/drivers/watchdog/pc87413_wdt.c
+++ b/drivers/watchdog/pc87413_wdt.c
@@ -33,7 +33,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 /* #define DEBUG 1 */
 
diff --git a/drivers/watchdog/sbc60xxwdt.c b/drivers/watchdog/sbc60xxwdt.c
index 626d0e8..4b53756 100644
--- a/drivers/watchdog/sbc60xxwdt.c
+++ b/drivers/watchdog/sbc60xxwdt.c
@@ -63,7 +63,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define OUR_NAME "sbc60xxwdt"
 #define PFX OUR_NAME ": "
diff --git a/drivers/watchdog/sbc7240_wdt.c b/drivers/watchdog/sbc7240_wdt.c
index 93ac589..80f39a3 100644
--- a/drivers/watchdog/sbc7240_wdt.c
+++ b/drivers/watchdog/sbc7240_wdt.c
@@ -30,7 +30,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 #define SBC7240_PREFIX "sbc7240_wdt: "
 
diff --git a/drivers/watchdog/sbc8360.c b/drivers/watchdog/sbc8360.c
index 514ec23..7c242bc 100644
--- a/drivers/watchdog/sbc8360.c
+++ b/drivers/watchdog/sbc8360.c
@@ -51,7 +51,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 static unsigned long sbc8360_is_open;
 static char expect_close;
diff --git a/drivers/watchdog/sbc_fitpc2_wdt.c b/drivers/watchdog/sbc_fitpc2_wdt.c
index d5d3994..07d59b3 100644
--- a/drivers/watchdog/sbc_fitpc2_wdt.c
+++ b/drivers/watchdog/sbc_fitpc2_wdt.c
@@ -25,7 +25,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 static unsigned int margin = 60;	/* (secs) Default is 1 minute */
diff --git a/drivers/watchdog/sc520_wdt.c b/drivers/watchdog/sc520_wdt.c
index b284040..c794803 100644
--- a/drivers/watchdog/sc520_wdt.c
+++ b/drivers/watchdog/sc520_wdt.c
@@ -67,7 +67,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define OUR_NAME "sc520_wdt"
 #define PFX OUR_NAME ": "
diff --git a/drivers/watchdog/smsc37b787_wdt.c b/drivers/watchdog/smsc37b787_wdt.c
index 97b8184..16365d0 100644
--- a/drivers/watchdog/smsc37b787_wdt.c
+++ b/drivers/watchdog/smsc37b787_wdt.c
@@ -58,7 +58,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 /* enable support for minutes as units? */
 /* (does not always work correctly, so disabled by default!) */
diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 576a388..1283d06 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -40,7 +40,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define WATCHDOG_NAME "w83627hf/thf/hg/dhg WDT"
 #define PFX WATCHDOG_NAME ": "
diff --git a/drivers/watchdog/w83697hf_wdt.c b/drivers/watchdog/w83697hf_wdt.c
index af08972..e5cb768 100644
--- a/drivers/watchdog/w83697hf_wdt.c
+++ b/drivers/watchdog/w83697hf_wdt.c
@@ -39,7 +39,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define WATCHDOG_NAME "w83697hf/hg WDT"
 #define PFX WATCHDOG_NAME ": "
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index be9c4d8..24a46ff 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -44,7 +44,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define WATCHDOG_NAME "w83697ug/uf WDT"
 #define PFX WATCHDOG_NAME ": "
diff --git a/drivers/watchdog/w83877f_wdt.c b/drivers/watchdog/w83877f_wdt.c
index 24587d2..5f3b945 100644
--- a/drivers/watchdog/w83877f_wdt.c
+++ b/drivers/watchdog/w83877f_wdt.c
@@ -56,7 +56,6 @@
 #include <linux/init.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 #define OUR_NAME "w83877f_wdt"
 #define PFX OUR_NAME ": "
diff --git a/drivers/watchdog/w83977f_wdt.c b/drivers/watchdog/w83977f_wdt.c
index 6e6743d..7f4330e 100644
--- a/drivers/watchdog/w83977f_wdt.c
+++ b/drivers/watchdog/w83977f_wdt.c
@@ -29,7 +29,6 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 
-#include <asm/system.h>
 
 #define WATCHDOG_VERSION  "1.00"
 #define WATCHDOG_NAME     "W83977F WDT"
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index d2ef002..f3026cd 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -46,7 +46,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 #include "wd501p.h"
 
 static unsigned long wdt_is_open;
diff --git a/drivers/watchdog/wdt977.c b/drivers/watchdog/wdt977.c
index a2f01c9..855bb0f 100644
--- a/drivers/watchdog/wdt977.c
+++ b/drivers/watchdog/wdt977.c
@@ -37,7 +37,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 #include <asm/mach-types.h>
 
 #define WATCHDOG_VERSION  "0.04"
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index e0fc3baa..fae2567 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -53,7 +53,6 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/system.h>
 
 #define WDT_IS_PCI
 #include "wd501p.h"
diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index 1ff9405..c86ef9e 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -26,7 +26,6 @@
 #include <linux/coredump.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/cacheflush.h>
 #include <asm/a.out-core.h>
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 1bffbe0..517ef66 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -37,7 +37,6 @@
 #include <linux/syscalls.h>
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 #include <asm/cacheflush.h>
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 5e2e1b3..2313183 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -21,7 +21,6 @@
 #include <linux/vfs.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include <linux/fs.h>
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index 8f616e0..761d5b3 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -38,7 +38,6 @@
 #include <linux/mutex.h>
 #include <linux/device.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/poll.h>
 #include <asm/uaccess.h>
 
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 9727e0c..0c68fd3 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -14,7 +14,6 @@
  * improvements to the Coda project. Contact Peter Braam <coda@cs.cmu.edu>.
  */
 
-#include <asm/system.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/types.h>
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index ea54cde..80fb4b2 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -34,7 +34,6 @@
 #include <linux/mutex.h>
 #include <linux/anon_inodes.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <asm/mman.h>
 #include <linux/atomic.h>
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 5069b84..9023572 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -28,7 +28,6 @@
 #include <linux/blkdev.h>
 #include <linux/bitops.h>
 #include <trace/events/jbd2.h>
-#include <asm/system.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index c0a5f9f..f9709ef 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -50,7 +50,6 @@
 
 #include <asm/uaccess.h>
 #include <asm/page.h>
-#include <asm/system.h>
 
 EXPORT_SYMBOL(jbd2_journal_extend);
 EXPORT_SYMBOL(jbd2_journal_stop);
diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index 64a3264..3ff5fcc 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -7,7 +7,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/time.h>
 #include <linux/kernel.h>
diff --git a/fs/ncpfs/inode.c b/fs/ncpfs/inode.c
index 3d1e34f..dd9a29f 100644
--- a/fs/ncpfs/inode.c
+++ b/fs/ncpfs/inode.c
@@ -11,7 +11,6 @@
 
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
 
diff --git a/fs/ncpfs/mmap.c b/fs/ncpfs/mmap.c
index e5d71b2..be20a7e 100644
--- a/fs/ncpfs/mmap.c
+++ b/fs/ncpfs/mmap.c
@@ -19,7 +19,6 @@
 #include <linux/memcontrol.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include "ncp_fs.h"
 
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 31778f7..913aac9 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -40,7 +40,6 @@
 #include <linux/nfs_xdr.h>
 #include <linux/sunrpc/bc_xprt.h>
 
-#include <asm/system.h>
 
 #include "nfs4_fs.h"
 #include "callback.h"
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 1940f1a..ea5be12 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -51,7 +51,6 @@
 #include <linux/nfs_page.h>
 #include <linux/sunrpc/clnt.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/atomic.h>
 
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index c43a452..a77a1f2 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -30,7 +30,6 @@
 #include <linux/swap.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include "delegation.h"
 #include "internal.h"
diff --git a/fs/nfs/getroot.c b/fs/nfs/getroot.c
index dcb6154..56eeeef 100644
--- a/fs/nfs/getroot.c
+++ b/fs/nfs/getroot.c
@@ -32,7 +32,6 @@
 #include <linux/namei.h>
 #include <linux/security.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "nfs4_fs.h"
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index f649fba..c2ce819 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -40,7 +40,6 @@
 #include <linux/compat.h>
 #include <linux/freezer.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "nfs4_fs.h"
diff --git a/fs/nfs/read.c b/fs/nfs/read.c
index cfa175c..b83e89b 100644
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -20,7 +20,6 @@
 #include <linux/nfs_page.h>
 #include <linux/module.h>
 
-#include <asm/system.h>
 #include "pnfs.h"
 
 #include "nfs4_fs.h"
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 3dfa4f1..e3f6b23 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -53,7 +53,6 @@
 #include <linux/magic.h>
 #include <linux/parser.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "nfs4_fs.h"
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 84fd323..d533f59 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -22,7 +22,6 @@
 #include <linux/slab.h>
 #include <linux/mount.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index c3cf54f..6f1a194 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -51,7 +51,6 @@
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 
 /* gets a struct reiserfs_journal_list * from a list head */
 #define JOURNAL_LIST_ENTRY(h) (list_entry((h), struct reiserfs_journal_list, \
diff --git a/fs/ufs/inode.c b/fs/ufs/inode.c
index 9094e1d..7cdd395 100644
--- a/fs/ufs/inode.c
+++ b/fs/ufs/inode.c
@@ -26,7 +26,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/errno.h>
 #include <linux/fs.h>
diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 5246ee3..a44c423 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -73,7 +73,6 @@
 #include <stdarg.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/errno.h>
 #include <linux/fs.h>
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index df7ffb0..5bf3be4 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -21,7 +21,6 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
-#include <asm/system.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index f4b2eff..6fbc4ca 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -57,7 +57,6 @@
 #include <linux/kernel.h>
 #include <linux/ctype.h>
 #include <linux/sched.h>
-#include <asm/system.h>
 #include <linux/atomic.h>
 #include <asm/div64.h>
 #include <asm/acpi.h>
diff --git a/include/asm-generic/atomic.h b/include/asm-generic/atomic.h
index e37963c..6ec0ba4 100644
--- a/include/asm-generic/atomic.h
+++ b/include/asm-generic/atomic.h
@@ -52,7 +52,6 @@
 #define atomic_set(v, i) (((v)->counter) = (i))
 
 #include <linux/irqflags.h>
-#include <asm/system.h>
 
 /**
  * atomic_add_return - add integer to atomic variable
diff --git a/include/asm-generic/bitops/atomic.h b/include/asm-generic/bitops/atomic.h
index ecc44a8..8054ef5 100644
--- a/include/asm-generic/bitops/atomic.h
+++ b/include/asm-generic/bitops/atomic.h
@@ -2,7 +2,6 @@
 #define _ASM_GENERIC_BITOPS_ATOMIC_H_
 
 #include <asm/types.h>
-#include <asm/system.h>
 
 #ifdef CONFIG_SMP
 #include <asm/spinlock.h>
diff --git a/include/linux/cnt32_to_63.h b/include/linux/cnt32_to_63.h
index e3d8bf2..aa629bc 100644
--- a/include/linux/cnt32_to_63.h
+++ b/include/linux/cnt32_to_63.h
@@ -16,7 +16,6 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <asm/byteorder.h>
-#include <asm/system.h>
 
 /* this is used only to give gcc a clue about good code generation */
 union cnt32_to_63 {
diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 5033fb8..75cae8b 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -3,7 +3,6 @@
 
 #include <linux/kernel.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 struct task_struct;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 37c3007..b6d057e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -22,7 +22,6 @@
 #include <linux/pstore.h>
 
 #include <asm/page.h>
-#include <asm/system.h>
 
 #define EFI_SUCCESS		0
 #define EFI_LOAD_ERROR          ( 1 | (1UL << (BITS_PER_LONG-1)))
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 501370b..9e355d0 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -23,7 +23,6 @@
 #include <acpi/acpi.h>
 #endif
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 /* for request_sense */
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index a64b00e..54ceeca 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -19,7 +19,6 @@
 
 #include <linux/atomic.h>
 #include <asm/ptrace.h>
-#include <asm/system.h>
 #include <trace/events/irq.h>
 
 /*
diff --git a/include/linux/llist.h b/include/linux/llist.h
index 801b44b..8bba66b 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -56,7 +56,6 @@
  */
 
 #include <linux/kernel.h>
-#include <asm/system.h>
 #include <asm/processor.h>
 
 struct llist_head {
diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 88e78de..eab507f 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -21,7 +21,6 @@
 #include <linux/path.h>
 #include <linux/key.h>
 #include <linux/skbuff.h>
-#include <asm/system.h>
 
 
 /* Auxiliary data to use in generating the audit record. */
diff --git a/include/linux/mtd/map.h b/include/linux/mtd/map.h
index 94e924e..836cf17 100644
--- a/include/linux/mtd/map.h
+++ b/include/linux/mtd/map.h
@@ -29,7 +29,6 @@
 #include <linux/kernel.h>
 
 #include <asm/unaligned.h>
-#include <asm/system.h>
 #include <asm/io.h>
 
 #ifdef CONFIG_MTD_MAP_BANK_WIDTH_1
diff --git a/include/linux/parport.h b/include/linux/parport.h
index 38a423e..106c2ca 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -100,7 +100,6 @@ typedef enum {
 #include <linux/wait.h>
 #include <linux/irqreturn.h>
 #include <linux/semaphore.h>
-#include <asm/system.h>
 #include <asm/ptrace.h>
 
 /* Define this later. */
diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index 63d4065..54bd7cd 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -14,7 +14,6 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 
 struct rw_semaphore;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0657368..aca0aed 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -63,7 +63,6 @@ struct sched_param {
 #include <linux/nodemask.h>
 #include <linux/mm_types.h>
 
-#include <asm/system.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
 #include <asm/cputime.h>
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index ae86ade..8fcc6f7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -490,7 +490,6 @@ struct sk_buff {
  */
 #include <linux/slab.h>
 
-#include <asm/system.h>
 
 /*
  * skb might have a dst pointer attached, refcounted or not.
diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 7df6c17..3a38aa3 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -56,7 +56,6 @@
 #include <linux/stringify.h>
 #include <linux/bottom_half.h>
 
-#include <asm/system.h>
 
 /*
  * Must define these before including other files, inline functions need them
diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
index c170edc..3b5e910 100644
--- a/include/linux/stop_machine.h
+++ b/include/linux/stop_machine.h
@@ -5,7 +5,6 @@
 #include <linux/cpumask.h>
 #include <linux/smp.h>
 #include <linux/list.h>
-#include <asm/system.h>
 
 /*
  * stop_cpu[s]() is simplistic per-cpu maximum priority cpu
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5dbb3cb..debdaca 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -44,7 +44,6 @@
 #include <linux/tty_ldisc.h>
 #include <linux/mutex.h>
 
-#include <asm/system.h>
 
 
 /*
diff --git a/include/linux/wait.h b/include/linux/wait.h
index a9ce45e..e5824e2 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -22,7 +22,6 @@
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/spinlock.h>
-#include <asm/system.h>
 #include <asm/current.h>
 
 typedef struct __wait_queue wait_queue_t;
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0d7c087..de50f7d 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -52,7 +52,6 @@
 #include <asm/cacheflush.h>
 #include <asm/byteorder.h>
 #include <linux/atomic.h>
-#include <asm/system.h>
 
 #include "debug_core.h"
 
diff --git a/kernel/debug/kdb/kdb_bt.c b/kernel/debug/kdb/kdb_bt.c
index 7179eac..07c9bbb 100644
--- a/kernel/debug/kdb/kdb_bt.c
+++ b/kernel/debug/kdb/kdb_bt.c
@@ -15,7 +15,6 @@
 #include <linux/sched.h>
 #include <linux/kdb.h>
 #include <linux/nmi.h>
-#include <asm/system.h>
 #include "kdb_private.h"
 
 
diff --git a/kernel/dma.c b/kernel/dma.c
index 68a2306..6c6262f 100644
--- a/kernel/dma.c
+++ b/kernel/dma.c
@@ -18,7 +18,6 @@
 #include <linux/proc_fs.h>
 #include <linux/init.h>
 #include <asm/dma.h>
-#include <asm/system.h>
 
 
 
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 7b08867..5d69b0c 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -37,7 +37,6 @@
 #include <asm/page.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
-#include <asm/system.h>
 #include <asm/sections.h>
 
 /* Per cpu memory for storing cpu states in case of system crash. */
diff --git a/kernel/rwsem.c b/kernel/rwsem.c
index b152f74..6850f53 100644
--- a/kernel/rwsem.c
+++ b/kernel/rwsem.c
@@ -10,7 +10,6 @@
 #include <linux/export.h>
 #include <linux/rwsem.h>
 
-#include <asm/system.h>
 #include <linux/atomic.h>
 
 /*
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f487f25..79f799c 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -141,7 +141,6 @@ static const int cap_last_cap = CAP_LAST_CAP;
 #include <linux/inotify.h>
 #endif
 #ifdef CONFIG_SPARC
-#include <asm/system.h>
 #endif
 
 #ifdef CONFIG_SPARC64
diff --git a/lib/llist.c b/lib/llist.c
index 700cff7..e429d27 100644
--- a/lib/llist.c
+++ b/lib/llist.c
@@ -27,7 +27,6 @@
 #include <linux/interrupt.h>
 #include <linux/llist.h>
 
-#include <asm/system.h>
 
 /**
  * llist_add_batch - add several linked entries in batch
diff --git a/lib/raid6/altivec.uc b/lib/raid6/altivec.uc
index 2654d5c..7c86119 100644
--- a/lib/raid6/altivec.uc
+++ b/lib/raid6/altivec.uc
@@ -28,7 +28,6 @@
 
 #include <altivec.h>
 #ifdef __KERNEL__
-# include <asm/system.h>
 # include <asm/cputable.h>
 #endif
 
diff --git a/net/802/fc.c b/net/802/fc.c
index bd345f3..b324e31 100644
--- a/net/802/fc.c
+++ b/net/802/fc.c
@@ -11,7 +11,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/net/802/fddi.c b/net/802/fddi.c
index 94b3ad0..5ab25cd 100644
--- a/net/802/fddi.c
+++ b/net/802/fddi.c
@@ -27,7 +27,6 @@
  */
 
 #include <linux/module.h>
-#include <asm/system.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/net/802/hippi.c b/net/802/hippi.c
index 91aca87..056794e 100644
--- a/net/802/hippi.c
+++ b/net/802/hippi.c
@@ -35,7 +35,6 @@
 #include <net/arp.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 /*
  * Create the HIPPI MAC header for an arbitrary protocol layer
diff --git a/net/802/tr.c b/net/802/tr.c
index 5e20cf8..b9a3a14 100644
--- a/net/802/tr.c
+++ b/net/802/tr.c
@@ -16,7 +16,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 3cd0a0d..0906c19 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -33,7 +33,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/mm.h>
diff --git a/net/ax25/ax25_addr.c b/net/ax25/ax25_addr.c
index 7e7964d..9162409 100644
--- a/net/ax25/ax25_addr.c
+++ b/net/ax25/ax25_addr.c
@@ -22,7 +22,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index c1cb982..d0de30e 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -24,7 +24,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_ds_in.c b/net/ax25/ax25_ds_in.c
index 8273b12..9bd31e8 100644
--- a/net/ax25/ax25_ds_in.c
+++ b/net/ax25/ax25_ds_in.c
@@ -23,7 +23,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_ds_subr.c b/net/ax25/ax25_ds_subr.c
index 85816e6..5ea7fd3 100644
--- a/net/ax25/ax25_ds_subr.c
+++ b/net/ax25/ax25_ds_subr.c
@@ -24,7 +24,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_ds_timer.c b/net/ax25/ax25_ds_timer.c
index c7d8143..993c439 100644
--- a/net/ax25/ax25_ds_timer.c
+++ b/net/ax25/ax25_ds_timer.c
@@ -25,7 +25,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_iface.c b/net/ax25/ax25_iface.c
index 60b545e..7d5f24b 100644
--- a/net/ax25/ax25_iface.c
+++ b/net/ax25/ax25_iface.c
@@ -24,7 +24,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index 9bb7765..96f4cab3 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -27,7 +27,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_ip.c b/net/ax25/ax25_ip.c
index cf0c47a..846ae4e 100644
--- a/net/ax25/ax25_ip.c
+++ b/net/ax25/ax25_ip.c
@@ -24,7 +24,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/mm.h>
diff --git a/net/ax25/ax25_out.c b/net/ax25/ax25_out.c
index 37507d8..be8a25e 100644
--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -27,7 +27,6 @@
 #include <linux/netfilter.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 87fddab..a655880 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -32,7 +32,6 @@
 #include <linux/spinlock.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_std_in.c b/net/ax25/ax25_std_in.c
index a8eef88..3fbf8f7 100644
--- a/net/ax25/ax25_std_in.c
+++ b/net/ax25/ax25_std_in.c
@@ -30,7 +30,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_std_subr.c b/net/ax25/ax25_std_subr.c
index 277f81b..8b66a41 100644
--- a/net/ax25/ax25_std_subr.c
+++ b/net/ax25/ax25_std_subr.c
@@ -21,7 +21,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_std_timer.c b/net/ax25/ax25_std_timer.c
index 96e4b92..004467c 100644
--- a/net/ax25/ax25_std_timer.c
+++ b/net/ax25/ax25_std_timer.c
@@ -25,7 +25,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index c6715ee..1997538 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -26,7 +26,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_timer.c b/net/ax25/ax25_timer.c
index db29ea7..c3cffa7 100644
--- a/net/ax25/ax25_timer.c
+++ b/net/ax25/ax25_timer.c
@@ -29,7 +29,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/ax25/ax25_uid.c b/net/ax25/ax25_uid.c
index 4c83137..e3c579b 100644
--- a/net/ax25/ax25_uid.c
+++ b/net/ax25/ax25_uid.c
@@ -26,7 +26,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/bluetooth/bnep/sock.c b/net/bluetooth/bnep/sock.c
index 17800b1..cfea109 100644
--- a/net/bluetooth/bnep/sock.c
+++ b/net/bluetooth/bnep/sock.c
@@ -42,7 +42,6 @@
 #include <linux/uaccess.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 
 #include "bnep.h"
 
diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
index 3f2dd5c..0ee6893 100644
--- a/net/bluetooth/cmtp/sock.c
+++ b/net/bluetooth/cmtp/sock.c
@@ -39,7 +39,6 @@
 
 #include <linux/isdn/capilli.h>
 
-#include <asm/system.h>
 
 #include "cmtp.h"
 
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 07bc69e..447313c 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -38,7 +38,6 @@
 #include <linux/notifier.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 5aeb624..0bab988 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -46,7 +46,6 @@
 #include <linux/crypto.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 001307f..285ae8b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -38,7 +38,6 @@
 #include <linux/notifier.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 0dcc962..b4c1c41 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -42,7 +42,6 @@
 #include <linux/ioctl.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <asm/unaligned.h>
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 32d338c..d3c207a 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -49,7 +49,6 @@
 #include <linux/crc16.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <asm/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 22169c3..a55a43e 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -45,7 +45,6 @@
 #include <linux/security.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 
 #include <net/bluetooth/bluetooth.h>
diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 8bf26d1..f6ab129 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -44,7 +44,6 @@
 #include <linux/security.h>
 #include <net/sock.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 
 #include <net/bluetooth/bluetooth.h>
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 68bbf9f..c72caac 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -37,7 +37,6 @@
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
diff --git a/net/core/dev.c b/net/core/dev.c
index 6ca32f6..961fd68 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -73,7 +73,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/capability.h>
 #include <linux/cpu.h>
diff --git a/net/core/filter.c b/net/core/filter.c
index 5dea452..cf4989a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -33,7 +33,6 @@
 #include <net/sock.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
 #include <linux/filter.h>
diff --git a/net/core/gen_estimator.c b/net/core/gen_estimator.c
index 43b03dd..d9d198a 100644
--- a/net/core/gen_estimator.c
+++ b/net/core/gen_estimator.c
@@ -14,7 +14,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
 #include <linux/types.h>
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f965dce..f1e0d78 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -38,7 +38,6 @@
 #include <linux/pci.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/inet.h>
 #include <linux/netdevice.h>
diff --git a/net/core/scm.c b/net/core/scm.c
index ff52ad0..611c5ef 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -28,7 +28,6 @@
 #include <linux/nsproxy.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 #include <net/protocol.h>
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index da0c97f..8dc3594 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -66,7 +66,6 @@
 #include <net/xfrm.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <trace/events/skb.h>
 
 #include "kmap_skb.h"
diff --git a/net/core/sock.c b/net/core/sock.c
index 02f8dfe..9b082a1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -115,7 +115,6 @@
 #include <linux/memcontrol.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/netdevice.h>
 #include <net/protocol.h>
diff --git a/net/core/utils.c b/net/core/utils.c
index 386e263f..dc3c3fa 100644
--- a/net/core/utils.c
+++ b/net/core/utils.c
@@ -30,7 +30,6 @@
 #include <net/net_ratelimit.h>
 
 #include <asm/byteorder.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 
 int net_msg_warn __read_mostly = 1;
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 19acd00..4136987 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -119,7 +119,6 @@ Version 0.0.6    2.1.110   07-aug-98   Eduardo Marcelo Serrat
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/flow.h>
-#include <asm/system.h>
 #include <asm/ioctls.h>
 #include <linux/capability.h>
 #include <linux/mm.h>
diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 74d321a..c00e307 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -42,7 +42,6 @@
 #include <linux/notifier.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <net/net_namespace.h>
 #include <net/neighbour.h>
 #include <net/dst.h>
diff --git a/net/decnet/dn_nsp_in.c b/net/decnet/dn_nsp_in.c
index 73fa268..f6544b2 100644
--- a/net/decnet/dn_nsp_in.c
+++ b/net/decnet/dn_nsp_in.c
@@ -60,7 +60,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/termios.h>
diff --git a/net/decnet/dn_nsp_out.c b/net/decnet/dn_nsp_out.c
index bd78836..e446e85 100644
--- a/net/decnet/dn_nsp_out.c
+++ b/net/decnet/dn_nsp_out.c
@@ -52,7 +52,6 @@
 #include <linux/route.h>
 #include <linux/slab.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/termios.h>
diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 7e717cb..71b5edc 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -47,7 +47,6 @@
 #include <linux/mutex.h>
 
 #include <linux/uaccess.h>
-#include <asm/system.h>
 
 static const struct proto_ops econet_ops;
 static struct hlist_head econet_sklist;
diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index a246836..e1bea79 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -59,7 +59,6 @@
 #include <net/ip.h>
 #include <net/dsa.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 __setup("ether=", netdev_boot_setup);
 
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index f7b5670..a9a280e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -89,7 +89,6 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 #include <linux/inet.h>
 #include <linux/igmp.h>
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 63e4989..8c24cd5 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -113,7 +113,6 @@
 #include <net/ax25.h>
 #include <net/netrom.h>
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 
 #include <linux/netfilter_arp.h>
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index e41c40f..39e0c16 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -27,7 +27,6 @@
 
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/capability.h>
 #include <linux/module.h>
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 92fc5f6..c7d21dd 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -15,7 +15,6 @@
 
 #include <linux/module.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/capability.h>
 #include <linux/types.h>
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 80106d8..3e32e4e 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -14,7 +14,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 2b555a5..c97c306 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -51,7 +51,6 @@
 #define VERSION "0.409"
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index ab188ae..eb88120 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -89,7 +89,6 @@
 #include <linux/errno.h>
 #include <linux/timer.h>
 #include <linux/init.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <net/checksum.h>
 #include <net/xfrm.h>
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 450e5d2..5dfecfd 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -73,7 +73,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/jiffies.h>
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 073a9b0..d035652 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -113,7 +113,6 @@
  *		2 of the License, or (at your option) any later version.
  */
 
-#include <asm/system.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index ff302bd..4910176 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -43,7 +43,6 @@
  */
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 7bc2db6..46c8952 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -26,7 +26,6 @@
  *
  */
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/types.h>
 #include <linux/capability.h>
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index b072386..4c87219 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -20,7 +20,6 @@
  *
  */
 
-#include <asm/system.h>
 #include <linux/uaccess.h>
 #include <linux/types.h>
 #include <linux/fcntl.h>
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index bcacf54..e010d01 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -64,7 +64,6 @@
 
 #include <linux/module.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/bitops.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 5d075b5..c8ace40 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -77,7 +77,6 @@
  *		2 of the License, or (at your option) any later version.
  */
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
 #include <linux/bootmem.h>
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 273f48d..faf2a6a 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -60,7 +60,6 @@
 #endif
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/mroute6.h>
 
 MODULE_AUTHOR("Cast of dozens");
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 01d46bf..e20807d 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -66,7 +66,6 @@
 #include <net/inet_common.h>
 
 #include <asm/uaccess.h>
-#include <asm/system.h>
 
 /*
  *	The ICMP socket(s). This is the most convenient way to flow control
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 5aa3981..8110362 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -16,7 +16,6 @@
  *
  */
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/types.h>
 #include <linux/sched.h>
diff --git a/net/irda/irlan/irlan_client.c b/net/irda/irlan/irlan_client.c
index ba1a3fc..42cf139 100644
--- a/net/irda/irlan/irlan_client.c
+++ b/net/irda/irlan/irlan_client.c
@@ -37,7 +37,6 @@
 #include <linux/bitops.h>
 #include <net/arp.h>
 
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include <net/irda/irda.h>
diff --git a/net/irda/irlan/irlan_common.c b/net/irda/irlan/irlan_common.c
index 579617c..7ac4d1b 100644
--- a/net/irda/irlan/irlan_common.c
+++ b/net/irda/irlan/irlan_common.c
@@ -40,7 +40,6 @@
 #include <linux/moduleparam.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include <net/irda/irda.h>
diff --git a/net/irda/irlan/irlan_provider.c b/net/irda/irlan/irlan_provider.c
index 8b61cf0..32dcaac 100644
--- a/net/irda/irlan/irlan_provider.c
+++ b/net/irda/irlan/irlan_provider.c
@@ -36,7 +36,6 @@
 #include <linux/bitops.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/byteorder.h>
 
 #include <net/irda/irda.h>
diff --git a/net/irda/timer.c b/net/irda/timer.c
index f418cb2..1d552b3 100644
--- a/net/irda/timer.c
+++ b/net/irda/timer.c
@@ -24,7 +24,6 @@
  *
  ********************************************************************/
 
-#include <asm/system.h>
 #include <linux/delay.h>
 
 #include <net/irda/timer.h>
diff --git a/net/lapb/lapb_iface.c b/net/lapb/lapb_iface.c
index 8d0324b..ab3d35f 100644
--- a/net/lapb/lapb_iface.c
+++ b/net/lapb/lapb_iface.c
@@ -32,7 +32,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/lapb/lapb_in.c b/net/lapb/lapb_in.c
index 2ec1af5..f4e3c1a 100644
--- a/net/lapb/lapb_in.c
+++ b/net/lapb/lapb_in.c
@@ -30,7 +30,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/lapb/lapb_out.c b/net/lapb/lapb_out.c
index c75a795..baab276 100644
--- a/net/lapb/lapb_out.c
+++ b/net/lapb/lapb_out.c
@@ -28,7 +28,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/lapb/lapb_subr.c b/net/lapb/lapb_subr.c
index 43a2a7f..066225b 100644
--- a/net/lapb/lapb_subr.c
+++ b/net/lapb/lapb_subr.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/lapb/lapb_timer.c b/net/lapb/lapb_timer.c
index af6d14b..f8cd641 100644
--- a/net/lapb/lapb_timer.c
+++ b/net/lapb/lapb_timer.c
@@ -28,7 +28,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/netfilter/ipvs/ip_vs_app.c b/net/netfilter/ipvs/ip_vs_app.c
index fe6cb43..5285617 100644
--- a/net/netfilter/ipvs/ip_vs_app.c
+++ b/net/netfilter/ipvs/ip_vs_app.c
@@ -31,7 +31,6 @@
 #include <net/net_namespace.h>
 #include <net/protocol.h>
 #include <net/tcp.h>
-#include <asm/system.h>
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
diff --git a/net/netfilter/ipvs/ip_vs_proto.c b/net/netfilter/ipvs/ip_vs_proto.c
index 8531293..f843a88 100644
--- a/net/netfilter/ipvs/ip_vs_proto.c
+++ b/net/netfilter/ipvs/ip_vs_proto.c
@@ -25,7 +25,6 @@
 #include <net/protocol.h>
 #include <net/tcp.h>
 #include <net/udp.h>
-#include <asm/system.h>
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
 
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4d70785..e6ddde1 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -23,7 +23,6 @@
 #include <linux/net.h>
 #include <linux/skbuff.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <net/sock.h>
 #include <net/netlink.h>
 #include <linux/init.h>
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 7dab229..06592d8 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -31,7 +31,6 @@
 #include <net/net_namespace.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/mm.h>
diff --git a/net/netrom/nr_dev.c b/net/netrom/nr_dev.c
index 64e6dde..1c51d7a 100644
--- a/net/netrom/nr_dev.c
+++ b/net/netrom/nr_dev.c
@@ -21,7 +21,6 @@
 #include <linux/if_ether.h>	/* For the statistics structure. */
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
diff --git a/net/netrom/nr_in.c b/net/netrom/nr_in.c
index 6d4ef6d..c3073a2 100644
--- a/net/netrom/nr_in.c
+++ b/net/netrom/nr_in.c
@@ -24,7 +24,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/netrom/nr_out.c b/net/netrom/nr_out.c
index 607fddb..0b4bcb2 100644
--- a/net/netrom/nr_out.c
+++ b/net/netrom/nr_out.c
@@ -23,7 +23,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index 2cf3301..70ffff7 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -26,7 +26,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
 #include <linux/mm.h>
diff --git a/net/netrom/nr_subr.c b/net/netrom/nr_subr.c
index 6a947ae..ca40e22 100644
--- a/net/netrom/nr_subr.c
+++ b/net/netrom/nr_subr.c
@@ -23,7 +23,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/netrom/nr_timer.c b/net/netrom/nr_timer.c
index 1cb98e8..ff2c1b1 100644
--- a/net/netrom/nr_timer.c
+++ b/net/netrom/nr_timer.c
@@ -24,7 +24,6 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <asm/uaccess.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index ce64c18..bf26c4b 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -38,7 +38,6 @@
 #include <linux/udp.h>
 #include <linux/ethtool.h>
 #include <linux/wait.h>
-#include <asm/system.h>
 #include <asm/div64.h>
 #include <linux/highmem.h>
 #include <linux/netfilter_bridge.h>
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 2dbb32b..b188cc9 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -73,7 +73,6 @@
 #include <net/sock.h>
 #include <linux/errno.h>
 #include <linux/timer.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
 #include <asm/page.h>
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index f9ea925..c4719ce 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -34,7 +34,6 @@
 #include <linux/if_arp.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>
diff --git a/net/rose/rose_dev.c b/net/rose/rose_dev.c
index 178ff4f..1ab8689 100644
--- a/net/rose/rose_dev.c
+++ b/net/rose/rose_dev.c
@@ -21,7 +21,6 @@
 #include <linux/if_ether.h>
 #include <linux/slab.h>
 
-#include <asm/system.h>
 #include <asm/io.h>
 
 #include <linux/inet.h>
diff --git a/net/rose/rose_in.c b/net/rose/rose_in.c
index 7f7fcb4..79c4abc 100644
--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -26,7 +26,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index 7a02bd1..bc55142 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -22,7 +22,6 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/rose/rose_out.c b/net/rose/rose_out.c
index 4ebf33af..9ad98b5 100644
--- a/net/rose/rose_out.c
+++ b/net/rose/rose_out.c
@@ -21,7 +21,6 @@
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <net/sock.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/rose/rose_route.c b/net/rose/rose_route.c
index cd9b7ee..4014893 100644
--- a/net/rose/rose_route.c
+++ b/net/rose/rose_route.c
@@ -25,7 +25,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <asm/system.h>
 #include <asm/uaccess.h>
 #include <linux/fcntl.h>
 #include <linux/termios.h>	/* For TIOCINQ/OUTQ */
diff --git a/net/rose/rose_subr.c b/net/rose/rose_subr.c
index f6c71ca..47f1fdb 100644
--- a/net/rose/rose_subr.c
+++ b/net/rose/rose_subr.c
@@ -22,7 +22,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/rose/rose_timer.c b/net/rose/rose_timer.c
index b6c8f38..bc5469d 100644
--- a/net/rose/rose_timer.c
+++ b/net/rose/rose_timer.c
@@ -23,7 +23,6 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 #include <net/tcp_states.h>
-#include <asm/system.h>
 #include <linux/fcntl.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index f0268ea..d3daab6 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -17,7 +17,6 @@
  *  Copyright (C) 1995,1996 Olaf Kirch <okir@monad.swb.de>
  */
 
-#include <asm/system.h>
 
 #include <linux/module.h>
 #include <linux/types.h>
diff --git a/security/selinux/include/avc.h b/security/selinux/include/avc.h
index 47fda96..005a91b 100644
--- a/security/selinux/include/avc.h
+++ b/security/selinux/include/avc.h
@@ -15,7 +15,6 @@
 #include <linux/audit.h>
 #include <linux/lsm_audit.h>
 #include <linux/in6.h>
-#include <asm/system.h>
 #include "flask.h"
 #include "av_permissions.h"
 #include "security.h"
diff --git a/sound/oss/os.h b/sound/oss/os.h
index a1a962d..75ad0cd 100644
--- a/sound/oss/os.h
+++ b/sound/oss/os.h
@@ -16,7 +16,6 @@
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <asm/page.h>
-#include <asm/system.h>
 #include <linux/vmalloc.h>
 #include <asm/uaccess.h>
 #include <linux/poll.h>
diff --git a/sound/oss/vidc.c b/sound/oss/vidc.c
index 12ba28e..92ca5be 100644
--- a/sound/oss/vidc.c
+++ b/sound/oss/vidc.c
@@ -28,7 +28,6 @@
 #include <asm/io.h>
 #include <asm/hardware/iomd.h>
 #include <asm/irq.h>
-#include <asm/system.h>
 
 #include "sound_config.h"
 #include "vidc.h"
diff --git a/sound/oss/waveartist.c b/sound/oss/waveartist.c
index 5246874..24c430f 100644
--- a/sound/oss/waveartist.c
+++ b/sound/oss/waveartist.c
@@ -42,7 +42,6 @@
 #include <linux/spinlock.h>
 #include <linux/bitops.h>
 
-#include <asm/system.h>
 
 #include "sound_config.h"
 #include "waveartist.h"
diff --git a/sound/pci/asihpi/hpios.h b/sound/pci/asihpi/hpios.h
index c5cef11..d3fbd0d 100644
--- a/sound/pci/asihpi/hpios.h
+++ b/sound/pci/asihpi/hpios.h
@@ -30,7 +30,6 @@ HPI Operating System Specific macros for Linux Kernel driver
 #define HPI_BUILD_KERNEL_MODE
 
 #include <linux/io.h>
-#include <asm/system.h>
 #include <linux/ioctl.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/sound/pci/aw2/aw2-saa7146.c b/sound/pci/aw2/aw2-saa7146.c
index 8afd8b5..4439636 100644
--- a/sound/pci/aw2/aw2-saa7146.c
+++ b/sound/pci/aw2/aw2-saa7146.c
@@ -27,7 +27,6 @@
 #include <linux/pci.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
-#include <asm/system.h>
 #include <asm/io.h>
 #include <sound/core.h>
 #include <sound/initval.h>

