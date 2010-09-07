Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab0IGQHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 12:07:08 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41334 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757395Ab0IGQG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 12:06:58 -0400
Date: Tue, 7 Sep 2010 09:06:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Fix typos
Message-ID: <20100907160644.GB2448@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com>
 <20100902121853.e90f6c53.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902121853.e90f6c53.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 12:18:53PM -0700, Randy Dunlap wrote:
> On Thu, 2 Sep 2010 16:05:14 -0300 Lucas De Marchi wrote:
> 
> > Hi,
> > 
> > I'd like to know if it's worth fixing all typos found in comments,
> > documentation and sometimes code. A first attempt to do that you can
> > find at http://people.profusion.mobi/~lucas/kernel-typos-fix.patch
> > 
> > This was done by using the list of common typos available at
> > http://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings
> > 
> > I already removed some false positives, but there are more. Before
> > going ahead and verifying all of them, I'd like to know whether this
> > would be a good patch.

I am messing with Documentation/RCU/trace.txt anyway, so I took the
s/thoughout/throughout/, thank you!!!

							Thanx, Paul

> Hi,
> 
> I'd take most of the corrections in Documentation/, but in general,
> I don't think that it's a good idea without some careful review.
> 
> E.g.:
> 
> 1.  changing thru to through isn't needed IMO.
> Can you add "thru" to your dictionary?
> 
> 2.
> -(Warning, pulses on ACK ar inverted by transistor, irq is rised up on sync
> +(Warning, pulses on ACK ar inverted by transistor, irq is rose up on sync
> 
> I'm not so sure about "is rose up" being better.  and what about "ar"?
> 
> I saw a few others that I could comment on, but I lost them in the 1.8 MB patch file.
> 
> 
> diffstat summary for those interested:
> 
>  CREDITS                                                    |    6 -
>  Documentation/ABI/testing/sysfs-bus-css                    |    2 
>  Documentation/ABI/testing/sysfs-class                      |    2 
>  Documentation/DocBook/dvb/dvbproperty.xml                  |    2 
>  Documentation/DocBook/dvb/frontend.xml                     |    2 
>  Documentation/DocBook/kernel-hacking.tmpl                  |    4 
>  Documentation/DocBook/kernel-locking.tmpl                  |    2 
>  Documentation/DocBook/libata.tmpl                          |    6 -
>  Documentation/DocBook/mtdnand.tmpl                         |    6 -
>  Documentation/DocBook/regulator.tmpl                       |    4 
>  Documentation/DocBook/uio-howto.tmpl                       |    2 
>  Documentation/DocBook/usb.tmpl                             |    2 
>  Documentation/DocBook/v4l/common.xml                       |    2 
>  Documentation/DocBook/v4l/controls.xml                     |    2 
>  Documentation/DocBook/v4l/libv4l.xml                       |    2 
>  Documentation/PCI/MSI-HOWTO.txt                            |    4 
>  Documentation/RCU/trace.txt                                |    2 
>  Documentation/SecurityBugs                                 |    2 
>  Documentation/SubmittingDrivers                            |    2 
>  Documentation/SubmittingPatches                            |    2 
>  Documentation/arm/IXP4xx                                   |    2 
>  Documentation/arm/Samsung-S3C24XX/Suspend.txt              |    2 
>  Documentation/arm/Samsung/GPIO.txt                         |    2 
>  Documentation/block/biodoc.txt                             |    4 
>  Documentation/cgroups/cgroup_event_listener.c              |    2 
>  Documentation/cpu-hotplug.txt                              |    2 
>  Documentation/dell_rbu.txt                                 |    2 
>  Documentation/device-mapper/dm-service-time.txt            |    2 
>  Documentation/dvb/README.dvb-usb                           |    2 
>  Documentation/dvb/ci.txt                                   |    2 
>  Documentation/dvb/faq.txt                                  |    2 
>  Documentation/edac.txt                                     |    2 
>  Documentation/eisa.txt                                     |    2 
>  Documentation/feature-removal-schedule.txt                 |    2 
>  Documentation/filesystems/autofs4-mount-control.txt        |    2 
>  Documentation/filesystems/caching/netfs-api.txt            |   18 +--
>  Documentation/filesystems/ext4.txt                         |    4 
>  Documentation/filesystems/gfs2-uevents.txt                 |    2 
>  Documentation/filesystems/gfs2.txt                         |    2 
>  Documentation/filesystems/ntfs.txt                         |    2 
>  Documentation/filesystems/ocfs2.txt                        |    2 
>  Documentation/filesystems/pohmelfs/network_protocol.txt    |    2 
>  Documentation/filesystems/proc.txt                         |    4 
>  Documentation/filesystems/squashfs.txt                     |    2 
>  Documentation/filesystems/sysfs.txt                        |    2 
>  Documentation/filesystems/vfat.txt                         |    2 
>  Documentation/filesystems/xfs-delayed-logging-design.txt   |    8 -
>  Documentation/hwmon/abituguru-datasheet                    |    8 -
>  Documentation/hwmon/lm85                                   |    2 
>  Documentation/hwmon/sysfs-interface                        |    2 
>  Documentation/hwmon/via686a                                |    2 
>  Documentation/hwmon/w83781d                                |    2 
>  Documentation/hwmon/w83791d                                |    2 
>  Documentation/i2c/busses/i2c-parport-light                 |    2 
>  Documentation/i2c/busses/i2c-sis96x                        |    2 
>  Documentation/i2c/busses/i2c-taos-evm                      |    2 
>  Documentation/ia64/aliasing-test.c                         |    2 
>  Documentation/input/joystick-parport.txt                   |    2 
>  Documentation/input/rotary-encoder.txt                     |    2 
>  Documentation/input/walkera0701.txt                        |    2 
>  Documentation/irqflags-tracing.txt                         |    2 
>  Documentation/isdn/CREDITS                                 |    2 
>  Documentation/isdn/INTERFACE.CAPI                          |    2 
>  Documentation/isdn/syncPPP.FAQ                             |   10 -
>  Documentation/kernel-parameters.txt                        |    4 
>  Documentation/kvm/mmu.txt                                  |    2 
>  Documentation/mips/AU1xxx_IDE.README                       |    2 
>  Documentation/networking/3c359.txt                         |    2 
>  Documentation/networking/README.ipw2200                    |    2 
>  Documentation/networking/bonding.txt                       |    2 
>  Documentation/networking/caif/Linux-CAIF.txt               |    2 
>  Documentation/networking/caif/spi_porting.txt              |    2 
>  Documentation/networking/can.txt                           |    2 
>  Documentation/networking/ieee802154.txt                    |    2 
>  Documentation/networking/olympic.txt                       |    2 
>  Documentation/networking/packet_mmap.txt                   |    2 
>  Documentation/networking/s2io.txt                          |    4 
>  Documentation/networking/tc-actions-env-rules.txt          |    4 
>  Documentation/power/devices.txt                            |    2 
>  Documentation/power/notifiers.txt                          |    4 
>  Documentation/power/swsusp.txt                             |    4 
>  Documentation/power/userland-swsusp.txt                    |    6 -
>  Documentation/powerpc/dts-bindings/can/sja1000.txt         |    2 
>  Documentation/powerpc/dts-bindings/fsl/upm-nand.txt        |    2 
>  Documentation/powerpc/hvcs.txt                             |    2 
>  Documentation/scsi/ChangeLog.lpfc                          |   22 ++--
>  Documentation/scsi/ChangeLog.megaraid                      |    2 
>  Documentation/scsi/ChangeLog.ncr53c8xx                     |    2 
>  Documentation/scsi/ChangeLog.sym53c8xx                     |    2 
>  Documentation/scsi/aha152x.txt                             |    2 
>  Documentation/scsi/aic79xx.txt                             |   12 +-
>  Documentation/scsi/ibmmca.txt                              |    4 
>  Documentation/scsi/scsi-changer.txt                        |    2 
>  Documentation/scsi/scsi_eh.txt                             |    2 
>  Documentation/scsi/scsi_fc_transport.txt                   |    2 
>  Documentation/serial/moxa-smartio                          |    2 
>  Documentation/spi/pxa2xx                                   |    2 
>  Documentation/spi/spi-lm70llp                              |    2 
>  Documentation/trace/ring-buffer-design.txt                 |    2 
>  Documentation/video4linux/README.pvrusb2                   |    2 
>  Documentation/video4linux/bttv/README                      |    2 
>  Documentation/video4linux/bttv/README.freeze               |    2 
>  Documentation/video4linux/bttv/Sound-FAQ                   |    2 
>  Documentation/video4linux/pxa_camera.txt                   |    8 -
>  Documentation/video4linux/v4l2-framework.txt               |    2 
>  Documentation/vm/active_mm.txt                             |    2 
>  Documentation/vm/hugetlbpage.txt                           |    2 
>  Documentation/vm/overcommit-accounting                     |    2 
>  Documentation/vm/pagemap.txt                               |    2 
>  Documentation/w1/w1.netlink                                |    2 
>  Documentation/watchdog/hpwdt.txt                           |    2 
>  Documentation/x86/x86_64/boot-options.txt                  |    2 
>  arch/alpha/include/asm/dma.h                               |    2 
>  arch/alpha/include/asm/elf.h                               |    2 
>  arch/alpha/kernel/core_lca.c                               |    4 
>  arch/alpha/lib/ev6-memcpy.S                                |    2 
>  arch/alpha/lib/ev67-strrchr.S                              |    2 
>  arch/alpha/lib/fls.c                                       |    2 
>  arch/alpha/lib/strrchr.S                                   |    2 
>  arch/alpha/oprofile/op_model_ev67.c                        |    2 
>  arch/arm/Kconfig                                           |    2 
>  arch/arm/Kconfig-nommu                                     |    2 
>  arch/arm/common/pl330.c                                    |    4 
>  arch/arm/include/asm/cacheflush.h                          |    2 
>  arch/arm/include/asm/fpstate.h                             |    2 
>  arch/arm/include/asm/glue.h                                |    4 
>  arch/arm/include/asm/hardware/pl080.h                      |    2 
>  arch/arm/include/asm/system.h                              |    2 
>  arch/arm/include/asm/ucontext.h                            |    2 
>  arch/arm/mach-at91/board-carmeva.c                         |    2 
>  arch/arm/mach-at91/board-ecbat91.c                         |    6 -
>  arch/arm/mach-at91/include/mach/gpio.h                     |    2 
>  arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c              |    4 
>  arch/arm/mach-bcmring/dma.c                                |    4 
>  arch/arm/mach-bcmring/include/csp/dmacHw.h                 |    4 
>  arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h    |    2 
>  arch/arm/mach-bcmring/include/mach/csp/intcHw_reg.h        |    4 
>  arch/arm/mach-bcmring/include/mach/reg_umi.h               |    2 
>  arch/arm/mach-davinci/cpufreq.c                            |    2 
>  arch/arm/mach-davinci/da850.c                              |    2 
>  arch/arm/mach-davinci/dm355.c                              |    2 
>  arch/arm/mach-davinci/dm644x.c                             |    2 
>  arch/arm/mach-davinci/include/mach/cputype.h               |    2 
>  arch/arm/mach-dove/include/mach/irqs.h                     |    6 -
>  arch/arm/mach-ep93xx/gpio.c                                |    2 
>  arch/arm/mach-imx/devices.c                                |    2 
>  arch/arm/mach-kirkwood/tsx1x-common.c                      |    2 
>  arch/arm/mach-lh7a40x/ssp-cpld.c                           |    2 
>  arch/arm/mach-lpc32xx/pm.c                                 |    2 
>  arch/arm/mach-mmp/time.c                                   |    2 
>  arch/arm/mach-msm/acpuclock-arm11.c                        |    2 
>  arch/arm/mach-msm/io.c                                     |    2 
>  arch/arm/mach-mx3/clock-imx35.c                            |    2 
>  arch/arm/mach-omap1/ams-delta-fiq-handler.S                |    2 
>  arch/arm/mach-omap1/board-sx1.c                            |    2 
>  arch/arm/mach-omap1/devices.c                              |    2 
>  arch/arm/mach-omap1/include/mach/ams-delta-fiq.h           |    2 
>  arch/arm/mach-omap2/mux2430.h                              |    2 
>  arch/arm/mach-omap2/powerdomains34xx.h                     |    2 
>  arch/arm/mach-orion5x/addr-map.c                           |    2 
>  arch/arm/mach-orion5x/net2big-setup.c                      |    2 
>  arch/arm/mach-orion5x/ts209-setup.c                        |    2 
>  arch/arm/mach-orion5x/ts409-setup.c                        |    2 
>  arch/arm/mach-pxa/include/mach/zeus.h                      |    2 
>  arch/arm/mach-pxa/mioa701.c                                |    2 
>  arch/arm/mach-s3c2410/include/mach/dma.h                   |    2 
>  arch/arm/mach-s3c2410/include/mach/regs-mem.h              |    2 
>  arch/arm/mach-s3c2440/mach-mini2440.c                      |    2 
>  arch/arm/mach-s3c64xx/dma.c                                |    2 
>  arch/arm/mach-s5pc100/setup-sdhci.c                        |    2 
>  arch/arm/mach-s5pv210/include/mach/gpio.h                  |    2 
>  arch/arm/mach-s5pv210/setup-sdhci-gpio.c                   |    4 
>  arch/arm/mach-s5pv210/setup-sdhci.c                        |    2 
>  arch/arm/mach-s5pv310/include/mach/gpio.h                  |    2 
>  arch/arm/mach-sa1100/cpu-sa1100.c                          |    2 
>  arch/arm/mach-sa1100/jornada720_ssp.c                      |    4 
>  arch/arm/mach-u300/clock.c                                 |    6 -
>  arch/arm/mach-ux500/include/mach/db8500-regs.h             |   10 -
>  arch/arm/mach-ux500/ste-dma40-db8500.h                     |    2 
>  arch/arm/mm/cache-v4wb.S                                   |    2 
>  arch/arm/mm/cache-v4wt.S                                   |    2 
>  arch/arm/mm/cache-v7.S                                     |    2 
>  arch/arm/mm/proc-arm1020.S                                 |    2 
>  arch/arm/mm/proc-arm1020e.S                                |    2 
>  arch/arm/mm/proc-arm1022.S                                 |    2 
>  arch/arm/mm/proc-arm1026.S                                 |    2 
>  arch/arm/mm/proc-arm720.S                                  |    2 
>  arch/arm/mm/proc-arm920.S                                  |    2 
>  arch/arm/mm/proc-arm922.S                                  |    2 
>  arch/arm/mm/proc-arm925.S                                  |    2 
>  arch/arm/mm/proc-macros.S                                  |    2 
>  arch/arm/plat-mxc/include/mach/entry-macro.S               |    4 
>  arch/arm/plat-mxc/include/mach/mxc_nand.h                  |    2 
>  arch/arm/plat-omap/devices.c                               |    2 
>  arch/arm/plat-omap/dma.c                                   |    4 
>  arch/arm/plat-omap/include/plat/gpio.h                     |    2 
>  arch/arm/plat-omap/mcbsp.c                                 |    2 
>  arch/arm/plat-pxa/include/plat/mfp.h                       |    2 
>  arch/arm/plat-s3c24xx/Makefile                             |    2 
>  arch/arm/plat-s3c24xx/cpu-freq.c                           |    2 
>  arch/arm/plat-s3c24xx/dma.c                                |    2 
>  arch/arm/plat-samsung/include/plat/gpio-cfg-helpers.h      |    2 
>  arch/arm/plat-samsung/include/plat/gpio-cfg.h              |    6 -
>  arch/arm/plat-samsung/include/plat/gpio-core.h             |    2 
>  arch/arm/plat-samsung/include/plat/sdhci.h                 |    4 
>  arch/arm/plat-samsung/s3c-pl330.c                          |    2 
>  arch/arm/tools/mach-types                                  |    2 
>  arch/blackfin/Kconfig.debug                                |    2 
>  arch/blackfin/include/asm/traps.h                          |    2 
>  arch/blackfin/kernel/traps.c                               |    2 
>  arch/blackfin/lib/ins.S                                    |    2 
>  arch/blackfin/mach-common/cpufreq.c                        |    2 
>  arch/blackfin/mach-common/entry.S                          |    4 
>  arch/blackfin/mach-common/head.S                           |    2 
>  arch/cris/arch-v10/README.mm                               |    2 
>  arch/cris/arch-v10/drivers/sync_serial.c                   |    2 
>  arch/cris/arch-v10/mm/init.c                               |    2 
>  arch/cris/arch-v32/drivers/mach-a3/nandflash.c             |    2 
>  arch/cris/arch-v32/drivers/mach-fs/nandflash.c             |    2 
>  arch/cris/arch-v32/drivers/sync_serial.c                   |    2 
>  arch/cris/arch-v32/kernel/entry.S                          |    2 
>  arch/cris/arch-v32/kernel/irq.c                            |    6 -
>  arch/cris/arch-v32/kernel/kgdb.c                           |    2 
>  arch/cris/arch-v32/kernel/process.c                        |    2 
>  arch/cris/arch-v32/kernel/signal.c                         |    2 
>  arch/cris/arch-v32/mach-a3/arbiter.c                       |    4 
>  arch/cris/arch-v32/mach-fs/arbiter.c                       |    2 
>  arch/cris/boot/rescue/head_v10.S                           |    2 
>  arch/cris/include/arch-v32/arch/hwregs/Makefile            |    2 
>  arch/cris/include/arch-v32/arch/hwregs/iop/Makefile        |    2 
>  arch/cris/include/asm/etraxgpio.h                          |    2 
>  arch/cris/include/asm/pgtable.h                            |    2 
>  arch/cris/kernel/traps.c                                   |    2 
>  arch/frv/include/asm/pci.h                                 |    2 
>  arch/frv/include/asm/spr-regs.h                            |    2 
>  arch/frv/include/asm/virtconvert.h                         |    2 
>  arch/frv/kernel/entry-table.S                              |    4 
>  arch/ia64/Kconfig                                          |    4 
>  arch/ia64/include/asm/mca_asm.h                            |    6 -
>  arch/ia64/include/asm/pal.h                                |    4 
>  arch/ia64/include/asm/perfmon_default_smpl.h               |    4 
>  arch/ia64/include/asm/sn/bte.h                             |    2 
>  arch/ia64/include/asm/sn/ioc3.h                            |   10 -
>  arch/ia64/include/asm/sn/shub_mmr.h                        |    2 
>  arch/ia64/include/asm/sn/shubio.h                          |    6 -
>  arch/ia64/kernel/cyclone.c                                 |    2 
>  arch/ia64/kernel/perfmon_default_smpl.c                    |    2 
>  arch/ia64/kernel/smpboot.c                                 |    2 
>  arch/ia64/kernel/topology.c                                |    2 
>  arch/ia64/kvm/process.c                                    |    2 
>  arch/ia64/lib/do_csum.S                                    |    2 
>  arch/ia64/sn/kernel/irq.c                                  |    4 
>  arch/ia64/sn/kernel/sn2/sn2_smp.c                          |    2 
>  arch/ia64/sn/pci/pcibr/pcibr_dma.c                         |    2 
>  arch/m32r/include/asm/pgtable-2level.h                     |    2 
>  arch/m32r/kernel/entry.S                                   |    4 
>  arch/m32r/mm/fault.c                                       |    2 
>  arch/m68k/fpsp040/bindec.S                                 |    2 
>  arch/m68k/fpsp040/x_ovfl.S                                 |    2 
>  arch/m68k/fpsp040/x_unfl.S                                 |    2 
>  arch/m68k/ifpsp060/src/fpsp.S                              |   10 -
>  arch/m68k/ifpsp060/src/pfpsp.S                             |    8 -
>  arch/m68k/include/asm/apollodma.h                          |    2 
>  arch/m68k/include/asm/atariints.h                          |    2 
>  arch/m68k/include/asm/bootstd.h                            |    2 
>  arch/m68k/include/asm/delay_no.h                           |    2 
>  arch/m68k/include/asm/gpio.h                               |    4 
>  arch/m68k/include/asm/mac_oss.h                            |    2 
>  arch/m68k/include/asm/mac_psc.h                            |    2 
>  arch/m68k/include/asm/macintosh.h                          |    2 
>  arch/m68k/include/asm/mcfcache.h                           |    8 -
>  arch/m68k/include/asm/mcftimer.h                           |    2 
>  arch/m68k/kernel/head.S                                    |   10 -
>  arch/m68knommu/kernel/vmlinux.lds.S                        |    2 
>  arch/m68knommu/platform/523x/config.c                      |    2 
>  arch/m68knommu/platform/527x/config.c                      |    2 
>  arch/m68knommu/platform/528x/config.c                      |    2 
>  arch/m68knommu/platform/coldfire/entry.S                   |    2 
>  arch/m68knommu/platform/coldfire/head.S                    |    2 
>  arch/m68knommu/platform/coldfire/intc.c                    |    2 
>  arch/microblaze/Makefile                                   |    2 
>  arch/microblaze/include/asm/io.h                           |    2 
>  arch/microblaze/include/asm/mmu.h                          |    2 
>  arch/microblaze/include/asm/pci-bridge.h                   |    2 
>  arch/microblaze/include/asm/pci.h                          |    2 
>  arch/microblaze/kernel/cpu/cache.c                         |    2 
>  arch/microblaze/lib/memcpy.c                               |    6 -
>  arch/microblaze/lib/memmove.c                              |    6 -
>  arch/microblaze/lib/memset.c                               |    2 
>  arch/microblaze/pci/indirect_pci.c                         |    2 
>  arch/mips/Kconfig                                          |    2 
>  arch/mips/Makefile                                         |    4 
>  arch/mips/alchemy/common/clocks.c                          |    2 
>  arch/mips/cavium-octeon/dma-octeon.c                       |    2 
>  arch/mips/cavium-octeon/executive/octeon-model.c           |    2 
>  arch/mips/cavium-octeon/setup.c                            |    2 
>  arch/mips/include/asm/dec/prom.h                           |    2 
>  arch/mips/include/asm/dma.h                                |    2 
>  arch/mips/include/asm/floppy.h                             |    4 
>  arch/mips/include/asm/hw_irq.h                             |    2 
>  arch/mips/include/asm/io.h                                 |    2 
>  arch/mips/include/asm/irqflags.h                           |    2 
>  arch/mips/include/asm/mach-ip32/mc146818rtc.h              |    2 
>  arch/mips/include/asm/mach-loongson/cs5536/cs5536.h        |    2 
>  arch/mips/include/asm/mach-powertv/dma-coherence.h         |    2 
>  arch/mips/include/asm/mipsregs.h                           |    4 
>  arch/mips/include/asm/octeon/cvmx-bootmem.h                |    2 
>  arch/mips/include/asm/octeon/cvmx-l2c.h                    |    2 
>  arch/mips/include/asm/octeon/cvmx.h                        |    2 
>  arch/mips/include/asm/paccess.h                            |    2 
>  arch/mips/include/asm/pmc-sierra/msp71xx/msp_regops.h      |    2 
>  arch/mips/include/asm/processor.h                          |    2 
>  arch/mips/include/asm/sgi/ioc.h                            |    2 
>  arch/mips/include/asm/siginfo.h                            |    2 
>  arch/mips/include/asm/sn/ioc3.h                            |   10 -
>  arch/mips/include/asm/sn/klconfig.h                        |    4 
>  arch/mips/include/asm/sn/sn0/hubmd.h                       |    6 -
>  arch/mips/include/asm/stackframe.h                         |    2 
>  arch/mips/include/asm/war.h                                |    2 
>  arch/mips/jz4740/board-qi_lb60.c                           |    4 
>  arch/mips/kernel/cpu-bugs64.c                              |    2 
>  arch/mips/kernel/genex.S                                   |    2 
>  arch/mips/kernel/process.c                                 |    2 
>  arch/mips/kernel/smp-mt.c                                  |    2 
>  arch/mips/kernel/time.c                                    |    2 
>  arch/mips/kernel/vpe.c                                     |    2 
>  arch/mips/lib/strnlen_user.S                               |    2 
>  arch/mips/math-emu/dp_mul.c                                |    2 
>  arch/mips/math-emu/dsemul.c                                |    2 
>  arch/mips/math-emu/sp_mul.c                                |    2 
>  arch/mips/mm/cex-sb1.S                                     |    2 
>  arch/mips/mm/tlbex.c                                       |    2 
>  arch/mips/mti-malta/malta-smtc.c                           |    2 
>  arch/mips/pci/ops-pmcmsp.c                                 |    4 
>  arch/mips/pci/pci-bcm1480.c                                |    2 
>  arch/mips/pci/pci-octeon.c                                 |    2 
>  arch/mips/pci/pci.c                                        |    2 
>  arch/mips/pmc-sierra/msp71xx/msp_setup.c                   |    2 
>  arch/mips/sgi-ip22/ip22-hpc.c                              |    2 
>  arch/mips/sgi-ip22/ip22-mc.c                               |    4 
>  arch/mips/sgi-ip22/ip22-nvram.c                            |    2 
>  arch/mips/sgi-ip22/ip22-reset.c                            |    2 
>  arch/mips/sgi-ip22/ip22-setup.c                            |    2 
>  arch/mips/sgi-ip27/Kconfig                                 |    2 
>  arch/mips/sgi-ip27/TODO                                    |    2 
>  arch/mips/sgi-ip27/ip27-init.c                             |    2 
>  arch/mips/sgi-ip27/ip27-irq.c                              |    2 
>  arch/mn10300/include/asm/cpu-regs.h                        |    2 
>  arch/mn10300/unit-asb2305/include/unit/serial.h            |    2 
>  arch/parisc/include/asm/dma.h                              |    2 
>  arch/parisc/include/asm/eisa_eeprom.h                      |    2 
>  arch/parisc/kernel/cache.c                                 |   10 -
>  arch/parisc/kernel/entry.S                                 |   10 -
>  arch/parisc/kernel/head.S                                  |    2 
>  arch/parisc/kernel/inventory.c                             |    2 
>  arch/parisc/kernel/perf_images.h                           |    4 
>  arch/parisc/kernel/signal.c                                |    2 
>  arch/parisc/kernel/syscall.S                               |    2 
>  arch/parisc/kernel/syscall_table.S                         |    2 
>  arch/parisc/kernel/traps.c                                 |    2 
>  arch/parisc/math-emu/dfadd.c                               |    2 
>  arch/parisc/math-emu/dfsub.c                               |    2 
>  arch/parisc/math-emu/fmpyfadd.c                            |    8 -
>  arch/parisc/math-emu/sfadd.c                               |    2 
>  arch/parisc/math-emu/sfsub.c                               |    2 
>  arch/powerpc/boot/dts/kmeter1.dts                          |    2 
>  arch/powerpc/include/asm/bitops.h                          |    4 
>  arch/powerpc/include/asm/compat.h                          |    2 
>  arch/powerpc/include/asm/dma.h                             |    2 
>  arch/powerpc/include/asm/hvcall.h                          |    2 
>  arch/powerpc/include/asm/kprobes.h                         |    2 
>  arch/powerpc/include/asm/lppaca.h                          |    2 
>  arch/powerpc/include/asm/mmu-hash32.h                      |    2 
>  arch/powerpc/include/asm/page_64.h                         |    2 
>  arch/powerpc/include/asm/pasemi_dma.h                      |    2 
>  arch/powerpc/include/asm/pci-bridge.h                      |    2 
>  arch/powerpc/include/asm/pte-common.h                      |    2 
>  arch/powerpc/include/asm/reg_booke.h                       |    2 
>  arch/powerpc/include/asm/spu_priv1.h                       |    2 
>  arch/powerpc/include/asm/uninorth.h                        |    2 
>  arch/powerpc/include/asm/vdso_datapage.h                   |    2 
>  arch/powerpc/include/asm/vio.h                             |    2 
>  arch/powerpc/kernel/btext.c                                |    2 
>  arch/powerpc/kernel/exceptions-64s.S                       |    2 
>  arch/powerpc/kernel/head_40x.S                             |    2 
>  arch/powerpc/kernel/head_64.S                              |    2 
>  arch/powerpc/kernel/l2cr_6xx.S                             |    2 
>  arch/powerpc/kernel/lparcfg.c                              |    2 
>  arch/powerpc/kernel/perf_event.c                           |    2 
>  arch/powerpc/kernel/ppc_save_regs.S                        |    2 
>  arch/powerpc/kernel/prom.c                                 |    2 
>  arch/powerpc/kernel/ptrace.c                               |    2 
>  arch/powerpc/kernel/reloc_64.S                             |    4 
>  arch/powerpc/kernel/setup_64.c                             |    2 
>  arch/powerpc/kernel/swsusp_32.S                            |    2 
>  arch/powerpc/kernel/traps.c                                |    2 
>  arch/powerpc/kernel/udbg_16550.c                           |    2 
>  arch/powerpc/kernel/vdso32/sigtramp.S                      |    4 
>  arch/powerpc/kernel/vdso64/sigtramp.S                      |    4 
>  arch/powerpc/kernel/vdso64/vdso64.lds.S                    |    2 
>  arch/powerpc/kernel/vmlinux.lds.S                          |    4 
>  arch/powerpc/mm/hash_utils_64.c                            |    2 
>  arch/powerpc/mm/mem.c                                      |    2 
>  arch/powerpc/mm/numa.c                                     |    2 
>  arch/powerpc/mm/tlb_low_64e.S                              |    4 
>  arch/powerpc/oprofile/op_model_cell.c                      |    4 
>  arch/powerpc/platforms/52xx/efika.c                        |    2 
>  arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c              |    6 -
>  arch/powerpc/platforms/52xx/mpc52xx_pic.c                  |    2 
>  arch/powerpc/platforms/83xx/suspend-asm.S                  |    6 -
>  arch/powerpc/platforms/cell/spufs/lscsa_alloc.c            |    2 
>  arch/powerpc/platforms/cell/spufs/sched.c                  |    2 
>  arch/powerpc/platforms/cell/spufs/spu_restore.c            |    2 
>  arch/powerpc/platforms/iseries/viopath.c                   |    8 -
>  arch/powerpc/platforms/pasemi/dma_lib.c                    |    4 
>  arch/powerpc/platforms/powermac/Makefile                   |    2 
>  arch/powerpc/platforms/powermac/low_i2c.c                  |    2 
>  arch/powerpc/platforms/powermac/pci.c                      |    2 
>  arch/powerpc/platforms/powermac/sleep.S                    |    2 
>  arch/powerpc/platforms/ps3/device-init.c                   |    4 
>  arch/powerpc/platforms/pseries/dlpar.c                     |    2 
>  arch/powerpc/platforms/pseries/eeh.c                       |    2 
>  arch/powerpc/platforms/pseries/hotplug-cpu.c               |    2 
>  arch/powerpc/platforms/pseries/iommu.c                     |    2 
>  arch/powerpc/platforms/pseries/xics.c                      |    2 
>  arch/powerpc/sysdev/axonram.c                              |    8 -
>  arch/powerpc/sysdev/bestcomm/bestcomm.c                    |    2 
>  arch/powerpc/sysdev/bestcomm/bestcomm.h                    |    2 
>  arch/powerpc/sysdev/bestcomm/bestcomm_priv.h               |    2 
>  arch/powerpc/sysdev/cpm1.c                                 |    2 
>  arch/powerpc/sysdev/indirect_pci.c                         |    2 
>  arch/powerpc/sysdev/ppc4xx_pci.h                           |    2 
>  arch/s390/include/asm/atomic.h                             |    2 
>  arch/s390/include/asm/cio.h                                |    2 
>  arch/s390/kernel/head.S                                    |    2 
>  arch/s390/kernel/reipl64.S                                 |    2 
>  arch/s390/kernel/setup.c                                   |    2 
>  arch/s390/kernel/time.c                                    |    6 -
>  arch/s390/kernel/vdso32/vdso32.lds.S                       |    2 
>  arch/s390/kernel/vdso64/vdso64.lds.S                       |    2 
>  arch/s390/kernel/vtime.c                                   |    2 
>  arch/s390/kvm/kvm-s390.c                                   |    2 
>  arch/s390/kvm/priv.c                                       |    2 
>  arch/s390/mm/fault.c                                       |    2 
>  arch/score/Makefile                                        |    2 
>  arch/sh/Kconfig.debug                                      |    2 
>  arch/sh/boards/mach-dreamcast/irq.c                        |    2 
>  arch/sh/boards/mach-ecovec24/setup.c                       |    2 
>  arch/sh/drivers/pci/pci.c                                  |    2 
>  arch/sh/include/asm/page.h                                 |    2 
>  arch/sh/include/asm/pgtable_32.h                           |    2 
>  arch/sh/include/asm/pgtable_64.h                           |    2 
>  arch/sh/include/asm/unaligned-sh4a.h                       |    2 
>  arch/sh/kernel/cpu/clock-cpg.c                             |    2 
>  arch/sh/kernel/cpu/sh5/entry.S                             |    2 
>  arch/sh/lib64/copy_user_memcpy.S                           |    2 
>  arch/sh/lib64/memcpy.S                                     |    2 
>  arch/sparc/include/asm/hypervisor.h                        |   20 +--
>  arch/sparc/include/asm/ns87303.h                           |    2 
>  arch/sparc/include/asm/pcr.h                               |    2 
>  arch/sparc/include/asm/ptrace.h                            |    2 
>  arch/sparc/include/asm/turbosparc.h                        |    2 
>  arch/sparc/include/asm/viking.h                            |    2 
>  arch/sparc/kernel/entry.S                                  |    4 
>  arch/sparc/kernel/head_32.S                                |    6 -
>  arch/sparc/kernel/head_64.S                                |    2 
>  arch/sparc/kernel/init_task.c                              |    2 
>  arch/sparc/kernel/of_device_64.c                           |    2 
>  arch/sparc/kernel/perf_event.c                             |    2 
>  arch/sparc/math-emu/Makefile                               |    2 
>  arch/sparc/mm/srmmu.c                                      |    2 
>  arch/sparc/mm/swift.S                                      |    2 
>  arch/tile/Kconfig                                          |    2 
>  arch/tile/include/asm/irqflags.h                           |    6 -
>  arch/tile/include/hv/hypervisor.h                          |    2 
>  arch/tile/kernel/entry.S                                   |    2 
>  arch/tile/kernel/head_32.S                                 |    4 
>  arch/tile/kernel/intvec_32.S                               |    2 
>  arch/tile/kernel/relocate_kernel.S                         |    2 
>  arch/tile/kernel/tile-desc_32.c                            |    4 
>  arch/tile/lib/atomic_asm_32.S                              |    2 
>  arch/tile/mm/hugetlbpage.c                                 |    2 
>  arch/um/Kconfig.net                                        |    2 
>  arch/x86/Kconfig.cpu                                       |    2 
>  arch/x86/include/asm/cacheflush.h                          |    2 
>  arch/x86/include/asm/dma.h                                 |    2 
>  arch/x86/include/asm/nops.h                                |    2 
>  arch/x86/include/asm/olpc.h                                |    2 
>  arch/x86/include/asm/perf_event_p4.h                       |    2 
>  arch/x86/include/asm/processor.h                           |    2 
>  arch/x86/include/asm/ptrace-abi.h                          |    2 
>  arch/x86/include/asm/ptrace.h                              |    4 
>  arch/x86/include/asm/tsc.h                                 |    2 
>  arch/x86/kernel/alternative.c                              |    2 
>  arch/x86/kernel/aperture_64.c                              |    2 
>  arch/x86/kernel/apic/io_apic.c                             |    4 
>  arch/x86/kernel/apm_32.c                                   |    2 
>  arch/x86/kernel/cpu/cpufreq/longhaul.c                     |    4 
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c                  |    2 
>  arch/x86/kernel/cpu/cpufreq/speedstep-smi.c                |    4 
>  arch/x86/kernel/cpu/mcheck/mce-inject.c                    |    2 
>  arch/x86/kernel/cpu/mcheck/mce.c                           |    2 
>  arch/x86/kernel/cpu/mtrr/generic.c                         |    2 
>  arch/x86/kernel/cpu/perf_event.c                           |    2 
>  arch/x86/kernel/cpu/perf_event_p4.c                        |    4 
>  arch/x86/kernel/cpu/vmware.c                               |    2 
>  arch/x86/kernel/entry_64.S                                 |    2 
>  arch/x86/kernel/i387.c                                     |    2 
>  arch/x86/kernel/kgdb.c                                     |    2 
>  arch/x86/kernel/mpparse.c                                  |    4 
>  arch/x86/kernel/pci-calgary_64.c                           |    2 
>  arch/x86/kernel/step.c                                     |    2 
>  arch/x86/kernel/tlb_uv.c                                   |    4 
>  arch/x86/kernel/topology.c                                 |    2 
>  arch/x86/kernel/tsc.c                                      |    2 
>  arch/x86/kernel/verify_cpu_64.S                            |    2 
>  arch/x86/kernel/xsave.c                                    |    2 
>  arch/x86/kvm/lapic.c                                       |    4 
>  arch/x86/kvm/paging_tmpl.h                                 |    2 
>  arch/x86/kvm/timer.c                                       |    2 
>  arch/x86/lib/copy_user_64.S                                |    2 
>  arch/x86/lib/csum-copy_64.S                                |    4 
>  arch/x86/lib/csum-partial_64.c                             |    2 
>  arch/x86/lib/memcpy_64.S                                   |    2 
>  arch/x86/mm/fault.c                                        |    2 
>  arch/x86/mm/hugetlbpage.c                                  |    2 
>  arch/x86/mm/pageattr.c                                     |    2 
>  arch/x86/pci/i386.c                                        |    4 
>  arch/x86/xen/mmu.c                                         |    2 
>  arch/xtensa/include/asm/dma.h                              |    2 
>  arch/xtensa/kernel/entry.S                                 |    2 
>  arch/xtensa/lib/strncpy_user.S                             |    2 
>  block/blk-barrier.c                                        |    2 
>  block/blk.h                                                |    2 
>  block/cfq-iosched.c                                        |    2 
>  block/genhd.c                                              |    4 
>  crypto/ansi_cprng.c                                        |    2 
>  crypto/async_tx/async_xor.c                                |    2 
>  crypto/gf128mul.c                                          |    2 
>  crypto/vmac.c                                              |    2 
>  crypto/xts.c                                               |    2 
>  drivers/acpi/acpica/exutils.c                              |    2 
>  drivers/acpi/acpica/rsutils.c                              |    2 
>  drivers/acpi/apei/Kconfig                                  |    2 
>  drivers/acpi/apei/erst-dbg.c                               |    2 
>  drivers/acpi/apei/erst.c                                   |    2 
>  drivers/acpi/bus.c                                         |    4 
>  drivers/acpi/processor_perflib.c                           |    4 
>  drivers/amba/bus.c                                         |    2 
>  drivers/ata/ahci.h                                         |    2 
>  drivers/ata/ata_piix.c                                     |    8 -
>  drivers/ata/libata-acpi.c                                  |    2 
>  drivers/ata/libata-core.c                                  |    8 -
>  drivers/ata/libata-eh.c                                    |   10 -
>  drivers/ata/libata-scsi.c                                  |   12 +-
>  drivers/ata/libata-sff.c                                   |    4 
>  drivers/ata/pata_amd.c                                     |    2 
>  drivers/ata/pata_bf54x.c                                   |    2 
>  drivers/ata/pata_cs5520.c                                  |    2 
>  drivers/ata/pata_mpiix.c                                   |    2 
>  drivers/ata/pata_rz1000.c                                  |    2 
>  drivers/ata/pata_sil680.c                                  |    4 
>  drivers/ata/pata_sis.c                                     |    4 
>  drivers/ata/pata_triflex.c                                 |    2 
>  drivers/ata/sata_fsl.c                                     |    4 
>  drivers/ata/sata_inic162x.c                                |    2 
>  drivers/ata/sata_mv.c                                      |   10 -
>  drivers/ata/sata_nv.c                                      |    2 
>  drivers/ata/sata_via.c                                     |    2 
>  drivers/atm/ambassador.c                                   |    2 
>  drivers/atm/firestream.c                                   |    2 
>  drivers/atm/fore200e.h                                     |    4 
>  drivers/atm/horizon.c                                      |   10 -
>  drivers/atm/idt77252.c                                     |    2 
>  drivers/atm/iphase.c                                       |    4 
>  drivers/atm/lanai.c                                        |    4 
>  drivers/auxdisplay/cfag12864b.c                            |    2 
>  drivers/base/class.c                                       |    2 
>  drivers/base/sys.c                                         |   14 +-
>  drivers/block/DAC960.c                                     |    2 
>  drivers/block/drbd/drbd_actlog.c                           |    2 
>  drivers/block/drbd/drbd_int.h                              |   10 -
>  drivers/block/drbd/drbd_main.c                             |    2 
>  drivers/block/drbd/drbd_receiver.c                         |    2 
>  drivers/block/drbd/drbd_vli.h                              |    2 
>  drivers/block/hd.c                                         |    2 
>  drivers/block/xsysace.c                                    |    8 -
>  drivers/cdrom/cdrom.c                                      |    2 
>  drivers/char/agp/agp.h                                     |    2 
>  drivers/char/agp/amd-k7-agp.c                              |    2 
>  drivers/char/agp/sworks-agp.c                              |    2 
>  drivers/char/agp/via-agp.c                                 |    2 
>  drivers/char/cd1865.h                                      |    2 
>  drivers/char/epca.c                                        |   12 +-
>  drivers/char/hvc_iucv.c                                    |    4 
>  drivers/char/hvc_vio.c                                     |    2 
>  drivers/char/hvcs.c                                        |    8 -
>  drivers/char/ip2/i2hw.h                                    |    4 
>  drivers/char/ip2/i2lib.c                                   |    8 -
>  drivers/char/ip2/ip2main.c                                 |    2 
>  drivers/char/ipmi/ipmi_poweroff.c                          |    2 
>  drivers/char/ipmi/ipmi_si_intf.c                           |    4 
>  drivers/char/mspec.c                                       |    2 
>  drivers/char/mxser.h                                       |    2 
>  drivers/char/n_gsm.c                                       |   10 -
>  drivers/char/nozomi.c                                      |    2 
>  drivers/char/nwbutton.c                                    |    2 
>  drivers/char/pcmcia/cm4000_cs.c                            |    2 
>  drivers/char/pcmcia/synclink_cs.c                          |    2 
>  drivers/char/random.c                                      |    2 
>  drivers/char/rio/map.h                                     |    2 
>  drivers/char/rio/rioboot.c                                 |    6 -
>  drivers/char/rio/riocmd.c                                  |    2 
>  drivers/char/rio/rioroute.c                                |    2 
>  drivers/char/rio/riotty.c                                  |    4 
>  drivers/char/rocket.c                                      |    4 
>  drivers/char/specialix.c                                   |    4 
>  drivers/char/specialix_io8.h                               |    4 
>  drivers/char/stallion.c                                    |    2 
>  drivers/char/sx.c                                          |    8 -
>  drivers/char/synclink_gt.c                                 |    2 
>  drivers/char/tty_io.c                                      |    8 -
>  drivers/char/tty_ioctl.c                                   |    4 
>  drivers/char/vt.c                                          |    2 
>  drivers/char/xilinx_hwicap/xilinx_hwicap.c                 |    2 
>  drivers/cpuidle/governors/menu.c                           |    2 
>  drivers/crypto/amcc/crypto4xx_sa.c                         |    2 
>  drivers/crypto/amcc/crypto4xx_sa.h                         |    2 
>  drivers/crypto/ixp4xx_crypto.c                             |    2 
>  drivers/crypto/padlock-aes.c                               |    2 
>  drivers/dma/at_hdmac.c                                     |    2 
>  drivers/dma/coh901318.c                                    |    2 
>  drivers/dma/intel_mid_dma.c                                |    4 
>  drivers/dma/ste_dma40.c                                    |    2 
>  drivers/edac/Kconfig                                       |    2 
>  drivers/edac/cpc925_edac.c                                 |    2 
>  drivers/edac/edac_core.h                                   |    6 -
>  drivers/edac/edac_device_sysfs.c                           |    4 
>  drivers/edac/edac_mc.c                                     |    2 
>  drivers/edac/edac_mc_sysfs.c                               |    2 
>  drivers/edac/edac_pci_sysfs.c                              |    2 
>  drivers/edac/i5000_edac.c                                  |    2 
>  drivers/edac/i5100_edac.c                                  |    2 
>  drivers/edac/i5400_edac.c                                  |    2 
>  drivers/edac/i7core_edac.c                                 |    2 
>  drivers/edac/i82443bxgx_edac.c                             |    2 
>  drivers/firewire/net.c                                     |    2 
>  drivers/gpio/mc33880.c                                     |    2 
>  drivers/gpu/drm/drm_crtc.c                                 |    4 
>  drivers/gpu/drm/drm_mm.c                                   |    2 
>  drivers/gpu/drm/i915/i915_drv.h                            |    4 
>  drivers/gpu/drm/i915/intel_dp.c                            |    2 
>  drivers/gpu/drm/i915/intel_sdvo_regs.h                     |    2 
>  drivers/gpu/drm/mga/mga_dma.c                              |    2 
>  drivers/gpu/drm/nouveau/nouveau_channel.c                  |    2 
>  drivers/gpu/drm/nouveau/nouveau_drv.h                      |    2 
>  drivers/gpu/drm/nouveau/nouveau_state.c                    |    2 
>  drivers/gpu/drm/nouveau/nv04_crtc.c                        |    4 
>  drivers/gpu/drm/nouveau/nv40_graph.c                       |    2 
>  drivers/gpu/drm/radeon/atombios.h                          |   18 +--
>  drivers/gpu/drm/radeon/evergreen_cs.c                      |    2 
>  drivers/gpu/drm/radeon/r300.c                              |    2 
>  drivers/gpu/drm/radeon/r300_reg.h                          |    4 
>  drivers/gpu/drm/radeon/r600_cs.c                           |    2 
>  drivers/gpu/drm/radeon/r600_hdmi.c                         |    2 
>  drivers/gpu/drm/radeon/radeon.h                            |    6 -
>  drivers/gpu/drm/radeon/radeon_cp.c                         |    2 
>  drivers/gpu/drm/radeon/radeon_cursor.c                     |    2 
>  drivers/gpu/drm/radeon/radeon_device.c                     |    2 
>  drivers/gpu/drm/radeon/radeon_drv.h                        |    2 
>  drivers/gpu/drm/radeon/radeon_fence.c                      |   32 +++---
>  drivers/gpu/drm/radeon/radeon_legacy_crtc.c                |    2 
>  drivers/gpu/drm/radeon/radeon_object.h                     |    2 
>  drivers/gpu/drm/radeon/radeon_pm.c                         |    4 
>  drivers/gpu/drm/radeon/radeon_ring.c                       |    2 
>  drivers/gpu/drm/radeon/radeon_state.c                      |    2 
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                        |    2 
>  drivers/gpu/vga/vgaarb.c                                   |    4 
>  drivers/hid/hid-core.c                                     |    4 
>  drivers/hid/hid-picolcd.c                                  |    4 
>  drivers/hid/hid-roccat-kone.h                              |    2 
>  drivers/hwmon/abituguru.c                                  |    2 
>  drivers/hwmon/abituguru3.c                                 |    2 
>  drivers/hwmon/adm1026.c                                    |    2 
>  drivers/hwmon/lm85.c                                       |    2 
>  drivers/hwmon/lm90.c                                       |    2 
>  drivers/hwmon/sht15.c                                      |    6 -
>  drivers/hwmon/tmp102.c                                     |    2 
>  drivers/hwmon/via686a.c                                    |    4 
>  drivers/hwmon/w83791d.c                                    |    2 
>  drivers/hwmon/w83792d.c                                    |    2 
>  drivers/hwmon/w83793.c                                     |    2 
>  drivers/i2c/algos/i2c-algo-pca.c                           |    2 
>  drivers/i2c/busses/i2c-ali1535.c                           |    2 
>  drivers/i2c/busses/i2c-ali15x3.c                           |    2 
>  drivers/i2c/busses/i2c-designware.c                        |    2 
>  drivers/i2c/busses/i2c-ibm_iic.c                           |    4 
>  drivers/i2c/busses/i2c-isch.c                              |    2 
>  drivers/i2c/busses/i2c-nomadik.c                           |    8 -
>  drivers/i2c/busses/i2c-s6000.c                             |    2 
>  drivers/i2c/busses/i2c-stu300.c                            |    4 
>  drivers/i2c/busses/i2c-xiic.c                              |    2 
>  drivers/i2c/i2c-core.c                                     |    2 
>  drivers/ide/cy82c693.c                                     |    2 
>  drivers/ide/hpt366.c                                       |    4 
>  drivers/ide/ide-floppy.c                                   |    2 
>  drivers/ide/ide-taskfile.c                                 |    2 
>  drivers/ide/piix.c                                         |    2 
>  drivers/ide/sis5513.c                                      |    4 
>  drivers/ide/tc86c001.c                                     |    2 
>  drivers/ide/triflex.c                                      |    2 
>  drivers/ide/via82cxxx.c                                    |    2 
>  drivers/ieee1394/csr1212.c                                 |    4 
>  drivers/ieee1394/dv1394.h                                  |    2 
>  drivers/ieee1394/eth1394.c                                 |    4 
>  drivers/ieee1394/hosts.h                                   |    6 -
>  drivers/ieee1394/ohci1394.c                                |    2 
>  drivers/ieee1394/sbp2.c                                    |    2 
>  drivers/infiniband/hw/amso1100/c2.c                        |    2 
>  drivers/infiniband/hw/amso1100/c2_ae.c                     |    2 
>  drivers/infiniband/hw/amso1100/c2_wr.h                     |    4 
>  drivers/infiniband/hw/cxgb3/cxio_wr.h                      |    2 
>  drivers/infiniband/hw/ipath/ipath_driver.c                 |    2 
>  drivers/infiniband/hw/ipath/ipath_file_ops.c               |    2 
>  drivers/infiniband/hw/ipath/ipath_init_chip.c              |    2 
>  drivers/infiniband/hw/ipath/ipath_ud.c                     |    4 
>  drivers/infiniband/hw/ipath/ipath_user_sdma.c              |    2 
>  drivers/infiniband/hw/nes/nes_cm.c                         |    2 
>  drivers/infiniband/hw/qib/qib.h                            |    2 
>  drivers/infiniband/hw/qib/qib_file_ops.c                   |    4 
>  drivers/infiniband/hw/qib/qib_iba6120.c                    |    4 
>  drivers/infiniband/hw/qib/qib_iba7220.c                    |    6 -
>  drivers/infiniband/hw/qib/qib_iba7322.c                    |    6 -
>  drivers/infiniband/hw/qib/qib_init.c                       |    2 
>  drivers/infiniband/hw/qib/qib_mad.h                        |    2 
>  drivers/infiniband/hw/qib/qib_twsi.c                       |    2 
>  drivers/infiniband/hw/qib/qib_ud.c                         |    4 
>  drivers/infiniband/hw/qib/qib_user_sdma.c                  |    2 
>  drivers/infiniband/ulp/iser/iscsi_iser.h                   |    2 
>  drivers/input/joydev.c                                     |    4 
>  drivers/input/joystick/iforce/iforce-ff.c                  |    4 
>  drivers/input/joystick/xpad.c                              |    2 
>  drivers/input/misc/keyspan_remote.c                        |    2 
>  drivers/input/misc/wistron_btns.c                          |    2 
>  drivers/input/mouse/bcm5974.c                              |    2 
>  drivers/input/mouse/synaptics_i2c.c                        |    2 
>  drivers/input/mouse/vsxxxaa.c                              |    2 
>  drivers/input/serio/hp_sdc.c                               |    2 
>  drivers/input/serio/xilinx_ps2.c                           |    2 
>  drivers/input/tablet/gtco.c                                |    6 -
>  drivers/input/touchscreen/ucb1400_ts.c                     |    2 
>  drivers/input/touchscreen/wm9705.c                         |    2 
>  drivers/input/touchscreen/wm9712.c                         |    2 
>  drivers/input/touchscreen/wm9713.c                         |    2 
>  drivers/input/touchscreen/wm97xx-core.c                    |    4 
>  drivers/isdn/hardware/eicon/divacapi.h                     |    2 
>  drivers/isdn/hardware/eicon/io.h                           |    2 
>  drivers/isdn/hardware/eicon/message.c                      |    6 -
>  drivers/isdn/hardware/eicon/mi_pc.h                        |    4 
>  drivers/isdn/hardware/eicon/pc.h                           |    2 
>  drivers/isdn/hardware/eicon/um_idi.c                       |    2 
>  drivers/isdn/hardware/mISDN/hfcmulti.c                     |    4 
>  drivers/isdn/hardware/mISDN/hfcpci.c                       |    2 
>  drivers/isdn/hisax/elsa_ser.c                              |    2 
>  drivers/isdn/hisax/hfc_pci.c                               |    2 
>  drivers/isdn/hisax/hfc_sx.c                                |    2 
>  drivers/isdn/hisax/hfc_usb.h                               |    2 
>  drivers/isdn/hisax/jade.c                                  |    2 
>  drivers/isdn/hisax/l3dss1.c                                |    6 -
>  drivers/isdn/hisax/l3ni1.c                                 |    6 -
>  drivers/isdn/hisax/nj_s.c                                  |    2 
>  drivers/isdn/hisax/st5481_b.c                              |    2 
>  drivers/isdn/hisax/st5481_usb.c                            |    2 
>  drivers/isdn/hysdn/hysdn_sched.c                           |    2 
>  drivers/isdn/i4l/isdn_net.c                                |    4 
>  drivers/isdn/i4l/isdn_ppp.c                                |    6 -
>  drivers/isdn/i4l/isdn_tty.c                                |    2 
>  drivers/isdn/isdnloop/isdnloop.c                           |    2 
>  drivers/isdn/mISDN/dsp.h                                   |    2 
>  drivers/isdn/mISDN/dsp_cmx.c                               |    4 
>  drivers/isdn/mISDN/dsp_core.c                              |    8 -
>  drivers/isdn/mISDN/dsp_dtmf.c                              |    4 
>  drivers/isdn/mISDN/dsp_tones.c                             |    2 
>  drivers/isdn/mISDN/l1oip_core.c                            |    6 -
>  drivers/isdn/mISDN/layer2.c                                |    4 
>  drivers/leds/leds-wm8350.c                                 |    4 
>  drivers/lguest/lguest_user.c                               |    2 
>  drivers/macintosh/adbhid.c                                 |    2 
>  drivers/macintosh/macio-adb.c                              |    2 
>  drivers/macintosh/mediabay.c                               |    2 
>  drivers/macintosh/therm_adt746x.c                          |    2 
>  drivers/macintosh/therm_pm72.c                             |    4 
>  drivers/macintosh/therm_windtunnel.c                       |    2 
>  drivers/md/bitmap.h                                        |    2 
>  drivers/md/dm-region-hash.c                                |    2 
>  drivers/md/faulty.c                                        |    2 
>  drivers/md/md.c                                            |    2 
>  drivers/md/md.h                                            |    2 
>  drivers/md/raid10.c                                        |    4 
>  drivers/md/raid10.h                                        |    4 
>  drivers/media/IR/Kconfig                                   |    2 
>  drivers/media/IR/ene_ir.c                                  |    2 
>  drivers/media/IR/imon.c                                    |    2 
>  drivers/media/IR/ir-raw-event.c                            |    2 
>  drivers/media/common/saa7146_i2c.c                         |    8 -
>  drivers/media/common/tuners/mxl5005s.c                     |    2 
>  drivers/media/common/tuners/tda18271-common.c              |    2 
>  drivers/media/common/tuners/tda18271-fe.c                  |    2 
>  drivers/media/common/tuners/tda18271.h                     |    6 -
>  drivers/media/common/tuners/tuner-types.c                  |    2 
>  drivers/media/dvb/b2c2/flexcop-pci.c                       |    2 
>  drivers/media/dvb/bt8xx/dvb-bt8xx.c                        |    4 
>  drivers/media/dvb/dvb-core/dvb_frontend.c                  |    4 
>  drivers/media/dvb/dvb-usb/af9005-fe.c                      |    8 -
>  drivers/media/dvb/dvb-usb/dib0700_devices.c                |    2 
>  drivers/media/dvb/dvb-usb/friio.h                          |    2 
>  drivers/media/dvb/frontends/atbm8830.h                     |    2 
>  drivers/media/dvb/frontends/au8522_dig.c                   |    6 -
>  drivers/media/dvb/frontends/cx22700.c                      |    2 
>  drivers/media/dvb/frontends/cx22702.c                      |    6 -
>  drivers/media/dvb/frontends/cx24110.c                      |    2 
>  drivers/media/dvb/frontends/cx24123.c                      |    2 
>  drivers/media/dvb/frontends/dib7000p.c                     |    2 
>  drivers/media/dvb/frontends/drx397xD.c                     |    2 
>  drivers/media/dvb/frontends/mt312.c                        |    2 
>  drivers/media/dvb/frontends/s5h1420.c                      |    2 
>  drivers/media/dvb/frontends/stv0297.c                      |    2 
>  drivers/media/dvb/frontends/stv090x.c                      |   12 +-
>  drivers/media/dvb/mantis/mantis_uart.c                     |    2 
>  drivers/media/dvb/ngene/ngene-core.c                       |    6 -
>  drivers/media/dvb/pluto2/pluto2.c                          |   10 -
>  drivers/media/dvb/siano/smsdvb.c                           |    2 
>  drivers/media/dvb/siano/smsusb.c                           |    2 
>  drivers/media/dvb/ttpci/av7110.c                           |    4 
>  drivers/media/dvb/ttpci/budget-patch.c                     |    2 
>  drivers/media/dvb/ttusb-dec/ttusb_dec.c                    |    2 
>  drivers/media/radio/radio-mr800.c                          |    2 
>  drivers/media/video/bt8xx/bttv-cards.c                     |    6 -
>  drivers/media/video/cx18/cx18-av-core.h                    |    2 
>  drivers/media/video/cx18/cx18-ioctl.c                      |    2 
>  drivers/media/video/cx18/cx18-vbi.c                        |    2 
>  drivers/media/video/cx231xx/cx231xx-avcore.c               |    2 
>  drivers/media/video/cx23885/cimax2.c                       |    2 
>  drivers/media/video/cx23885/cx23885-core.c                 |    6 -
>  drivers/media/video/cx23885/cx23885.h                      |    2 
>  drivers/media/video/cx25840/cx25840-core.c                 |    8 -
>  drivers/media/video/cx25840/cx25840-ir.c                   |    2 
>  drivers/media/video/cx88/cx88-tvaudio.c                    |    2 
>  drivers/media/video/davinci/dm644x_ccdc.c                  |    4 
>  drivers/media/video/davinci/vpfe_capture.c                 |    2 
>  drivers/media/video/gspca/gl860/gl860-mi1320.c             |    2 
>  drivers/media/video/gspca/gspca.c                          |    6 -
>  drivers/media/video/gspca/mars.c                           |    2 
>  drivers/media/video/gspca/mr97310a.c                       |   12 +-
>  drivers/media/video/gspca/ov519.c                          |    4 
>  drivers/media/video/gspca/sonixb.c                         |    4 
>  drivers/media/video/gspca/sonixj.c                         |    2 
>  drivers/media/video/gspca/spca500.c                        |    4 
>  drivers/media/video/gspca/sq905.c                          |    2 
>  drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c           |    2 
>  drivers/media/video/gspca/sunplus.c                        |    4 
>  drivers/media/video/gspca/zc3xx.c                          |    4 
>  drivers/media/video/hexium_gemini.c                        |    2 
>  drivers/media/video/ivtv/ivtv-firmware.c                   |    4 
>  drivers/media/video/ivtv/ivtvfb.c                          |    2 
>  drivers/media/video/msp3400-driver.c                       |    2 
>  drivers/media/video/omap/omap_vout.c                       |    4 
>  drivers/media/video/omap/omap_voutlib.c                    |    6 -
>  drivers/media/video/ov9640.c                               |    2 
>  drivers/media/video/pvrusb2/pvrusb2-eeprom.c               |    2 
>  drivers/media/video/pvrusb2/pvrusb2-hdw.h                  |    2 
>  drivers/media/video/pwc/pwc-v4l.c                          |    2 
>  drivers/media/video/pxa_camera.c                           |    2 
>  drivers/media/video/saa5249.c                              |    2 
>  drivers/media/video/saa7164/saa7164-cmd.c                  |    2 
>  drivers/media/video/saa7164/saa7164-core.c                 |    4 
>  drivers/media/video/se401.c                                |    2 
>  drivers/media/video/sn9c102/sn9c102_core.c                 |    2 
>  drivers/media/video/sn9c102/sn9c102_sensor.h               |    2 
>  drivers/media/video/stradis.c                              |    2 
>  drivers/media/video/tcm825x.c                              |    4 
>  drivers/media/video/usbvideo/usbvideo.c                    |    2 
>  drivers/media/video/uvc/uvc_video.c                        |    8 -
>  drivers/media/video/vpx3220.c                              |    2 
>  drivers/media/video/zoran/videocodec.h                     |    2 
>  drivers/media/video/zoran/zoran.h                          |    2 
>  drivers/media/video/zoran/zoran_driver.c                   |    4 
>  drivers/memstick/core/mspro_block.c                        |    2 
>  drivers/message/fusion/lsi/mpi_log_fc.h                    |    4 
>  drivers/message/fusion/lsi/mpi_log_sas.h                   |   14 +-
>  drivers/message/fusion/mptbase.c                           |   10 -
>  drivers/message/fusion/mptctl.c                            |    4 
>  drivers/message/fusion/mptsas.c                            |   10 -
>  drivers/message/i2o/device.c                               |    8 -
>  drivers/message/i2o/i2o_block.c                            |    6 -
>  drivers/message/i2o/i2o_block.h                            |    2 
>  drivers/message/i2o/i2o_config.c                           |    2 
>  drivers/message/i2o/i2o_scsi.c                             |    2 
>  drivers/mfd/Kconfig                                        |    2 
>  drivers/mfd/ab8500-spi.c                                   |    2 
>  drivers/mfd/ezx-pcap.c                                     |    4 
>  drivers/mfd/pcf50633-core.c                                |    4 
>  drivers/mfd/ucb1400_core.c                                 |    2 
>  drivers/misc/bmp085.c                                      |    2 
>  drivers/misc/c2port/c2port-duramar2150.c                   |    2 
>  drivers/misc/kgdbts.c                                      |    2 
>  drivers/misc/sgi-gru/grukservices.c                        |    2 
>  drivers/misc/sgi-gru/grutables.h                           |    2 
>  drivers/mmc/card/mmc_test.c                                |    2 
>  drivers/mmc/core/mmc_ops.c                                 |    2 
>  drivers/mmc/core/sdio_irq.c                                |    2 
>  drivers/mmc/host/atmel-mci.c                               |    4 
>  drivers/mmc/host/mmc_spi.c                                 |    2 
>  drivers/mmc/host/s3cmci.c                                  |    4 
>  drivers/mmc/host/tmio_mmc.c                                |    2 
>  drivers/mmc/host/wbsd.c                                    |    6 -
>  drivers/mtd/chips/Kconfig                                  |    2 
>  drivers/mtd/chips/cfi_cmdset_0001.c                        |    4 
>  drivers/mtd/chips/cfi_cmdset_0002.c                        |   10 -
>  drivers/mtd/chips/cfi_util.c                               |    2 
>  drivers/mtd/chips/jedec_probe.c                            |    2 
>  drivers/mtd/devices/block2mtd.c                            |    2 
>  drivers/mtd/devices/doc2001plus.c                          |    2 
>  drivers/mtd/devices/lart.c                                 |    4 
>  drivers/mtd/devices/pmc551.c                               |    4 
>  drivers/mtd/lpddr/lpddr_cmds.c                             |    4 
>  drivers/mtd/maps/ceiva.c                                   |    4 
>  drivers/mtd/maps/pcmciamtd.c                               |    2 
>  drivers/mtd/maps/pmcmsp-flash.c                            |    2 
>  drivers/mtd/maps/sc520cdp.c                                |    4 
>  drivers/mtd/maps/tqm8xxl.c                                 |    2 
>  drivers/mtd/mtdblock.c                                     |    2 
>  drivers/mtd/mtdchar.c                                      |    2 
>  drivers/mtd/nand/Kconfig                                   |    2 
>  drivers/mtd/nand/ams-delta.c                               |    2 
>  drivers/mtd/nand/autcpu12.c                                |    2 
>  drivers/mtd/nand/cs553x_nand.c                             |    2 
>  drivers/mtd/nand/denali.c                                  |    6 -
>  drivers/mtd/nand/diskonchip.c                              |    8 -
>  drivers/mtd/nand/nand_base.c                               |    2 
>  drivers/mtd/nand/nand_bbt.c                                |    2 
>  drivers/mtd/nand/nandsim.c                                 |    4 
>  drivers/mtd/nand/nomadik_nand.c                            |    2 
>  drivers/mtd/nand/pasemi_nand.c                             |    2 
>  drivers/mtd/nand/plat_nand.c                               |    2 
>  drivers/mtd/nand/pxa3xx_nand.c                             |    2 
>  drivers/mtd/nand/r852.c                                    |   14 +-
>  drivers/mtd/nand/sh_flctl.c                                |    2 
>  drivers/mtd/nand/sm_common.c                               |    2 
>  drivers/mtd/nand/tmio_nand.c                               |    2 
>  drivers/mtd/onenand/onenand_sim.c                          |    4 
>  drivers/mtd/sm_ftl.c                                       |    4 
>  drivers/net/3c501.c                                        |    6 -
>  drivers/net/3c523.c                                        |    4 
>  drivers/net/3c527.c                                        |    4 
>  drivers/net/3c59x.c                                        |    2 
>  drivers/net/acenic.c                                       |    4 
>  drivers/net/amd8111e.c                                     |    2 
>  drivers/net/bcm63xx_enet.c                                 |    2 
>  drivers/net/benet/be_cmds.c                                |    2 
>  drivers/net/benet/be_main.c                                |    2 
>  drivers/net/bnx2x/bnx2x_hsi.h                              |    2 
>  drivers/net/bnx2x/bnx2x_link.c                             |   24 ++--
>  drivers/net/bnx2x/bnx2x_main.c                             |    2 
>  drivers/net/bnx2x/bnx2x_reg.h                              |    4 
>  drivers/net/bonding/bond_alb.h                             |    2 
>  drivers/net/bonding/bond_sysfs.c                           |    2 
>  drivers/net/caif/caif_spi.c                                |    2 
>  drivers/net/caif/caif_spi_slave.c                          |    4 
>  drivers/net/can/at91_can.c                                 |    4 
>  drivers/net/can/janz-ican3.c                               |    4 
>  drivers/net/can/mscan/mscan.c                              |    2 
>  drivers/net/can/sja1000/sja1000.c                          |    2 
>  drivers/net/can/ti_hecc.c                                  |    2 
>  drivers/net/can/usb/ems_usb.c                              |    2 
>  drivers/net/can/usb/esd_usb2.c                             |    2 
>  drivers/net/cassini.c                                      |    4 
>  drivers/net/cassini.h                                      |    2 
>  drivers/net/chelsio/pm3393.c                               |    2 
>  drivers/net/chelsio/sge.c                                  |    2 
>  drivers/net/chelsio/vsc7326.c                              |    2 
>  drivers/net/cris/eth_v10.c                                 |    2 
>  drivers/net/cxgb3/sge.c                                    |    2 
>  drivers/net/cxgb3/t3_hw.c                                  |    6 -
>  drivers/net/cxgb4/t4_hw.c                                  |    2 
>  drivers/net/cxgb4vf/cxgb4vf_main.c                         |    2 
>  drivers/net/cxgb4vf/sge.c                                  |    6 -
>  drivers/net/davinci_emac.c                                 |    8 -
>  drivers/net/e1000/e1000_ethtool.c                          |    2 
>  drivers/net/e1000e/ich8lan.c                               |    4 
>  drivers/net/e1000e/netdev.c                                |    2 
>  drivers/net/enic/vnic_resource.h                           |    2 
>  drivers/net/eth16i.c                                       |    2 
>  drivers/net/forcedeth.c                                    |   12 +-
>  drivers/net/gianfar.h                                      |    2 
>  drivers/net/hamradio/Makefile                              |    2 
>  drivers/net/hp100.c                                        |   14 +-
>  drivers/net/hp100.h                                        |    2 
>  drivers/net/ibm_newemac/tah.c                              |    2 
>  drivers/net/ibmlana.c                                      |    2 
>  drivers/net/ibmlana.h                                      |    2 
>  drivers/net/igb/e1000_82575.c                              |    2 
>  drivers/net/igb/e1000_mac.c                                |    2 
>  drivers/net/igb/e1000_phy.c                                |    2 
>  drivers/net/igb/igb_main.c                                 |   12 +-
>  drivers/net/igbvf/netdev.c                                 |    2 
>  drivers/net/ipg.c                                          |   28 ++---
>  drivers/net/irda/ali-ircc.c                                |    4 
>  drivers/net/irda/donauboe.c                                |    2 
>  drivers/net/irda/donauboe.h                                |    2 
>  drivers/net/irda/girbil-sir.c                              |    2 
>  drivers/net/irda/irda-usb.c                                |    4 
>  drivers/net/irda/mcs7780.c                                 |    6 -
>  drivers/net/irda/nsc-ircc.c                                |    2 
>  drivers/net/irda/pxaficp_ir.c                              |    2 
>  drivers/net/irda/sir_dev.c                                 |    4 
>  drivers/net/irda/smsc-ircc2.c                              |    2 
>  drivers/net/irda/tekram-sir.c                              |    2 
>  drivers/net/irda/toim3232-sir.c                            |    2 
>  drivers/net/irda/via-ircc.c                                |    4 
>  drivers/net/irda/vlsi_ir.h                                 |    4 
>  drivers/net/ixgbe/ixgbe_main.c                             |    6 -
>  drivers/net/ixgbe/ixgbe_phy.c                              |    2 
>  drivers/net/ixgbevf/ixgbevf_main.c                         |    2 
>  drivers/net/ks8842.c                                       |    2 
>  drivers/net/ks8851.c                                       |    6 -
>  drivers/net/ks8851_mll.c                                   |    4 
>  drivers/net/lib8390.c                                      |    4 
>  drivers/net/lp486e.c                                       |    2 
>  drivers/net/meth.h                                         |    2 
>  drivers/net/mlx4/en_main.c                                 |    2 
>  drivers/net/mlx4/en_netdev.c                               |    6 -
>  drivers/net/mlx4/en_rx.c                                   |    2 
>  drivers/net/mlx4/port.c                                    |    4 
>  drivers/net/myri10ge/myri10ge.c                            |    2 
>  drivers/net/myri_sbus.c                                    |    2 
>  drivers/net/natsemi.c                                      |    6 -
>  drivers/net/netxen/netxen_nic_hdr.h                        |    2 
>  drivers/net/ni52.c                                         |    4 
>  drivers/net/ni65.c                                         |    2 
>  drivers/net/ns83820.c                                      |    4 
>  drivers/net/pcmcia/axnet_cs.c                              |    4 
>  drivers/net/pcmcia/smc91c92_cs.c                           |    2 
>  drivers/net/pcnet32.c                                      |    2 
>  drivers/net/phy/phy_device.c                               |    2 
>  drivers/net/ppp_generic.c                                  |    2 
>  drivers/net/ppp_synctty.c                                  |    2 
>  drivers/net/pppoe.c                                        |    2 
>  drivers/net/ps3_gelic_net.c                                |    4 
>  drivers/net/ps3_gelic_net.h                                |    2 
>  drivers/net/ps3_gelic_wireless.c                           |    2 
>  drivers/net/pxa168_eth.c                                   |    2 
>  drivers/net/qla3xxx.h                                      |    2 
>  drivers/net/qlge/qlge_main.c                               |   10 -
>  drivers/net/r6040.c                                        |    2 
>  drivers/net/r8169.c                                        |    2 
>  drivers/net/s2io.c                                         |    6 -
>  drivers/net/s2io.h                                         |    2 
>  drivers/net/sfc/falcon.c                                   |    4 
>  drivers/net/sfc/falcon_xmac.c                              |    2 
>  drivers/net/sfc/mcdi.c                                     |    2 
>  drivers/net/sfc/mcdi_pcol.h                                |    6 -
>  drivers/net/sfc/mcdi_phy.c                                 |    2 
>  drivers/net/sfc/net_driver.h                               |    2 
>  drivers/net/sgiseeq.c                                      |    4 
>  drivers/net/sh_eth.c                                       |    2 
>  drivers/net/sis190.c                                       |    2 
>  drivers/net/sis900.c                                       |    6 -
>  drivers/net/skfp/ess.c                                     |    6 -
>  drivers/net/skfp/fplustm.c                                 |    6 -
>  drivers/net/skfp/h/cmtdef.h                                |    2 
>  drivers/net/skfp/h/fplustm.h                               |    4 
>  drivers/net/skfp/h/smc.h                                   |    4 
>  drivers/net/skfp/h/supern_2.h                              |    4 
>  drivers/net/skfp/hwmtm.c                                   |    2 
>  drivers/net/skfp/pcmplc.c                                  |    8 -
>  drivers/net/skfp/smt.c                                     |    2 
>  drivers/net/skge.h                                         |    2 
>  drivers/net/sky2.c                                         |    4 
>  drivers/net/smc91x.h                                       |    2 
>  drivers/net/smsc911x.c                                     |    2 
>  drivers/net/smsc9420.c                                     |    2 
>  drivers/net/stmmac/norm_desc.c                             |    2 
>  drivers/net/sun3_82586.c                                   |    4 
>  drivers/net/sunbmac.h                                      |    2 
>  drivers/net/sungem.c                                       |    2 
>  drivers/net/sunhme.h                                       |    2 
>  drivers/net/tc35815.c                                      |   32 +++---
>  drivers/net/tehuti.c                                       |   12 +-
>  drivers/net/tehuti.h                                       |    2 
>  drivers/net/tg3.c                                          |    2 
>  drivers/net/tg3.h                                          |    4 
>  drivers/net/tlan.c                                         |    2 
>  drivers/net/tokenring/3c359.c                              |    2 
>  drivers/net/tokenring/lanstreamer.c                        |    2 
>  drivers/net/tokenring/madgemc.c                            |    6 -
>  drivers/net/tokenring/smctr.c                              |    4 
>  drivers/net/tokenring/tms380tr.h                           |    2 
>  drivers/net/tsi108_eth.h                                   |    8 -
>  drivers/net/tulip/de4x5.c                                  |    2 
>  drivers/net/tulip/dmfe.c                                   |    2 
>  drivers/net/tulip/eeprom.c                                 |    2 
>  drivers/net/typhoon.c                                      |    2 
>  drivers/net/ucc_geth.h                                     |    4 
>  drivers/net/usb/cdc_eem.c                                  |    2 
>  drivers/net/usb/kaweth.c                                   |    2 
>  drivers/net/via-rhine.c                                    |    4 
>  drivers/net/via-velocity.c                                 |    4 
>  drivers/net/vmxnet3/vmxnet3_drv.c                          |    4 
>  drivers/net/vxge/vxge-main.c                               |    4 
>  drivers/net/vxge/vxge-traffic.c                            |    2 
>  drivers/net/vxge/vxge-traffic.h                            |    2 
>  drivers/net/wan/cycx_x25.c                                 |    8 -
>  drivers/net/wan/dscc4.c                                    |    8 -
>  drivers/net/wan/hostess_sv11.c                             |    2 
>  drivers/net/wan/ixp4xx_hss.c                               |    4 
>  drivers/net/wan/lapbether.c                                |    2 
>  drivers/net/wan/lmc/lmc_main.c                             |    2 
>  drivers/net/wan/sdla.c                                     |    2 
>  drivers/net/wan/z85230.c                                   |    6 -
>  drivers/net/wimax/i2400m/control.c                         |    4 
>  drivers/net/wimax/i2400m/driver.c                          |    4 
>  drivers/net/wimax/i2400m/fw.c                              |    4 
>  drivers/net/wimax/i2400m/i2400m-usb.h                      |    6 -
>  drivers/net/wimax/i2400m/i2400m.h                          |    8 -
>  drivers/net/wimax/i2400m/netdev.c                          |    2 
>  drivers/net/wimax/i2400m/op-rfkill.c                       |    4 
>  drivers/net/wimax/i2400m/rx.c                              |    4 
>  drivers/net/wimax/i2400m/sdio-fw.c                         |    2 
>  drivers/net/wimax/i2400m/tx.c                              |    4 
>  drivers/net/wimax/i2400m/usb-fw.c                          |    4 
>  drivers/net/wimax/i2400m/usb-rx.c                          |    2 
>  drivers/net/wimax/i2400m/usb-tx.c                          |    2 
>  drivers/net/wireless/airo.c                                |   14 +-
>  drivers/net/wireless/ath/ar9170/main.c                     |    2 
>  drivers/net/wireless/ath/ar9170/phy.c                      |    2 
>  drivers/net/wireless/ath/ath5k/ani.h                       |    2 
>  drivers/net/wireless/ath/ath5k/base.c                      |    2 
>  drivers/net/wireless/ath/ath5k/desc.c                      |    6 -
>  drivers/net/wireless/ath/ath5k/eeprom.c                    |    4 
>  drivers/net/wireless/ath/ath5k/eeprom.h                    |    2 
>  drivers/net/wireless/ath/ath5k/pcu.c                       |    2 
>  drivers/net/wireless/ath/ath5k/phy.c                       |   18 +--
>  drivers/net/wireless/ath/ath5k/reg.h                       |   12 +-
>  drivers/net/wireless/ath/ath5k/reset.c                     |   10 -
>  drivers/net/wireless/ath/ath9k/ar5008_phy.c                |    2 
>  drivers/net/wireless/ath/ath9k/ar9003_eeprom.c             |    2 
>  drivers/net/wireless/ath/ath9k/main.c                      |    2 
>  drivers/net/wireless/ath/ath9k/pci.c                       |    2 
>  drivers/net/wireless/ath/ath9k/rc.c                        |    2 
>  drivers/net/wireless/ath/ath9k/xmit.c                      |    4 
>  drivers/net/wireless/ath/hw.c                              |    2 
>  drivers/net/wireless/ath/regd.c                            |    4 
>  drivers/net/wireless/atmel.c                               |    4 
>  drivers/net/wireless/atmel_cs.c                            |    2 
>  drivers/net/wireless/b43/b43.h                             |    2 
>  drivers/net/wireless/b43/main.c                            |    2 
>  drivers/net/wireless/b43/phy_g.h                           |    2 
>  drivers/net/wireless/b43/phy_n.h                           |    2 
>  drivers/net/wireless/b43legacy/b43legacy.h                 |    2 
>  drivers/net/wireless/hostap/hostap_ap.c                    |    2 
>  drivers/net/wireless/hostap/hostap_ioctl.c                 |    4 
>  drivers/net/wireless/hostap/hostap_wlan.h                  |    2 
>  drivers/net/wireless/ipw2x00/ipw2100.c                     |    2 
>  drivers/net/wireless/ipw2x00/ipw2200.c                     |   18 +--
>  drivers/net/wireless/iwlwifi/iwl-agn-ict.c                 |    2 
>  drivers/net/wireless/iwlwifi/iwl-core.c                    |    2 
>  drivers/net/wireless/iwlwifi/iwl-fh.h                      |    2 
>  drivers/net/wireless/iwlwifi/iwl-sta.c                     |    2 
>  drivers/net/wireless/iwmc3200wifi/hal.c                    |    4 
>  drivers/net/wireless/iwmc3200wifi/tx.c                     |    2 
>  drivers/net/wireless/libertas/README                       |    4 
>  drivers/net/wireless/libertas/if_cs.c                      |    2 
>  drivers/net/wireless/libertas/if_spi.h                     |    2 
>  drivers/net/wireless/mac80211_hwsim.c                      |    2 
>  drivers/net/wireless/orinoco/hw.c                          |    2 
>  drivers/net/wireless/p54/main.c                            |    2 
>  drivers/net/wireless/p54/p54spi.c                          |    2 
>  drivers/net/wireless/prism54/islpci_dev.c                  |    4 
>  drivers/net/wireless/prism54/islpci_eth.c                  |    6 -
>  drivers/net/wireless/rt2x00/rt2800.h                       |    2 
>  drivers/net/wireless/rt2x00/rt2x00.h                       |    6 -
>  drivers/net/wireless/rt2x00/rt2x00config.c                 |    2 
>  drivers/net/wireless/rt2x00/rt2x00crypto.c                 |    2 
>  drivers/net/wireless/rt2x00/rt2x00dump.h                   |    2 
>  drivers/net/wireless/rt2x00/rt2x00link.c                   |    2 
>  drivers/net/wireless/rt2x00/rt2x00queue.c                  |    2 
>  drivers/net/wireless/rt2x00/rt2x00queue.h                  |    4 
>  drivers/net/wireless/rt2x00/rt2x00usb.c                    |    4 
>  drivers/net/wireless/rt2x00/rt2x00usb.h                    |    2 
>  drivers/net/wireless/wl12xx/wl1251_cmd.c                   |    2 
>  drivers/net/wireless/wl12xx/wl1251_rx.c                    |    2 
>  drivers/net/wireless/wl12xx/wl1271_cmd.c                   |    2 
>  drivers/net/wireless/wl12xx/wl1271_conf.h                  |    4 
>  drivers/net/wireless/wl12xx/wl1271_io.h                    |    2 
>  drivers/net/wireless/zd1211rw/zd_rf_rf2959.c               |    2 
>  drivers/net/wireless/zd1211rw/zd_rf_uw2453.c               |    2 
>  drivers/net/xilinx_emaclite.c                              |    2 
>  drivers/net/znet.c                                         |    2 
>  drivers/of/of_mdio.c                                       |    2 
>  drivers/parisc/pdc_stable.c                                |    4 
>  drivers/parport/Kconfig                                    |    2 
>  drivers/parport/ieee1284.c                                 |    2 
>  drivers/parport/parport_pc.c                               |    6 -
>  drivers/pci/hotplug/acpi_pcihp.c                           |    2 
>  drivers/pci/hotplug/acpiphp_glue.c                         |    2 
>  drivers/pci/hotplug/rpaphp_core.c                          |    2 
>  drivers/pci/intel-iommu.c                                  |    2 
>  drivers/pci/iova.c                                         |    2 
>  drivers/pci/pci-sysfs.c                                    |    2 
>  drivers/pci/quirks.c                                       |    4 
>  drivers/pcmcia/i82092.c                                    |    2 
>  drivers/pcmcia/pcmcia_resource.c                           |    4 
>  drivers/pcmcia/pxa2xx_lubbock.c                            |    2 
>  drivers/pcmcia/ti113x.h                                    |    2 
>  drivers/platform/x86/asus-laptop.c                         |    2 
>  drivers/platform/x86/eeepc-laptop.c                        |    2 
>  drivers/platform/x86/intel_scu_ipc.c                       |    2 
>  drivers/platform/x86/sony-laptop.c                         |    2 
>  drivers/platform/x86/thinkpad_acpi.c                       |    4 
>  drivers/pnp/card.c                                         |    4 
>  drivers/pnp/pnpbios/bioscalls.c                            |    2 
>  drivers/ps3/ps3-lpm.c                                      |    4 
>  drivers/ps3/ps3-sys-manager.c                              |    2 
>  drivers/rapidio/rio-scan.c                                 |    2 
>  drivers/regulator/core.c                                   |    2 
>  drivers/rtc/rtc-at91rm9200.c                               |    2 
>  drivers/rtc/rtc-bfin.c                                     |    4 
>  drivers/rtc/rtc-x1205.c                                    |    2 
>  drivers/s390/block/dasd_3990_erp.c                         |    6 -
>  drivers/s390/block/dasd_devmap.c                           |    2 
>  drivers/s390/block/dasd_eckd.c                             |   52 +++++-----
>  drivers/s390/char/raw3270.c                                |    2 
>  drivers/s390/char/tape_3590.c                              |    4 
>  drivers/s390/char/tape_char.c                              |    2 
>  drivers/s390/char/tty3270.c                                |    2 
>  drivers/s390/cio/device_fsm.c                              |    4 
>  drivers/s390/crypto/zcrypt_api.h                           |    2 
>  drivers/s390/net/ctcm_fsms.c                               |    2 
>  drivers/s390/net/lcs.c                                     |    2 
>  drivers/s390/net/qeth_core_main.c                          |    2 
>  drivers/s390/net/qeth_core_mpc.h                           |    4 
>  drivers/s390/scsi/zfcp_qdio.c                              |    2 
>  drivers/sbus/char/jsflash.c                                |    2 
>  drivers/sbus/char/max1617.h                                |    2 
>  drivers/scsi/3w-9xxx.h                                     |    2 
>  drivers/scsi/3w-xxxx.h                                     |    4 
>  drivers/scsi/53c700.scr                                    |    2 
>  drivers/scsi/53c700_d.h_shipped                            |    2 
>  drivers/scsi/FlashPoint.c                                  |    4 
>  drivers/scsi/NCR5380.c                                     |    8 -
>  drivers/scsi/aacraid/aachba.c                              |    4 
>  drivers/scsi/aacraid/aacraid.h                             |    2 
>  drivers/scsi/aacraid/commsup.c                             |    2 
>  drivers/scsi/advansys.c                                    |    2 
>  drivers/scsi/aic7xxx/aic79xx.h                             |    4 
>  drivers/scsi/aic7xxx/aic79xx.reg                           |    4 
>  drivers/scsi/aic7xxx/aic79xx.seq                           |   18 +--
>  drivers/scsi/aic7xxx/aic79xx_core.c                        |   34 +++---
>  drivers/scsi/aic7xxx/aic79xx_osm.c                         |    2 
>  drivers/scsi/aic7xxx/aic7xxx.h                             |    4 
>  drivers/scsi/aic7xxx/aic7xxx.seq                           |   10 -
>  drivers/scsi/aic7xxx/aic7xxx_core.c                        |   30 ++---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c                         |    4 
>  drivers/scsi/aic7xxx/aic7xxx_pci.c                         |    4 
>  drivers/scsi/aic7xxx/aicasm/aicasm_gram.y                  |    8 -
>  drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y            |    2 
>  drivers/scsi/aic7xxx_old.c                                 |   10 -
>  drivers/scsi/aic7xxx_old/aic7xxx.seq                       |    8 -
>  drivers/scsi/aic94xx/aic94xx_reg_def.h                     |    2 
>  drivers/scsi/arm/acornscsi.c                               |    4 
>  drivers/scsi/arm/acornscsi.h                               |    6 -
>  drivers/scsi/arm/arxescsi.c                                |    2 
>  drivers/scsi/arm/cumana_2.c                                |    2 
>  drivers/scsi/arm/eesox.c                                   |    2 
>  drivers/scsi/arm/fas216.c                                  |    4 
>  drivers/scsi/arm/fas216.h                                  |    2 
>  drivers/scsi/arm/powertec.c                                |    2 
>  drivers/scsi/atari_NCR5380.c                               |   14 +-
>  drivers/scsi/atp870u.c                                     |    2 
>  drivers/scsi/be2iscsi/be_cmds.h                            |   18 +--
>  drivers/scsi/bfa/bfa_fcxp_priv.h                           |    2 
>  drivers/scsi/bfa/bfa_intr.c                                |    2 
>  drivers/scsi/bfa/bfa_uf.c                                  |    2 
>  drivers/scsi/bfa/bfad_intr.c                               |    2 
>  drivers/scsi/bfa/fabric.c                                  |    2 
>  drivers/scsi/bfa/fdmi.c                                    |    2 
>  drivers/scsi/bfa/include/cs/bfa_log.h                      |    2 
>  drivers/scsi/bfa/include/defs/bfa_defs_iocfc.h             |    2 
>  drivers/scsi/bfa/include/fcb/bfa_fcb_port.h                |    2 
>  drivers/scsi/bfa/include/protocol/fc.h                     |    2 
>  drivers/scsi/bfa/include/protocol/scsi.h                   |    4 
>  drivers/scsi/bnx2i/bnx2i_hwi.c                             |    2 
>  drivers/scsi/dc395x.c                                      |   12 +-
>  drivers/scsi/device_handler/scsi_dh_alua.c                 |    4 
>  drivers/scsi/eata.c                                        |    2 
>  drivers/scsi/fcoe/fcoe.c                                   |    2 
>  drivers/scsi/fcoe/libfcoe.c                                |    4 
>  drivers/scsi/fdomain.c                                     |    2 
>  drivers/scsi/fnic/fnic_fcs.c                               |    2 
>  drivers/scsi/fnic/fnic_scsi.c                              |    4 
>  drivers/scsi/fnic/vnic_resource.h                          |    2 
>  drivers/scsi/g_NCR5380.c                                   |    4 
>  drivers/scsi/gdth.h                                        |    4 
>  drivers/scsi/gvp11.c                                       |    2 
>  drivers/scsi/imm.c                                         |    2 
>  drivers/scsi/initio.c                                      |    4 
>  drivers/scsi/ips.c                                         |    2 
>  drivers/scsi/iscsi_tcp.c                                   |    2 
>  drivers/scsi/libfc/fc_exch.c                               |    4 
>  drivers/scsi/libfc/fc_fcp.c                                |    4 
>  drivers/scsi/libfc/fc_lport.c                              |   16 +--
>  drivers/scsi/libsas/sas_expander.c                         |    2 
>  drivers/scsi/lpfc/lpfc_attr.c                              |    2 
>  drivers/scsi/lpfc/lpfc_bsg.c                               |    2 
>  drivers/scsi/lpfc/lpfc_debugfs.c                           |    4 
>  drivers/scsi/lpfc/lpfc_disc.h                              |    4 
>  drivers/scsi/lpfc/lpfc_els.c                               |   18 +--
>  drivers/scsi/lpfc/lpfc_hbadisc.c                           |   22 ++--
>  drivers/scsi/lpfc/lpfc_init.c                              |   20 +--
>  drivers/scsi/lpfc/lpfc_mbox.c                              |    2 
>  drivers/scsi/lpfc/lpfc_nl.h                                |    2 
>  drivers/scsi/lpfc/lpfc_nportdisc.c                         |    6 -
>  drivers/scsi/lpfc/lpfc_scsi.c                              |   10 -
>  drivers/scsi/lpfc/lpfc_scsi.h                              |    2 
>  drivers/scsi/lpfc/lpfc_sli.c                               |   26 ++---
>  drivers/scsi/megaraid.c                                    |    4 
>  drivers/scsi/megaraid.h                                    |    8 -
>  drivers/scsi/megaraid/mbox_defs.h                          |   10 -
>  drivers/scsi/megaraid/megaraid_mbox.c                      |    6 -
>  drivers/scsi/megaraid/megaraid_mm.c                        |    2 
>  drivers/scsi/megaraid/megaraid_sas.c                       |    2 
>  drivers/scsi/mpt2sas/mpi/mpi2_history.txt                  |    2 
>  drivers/scsi/mpt2sas/mpi/mpi2_init.h                       |    2 
>  drivers/scsi/mpt2sas/mpt2sas_base.c                        |   14 +-
>  drivers/scsi/mpt2sas/mpt2sas_config.c                      |    2 
>  drivers/scsi/mpt2sas/mpt2sas_ctl.c                         |    2 
>  drivers/scsi/mpt2sas/mpt2sas_scsih.c                       |   20 +--
>  drivers/scsi/mpt2sas/mpt2sas_transport.c                   |    2 
>  drivers/scsi/nsp32.c                                       |    6 -
>  drivers/scsi/nsp32.h                                       |    2 
>  drivers/scsi/osst.c                                        |    2 
>  drivers/scsi/osst.h                                        |    2 
>  drivers/scsi/pcmcia/nsp_cs.c                               |    4 
>  drivers/scsi/pm8001/pm8001_hwi.c                           |    2 
>  drivers/scsi/pm8001/pm8001_hwi.h                           |    4 
>  drivers/scsi/pm8001/pm8001_sas.h                           |    2 
>  drivers/scsi/pmcraid.c                                     |   10 -
>  drivers/scsi/pmcraid.h                                     |    2 
>  drivers/scsi/qla1280.c                                     |    6 -
>  drivers/scsi/qla2xxx/qla_def.h                             |    2 
>  drivers/scsi/qla2xxx/qla_fw.h                              |    2 
>  drivers/scsi/qla2xxx/qla_mbx.c                             |    6 -
>  drivers/scsi/qla2xxx/qla_nx.c                              |    2 
>  drivers/scsi/qla2xxx/qla_os.c                              |    6 -
>  drivers/scsi/qla4xxx/ql4_def.h                             |    2 
>  drivers/scsi/qla4xxx/ql4_init.c                            |    2 
>  drivers/scsi/qla4xxx/ql4_nx.c                              |    2 
>  drivers/scsi/qla4xxx/ql4_os.c                              |    2 
>  drivers/scsi/scsi_debug.c                                  |    2 
>  drivers/scsi/scsi_netlink.c                                |    2 
>  drivers/scsi/scsi_tgt_lib.c                                |    2 
>  drivers/scsi/scsi_transport_fc.c                           |    4 
>  drivers/scsi/sd.c                                          |    2 
>  drivers/scsi/sr.c                                          |    2 
>  drivers/scsi/sun3_NCR5380.c                                |   14 +-
>  drivers/scsi/sym53c416.c                                   |    2 
>  drivers/scsi/sym53c8xx_2/sym_fw1.h                         |    2 
>  drivers/scsi/sym53c8xx_2/sym_fw2.h                         |    2 
>  drivers/scsi/sym53c8xx_2/sym_hipd.c                        |    4 
>  drivers/scsi/sym53c8xx_2/sym_malloc.c                      |    2 
>  drivers/scsi/wd33c93.c                                     |    2 
>  drivers/scsi/wd7000.c                                      |    2 
>  drivers/serial/8250.c                                      |    2 
>  drivers/serial/8250_pci.c                                  |    2 
>  drivers/serial/imx.c                                       |    2 
>  drivers/serial/ioc4_serial.c                               |    6 -
>  drivers/serial/ip22zilog.c                                 |    2 
>  drivers/serial/jsm/jsm_neo.c                               |    4 
>  drivers/serial/max3107.h                                   |    2 
>  drivers/serial/mfd.c                                       |    2 
>  drivers/serial/mrst_max3110.c                              |    2 
>  drivers/serial/mrst_max3110.h                              |    2 
>  drivers/serial/pmac_zilog.c                                |    6 -
>  drivers/serial/samsung.c                                   |    4 
>  drivers/serial/sh-sci.c                                    |    2 
>  drivers/serial/sn_console.c                                |    6 -
>  drivers/serial/sunzilog.c                                  |    2 
>  drivers/sfi/sfi_core.c                                     |    2 
>  drivers/spi/amba-pl022.c                                   |   14 +-
>  drivers/spi/au1550_spi.c                                   |    2 
>  drivers/spi/dw_spi.c                                       |    2 
>  drivers/spi/ep93xx_spi.c                                   |    2 
>  drivers/spi/pxa2xx_spi.c                                   |    2 
>  drivers/spi/spi.c                                          |    2 
>  drivers/spi/spi_bfin5xx.c                                  |    2 
>  drivers/ssb/pci.c                                          |    2 
>  drivers/ssb/sprom.c                                        |    2 
>  drivers/staging/batman-adv/soft-interface.c                |    2 
>  drivers/staging/comedi/comedi_fops.c                       |    2 
>  drivers/staging/comedi/drivers/addi-data/APCI1710_Chrono.c |    8 -
>  drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c    |    8 -
>  drivers/staging/comedi/drivers/addi-data/hwdrv_apci2032.c  |    2 
>  drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c  |   18 +--
>  drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.h  |    2 
>  drivers/staging/comedi/drivers/adl_pci9118.c               |    8 -
>  drivers/staging/comedi/drivers/adq12b.c                    |    4 
>  drivers/staging/comedi/drivers/adv_pci1710.c               |    8 -
>  drivers/staging/comedi/drivers/cb_pcidas.c                 |    6 -
>  drivers/staging/comedi/drivers/cb_pcidas64.c               |   14 +-
>  drivers/staging/comedi/drivers/comedi_test.c               |    2 
>  drivers/staging/comedi/drivers/das1800.c                   |    2 
>  drivers/staging/comedi/drivers/das800.c                    |    2 
>  drivers/staging/comedi/drivers/dmm32at.c                   |    2 
>  drivers/staging/comedi/drivers/dt2811.c                    |    2 
>  drivers/staging/comedi/drivers/dt9812.c                    |    2 
>  drivers/staging/comedi/drivers/gsc_hpdi.c                  |    4 
>  drivers/staging/comedi/drivers/icp_multi.c                 |    6 -
>  drivers/staging/comedi/drivers/me4000.c                    |    4 
>  drivers/staging/comedi/drivers/mpc624.c                    |    8 -
>  drivers/staging/comedi/drivers/ni_at_a2150.c               |   12 +-
>  drivers/staging/comedi/drivers/ni_labpc.c                  |   14 +-
>  drivers/staging/comedi/drivers/ni_pcidio.c                 |    2 
>  drivers/staging/comedi/drivers/pcl812.c                    |    2 
>  drivers/staging/comedi/drivers/pcl816.c                    |    6 -
>  drivers/staging/comedi/drivers/pcl818.c                    |    6 -
>  drivers/staging/comedi/drivers/pcmmio.c                    |    4 
>  drivers/staging/comedi/drivers/pcmuio.c                    |    2 
>  drivers/staging/comedi/drivers/quatech_daqp_cs.c           |    4 
>  drivers/staging/comedi/drivers/rtd520.c                    |   10 -
>  drivers/staging/comedi/drivers/s626.c                      |   18 +--
>  drivers/staging/comedi/drivers/usbdux.c                    |   22 ++--
>  drivers/staging/comedi/drivers/usbduxfast.c                |    8 -
>  drivers/staging/crystalhd/crystalhd_cmds.c                 |    2 
>  drivers/staging/crystalhd/crystalhd_hw.c                   |    4 
>  drivers/staging/cxt1e1/functions.c                         |    2 
>  drivers/staging/cxt1e1/hwprobe.c                           |    2 
>  drivers/staging/cxt1e1/libsbew.h                           |    2 
>  drivers/staging/cxt1e1/musycc.c                            |    6 -
>  drivers/staging/cxt1e1/musycc.h                            |    4 
>  drivers/staging/cxt1e1/pmcc4.h                             |    4 
>  drivers/staging/cxt1e1/pmcc4_defs.h                        |    4 
>  drivers/staging/cxt1e1/pmcc4_drv.c                         |    4 
>  drivers/staging/cxt1e1/sbecrc.c                            |    2 
>  drivers/staging/cxt1e1/sbeid.c                             |    2 
>  drivers/staging/cxt1e1/sbeproc.c                           |    2 
>  drivers/staging/dream/include/linux/wakelock.h             |    2 
>  drivers/staging/dream/include/mach/msm_rpcrouter.h         |    2 
>  drivers/staging/dream/pmem.c                               |    8 -
>  drivers/staging/dream/qdsp5/adsp.c                         |    2 
>  drivers/staging/dream/qdsp5/audio_in.c                     |    2 
>  drivers/staging/et131x/et1310_address_map.h                |    4 
>  drivers/staging/et131x/et1310_phy.h                        |    2 
>  drivers/staging/et131x/et1310_rx.c                         |    2 
>  drivers/staging/et131x/et131x_isr.c                        |    2 
>  drivers/staging/et131x/et131x_netdev.c                     |    2 
>  drivers/staging/frontier/alphatrack.c                      |    4 
>  drivers/staging/frontier/tranzport.c                       |    4 
>  drivers/staging/go7007/go7007.txt                          |    2 
>  drivers/staging/hv/blkvsc_drv.c                            |    2 
>  drivers/staging/hv/channel_mgmt.c                          |    2 
>  drivers/staging/hv/connection.c                            |    2 
>  drivers/staging/hv/hv.c                                    |    2 
>  drivers/staging/hv/hv_api.h                                |    4 
>  drivers/staging/hv/hv_utils.c                              |    2 
>  drivers/staging/hv/osd.c                                   |    2 
>  drivers/staging/hv/rndis_filter.c                          |    2 
>  drivers/staging/iio/Documentation/iio_utils.h              |    2 
>  drivers/staging/iio/Documentation/lis3l02dqbuffersimple.c  |    2 
>  drivers/staging/iio/Documentation/sysfs-class-iio          |    4 
>  drivers/staging/iio/Documentation/userspace.txt            |    2 
>  drivers/staging/iio/accel/accel.h                          |    6 -
>  drivers/staging/iio/accel/adis16209.h                      |    2 
>  drivers/staging/iio/accel/adis16220.h                      |    2 
>  drivers/staging/iio/accel/adis16240.h                      |    2 
>  drivers/staging/iio/accel/lis3l02dq.h                      |    8 -
>  drivers/staging/iio/accel/lis3l02dq_core.c                 |    2 
>  drivers/staging/iio/accel/lis3l02dq_ring.c                 |    4 
>  drivers/staging/iio/accel/sca3000.h                        |    4 
>  drivers/staging/iio/accel/sca3000_ring.c                   |    2 
>  drivers/staging/iio/adc/max1363_core.c                     |    2 
>  drivers/staging/iio/adc/max1363_ring.c                     |    2 
>  drivers/staging/iio/chrdev.h                               |    6 -
>  drivers/staging/iio/gyro/adis16260.h                       |    2 
>  drivers/staging/iio/iio.h                                  |    2 
>  drivers/staging/iio/imu/adis16300.h                        |    2 
>  drivers/staging/iio/imu/adis16350.h                        |    2 
>  drivers/staging/iio/imu/adis16400.h                        |    2 
>  drivers/staging/iio/industrialio-core.c                    |    2 
>  drivers/staging/iio/ring_generic.h                         |    2 
>  drivers/staging/lirc/lirc_ene0100.h                        |    4 
>  drivers/staging/memrar/memrar_handler.c                    |    2 
>  drivers/staging/mrst-touchscreen/intel-mid-touch.c         |    2 
>  drivers/staging/msm/mdp4_overlay.c                         |    2 
>  drivers/staging/msm/mdp_ppp_dq.c                           |    2 
>  drivers/staging/msm/msm_fb.c                               |    6 -
>  drivers/staging/octeon/cvmx-cmd-queue.h                    |    2 
>  drivers/staging/octeon/cvmx-fpa.c                          |    2 
>  drivers/staging/octeon/cvmx-fpa.h                          |    4 
>  drivers/staging/octeon/cvmx-helper-board.h                 |    2 
>  drivers/staging/octeon/cvmx-helper-util.c                  |    2 
>  drivers/staging/octeon/cvmx-helper.c                       |    2 
>  drivers/staging/octeon/cvmx-mdio.h                         |    2 
>  drivers/staging/octeon/cvmx-pko.h                          |    4 
>  drivers/staging/octeon/cvmx-pow.h                          |   12 +-
>  drivers/staging/octeon/ethernet-util.h                     |    2 
>  drivers/staging/otus/80211core/ccmd.c                      |    2 
>  drivers/staging/otus/80211core/cmmsta.c                    |    2 
>  drivers/staging/otus/80211core/cpsmgr.c                    |    2 
>  drivers/staging/otus/hal/hpmain.c                          |    2 
>  drivers/staging/otus/usbdrv.c                              |    2 
>  drivers/staging/otus/zdusb.c                               |    2 
>  drivers/staging/pohmelfs/crypto.c                          |    2 
>  drivers/staging/quatech_usb2/quatech_usb2.c                |   10 -
>  drivers/staging/rt2860/chip/rtmp_phy.h                     |    2 
>  drivers/staging/rt2860/common/ba_action.c                  |    4 
>  drivers/staging/rt2860/common/cmm_aes.c                    |    2 
>  drivers/staging/rt2860/common/cmm_data.c                   |    2 
>  drivers/staging/rt2860/common/cmm_data_pci.c               |    6 -
>  drivers/staging/rt2860/common/cmm_data_usb.c               |    6 -
>  drivers/staging/rt2860/common/cmm_mac_pci.c                |    2 
>  drivers/staging/rt2860/common/cmm_sanity.c                 |    6 -
>  drivers/staging/rt2860/common/cmm_sync.c                   |    2 
>  drivers/staging/rt2860/common/cmm_wpa.c                    |    4 
>  drivers/staging/rt2860/common/mlme.c                       |   16 +--
>  drivers/staging/rt2860/common/rtmp_init.c                  |    4 
>  drivers/staging/rt2860/common/spectrum.c                   |    8 -
>  drivers/staging/rt2860/mlme.h                              |   10 -
>  drivers/staging/rt2860/rt_linux.c                          |    2 
>  drivers/staging/rt2860/rt_usb.c                            |    2 
>  drivers/staging/rt2860/rtmp.h                              |    6 -
>  drivers/staging/rt2860/sta/rtmp_data.c                     |    4 
>  drivers/staging/rt2860/sta_ioctl.c                         |    2 
>  drivers/staging/rt2860/usb_main_dev.c                      |    2 
>  drivers/staging/rt2870/common/rtusb_bulk.c                 |    6 -
>  drivers/staging/rt2870/common/rtusb_data.c                 |    2 
>  drivers/staging/rtl8187se/ieee80211/ieee80211.h            |    6 -
>  drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c    |    2 
>  drivers/staging/rtl8187se/r8180_core.c                     |    4 
>  drivers/staging/rtl8187se/r8180_dm.c                       |    4 
>  drivers/staging/rtl8187se/r8180_rtl8225z2.c                |    2 
>  drivers/staging/rtl8187se/r8185b_init.c                    |    2 
>  drivers/staging/rtl8192e/ieee80211.h                       |    8 -
>  drivers/staging/rtl8192e/ieee80211/ieee80211.h             |    8 -
>  drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c     |    4 
>  drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c        |    8 -
>  drivers/staging/rtl8192e/r8192E_core.c                     |    4 
>  drivers/staging/rtl8192e/r819xE_phy.c                      |    8 -
>  drivers/staging/rtl8192su/ieee80211/ieee80211.h            |    8 -
>  drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c    |    8 -
>  drivers/staging/rtl8192su/ieee80211/readme                 |    8 -
>  drivers/staging/rtl8192su/ieee80211/rtl819x_HTProc.c       |    8 -
>  drivers/staging/rtl8192su/r8192S_hw.h                      |    2 
>  drivers/staging/rtl8192su/r8192S_phy.c                     |    8 -
>  drivers/staging/rtl8192su/r8192U.h                         |    2 
>  drivers/staging/rtl8192su/r8192U_core.c                    |    8 -
>  drivers/staging/rtl8192u/ieee80211/ieee80211.h             |    8 -
>  drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c     |    4 
>  drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c        |    8 -
>  drivers/staging/rtl8192u/ieee80211/scatterwalk.c           |    2 
>  drivers/staging/rtl8192u/r8192U_core.c                     |    6 -
>  drivers/staging/rtl8192u/r819xU_phy.c                      |    6 -
>  drivers/staging/slicoss/README                             |    2 
>  drivers/staging/sm7xx/smtcfb.c                             |    4 
>  drivers/staging/spectra/ffsport.c                          |    4 
>  drivers/staging/spectra/flash.c                            |    6 -
>  drivers/staging/spectra/flash.h                            |    2 
>  drivers/staging/tidspbridge/core/_tiomap.h                 |    2 
>  drivers/staging/tidspbridge/core/chnl_sm.c                 |    2 
>  drivers/staging/tidspbridge/core/ue_deh.c                  |    2 
>  drivers/staging/tidspbridge/dynload/cload.c                |    2 
>  drivers/staging/tidspbridge/hw/hw_mmu.c                    |    6 -
>  drivers/staging/tidspbridge/include/dspbridge/_chnl_sm.h   |    4 
>  drivers/staging/tidspbridge/include/dspbridge/cfg.h        |    4 
>  drivers/staging/tidspbridge/include/dspbridge/clk.h        |    6 -
>  drivers/staging/tidspbridge/include/dspbridge/cmm.h        |    2 
>  drivers/staging/tidspbridge/include/dspbridge/cod.h        |    2 
>  drivers/staging/tidspbridge/include/dspbridge/dev.h        |    2 
>  drivers/staging/tidspbridge/include/dspbridge/drv.h        |    4 
>  drivers/staging/tidspbridge/include/dspbridge/dspdefs.h    |   14 +-
>  drivers/staging/tidspbridge/include/dspbridge/mbx_sh.h     |   12 +-
>  drivers/staging/tidspbridge/include/dspbridge/mgr.h        |    2 
>  drivers/staging/tidspbridge/include/dspbridge/node.h       |    2 
>  drivers/staging/tidspbridge/include/dspbridge/proc.h       |    4 
>  drivers/staging/tidspbridge/include/dspbridge/pwr.h        |    8 -
>  drivers/staging/tidspbridge/pmgr/dev.c                     |    4 
>  drivers/staging/tidspbridge/rmgr/drv.c                     |    2 
>  drivers/staging/tidspbridge/rmgr/nldr.c                    |    6 -
>  drivers/staging/usbip/vhci_hcd.c                           |    2 
>  drivers/staging/vme/bridges/vme_ca91cx42.c                 |    6 -
>  drivers/staging/vme/bridges/vme_tsi148.c                   |    4 
>  drivers/staging/vme/bridges/vme_tsi148.h                   |    6 -
>  drivers/staging/vme/vme_api.txt                            |    6 -
>  drivers/staging/vt6655/card.c                              |    2 
>  drivers/staging/vt6655/device_main.c                       |    2 
>  drivers/staging/vt6655/rxtx.c                              |    2 
>  drivers/staging/vt6655/wcmd.c                              |    2 
>  drivers/staging/vt6656/rxtx.c                              |    4 
>  drivers/staging/vt6656/wcmd.c                              |    4 
>  drivers/staging/winbond/mds.c                              |    2 
>  drivers/staging/wlags49_h2/README.wlags49                  |    4 
>  drivers/staging/wlags49_h2/TODO                            |    4 
>  drivers/staging/wlags49_h2/hcf.c                           |   22 ++--
>  drivers/staging/wlags49_h2/hcfdef.h                        |    2 
>  drivers/staging/wlags49_h2/mdd.h                           |    2 
>  drivers/staging/wlags49_h2/wl_if.h                         |    2 
>  drivers/staging/wlags49_h2/wl_main.c                       |    2 
>  drivers/staging/wlags49_h2/wl_netdev.c                     |    2 
>  drivers/staging/wlags49_h2/wl_pci.c                        |    4 
>  drivers/staging/wlags49_h2/wl_profile.c                    |    2 
>  drivers/staging/wlags49_h2/wl_version.h                    |    2 
>  drivers/staging/wlags49_h2/wl_wext.c                       |    2 
>  drivers/staging/wlags49_h25/TODO                           |    4 
>  drivers/staging/wlan-ng/prism2sta.c                        |    2 
>  drivers/staging/xgifb/vb_setmode.c                         |    2 
>  drivers/telephony/ixj.c                                    |    4 
>  drivers/telephony/ixj.h                                    |    2 
>  drivers/usb/atm/ueagle-atm.c                               |    8 -
>  drivers/usb/c67x00/c67x00-drv.c                            |    2 
>  drivers/usb/c67x00/c67x00-hcd.h                            |    2 
>  drivers/usb/c67x00/c67x00-sched.c                          |    2 
>  drivers/usb/class/cdc-acm.h                                |    2 
>  drivers/usb/class/usbtmc.c                                 |    2 
>  drivers/usb/core/hcd.c                                     |    2 
>  drivers/usb/core/hub.c                                     |    2 
>  drivers/usb/early/ehci-dbgp.c                              |    2 
>  drivers/usb/gadget/amd5536udc.c                            |   14 +-
>  drivers/usb/gadget/amd5536udc.h                            |    2 
>  drivers/usb/gadget/at91_udc.c                              |    2 
>  drivers/usb/gadget/composite.c                             |    6 -
>  drivers/usb/gadget/f_audio.c                               |    2 
>  drivers/usb/gadget/fsl_qe_udc.h                            |    6 -
>  drivers/usb/gadget/fsl_udc_core.c                          |    4 
>  drivers/usb/gadget/gmidi.c                                 |    2 
>  drivers/usb/gadget/lh7a40x_udc.c                           |    2 
>  drivers/usb/gadget/net2280.c                               |    2 
>  drivers/usb/gadget/nokia.c                                 |    2 
>  drivers/usb/gadget/printer.c                               |    2 
>  drivers/usb/gadget/pxa27x_udc.c                            |   12 +-
>  drivers/usb/gadget/s3c-hsotg.c                             |   16 +--
>  drivers/usb/host/ehci.h                                    |    2 
>  drivers/usb/host/fhci-hcd.c                                |    2 
>  drivers/usb/host/fhci-tds.c                                |    8 -
>  drivers/usb/host/fhci.h                                    |    4 
>  drivers/usb/host/imx21-hcd.c                               |    2 
>  drivers/usb/host/isp116x.h                                 |    2 
>  drivers/usb/host/isp1362.h                                 |    2 
>  drivers/usb/host/isp1760-hcd.c                             |    2 
>  drivers/usb/host/ohci-hcd.c                                |    2 
>  drivers/usb/host/oxu210hp-hcd.c                            |    4 
>  drivers/usb/host/whci/qset.c                               |    2 
>  drivers/usb/host/xhci.c                                    |    2 
>  drivers/usb/host/xhci.h                                    |    2 
>  drivers/usb/image/microtek.c                               |    8 -
>  drivers/usb/misc/ftdi-elan.c                               |   28 ++---
>  drivers/usb/misc/iowarrior.c                               |    2 
>  drivers/usb/otg/isp1301_omap.c                             |    2 
>  drivers/usb/serial/aircable.c                              |    4 
>  drivers/usb/serial/cp210x.c                                |    2 
>  drivers/usb/serial/cypress_m8.c                            |    2 
>  drivers/usb/serial/ftdi_sio.c                              |    2 
>  drivers/usb/serial/io_edgeport.h                           |    2 
>  drivers/usb/serial/io_ti.c                                 |    2 
>  drivers/usb/storage/isd200.c                               |    2 
>  drivers/usb/storage/scsiglue.c                             |    2 
>  drivers/usb/storage/shuttle_usbat.c                        |    2 
>  drivers/usb/wusbcore/crypto.c                              |    4 
>  drivers/usb/wusbcore/reservation.c                         |    2 
>  drivers/usb/wusbcore/rh.c                                  |    2 
>  drivers/usb/wusbcore/wa-xfer.c                             |    6 -
>  drivers/usb/wusbcore/wusbhc.h                              |    2 
>  drivers/uwb/driver.c                                       |    2 
>  drivers/uwb/drp.c                                          |    6 -
>  drivers/uwb/i1480/i1480u-wlp/netdev.c                      |    2 
>  drivers/uwb/i1480/i1480u-wlp/sysfs.c                       |    2 
>  drivers/uwb/lc-rc.c                                        |    2 
>  drivers/uwb/reset.c                                        |    2 
>  drivers/uwb/umc-dev.c                                      |    2 
>  drivers/uwb/wlp/messages.c                                 |    6 -
>  drivers/uwb/wlp/txrx.c                                     |    2 
>  drivers/uwb/wlp/wlp-lc.c                                   |    2 
>  drivers/uwb/wlp/wss-lc.c                                   |    2 
>  drivers/video/atmel_lcdfb.c                                |    2 
>  drivers/video/aty/mach64_cursor.c                          |    2 
>  drivers/video/aty/radeon_base.c                            |    2 
>  drivers/video/au1200fb.c                                   |    2 
>  drivers/video/backlight/corgi_lcd.c                        |    2 
>  drivers/video/backlight/locomolcd.c                        |    2 
>  drivers/video/da8xx-fb.c                                   |    2 
>  drivers/video/display/display-sysfs.c                      |    2 
>  drivers/video/ep93xx-fb.c                                  |    2 
>  drivers/video/fbsysfs.c                                    |    2 
>  drivers/video/fsl-diu-fb.c                                 |    2 
>  drivers/video/gbefb.c                                      |    2 
>  drivers/video/geode/lxfb.h                                 |    2 
>  drivers/video/hecubafb.c                                   |    2 
>  drivers/video/i810/i810_accel.c                            |    2 
>  drivers/video/kyro/STG4000OverlayDevice.c                  |    2 
>  drivers/video/kyro/STG4000Reg.h                            |    2 
>  drivers/video/matrox/matroxfb_DAC1064.h                    |    2 
>  drivers/video/matrox/matroxfb_Ti3026.c                     |    6 -
>  drivers/video/matrox/matroxfb_base.c                       |    2 
>  drivers/video/matrox/matroxfb_base.h                       |    6 -
>  drivers/video/omap/Kconfig                                 |    2 
>  drivers/video/savage/savagefb_driver.c                     |    4 
>  drivers/video/sm501fb.c                                    |    4 
>  drivers/video/sstfb.c                                      |    8 -
>  drivers/video/sticore.h                                    |    2 
>  drivers/video/tdfxfb.c                                     |   20 +--
>  drivers/video/tmiofb.c                                     |    2 
>  drivers/video/vga16fb.c                                    |    2 
>  drivers/video/via/via_utility.c                            |    2 
>  drivers/video/via/via_utility.h                            |    2 
>  drivers/video/w100fb.c                                     |    2 
>  drivers/virtio/virtio_pci.c                                |    2 
>  drivers/w1/masters/omap_hdq.c                              |    2 
>  drivers/watchdog/Kconfig                                   |    2 
>  drivers/watchdog/Makefile                                  |    2 
>  drivers/watchdog/acquirewdt.c                              |    2 
>  drivers/watchdog/sbc7240_wdt.c                             |    2 
>  drivers/watchdog/sch311x_wdt.c                             |    2 
>  drivers/watchdog/shwdt.c                                   |    2 
>  drivers/watchdog/smsc37b787_wdt.c                          |    2 
>  drivers/watchdog/sp805_wdt.c                               |    2 
>  drivers/xen/events.c                                       |    2 
>  fs/9p/vfs_inode.c                                          |    2 
>  fs/adfs/map.c                                              |    2 
>  fs/affs/super.c                                            |    4 
>  fs/afs/cache.c                                             |   12 +-
>  fs/afs/cell.c                                              |    2 
>  fs/befs/ChangeLog                                          |    8 -
>  fs/befs/befs_fs_types.h                                    |    2 
>  fs/befs/btree.c                                            |    2 
>  fs/binfmt_flat.c                                           |    2 
>  fs/block_dev.c                                             |    2 
>  fs/btrfs/extent_map.c                                      |    2 
>  fs/btrfs/inode.c                                           |    2 
>  fs/btrfs/relocation.c                                      |    2 
>  fs/cachefiles/interface.c                                  |    2 
>  fs/ceph/addr.c                                             |    2 
>  fs/ceph/caps.c                                             |    2 
>  fs/ceph/mds_client.c                                       |    2 
>  fs/ceph/osd_client.c                                       |    2 
>  fs/ceph/snap.c                                             |    2 
>  fs/cifs/cifs_dfs_ref.c                                     |    2 
>  fs/cifs/cifssmb.c                                          |    2 
>  fs/cifs/connect.c                                          |    4 
>  fs/cifs/dir.c                                              |    2 
>  fs/configfs/dir.c                                          |    2 
>  fs/dcache.c                                                |    6 -
>  fs/dlm/lock.c                                              |    2 
>  fs/dlm/lowcomms.c                                          |    2 
>  fs/ecryptfs/main.c                                         |    4 
>  fs/eventpoll.c                                             |    8 -
>  fs/exofs/common.h                                          |    2 
>  fs/exofs/super.c                                           |    2 
>  fs/ext2/balloc.c                                           |    6 -
>  fs/ext2/inode.c                                            |    8 -
>  fs/ext2/super.c                                            |    2 
>  fs/ext2/xattr.c                                            |    2 
>  fs/ext3/balloc.c                                           |   10 -
>  fs/ext3/inode.c                                            |    6 -
>  fs/ext3/super.c                                            |    2 
>  fs/ext4/balloc.c                                           |    2 
>  fs/ext4/extents.c                                          |   10 -
>  fs/ext4/inode.c                                            |   20 +--
>  fs/ext4/mballoc.c                                          |    2 
>  fs/ext4/migrate.c                                          |    2 
>  fs/ext4/super.c                                            |    4 
>  fs/freevxfs/vxfs_fshead.c                                  |    2 
>  fs/freevxfs/vxfs_lookup.c                                  |    2 
>  fs/freevxfs/vxfs_olt.h                                     |    2 
>  fs/fs-writeback.c                                          |    4 
>  fs/fuse/file.c                                             |    2 
>  fs/gfs2/glock.c                                            |    2 
>  fs/gfs2/super.c                                            |    2 
>  fs/jbd/commit.c                                            |    2 
>  fs/jbd/revoke.c                                            |    2 
>  fs/jbd/transaction.c                                       |    2 
>  fs/jbd2/commit.c                                           |    2 
>  fs/jbd2/revoke.c                                           |    2 
>  fs/jbd2/transaction.c                                      |    2 
>  fs/jffs2/TODO                                              |    2 
>  fs/jffs2/readinode.c                                       |    2 
>  fs/jffs2/summary.c                                         |    4 
>  fs/jffs2/wbuf.c                                            |    2 
>  fs/jfs/jfs_dmap.c                                          |    6 -
>  fs/jfs/jfs_extent.c                                        |    8 -
>  fs/jfs/jfs_imap.c                                          |   14 +-
>  fs/jfs/jfs_logmgr.h                                        |    2 
>  fs/jfs/jfs_metapage.h                                      |    2 
>  fs/jfs/jfs_txnmgr.c                                        |    4 
>  fs/jfs/namei.c                                             |    2 
>  fs/jfs/resize.c                                            |    4 
>  fs/jfs/super.c                                             |    2 
>  fs/logfs/dev_mtd.c                                         |    2 
>  fs/logfs/dir.c                                             |    2 
>  fs/logfs/readwrite.c                                       |    2 
>  fs/namei.c                                                 |    2 
>  fs/nfs/file.c                                              |    2 
>  fs/nfs_common/nfsacl.c                                     |    2 
>  fs/nfsd/nfs3xdr.c                                          |    2 
>  fs/nfsd/nfs4state.c                                        |    4 
>  fs/nfsd/nfsxdr.c                                           |    2 
>  fs/notify/fanotify/fanotify_user.c                         |    4 
>  fs/notify/inotify/inotify_fsnotify.c                       |    2 
>  fs/notify/inotify/inotify_user.c                           |    2 
>  fs/notify/mark.c                                           |    2 
>  fs/ntfs/attrib.c                                           |    4 
>  fs/ntfs/compress.c                                         |    2 
>  fs/ntfs/inode.c                                            |    4 
>  fs/ntfs/layout.h                                           |   12 +-
>  fs/ntfs/logfile.c                                          |    2 
>  fs/ntfs/logfile.h                                          |    2 
>  fs/ntfs/mft.c                                              |    6 -
>  fs/ntfs/runlist.c                                          |    2 
>  fs/ntfs/super.c                                            |   14 +-
>  fs/ocfs2/alloc.c                                           |    2 
>  fs/ocfs2/cluster/heartbeat.c                               |    2 
>  fs/ocfs2/cluster/quorum.c                                  |    4 
>  fs/ocfs2/cluster/tcp.c                                     |    2 
>  fs/ocfs2/dlm/dlmconvert.c                                  |    2 
>  fs/ocfs2/dlm/dlmmaster.c                                   |    8 -
>  fs/ocfs2/dlmglue.c                                         |    4 
>  fs/ocfs2/inode.c                                           |    4 
>  fs/ocfs2/journal.c                                         |    2 
>  fs/ocfs2/journal.h                                         |    2 
>  fs/ocfs2/ocfs2_fs.h                                        |    4 
>  fs/ocfs2/quota_global.c                                    |    2 
>  fs/ocfs2/stackglue.h                                       |    2 
>  fs/ocfs2/suballoc.c                                        |    4 
>  fs/ocfs2/super.c                                           |    2 
>  fs/ocfs2/sysfile.c                                         |    2 
>  fs/ocfs2/xattr.c                                           |    4 
>  fs/openpromfs/inode.c                                      |    4 
>  fs/partitions/check.c                                      |    4 
>  fs/quota/dquot.c                                           |    2 
>  fs/reiserfs/journal.c                                      |    4 
>  fs/reiserfs/lock.c                                         |    2 
>  fs/reiserfs/super.c                                        |    4 
>  fs/reiserfs/xattr.c                                        |    2 
>  fs/squashfs/cache.c                                        |    4 
>  fs/ubifs/budget.c                                          |    2 
>  fs/ubifs/dir.c                                             |    2 
>  fs/ubifs/io.c                                              |    2 
>  fs/ufs/inode.c                                             |    2 
>  fs/ufs/super.c                                             |    4 
>  fs/xfs/linux-2.6/xfs_aops.c                                |    2 
>  fs/xfs/linux-2.6/xfs_buf.c                                 |    4 
>  fs/xfs/linux-2.6/xfs_file.c                                |    2 
>  fs/xfs/linux-2.6/xfs_iops.c                                |    2 
>  fs/xfs/quota/xfs_dquot.c                                   |    4 
>  fs/xfs/quota/xfs_qm.c                                      |   14 +-
>  fs/xfs/quota/xfs_qm_bhv.c                                  |    2 
>  fs/xfs/quota/xfs_qm_syscalls.c                             |   10 -
>  fs/xfs/quota/xfs_trans_dquot.c                             |    2 
>  fs/xfs/xfs_bmap.c                                          |    8 -
>  fs/xfs/xfs_buf_item.c                                      |    2 
>  fs/xfs/xfs_da_btree.c                                      |    4 
>  fs/xfs/xfs_inode.c                                         |    2 
>  fs/xfs/xfs_inode.h                                         |    2 
>  fs/xfs/xfs_log_recover.c                                   |    4 
>  fs/xfs/xfs_trans_inode.c                                   |    2 
>  fs/xfs/xfs_vnodeops.c                                      |    2 
>  include/acpi/acpixf.h                                      |    2 
>  include/asm-generic/siginfo.h                              |    2 
>  include/asm-generic/vmlinux.lds.h                          |    2 
>  include/drm/drmP.h                                         |    2 
>  include/drm/drm_crtc.h                                     |    2 
>  include/drm/drm_mode.h                                     |    2 
>  include/drm/mga_drm.h                                      |    2 
>  include/drm/radeon_drm.h                                   |    2 
>  include/drm/savage_drm.h                                   |    2 
>  include/drm/ttm/ttm_bo_api.h                               |   14 +-
>  include/drm/ttm/ttm_bo_driver.h                            |    2 
>  include/drm/vmwgfx_drm.h                                   |    2 
>  include/linux/adb.h                                        |    2 
>  include/linux/can/error.h                                  |    2 
>  include/linux/can/netlink.h                                |    2 
>  include/linux/cdk.h                                        |    2 
>  include/linux/cfag12864b.h                                 |    2 
>  include/linux/cgroup.h                                     |    2 
>  include/linux/cm4000_cs.h                                  |    2 
>  include/linux/configfs.h                                   |    2 
>  include/linux/cycx_x25.h                                   |   12 +-
>  include/linux/decompress/mm.h                              |    2 
>  include/linux/dmaengine.h                                  |    2 
>  include/linux/drbd.h                                       |    2 
>  include/linux/drbd_limits.h                                |    6 -
>  include/linux/exportfs.h                                   |    2 
>  include/linux/fb.h                                         |    8 -
>  include/linux/firewire-cdev.h                              |    2 
>  include/linux/fs.h                                         |    4 
>  include/linux/fscache-cache.h                              |    2 
>  include/linux/fscache.h                                    |    6 -
>  include/linux/fsl-diu-fb.h                                 |    6 -
>  include/linux/hid.h                                        |    2 
>  include/linux/i2o.h                                        |    2 
>  include/linux/interrupt.h                                  |    4 
>  include/linux/ipmi.h                                       |    4 
>  include/linux/ixjuser.h                                    |    2 
>  include/linux/jiffies.h                                    |    2 
>  include/linux/ktime.h                                      |    4 
>  include/linux/libata.h                                     |    4 
>  include/linux/lru_cache.h                                  |    2 
>  include/linux/mfd/abx500.h                                 |    2 
>  include/linux/mm.h                                         |    2 
>  include/linux/mroute6.h                                    |    2 
>  include/linux/mtd/cfi.h                                    |    2 
>  include/linux/mtd/nand.h                                   |    4 
>  include/linux/mtd/xip.h                                    |    2 
>  include/linux/netfilter/nf_conntrack_proto_gre.h           |    2 
>  include/linux/netfilter_bridge/ebtables.h                  |    2 
>  include/linux/netfilter_ipv4/ipt_ecn.h                     |    2 
>  include/linux/nfs4.h                                       |    2 
>  include/linux/nfsd/export.h                                |    2 
>  include/linux/nfsd/nfsfh.h                                 |    2 
>  include/linux/nl80211.h                                    |    6 -
>  include/linux/notifier.h                                   |    2 
>  include/linux/perf_event.h                                 |    2 
>  include/linux/pid.h                                        |    2 
>  include/linux/pkt_sched.h                                  |    2 
>  include/linux/prefetch.h                                   |    2 
>  include/linux/raid/md_p.h                                  |    2 
>  include/linux/reiserfs_fs.h                                |    2 
>  include/linux/sched.h                                      |    2 
>  include/linux/skbuff.h                                     |    2 
>  include/linux/smc91x.h                                     |    2 
>  include/linux/soundcard.h                                  |    2 
>  include/linux/spi/dw_spi.h                                 |    2 
>  include/linux/spi/spidev.h                                 |    2 
>  include/linux/spinlock.h                                   |    2 
>  include/linux/stop_machine.h                               |    2 
>  include/linux/sunrpc/cache.h                               |    2 
>  include/linux/sysdev.h                                     |    2 
>  include/linux/tracehook.h                                  |    4 
>  include/linux/ucb1400.h                                    |    2 
>  include/linux/usb.h                                        |    4 
>  include/linux/usb/composite.h                              |    2 
>  include/linux/usb/ehci_def.h                               |    2 
>  include/linux/usb/functionfs.h                             |    2 
>  include/linux/usb/gadget.h                                 |    4 
>  include/linux/usb/midi.h                                   |    2 
>  include/linux/usb/otg.h                                    |    4 
>  include/linux/usb/wusb.h                                   |    2 
>  include/linux/uwb.h                                        |    6 -
>  include/linux/uwb/umc.h                                    |    2 
>  include/linux/vgaarb.h                                     |    4 
>  include/linux/xilinxfb.h                                   |    2 
>  include/media/davinci/dm355_ccdc.h                         |    2 
>  include/media/lirc.h                                       |    2 
>  include/net/9p/9p.h                                        |    8 -
>  include/net/9p/client.h                                    |    2 
>  include/net/addrconf.h                                     |    2 
>  include/net/cfg80211.h                                     |    4 
>  include/net/gen_stats.h                                    |    2 
>  include/net/irda/wrapper.h                                 |    2 
>  include/net/iucv/iucv.h                                    |    4 
>  include/net/iw_handler.h                                   |    4 
>  include/net/mac80211.h                                     |    4 
>  include/net/pkt_sched.h                                    |    2 
>  include/net/sock.h                                         |    2 
>  include/net/transp_v6.h                                    |    2 
>  include/net/wimax.h                                        |    2 
>  include/net/wpan-phy.h                                     |    2 
>  include/rxrpc/packet.h                                     |    2 
>  include/scsi/fc/fc_fcp.h                                   |    2 
>  include/scsi/iscsi_if.h                                    |    2 
>  include/scsi/libfc.h                                       |    6 -
>  include/scsi/libiscsi_tcp.h                                |    2 
>  include/scsi/osd_initiator.h                               |    2 
>  include/scsi/scsi.h                                        |    4 
>  include/scsi/scsi_host.h                                   |    2 
>  include/scsi/scsi_transport_fc.h                           |    6 -
>  include/sound/ac97_codec.h                                 |    2 
>  include/sound/asound.h                                     |    2 
>  include/sound/control.h                                    |    2 
>  include/sound/cs46xx_dsp_spos.h                            |    2 
>  include/sound/hdspm.h                                      |    4 
>  include/sound/soc-dapm.h                                   |    2 
>  include/video/sstfb.h                                      |    6 -
>  include/xen/interface/elfnote.h                            |    2 
>  init/do_mounts.c                                           |    2 
>  ipc/msg.c                                                  |    4 
>  ipc/sem.c                                                  |    2 
>  ipc/shm.c                                                  |    2 
>  kernel/audit.c                                             |    2 
>  kernel/auditsc.c                                           |    2 
>  kernel/cgroup.c                                            |    2 
>  kernel/cpu.c                                               |    2 
>  kernel/debug/kdb/kdb_main.c                                |    6 -
>  kernel/debug/kdb/kdb_support.c                             |    2 
>  kernel/exit.c                                              |    2 
>  kernel/irq/chip.c                                          |    2 
>  kernel/irq/migration.c                                     |    2 
>  kernel/kexec.c                                             |    6 -
>  kernel/kthread.c                                           |    2 
>  kernel/latencytop.c                                        |    2 
>  kernel/lockdep.c                                           |    4 
>  kernel/module.c                                            |    4 
>  kernel/mutex.c                                             |    2 
>  kernel/padata.c                                            |    8 -
>  kernel/perf_event.c                                        |    2 
>  kernel/posix-cpu-timers.c                                  |    2 
>  kernel/posix-timers.c                                      |    2 
>  kernel/power/main.c                                        |    2 
>  kernel/sched.c                                             |    6 -
>  kernel/sched_fair.c                                        |    4 
>  kernel/sched_rt.c                                          |    4 
>  kernel/signal.c                                            |    2 
>  kernel/softirq.c                                           |    4 
>  kernel/time/jiffies.c                                      |    2 
>  kernel/time/timer_stats.c                                  |    2 
>  kernel/trace/ftrace.c                                      |    4 
>  kernel/trace/ring_buffer.c                                 |    6 -
>  kernel/trace/trace.c                                       |    6 -
>  kernel/trace/trace_clock.c                                 |    2 
>  kernel/trace/trace_entries.h                               |    2 
>  kernel/trace/trace_irqsoff.c                               |    2 
>  kernel/trace/trace_kprobe.c                                |    2 
>  kernel/user-return-notifier.c                              |    2 
>  kernel/wait.c                                              |    2 
>  kernel/workqueue.c                                         |    2 
>  lib/bitmap.c                                               |    2 
>  lib/btree.c                                                |    2 
>  lib/nlattr.c                                               |    2 
>  lib/parser.c                                               |    2 
>  lib/textsearch.c                                           |    6 -
>  lib/vsprintf.c                                             |    8 -
>  lib/zlib_deflate/deftree.c                                 |    2 
>  mm/bootmem.c                                               |    2 
>  mm/hugetlb.c                                               |   10 -
>  mm/hwpoison-inject.c                                       |    2 
>  mm/internal.h                                              |    2 
>  mm/kmemleak.c                                              |    6 -
>  mm/ksm.c                                                   |    2 
>  mm/memblock.c                                              |    2 
>  mm/memcontrol.c                                            |    8 -
>  mm/memory-failure.c                                        |    6 -
>  mm/mlock.c                                                 |    2 
>  mm/page_alloc.c                                            |    4 
>  mm/page_cgroup.c                                           |    2 
>  mm/percpu.c                                                |   12 +-
>  mm/shmem.c                                                 |    2 
>  mm/slab.c                                                  |    4 
>  mm/slub.c                                                  |    6 -
>  mm/sparse.c                                                |    2 
>  mm/vmscan.c                                                |    2 
>  net/8021q/vlanproc.c                                       |    2 
>  net/9p/client.c                                            |    2 
>  net/9p/util.c                                              |    2 
>  net/atm/br2684.c                                           |    2 
>  net/bluetooth/hci_core.c                                   |    2 
>  net/bridge/br_fdb.c                                        |    2 
>  net/bridge/br_ioctl.c                                      |    2 
>  net/core/dev.c                                             |   12 +-
>  net/core/link_watch.c                                      |    2 
>  net/core/rtnetlink.c                                       |    4 
>  net/core/skbuff.c                                          |    2 
>  net/core/sock.c                                            |   10 -
>  net/dccp/ackvec.h                                          |    2 
>  net/dccp/output.c                                          |    2 
>  net/dsa/mv88e6131.c                                        |    2 
>  net/ipv4/arp.c                                             |    2 
>  net/ipv4/cipso_ipv4.c                                      |    8 -
>  net/ipv4/fib_trie.c                                        |    2 
>  net/ipv4/icmp.c                                            |    2 
>  net/ipv4/ip_output.c                                       |    2 
>  net/ipv4/ipconfig.c                                        |    2 
>  net/ipv4/netfilter/nf_nat_standalone.c                     |    2 
>  net/ipv4/raw.c                                             |    2 
>  net/ipv4/route.c                                           |    2 
>  net/ipv4/tcp_lp.c                                          |    2 
>  net/ipv4/tcp_output.c                                      |    2 
>  net/ipv4/tcp_yeah.c                                        |    2 
>  net/ipv4/udp.c                                             |    4 
>  net/ipv6/addrconf.c                                        |    8 -
>  net/ipv6/af_inet6.c                                        |    2 
>  net/ipv6/ip6_output.c                                      |    2 
>  net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c             |    2 
>  net/ipv6/route.c                                           |    6 -
>  net/irda/irlap.c                                           |    2 
>  net/irda/irlap_event.c                                     |    4 
>  net/irda/irlap_frame.c                                     |    2 
>  net/irda/irlmp_event.c                                     |    2 
>  net/irda/irnet/irnet.h                                     |    2 
>  net/irda/irqueue.c                                         |    2 
>  net/irda/qos.c                                             |    6 -
>  net/irda/timer.c                                           |    2 
>  net/iucv/af_iucv.c                                         |    2 
>  net/iucv/iucv.c                                            |    4 
>  net/llc/llc_conn.c                                         |    2 
>  net/llc/llc_sap.c                                          |    2 
>  net/llc/llc_station.c                                      |    2 
>  net/mac80211/ieee80211_i.h                                 |    2 
>  net/mac80211/mesh.h                                        |    2 
>  net/mac80211/mesh_pathtbl.c                                |    2 
>  net/mac80211/rc80211_minstrel_ht.c                         |    2 
>  net/mac80211/rc80211_pid.h                                 |    2 
>  net/mac80211/rx.c                                          |    2 
>  net/mac80211/sta_info.c                                    |    4 
>  net/mac80211/sta_info.h                                    |    2 
>  net/netfilter/ipvs/ip_vs_conn.c                            |    4 
>  net/netfilter/ipvs/ip_vs_lblc.c                            |    2 
>  net/netfilter/ipvs/ip_vs_lblcr.c                           |    2 
>  net/netfilter/ipvs/ip_vs_proto_sctp.c                      |    8 -
>  net/netfilter/nf_conntrack_core.c                          |    4 
>  net/netfilter/nf_conntrack_proto_dccp.c                    |    2 
>  net/netfilter/nf_conntrack_sip.c                           |    2 
>  net/netfilter/nf_queue.c                                   |    2 
>  net/netlabel/netlabel_domainhash.c                         |   10 -
>  net/netlabel/netlabel_mgmt.c                               |    2 
>  net/rds/ib_send.c                                          |    2 
>  net/rds/iw_cm.c                                            |    2 
>  net/rds/iw_rdma.c                                          |    2 
>  net/rds/iw_send.c                                          |    2 
>  net/rds/send.c                                             |    4 
>  net/rose/rose_route.c                                      |    2 
>  net/sched/act_api.c                                        |    2 
>  net/sched/act_pedit.c                                      |    2 
>  net/sched/em_meta.c                                        |    2 
>  net/sched/sch_htb.c                                        |    8 -
>  net/sctp/associola.c                                       |    2 
>  net/sctp/auth.c                                            |    4 
>  net/sctp/input.c                                           |    2 
>  net/sctp/output.c                                          |    2 
>  net/sctp/outqueue.c                                        |    2 
>  net/sctp/sm_statefuns.c                                    |    8 -
>  net/sctp/socket.c                                          |    4 
>  net/sctp/ulpevent.c                                        |    2 
>  net/sctp/ulpqueue.c                                        |    2 
>  net/socket.c                                               |    2 
>  net/sunrpc/auth_gss/svcauth_gss.c                          |    2 
>  net/sunrpc/xprtsock.c                                      |    4 
>  net/tipc/link.c                                            |    4 
>  net/unix/af_unix.c                                         |    2 
>  net/wanrouter/wanproc.c                                    |    2 
>  net/wireless/reg.c                                         |    2 
>  net/x25/x25_forward.c                                      |    4 
>  net/xfrm/xfrm_user.c                                       |    6 -
>  samples/hw_breakpoint/data_breakpoint.c                    |    2 
>  scripts/Makefile.modpost                                   |    4 
>  scripts/checkpatch.pl                                      |    6 -
>  scripts/dtc/dtc-parser.tab.c_shipped                       |    2 
>  scripts/gen_initramfs_list.sh                              |    2 
>  scripts/genksyms/parse.c_shipped                           |    2 
>  scripts/kconfig/nconf.c                                    |    6 -
>  scripts/kconfig/zconf.tab.c_shipped                        |    2 
>  scripts/kernel-doc                                         |    4 
>  scripts/mod/modpost.c                                      |   18 +--
>  scripts/package/buildtar                                   |    2 
>  security/apparmor/match.c                                  |    2 
>  security/apparmor/policy_unpack.c                          |    2 
>  security/selinux/netlabel.c                                |    2 
>  security/selinux/ss/services.c                             |    4 
>  security/selinux/xfrm.c                                    |    2 
>  security/smack/smack_access.c                              |    2 
>  security/smack/smack_lsm.c                                 |    4 
>  security/smack/smackfs.c                                   |    2 
>  security/tomoyo/load_policy.c                              |    2 
>  sound/aoa/codecs/tas.c                                     |    2 
>  sound/core/pcm_memory.c                                    |    6 -
>  sound/core/pcm_native.c                                    |    4 
>  sound/core/seq/seq_dummy.c                                 |    2 
>  sound/core/vmaster.c                                       |    2 
>  sound/drivers/pcm-indirect2.c                              |    4 
>  sound/drivers/vx/vx_pcm.c                                  |    2 
>  sound/isa/sb/emu8000.c                                     |    2 
>  sound/isa/wavefront/wavefront_midi.c                       |    2 
>  sound/isa/wss/wss_lib.c                                    |    2 
>  sound/oss/ac97_codec.c                                     |    6 -
>  sound/oss/dmasound/dmasound_atari.c                        |    2 
>  sound/oss/dmasound/dmasound_core.c                         |    2 
>  sound/oss/sb_card.c                                        |    2 
>  sound/oss/sb_ess.c                                         |    4 
>  sound/oss/swarm_cs4297a.c                                  |    2 
>  sound/oss/vidc.c                                           |    2 
>  sound/pci/ad1889.c                                         |    2 
>  sound/pci/als4000.c                                        |    2 
>  sound/pci/asihpi/asihpi.c                                  |    2 
>  sound/pci/asihpi/hpi.h                                     |    2 
>  sound/pci/asihpi/hpi6000.c                                 |    2 
>  sound/pci/asihpi/hpi6205.c                                 |    2 
>  sound/pci/asihpi/hpi_internal.h                            |    2 
>  sound/pci/asihpi/hpimsgx.c                                 |    2 
>  sound/pci/au88x0/au88x0.h                                  |    2 
>  sound/pci/au88x0/au88x0_a3d.c                              |    4 
>  sound/pci/au88x0/au88x0_core.c                             |   10 -
>  sound/pci/au88x0/au88x0_pcm.c                              |    2 
>  sound/pci/azt3328.c                                        |    2 
>  sound/pci/ca0106/ca0106.h                                  |    2 
>  sound/pci/ca0106/ca0106_main.c                             |    2 
>  sound/pci/ca0106/ca0106_mixer.c                            |    2 
>  sound/pci/ca0106/ca0106_proc.c                             |    2 
>  sound/pci/cmipci.c                                         |    6 -
>  sound/pci/ctxfi/ctatc.c                                    |    2 
>  sound/pci/ctxfi/cthw20k1.c                                 |    2 
>  sound/pci/emu10k1/emupcm.c                                 |    6 -
>  sound/pci/emu10k1/memory.c                                 |    2 
>  sound/pci/emu10k1/p16v.c                                   |    2 
>  sound/pci/emu10k1/p16v.h                                   |    2 
>  sound/pci/ens1370.c                                        |    2 
>  sound/pci/hda/hda_codec.c                                  |    4 
>  sound/pci/hda/patch_cirrus.c                               |    2 
>  sound/pci/hda/patch_realtek.c                              |    2 
>  sound/pci/hda/patch_sigmatel.c                             |    2 
>  sound/pci/hda/patch_via.c                                  |    2 
>  sound/pci/ice1712/aureon.c                                 |    4 
>  sound/pci/ice1712/delta.c                                  |    2 
>  sound/pci/ice1712/pontis.c                                 |    2 
>  sound/pci/ice1712/prodigy_hifi.c                           |    4 
>  sound/pci/intel8x0.c                                       |    2 
>  sound/pci/intel8x0m.c                                      |    2 
>  sound/pci/mixart/mixart_core.c                             |    2 
>  sound/pci/pcxhr/pcxhr_core.c                               |   12 +-
>  sound/pci/rme9652/hdspm.c                                  |    8 -
>  sound/pci/rme9652/rme9652.c                                |   10 -
>  sound/pci/sis7019.c                                        |    6 -
>  sound/pci/trident/trident_main.c                           |    8 -
>  sound/pcmcia/pdaudiocf/pdaudiocf_pcm.c                     |    2 
>  sound/ppc/snd_ps3.c                                        |    6 -
>  sound/ppc/snd_ps3_reg.h                                    |   14 +-
>  sound/soc/atmel/atmel_ssc_dai.c                            |    2 
>  sound/soc/codecs/tlv320aic3x.c                             |    2 
>  sound/soc/codecs/tlv320dac33.c                             |    2 
>  sound/soc/codecs/twl4030.c                                 |    4 
>  sound/soc/codecs/wm8510.c                                  |   14 +-
>  sound/soc/codecs/wm8580.c                                  |    2 
>  sound/soc/codecs/wm8753.c                                  |    2 
>  sound/soc/codecs/wm8903.c                                  |    2 
>  sound/soc/codecs/wm8904.c                                  |    2 
>  sound/soc/codecs/wm8955.c                                  |    2 
>  sound/soc/codecs/wm8974.c                                  |   14 +-
>  sound/soc/codecs/wm8993.c                                  |    2 
>  sound/soc/codecs/wm8994.c                                  |    4 
>  sound/soc/codecs/wm9081.c                                  |    4 
>  sound/soc/imx/imx-ssi.c                                    |    2 
>  sound/soc/kirkwood/kirkwood-dma.c                          |    4 
>  sound/soc/omap/ams-delta.c                                 |    6 -
>  sound/usb/caiaq/audio.c                                    |    2 
>  sound/usb/clock.c                                          |    2 
>  sound/usb/mixer.c                                          |    2 
>  sound/usb/quirks.c                                         |    2 
>  sound/usb/usx2y/usx2yhwdeppcm.c                            |    4 
>  tools/perf/Documentation/Makefile                          |    2 
>  tools/perf/Documentation/perf-diff.txt                     |    2 
>  tools/perf/Documentation/perf-report.txt                   |    2 
>  tools/perf/Documentation/perf-test.txt                     |    2 
>  tools/perf/util/string.c                                   |    2 
>  tools/perf/util/symbol.c                                   |    4 
>  tools/perf/util/trace-event-parse.c                        |   16 +--
>  tools/perf/util/ui/browsers/annotate.c                     |    2 
>  tools/perf/util/ui/browsers/hists.c                        |    2 
>  virt/kvm/eventfd.c                                         |    2 
>  2254 files changed, 3820 insertions(+), 3820 deletions(-)
> 
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
