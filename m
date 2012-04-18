Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab2DRJHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 05:07:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62986 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2DRJHb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 05:07:31 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1204181104060.18564@ayla.of.borg>
References: <alpine.DEB.2.00.1204181104060.18564@ayla.of.borg>
Date: Wed, 18 Apr 2012 11:07:30 +0200
X-Google-Sender-Auth: YIuUc3Rgp8jc3qEqCWy2d-8y13A
Message-ID: <CAMuHMdXo99XeZs56WLdtSEO5Npqy9ymEve0L5e8EST+2Y+SjoA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.4-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 11:04, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.4-rc3 to v3.4-rc2[3], the summaries are:
>  - build errors: +8/-221
>  - build warnings: +146/-1635

 *** ERRORS ***

8 regressions:
  + arch/um/drivers/cow_user.c: error: implicit declaration of
function 'be32toh':  => 303
  + arch/um/drivers/cow_user.c: error: implicit declaration of
function 'be64toh':  => 330
  + arch/um/drivers/cow_user.c: error: implicit declaration of
function 'htobe32':  => 216
  + arch/um/drivers/cow_user.c: error: implicit declaration of
function 'htobe64':  => 249
  + error: of_platform.c: undefined reference to
`.pcibios_claim_one_bus':  => .devinit.text+0xb4)
  + fs/ocfs2/./ocfs2_trace.h: error: initializer element is not
constant  LD      sound/soc/codecs/snd-soc-twl4030.o:  => 602:1
  + include/trace/events/vmscan.h: error: initializer element is not
constant/scratch/kisskb/src/include/trace/events/signal.h:50:1: error:
(near initialization for '__tracepoint_signal_generate'):  => 444:1
  + include/trace/events/vmscan.h: error: initializer element is not
constant/scratch/kisskb/src/include/trace/events/signal.h:50:1: error:
(near initialization for '__tracepoint_signal_generate.key'):  =>
444:1

*** WARNINGS ***

146 regressions:
  + .config: warning: override: HIGHMEM4G changes choice state:  => 354
  + arch/x86/kernel/dumpstack_64.c: warning: 'id' may be used
uninitialized in this function [-Wuninitialized]:  => 153:4
  + block/blk-merge.c: warning: 'bbio' may be used uninitialized in
this function [-Wuninitialized]:  => 65:2, 65:44
  + block/bsg.c: warning: 'rw' may be used uninitialized in this
function [-Wuninitialized]:  => 273:5
  + crypto/async_tx/async_tx.c: warning: 'chan' may be used
uninitialized in this function [-Wuninitialized]:  => 258:18
  + drivers/ata/libata-core.c: warning: 'native_sectors' may be used
uninitialized in this function [-Wuninitialized]:  => 1394:3
  + drivers/ata/libata-scsi.c: warning: 'dev' may be used
uninitialized in this function [-Wuninitialized]:  => 3472:3
  + drivers/ata/libata-scsi.c: warning: 'last_failed_dev' may be used
uninitialized in this function [-Wuninitialized]:  => 3472:3
  + drivers/atm/ambassador.c: warning: 'fw' may be used uninitialized
in this function [-Wuninitialized]:  => 1971:19
  + drivers/atm/ambassador.c: warning: 'version' may be used
uninitialized in this function [-Wuninitialized]:  => 2104:7
  + drivers/atm/he.c: warning: 'he_vcc' may be used uninitialized in
this function [-Wuninitialized]:  => 1767:16
  + drivers/base/regmap/regmap.c: warning: 'ret' may be used
uninitialized in this function [-Wuninitialized]: 744:2 => 744:2,
872:9
  + drivers/block/xd.c: warning: 'address' may be used uninitialized
in this function [-Wuninitialized]:  => 193:39
  + drivers/block/xd.c: warning: 'controller' may be used
uninitialized in this function [-Wuninitialized]:  => 192:293
  + drivers/block/xen-blkback/xenbus.c: warning: passing argument 1 of
'dev_warn' makes pointer from integer without a cast [enabled by
default]:  => 419:4
  + drivers/gpu/drm/drm_bufs.c: warning: 'master' may be used
uninitialized in this function [-Wuninitialized]:  => 467:4
  + drivers/gpu/drm/nouveau/nv50_display.c: warning: 'mc' may be used
uninitialized in this function [-Wuninitialized]:  => 759:2
  + drivers/gpu/drm/nouveau/nv50_evo.c: warning: 'offset' may be used
uninitialized in this function [-Wuninitialized]:  => 349:7
  + drivers/gpu/drm/nouveau/nv50_instmem.c: warning: 'chan' may be
used uninitialized in this function [-Wuninitialized]:  => 206:6
  + drivers/gpu/vga/vgaarb.c: warning: 'devfn' may be used
uninitialized in this function [-Wuninitialized]:  => 1090:5
  + drivers/md/md.c: warning: large integer implicitly truncated to
unsigned type [-Woverflow]:  => 1146:3, 1428:3
  + drivers/mfd/mc13xxx-core.c: warning: 'id' may be used
uninitialized in this function [-Wuninitialized]:  => 783:26
  + drivers/mmc/host/sh_mobile_sdhi.c: warning:
'sh_mobile_sdhi_remove' defined but not used [-Wunused-function]:  =>
258:12
  + drivers/mmc/host/tmio_mmc_dma.c: warning: 'cookie' may be used
uninitialized in this function [-Wuninitialized]: 203:2, 122:2 =>
203:2, 203:97, 122:2, 122:97
  + drivers/mtd/chips/cfi_cmdset_0002.c: warning: 'r.x[0]' may be used
uninitialized in this function [-Wuninitialized]: 1350:7, 1773:7,
651:2 => 1350:7, 1773:7, 651:2, 1390:93, 1412:15
  + drivers/mtd/devices/docg3.c: warning: unused variable 'base'
[-Wunused-variable]: 2114:16 => 2114:16, 2114:8
  + drivers/mtd/devices/phram.c: warning: 'name' may be used
uninitialized in this function [-Wuninitialized]:  => 262:8
  + drivers/mtd/ubi/vmt.c: warning: 'err' may be used uninitialized in
this function [-Wuninitialized]:  => 412:9
  + drivers/net/ethernet/atheros/atlx/atl1.c: warning: 'control' may
be used uninitialized in this function [-Wuninitialized]:  => 496:26
  + drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c: warning:
'pin_val' may be used uninitialized in this function
[-Wuninitialized]:  => 12765:2
  + drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c: warning:
'reg_elem' may be used uninitialized in this function
[-Wuninitialized]:  => 1631:19
  + drivers/rtc/rtc-rx8025.c: warning: 'adj' may be used uninitialized
in this function [-Wuninitialized]:  => 506:16
  + drivers/scsi/advansys.c: warning: 'adv_scsiqp' may be used
uninitialized in this function [-Wuninitialized]:  => 9356:19
  + drivers/scsi/advansys.c: warning: 'next_qp' may be used
uninitialized in this function [-Wuninitialized]:  => 9037:3
  + drivers/scsi/aha1542.c: warning: 'dma_chan' may be used
uninitialized in this function [-Wuninitialized]:  => 1193:23
  + drivers/scsi/aha1542.c: warning: 'irq_level' may be used
uninitialized in this function [-Wuninitialized]:  => 1170:34
  + drivers/scsi/aha1542.c: warning: 'scsi_id' may be used
uninitialized in this function [-Wuninitialized]:  => 1189:19
  + drivers/scsi/aic94xx/aic94xx_sds.c: warning: 'offs' may be used
uninitialized in this function [-Wuninitialized]: 597:21 => 597:21,
273:25
  + drivers/scsi/dpt_i2o.c: warning: 'dptids' defined but not used
[-Wunused-variable]:  => 183:29
  + drivers/scsi/hpsa.c: warning: 'asc' may be used uninitialized in
this function [-Wuninitialized]:  => 1196:12
  + drivers/scsi/hpsa.c: warning: 'ascq' may be used uninitialized in
this function [-Wuninitialized]:  => 1196:12
  + drivers/scsi/hpsa.c: warning: 'sense_key' may be used
uninitialized in this function [-Wuninitialized]:  => 1173:4
  + drivers/scsi/mvsas/mv_sas.c: warning: 'tag' may be used
uninitialized in this function [-Wuninitialized]:  => 1607:40, 1552:40
  + drivers/scsi/mvsas/mv_sas.c: warning: comparison between 'enum
sas_device_type' and 'enum sas_dev_type' [-Wenum-compare]: 1157:34,
1160:39 => 1157:4, 1157:34, 1160:39, 1160:9
  + drivers/scsi/ncr53c8xx.c: warning: 'host_data' may be used
uninitialized in this function [-Wuninitialized]:  => 8521:17
  + drivers/scsi/osst.c: warning: 'STp' may be used uninitialized in
this function [-Wuninitialized]:  => 4612:2
  + drivers/scsi/sg.c: warning: 'sdp' may be used uninitialized in
this function [-Wuninitialized]:  => 813:5
  + drivers/staging/ramster/zcache-main.c: warning: 'page' may be used
uninitialized in this function [-Wuninitialized]:  => 1554:13
  + drivers/staging/ramster/zcache-main.c: warning:
'ramster_remotify_init' defined but not used [-Wunused-function]:  =>
1002:13
  + drivers/staging/ramster/zcache-main.c: warning:
'zcache_do_remotify_ops' defined but not used [-Wunused-function]:  =>
913:13
  + drivers/tty/ehv_bytechan.c: warning: 'ehv_bc_console_init' defined
but not used [-Wunused-function]: 334:19 => 334:122, 334:19
  + drivers/uio/uio.c: warning: 'ret' may be used uninitialized in
this function [-Wuninitialized]:  => 342:9
  + drivers/video/matrox/matroxfb_maven.c: warning: 'c' may be used
uninitialized in this function [-Wuninitialized]:  => 731:19
  + drivers/video/sis/init301.c: warning: 'CRT2Index' may be used
uninitialized in this function [-Wuninitialized]:  => 6973:7
  + drivers/video/sis/init301.c: warning: 'resindex' may be used
uninitialized in this function [-Wuninitialized]:  => 6979:68
  + drivers/virtio/virtio_ring.c: warning: cast to pointer from
integer of different size [-Wint-to-pointer-cast]: 382:9 => 382:9,
382:10
  + fs/autofs4/waitq.c: warning: 'wq' may be used uninitialized in
this function [-Wuninitialized]:  => 473:5
  + fs/fat/namei_vfat.c: warning: 'lcase' may be used uninitialized in
this function [-Wuninitialized]:  => 649:12
  + fs/fat/namei_vfat.c: warning: 'ulen' may be used uninitialized in
this function [-Wuninitialized]:  => 218:2
  + fs/freevxfs/vxfs_lookup.c: warning: 'pp' may be used uninitialized
in this function [-Wuninitialized]:  => 185:3
  + fs/hfsplus/wrapper.c: warning: 'wd.ablk_size' may be used
uninitialized in this function [-Wuninitialized]:  => 213:16
  + fs/hfsplus/wrapper.c: warning: 'wd.ablk_start' may be used
uninitialized in this function [-Wuninitialized]:  => 214:17
  + fs/hfsplus/wrapper.c: warning: 'wd.embed_count' may be used
uninitialized in this function [-Wuninitialized]:  => 216:15
  + fs/hfsplus/wrapper.c: warning: 'wd.embed_start' may be used
uninitialized in this function [-Wuninitialized]:  => 215:11
  + fs/isofs/namei.c: warning: 'i' may be used uninitialized in this
function [-Wuninitialized]:  => 26:2
  + fs/lockd/svc.c: warning: label 'err_sysctl' defined but not used
[-Wunused-label]:  => 596:1
  + fs/locks.c: warning: 'lock' may be used uninitialized in this
function [-Wuninitialized]:  => 1662:39
  + fs/ocfs2/aops.c: warning: 'wc' may be used uninitialized in this
function [-Wuninitialized]:  => 1428:20
  + fs/ocfs2/cluster/heartbeat.c: warning: 'block_bits' may be used
uninitialized in this function [-Wuninitialized]:  => 1557:21
  + fs/ocfs2/cluster/heartbeat.c: warning: 'block_bytes' may be used
uninitialized in this function [-Wuninitialized]:  => 1556:24
  + fs/ocfs2/dir.c: warning: 'split_hash' may be used uninitialized in
this function [-Wuninitialized]:  => 3754:4
  + fs/ocfs2/quota_local.c: warning: 'dchunk' may be used
uninitialized in this function [-Wuninitialized]:  => 952:45
  + fs/ocfs2/refcounttree.c: warning: 'new_cpos' may be used
uninitialized in this function [-Wuninitialized]:  => 1608:6
  + fs/ocfs2/suballoc.c: warning: 'bg_bh' may be used uninitialized in
this function [-Wuninitialized]:  => 737:2
  + fs/ocfs2/xattr.c: warning: 'ret' may be used uninitialized in this
function [-Wuninitialized]:  => 2979:2
  + fs/udf/super.c: warning: 'map' may be used uninitialized in this
function [-Wuninitialized]: 1193:9 => 1193:9, 1193:2
  + include/asm-generic/bitops/non-atomic.h: warning: array subscript
is above array bounds [-Warray-bounds]:  => 105:20
  + include/linux/err.h: warning: 'bg_bh' may be used uninitialized in
this function [-Wuninitialized]:  => 34:32
  + include/linux/list.h: warning: 'prev_page' may be used
uninitialized in this function [-Wuninitialized]:  => 44:13, 62:12
  + include/linux/spinlock.h: warning: 'dst_ptl' may be used
uninitialized in this function [-Wuninitialized]:  => 157:18
  + include/linux/spinlock.h: warning: 'ptl' may be used uninitialized
in this function [-Wuninitialized]:  => 157:18
  + kernel/cgroup.c: warning: 'l' may be used uninitialized in this
function [-Wuninitialized]:  => 3378:51
  + kernel/profile.c: warning: 'profile_cpu_callback' defined but not
used [-Wunused-function]:  => 355:125
  + kernel/profile.c: warning: 'profile_discard_flip_buffers' defined
but not used [-Wunused-function]:  => 291:13
  + kernel/profile.c: warning: 'profile_flip_buffers' defined but not
used [-Wunused-function]:  => 268:13
  + kernel/watchdog.c: warning: 'watchdog_disable' defined but not
used [-Wunused-function]:  => 470:13
  + mm/hugetlb.c: warning: 'page' may be used uninitialized in this
function [-Wuninitialized]: 1135:5 => 1135:5, 1143:19
  + mm/memblock.c: warning: 'r' may be used uninitialized in this
function [-Wuninitialized]:  => 691:15
  + net/bridge/br_notify.c: warning: statement with no effect
[-Wunused-value]:  => 42:3
  + net/core/skbuff.c: warning: 'err' may be used uninitialized in
this function [-Wuninitialized]:  => 1235:6
  + net/ipv4/inet_connection_sock.c: warning: 'head' may be used
uninitialized in this function [-Wuninitialized]:  => 193:17
  + net/ipv4/ip_options.c: warning: 'nexthop' may be used
uninitialized in this function [-Wuninitialized]:  => 646:16
  + net/sched/sch_atm.c: warning: 'len' may be used uninitialized in
this function [-Wuninitialized]:  => 526:15
  + net/sched/sch_choke.c: warning: 'idx' may be used uninitialized in
this function [-Wuninitialized]:  => 134:2
  + net/sched/sch_sfb.c: warning: 'salt' may be used uninitialized in
this function [-Wuninitialized]:  => 313:12
  + security/selinux/ss/policydb.c: warning: 'buf[0]' may be used
uninitialized in this function [-Wuninitialized]:  => 1929:12, 1030:10
  + security/selinux/ss/policydb.c: warning: 'buf[1]' may be used
uninitialized in this function [-Wuninitialized]:  => 1031:10
  + security/selinux/ss/policydb.c: warning: 'buf[2]' may be used
uninitialized in this function [-Wuninitialized]:  => 1032:10
  + warning:   CC [M]  drivers/input/touchscreen/tsc40.o:  => N/A
  + warning:   CC [M]  fs/btrfs/ordered-data.o:  => N/A
  + warning:   CC [M]  net/ipv4/netfilter/nf_nat_snmp_basic.o:  => N/A
  + warning:   CC [M]  sound/i2c/other/tea575x-tuner.o:  => N/A
  + warning: "saved_config" [vmlinux] is COMMON symbol:  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB && USB_EHCI_HCD_PMC_MSP &&
XPS_USB_HCD_XILINX && USB_OCTEON_EHCI) selects
USB_EHCI_BIG_ENDIAN_MMIO which has unmet direct dependencies
(USB_SUPPORT && USB_EHCI_HCD && (PPC_CELLEB || PPC_PS3 || 440EPX ||
ARCH_IXP4XX || XPS_USB_HCD_XILINX || PPC_MPC512x || CPU_CAVIUM_OCTEON
|| PMC_MSP || SPARC_LEON)):  => N/A
  + warning: (PPC_PS3 && PPC_CELLEB) selects USB_OHCI_BIG_ENDIAN_MMIO
which has unmet direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  =>
N/A
  + warning: (PPC_PS3 && SPU_FS) selects MEMORY_HOTPLUG which has
unmet direct dependencies ((SPARSEMEM || X86_64_ACPI_NUMA) && HOTPLUG
&& ARCH_ENABLE_MEMORY_HOTPLUG && (IA64 || X86 || PPC_BOOK3S_64 ||
SUPERH || S390)):  => N/A
  + warning: (PPC_PS3) selects USB_OHCI_LITTLE_ENDIAN which has unmet
direct dependencies (USB_SUPPORT && USB_OHCI_HCD):  => N/A
  + warning: (SCSI_SRP) selects SCSI_TGT which has unmet direct
dependencies (SCSI && EXPERIMENTAL):  => N/A
  + warning: In file included from
/scratch/kisskb/src/drivers/video/cirrusfb.c:63:0::  => N/A
  + warning: __mcount_loc already exists:
drivers/scsi/aic7xxx/aic7xxx_osm.o:  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xe12c): Section
mismatch in reference from the function .ics_rtas_init() to the
function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/built-in.o(.text+0xf6d4): Section
mismatch in reference from the function .ics_rtas_init() to the
function .init.text:.xics_register_ics():  => N/A
  + warning: arch/powerpc/sysdev/xics/built-in.o(.text+0x2610):
Section mismatch in reference from the function .ics_rtas_init() to
the function .init.text:.xics_register_ics():  => N/A
  + warning: drivers/gpu/drm/r128/r128.o (.xt.lit): unexpected
non-allocatable section.:  => N/A
  + warning: drivers/media/dvb/dvb-usb/dvb-usb-af9005.o (.xt.lit):
unexpected non-allocatable section.:  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0x38):
Section mismatch in reference from the function depca_isa_probe() to
the function .init.text:DevicePresent():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0x9a):
Section mismatch in reference from the function depca_isa_probe() to
the function .init.text:DepcaSignature():  => N/A
  + warning: drivers/net/ethernet/amd/depca.o(.devinit.text+0xe8):
Section mismatch in reference from the function depca_isa_probe() to
the function .init.text:depca_hw_init():  => N/A
  + warning: drivers/staging/android/built-in.o (.xt.lit): unexpected
non-allocatable section.:  => N/A
  + warning: drivers/staging/android/built-in.o (.xt.prop): unexpected
non-allocatable section.:  => N/A
  + warning: net/can/can-bcm.o (.xt.lit): unexpected non-allocatable
section.:  => N/A
  + warning: vmlinux.o(.text+0x189b4): Section mismatch in reference
from the function .early_setup_secondary() to the function
.cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x2cc34): Section mismatch in reference
from the function .early_setup_secondary() to the function
.cpuinit.text:.early_init_mmu_secondary():  => N/A
  + warning: vmlinux.o(.text+0x4e6e0): Section mismatch in reference
from the function .wake_offline_cpus() to the function
.cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x4fafc): Section mismatch in reference
from the function .wake_offline_cpus() to the function
.cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x7082): Section mismatch in reference
from the variable generic_secondary_common_init to the variable
.init.data:spinning_secondaries:  => N/A
  + warning: vmlinux.o(.text+0x7268): Section mismatch in reference
from the function .start_secondary_prolog() to the function
.devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x727c): Section mismatch in reference
from the function .start_secondary_resume() to the function
.devinit.text:.start_secondary():  => N/A
  + warning: vmlinux.o(.text+0x72954): Section mismatch in reference
from the function .ics_rtas_init() to the function
.init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x752fc): Section mismatch in reference
from the function .ics_rtas_init() to the function
.init.text:.xics_register_ics():  => N/A
  + warning: vmlinux.o(.text+0x867e4): Section mismatch in reference
from the function .pnv_pci_ioda_msi_setup() to the function
.devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x86800): Section mismatch in reference
from the function .pnv_pci_ioda_msi_setup() to the function
.devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x891a4): Section mismatch in reference
from the function .pnv_pci_ioda_msi_setup() to the function
.devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x891c0): Section mismatch in reference
from the function .pnv_pci_ioda_msi_setup() to the function
.devinit.text:.__pnv_ioda_get_one_pe():  => N/A
  + warning: vmlinux.o(.text+0x8b09c): Section mismatch in reference
from the function .pci_dn_reconfig_notifier() to the function
.devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8b0b8): Section mismatch in reference
from the function .pci_dn_reconfig_notifier() to the function
.devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x8da5c): Section mismatch in reference
from the function .pci_dn_reconfig_notifier() to the function
.devinit.text:.update_dn_pci_info():  => N/A
  + warning: vmlinux.o(.text+0x8da78): Section mismatch in reference
from the function .pci_dn_reconfig_notifier() to the function
.devinit.text:.eeh_dev_init():  => N/A
  + warning: vmlinux.o(.text+0x901e4): Section mismatch in reference
from the function .dlpar_online_cpu() to the function
.cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x92ba4): Section mismatch in reference
from the function .dlpar_online_cpu() to the function
.cpuinit.text:.cpu_up():  => N/A
  + warning: vmlinux.o(.text+0x97d80): Section mismatch in reference
from the function .pcibios_add_pci_devices() to the function
.devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x97e0c): Section mismatch in reference
from the function .pcibios_add_pci_devices() to the function
.devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x97e70): Section mismatch in reference
from the function .pcibios_add_pci_devices() to the function
.devinit.text:.pci_scan_bridge():  => N/A
  + warning: vmlinux.o(.text+0x9accc): Section mismatch in reference
from the function .pcibios_add_pci_devices() to the function
.devinit.text:.of_rescan_bus():  => N/A
  + warning: vmlinux.o(.text+0x9ad58): Section mismatch in reference
from the function .pcibios_add_pci_devices() to the function
.devinit.text:.pcibios_setup_bus_devices():  => N/A
  + warning: vmlinux.o(.text+0x9adbc): Section mismatch in reference
from the function .pcibios_add_pci_devices() to the function
.devinit.text:.pci_scan_bridge():  => N/A

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
