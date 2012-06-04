Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2FDB6P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 21:58:15 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:39027 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755508Ab2FDB6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 21:58:13 -0400
X-Greylist: delayed 3604 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jun 2012 21:58:12 EDT
From: "werner" <w.landgraf@ru.ru>
Subject: 3.5-rc1:  YOU, fox your driver !  apple_gmux chipidea/udc 
  btrfs cifs/connect jbd2 ubifs nicstar nvme noveau radeon/atombios udl
 hid-wiimote i2c-pxa mix4 gigaset mISDN isdn/icn isdn/sc raid10
 dvb/cx24110 wl128x/fmdrv mfd/wm8994 twl-4030 da9052 rc5t583 lm3533
 ti-st apds990x mmc/card/block doc2001plus  acenic nmclan bnx2x  bnad
 ewrk3 b43/phyn brc80211 libipw_wx iwl-trans-pcie-tx rt2800lib rtl8192
 of_net of_mtd parport_pc oaktrail rtc-m41t80 mv_sas ql4_nx advansys
 dpt_i2o aic7xxx fdomain g_NCR5380 dtc initio stex vmk80xx ad5064
 easycap lirc rtl8192/rtllib rtl8712 wlags49 zsmalloc ifx6x60
 vt/keyboard xhci twl6030   via/hw i740fb udlfb sound/core/memory
 ctvmem lm49453 wm8996 br_netfilter ceph_fs ieee802154/6lowpan
 ip_tables ipt_ULOG arp_tables ip6_tables mac80211/mlme
 mac802154/monitor netfilter/xt_time sctp/sm_statefuns
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sun, 03 Jun 2012 20:58:04 -0400
Message-ID: <web-751426579@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-rc1:  YOU, fox your driver !  apple_gmux chipidea/udc 
  btrfs cifs/connect jbd2 ubifs nicstar nvme noveau 
radeon/atombios udl hid-wiimote i2c-pxa mix4 gigaset mISDN 
isdn/icn isdn/sc raid10 dvb/cx24110 wl128x/fmdrv 
mfd/wm8994 twl-4030
da9052 rc5t583 lm3533 ti-st apds990x mmc/card/block 
doc2001plus  acenic nmclan bnx2x
bnad ewrk3 b43/phyn brc80211 libipw_wx iwl-trans-pcie-tx 
rt2800lib rtl8192 of_net of_mtd parport_pc oaktrail 
rtc-m41t80 mv_sas ql4_nx advansys dpt_i2o aic7xxx fdomain 
g_NCR5380 dtc initio
stex vmk80xx ad5064 easycap lirc rtl8192/rtllib rtl8712 
wlags49 zsmalloc ifx6x60 vt/keyboard xhci twl6030
via/hw i740fb udlfb sound/core/memory ctvmem lm49453 
wm8996 br_netfilter ceph_fs ieee802154/6lowpan ip_tables 
ipt_ULOG arp_tables ip6_tables mac80211/mlme 
mac802154/monitor netfilter/xt_time sctp/sm_statefuns



Last month, many people fixed them driver, after this 
reclamation, here the next uncleannesses or errors, which 
people could fix.
One never know, what side- (or main-) effects these have, 
sometimes perhaps difficult to find then.
The errors in apple_gmux and chipidea_udc resultet an 
unsuccessful compilation/linking for me.




scripts/sortextable.h:104: warning: 'relocs_size' may be 
used uninitialized in this function
scripts/sortextable.h:104: warning: 'relocs_size' may be 
used uninitialized in this function
fs/btrfs/file-item.c:717: warning: comparison of distinct 
pointer types lacks a cast
fs/btrfs/file-item.c:767: warning: comparison of distinct 
pointer types lacks a cast
fs/btrfs/file-item.c:808: warning: comparison of distinct 
pointer types lacks a cast
fs/btrfs/file-item.c:808: warning: comparison of distinct 
pointer types lacks a cast
fs/btrfs/extent_io.h:281: warning: 'extent_buffer_page' 
declared inline after being called
fs/btrfs/extent_io.h:281: warning: previous declaration of 
'extent_buffer_page' was here
fs/btrfs/extent_io.h:280: warning: 'num_extent_pages' 
declared inline after being called
fs/btrfs/extent_io.h:280: warning: previous declaration of 
'num_extent_pages' was here
fs/cifs/connect.c:3723: warning: 'tcon' may be used 
uninitialized in this function
fs/cifs/connect.c:3722: warning: 'pSesInfo' may be used 
uninitialized in this function
fs/cifs/connect.c:3721: warning: 'xid' may be used 
uninitialized in this function
fs/jbd2/commit.c:352: warning: 'kmap_atomic_deprecated' is 
deprecated (declared at include/linux/highmem.h:127)
fs/jbd2/commit.c:357: warning: 
'__kunmap_atomic_deprecated' is deprecated (declared at 
include/linux/highmem.h:137)
fs/ubifs/dir.c:972: warning: 'saved_nlink' may be used 
uninitialized in this function
drivers/atm/nicstar.c:957: warning: 'err' may be used 
uninitialized in this function
drivers/block/nvme.c:921: warning: passing argument 3 of 
'dma_free_attrs' discards qualifiers from pointer target 
type
drivers/block/nvme.c:968: warning: passing argument 3 of 
'dma_free_attrs' discards qualifiers from pointer target 
type
drivers/block/nvme.c:879: warning: passing argument 3 of 
'dma_free_attrs' discards qualifiers from pointer target 
type
drivers/block/nvme.c:1156: warning: 'iod' may be used 
uninitialized in this function
drivers/gpu/drm/nouveau/nv04_fence.c:139: warning: 'ret' 
is used uninitialized in this function
drivers/gpu/drm/nouveau/nv50_display.c:670: warning: 'mc' 
may be used uninitialized in this function
drivers/gpu/drm/nouveau/nv50_pm.c:76: warning: 'id' may be 
used uninitialized in this function
drivers/gpu/drm/radeon/atombios_i2c.c:59: warning: 
comparison is always false due to limited range of data 
type
drivers/gpu/drm/udl/udl_transfer.c:152: warning: passing 
argument 1 of 'prefetch_range' discards qualifiers from 
pointer target type
drivers/hid/hid-wiimote-debug.c:34: warning: 'size' may be 
used uninitialized in this function
drivers/i2c/busses/i2c-pxa.c:1249: warning: unused 
variable 'i2c'
drivers/infiniband/hw/mlx4/qp.c:1386: warning: 'vlan' may 
be used uninitialized in this function
drivers/isdn/gigaset/capi.c:292: warning: 'format_ie' 
defined but not used
drivers/isdn/hardware/mISDN/hfcpci.c:2298: warning: 
ignoring return value of 'driver_for_each_device', 
declared with attribute warn_unused_result
drivers/isdn/hardware/mISDN/netjet.c:319: warning: 
comparison is always false due to limited range of data 
type
drivers/isdn/icn/icn.c:721:2: warning: #warning TODO test 
headroom or use skb->nb to flag ACK
drivers/isdn/sc/init.c:36: warning: return from 
incompatible pointer type
drivers/isdn/sc/init.c:37: warning: return from 
incompatible pointer type
drivers/isdn/sc/init.c:487: warning: passing argument 1 of 
'readl' makes pointer from integer without a cast
drivers/isdn/sc/init.c:497: warning: passing argument 1 of 
'readl' makes pointer from integer without a cast
drivers/isdn/sc/init.c:507: warning: passing argument 1 of 
'readl' makes pointer from integer without a cast
drivers/md/raid10.c:720: warning: 'rdev' may be used 
uninitialized in this function
drivers/media/dvb/frontends/cx24110.c:521: warning: value 
computed is not used
drivers/media/radio/wl128x/fmdrv_common.c:745: warning: 
comparison is always false due to limited range of data 
type
drivers/media/radio/wl128x/fmdrv_rx.c:308: warning: 
comparison is always false due to limited range of data 
type
drivers/mfd/wm8994-core.c:393: warning: 'patch_regs' may 
be used uninitialized in this function
drivers/mfd/twl4030-madc.c:517: warning: comparison is 
always false due to limited range of data type
drivers/mfd/da9052-core.c:775: warning: unused variable 
'desc'
drivers/mfd/rc5t583.c:88: warning: 'sleepseq_val' may be 
used uninitialized in this function
drivers/mfd/rc5t583-irq.c:258: warning: 'master_int' may 
be used uninitialized in this function
drivers/mfd/lm3533-ctrlbank.c:129: warning: comparison is 
always false due to limited range of data type
drivers/misc/ti-st/st_core.c:639: warning: comparison is 
always false due to limited range of data type
drivers/misc/apds990x.c:703: warning: comparison is always 
false due to limited range of data type
drivers/mmc/card/block.c:831: warning: 'arg' may be used 
uninitialized in this function
drivers/mmc/card/block.c:831: warning: 'nr' may be used 
uninitialized in this function
drivers/mmc/card/block.c:831: warning: 'from' may be used 
uninitialized in this function
drivers/mtd/devices/doc2001plus.c:750: warning: passing 
argument 2 of 'MemWriteDOC' discards qualifiers from 
pointer target type
drivers/net/ethernet/alteon/acenic.c:750: warning: passing 
argument 3 of 'pci_free_consistent' discards qualifiers 
from pointer target type
drivers/net/ethernet/alteon/acenic.c:755: warning: passing 
argument 3 of 'pci_free_consistent' discards qualifiers 
from pointer target type
drivers/net/ethernet/alteon/acenic.c:761: warning: passing 
argument 3 of 'pci_free_consistent' discards qualifiers 
from pointer target type
drivers/net/ethernet/amd/nmclan_cs.c:625: warning: 
'pcmcia_request_exclusive_irq' is deprecated (declared at 
include/pcmcia/ds.h:203)
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:2883: 
warning: comparison of distinct pointer types lacks a cast
drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:1646: 
warning: comparison of distinct pointer types lacks a cast
drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c:938: 
warning: 'val' may be used uninitialized in this function
drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c:973: 
warning: 'val' may be used uninitialized in this function
drivers/net/ethernet/brocade/bna/bnad.c:2781: warning: 
comparison is always true due to limited range of data 
type
drivers/net/ethernet/dec/ewrk3.c:1915: warning: return 
from incompatible pointer type
drivers/net/wireless/b43/phy_n.c:2576: warning: 'idx' may 
be used uninitialized in this function
drivers/net/wireless/brcm80211/brcmsmac/main.c:5560: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/brcm80211/brcmsmac/main.c:5660: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/ipw2x00/libipw_wx.c:526: warning: 
unused variable 'dev'
drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:646: 
warning: passing argument 2 of 'dma_map_single_attrs' 
discards qualifiers from pointer target type
drivers/net/wireless/rt2x00/rt2800lib.c:1311: warning: 
'gf40_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1311: warning: 
'gf20_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1311: warning: 
'mm40_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1311: warning: 
'mm20_mode' may be used uninitialized in this function
drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:916: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/rtlwifi/rtl8192de/dm.c:1059: warning: 
comparison is always false due to limited range of data 
type
drivers/net/wireless/rtlwifi/rtl8192de/trx.c:124: warning: 
'rx_pwr_all' may be used uninitialized in this function
include/linux/of_net.h:12: warning: type qualifiers 
ignored on function return type
drivers/of/of_net.c:42: warning: type qualifiers ignored 
on function return type
include/linux/of_mtd.h:14: warning: type qualifiers 
ignored on function return type
drivers/of/of_mtd.c:36: warning: type qualifiers ignored 
on function return type
drivers/parport/parport_pc.c:587: warning: passing 
argument 2 of 'dma_map_single_attrs' discards qualifiers 
from pointer target type
drivers/platform/x86/intel_oaktrail.c:233: warning: 
comparison is always false due to limited range of data 
type
drivers/rtc/rtc-m41t80.c:217: warning: 
'm41t80_rtc_alarm_irq_enable' defined but not used
drivers/rtc/rtc-m41t80.c:239: warning: 
'm41t80_rtc_set_alarm' defined but not used
drivers/rtc/rtc-m41t80.c:309: warning: 
'm41t80_rtc_read_alarm' defined but not used
drivers/scsi/mvsas/mv_sas.c:888: warning: unused variable 
'dev'
drivers/scsi/qla4xxx/ql4_nx.c:1867: warning: format '%lx' 
expects type 'long unsigned int', but argument 5 has type 
'uint32_t'
drivers/scsi/advansys.c:71:2: warning: #warning this 
driver is still not properly converted to the DMA API
drivers/scsi/dpt_i2o.c:183: warning: 'dptids' defined but 
not used
drivers/scsi/aic7xxx_old.c:8484: warning: passing argument 
3 of 'pci_free_consistent' discards qualifiers from 
pointer target type
drivers/scsi/fdomain.c:1774: warning: 'fdomain_pci_tbl' 
defined but not used
drivers/scsi/g_NCR5380.c:942: warning: 'id_table' defined 
but not used
drivers/scsi/dtc.c:179: warning: 'dtc_setup' defined but 
not used
drivers/scsi/initio.c:131: warning: 'i91u_pci_devices' 
defined but not used
drivers/scsi/stex.c:636: warning: passing argument 2 of 
'scsi_sg_copy_from_buffer' discards qualifiers from 
pointer target type
drivers/staging/comedi/drivers/vmk80xx.c:917: warning: 
'reg[0]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:917: warning: 
'reg[1]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:559: warning: 
'reg[0]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:559: warning: 
'reg[1]' may be used uninitialized in this function
drivers/staging/iio/dac/ad5064.c:436: warning: type 
qualifiers ignored on function return type
drivers/staging/media/easycap/easycap_main.c:3495: 
warning: 'rc' may be used uninitialized in this function
drivers/staging/media/lirc/lirc_serial.c:1295: warning: 
return from incompatible pointer type
drivers/staging/rtl8192e/rtllib_softmac.c:2301: warning: 
'challenge' may be used uninitialized in this function
drivers/staging/rtl8192e/rtllib_softmac.c:2218: warning: 
'aid' may be used uninitialized in this function
drivers/staging/rtl8192e/rtllib_softmac.c:2218: warning: 
'aid' may be used uninitialized in this function
drivers/staging/rtl8192e/rtllib_softmac.c:2301: warning: 
'challenge' may be used uninitialized in this function
drivers/staging/rtl8192e/rtl819x_TSProc.c:321: warning: 
comparison is always true due to limited range of data 
type
drivers/staging/rtl8712/rtl8712_recv.c:751: warning: 
'rx_pwr_all' may be used uninitialized in this function
drivers/staging/wlags49_h2/wl_wext.c:225: warning: 
comparison is always false due to limited range of data 
type
drivers/staging/wlags49_h2/wl_wext.c:250: warning: 
comparison is always true due to limited range of data 
type
drivers/staging/wlags49_h2/wl_main.c:543: warning: 
comparison is always true due to limited range of data 
type
drivers/staging/wlags49_h25/../wlags49_h2/wl_wext.c:225: 
warning: comparison is always false due to limited range 
of data type
drivers/staging/wlags49_h25/../wlags49_h2/wl_wext.c:250: 
warning: comparison is always true due to limited range of 
data type
drivers/staging/wlags49_h25/../wlags49_h2/wl_main.c:543: 
warning: comparison is always true due to limited range of 
data type
drivers/staging/zsmalloc/zsmalloc-main.c:372: warning: 
'prev_page' may be used uninitialized in this function
drivers/tty/serial/ifx6x60.c:1357: warning: passing 
argument 1 of 'spi_unregister_driver' discards qualifiers 
from pointer target type
drivers/tty/vt/keyboard.c:738: warning: comparison is 
always true due to limited range of data type
drivers/usb/host/xhci-mem.c:799: warning: 'tt_info' may be 
used uninitialized in this function
drivers/usb/host/xhci-ring.c:1280: warning: 'hcd' may be 
used uninitialized in this function
drivers/usb/otg/twl6030-usb.c:131: warning: comparison is 
always true due to limited range of data type
drivers/video/via/hw.c:1423: warning: 'config.rshift' may 
be used uninitialized in this function
drivers/video/via/hw.c:1423: warning: 'config.divisor' may 
be used uninitialized in this function
drivers/video/via/hw.c:1423: warning: 'config.multiplier' 
may be used uninitialized in this function
drivers/video/i740fb.c:228: warning: 'wm' may be used 
uninitialized in this function
drivers/video/udlfb.c:457: warning: passing argument 1 of 
'prefetch_range' discards qualifiers from pointer target 
type
sound/core/memory.c:74: warning: passing argument 1 of 
'copy_from_user' discards qualifiers from pointer target 
type
sound/pci/ctxfi/ctvmem.c:79: warning: 'entry' may be used 
uninitialized in this function
sound/pci/ctxfi/ctvmem.c:34: warning: 'entry' may be used 
uninitialized in this function
sound/soc/codecs/lm49453.c:1511: warning: passing argument 
3 of 'snd_soc_register_codec' discards qualifiers from 
pointer target type
sound/soc/codecs/wm8996.c:1728: warning: 'bclk_reg' may be 
used uninitialized in this function
net/bridge/br_netfilter.c:827: warning: passing argument 4 
of 'NF_HOOK' discards qualifiers from pointer target type
net/bridge/br_netfilter.c:827: warning: passing argument 5 
of 'NF_HOOK' discards qualifiers from pointer target type
net/ceph/ceph_fs.c:33: warning: 'mode' may be used 
uninitialized in this function
net/ieee802154/6lowpan.c:406: warning: passing argument 3 
of 'lowpan_raw_dump_inline' discards qualifiers from 
pointer target type
net/ieee802154/6lowpan.c:419: warning: passing argument 3 
of 'lowpan_raw_dump_inline' discards qualifiers from 
pointer target type
net/ipv4/netfilter/ip_tables.c:182: warning: passing 
argument 1 of 'ipt_get_target' discards qualifiers from 
pointer target type
net/ipv4/netfilter/ipt_ULOG.c:208: warning: passing 
argument 1 of '__net_timestamp' discards qualifiers from 
pointer target type
net/ipv4/netfilter/arp_tables.c:233: warning: passing 
argument 1 of 'arpt_get_target' discards qualifiers from 
pointer target type
net/ipv6/netfilter/ip6_tables.c:207: warning: passing 
argument 1 of 'ip6t_get_target' discards qualifiers from 
pointer target type
net/mac80211/mlme.c:3017: warning: 'sta' may be used 
uninitialized in this function
net/mac802154/monitor.c:49: warning: comparison is always 
false due to limited range of data type
net/netfilter/xt_time.c:171: warning: passing argument 1 
of '__net_timestamp' discards qualifiers from pointer 
target type
net/sctp/sm_statefuns.c:2051: warning: passing argument 1 
of 'SCTP_ASOC' discards qualifiers from pointer target 
type
   CC      fs/xfs/xfs_error.o
   CC      drivers/acpi/acpica/utxferror.o
This is often seen when error handling in the init 
function
This is often seen when error handling in the init 
function
   CC      drivers/scsi/scsi_error.o
This is often seen when error handling in the init 
function
This is often seen when error handling in the init 
function
   CC      arch/x86/math-emu/errors.o
   CC [M]  net/9p/error.o
   CC      net/rxrpc/ar-error.o
   CC      lib/cpu-notifier-error-inject.o
This is often seen when error handling in the init 
function
make[2]: Target `arch/x86/boot/compressed/vmlinux' not 
remade because of errors.
make[1]: Target `arch/x86/boot/bzImage' not remade because 
of errors.
This is often seen when error handling in the init 
function





WARNING: arch/x86/kernel/built-in.o(.data+0x3640): Section 
mismatch in reference from the variable 
nmi_unk_cb_na.12435 to the function 
.init.text:nmi_unk_cb()
The variable nmi_unk_cb_na.12435 references
the function __init nmi_unk_cb()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: arch/x86/kernel/built-in.o(.data+0x3654): Section 
mismatch in reference from the variable 
test_nmi_ipi_callback_na.12491 to the function 
.init.text:test_nmi_ipi_callback()
The variable test_nmi_ipi_callback_na.12491 references
the function __init test_nmi_ipi_callback()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: arch/x86/built-in.o(.data+0x3d80): Section 
mismatch in reference from the variable 
nmi_unk_cb_na.12435 to the function 
.init.text:nmi_unk_cb()
The variable nmi_unk_cb_na.12435 references
the function __init nmi_unk_cb()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: arch/x86/built-in.o(.data+0x3d94): Section 
mismatch in reference from the variable 
test_nmi_ipi_callback_na.12491 to the function 
.init.text:test_nmi_ipi_callback()
The variable test_nmi_ipi_callback_na.12491 references
the function __init test_nmi_ipi_callback()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: drivers/block/built-in.o(.devinit.text+0x229): 
Section mismatch in reference from the function 
cpqarray_register_ctlr() to the function 
.init.text:ida_procinit()
The function __devinit cpqarray_register_ctlr() references
a function __init ida_procinit().
If ida_procinit is only used by cpqarray_register_ctlr 
then
annotate ida_procinit with a matching annotation.

WARNING: drivers/misc/built-in.o(.text+0x254b): Section 
mismatch in reference from the function 
bmp085_init_client() to the function 
.init.text:bmp085_get_of_properties()
The function bmp085_init_client() references
the function __init bmp085_get_of_properties().
This is often because bmp085_init_client lacks a __init
annotation or the annotation of bmp085_get_of_properties 
is wrong.

WARNING: drivers/pci/built-in.o(.text+0x1bf00): Section 
mismatch in reference from the function 
cpqhp_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
The function cpqhp_configure_device() references
the function __devinit pci_do_scan_bus().
This is often because cpqhp_configure_device lacks a 
__devinit
annotation or the annotation of pci_do_scan_bus is wrong.

WARNING: drivers/pci/built-in.o(.text+0x1ce0a): Section 
mismatch in reference from the function 
bus_structure_fixup() to the function 
.devinit.text:pci_scan_bus()
The function bus_structure_fixup() references
the function __devinit pci_scan_bus().
This is often because bus_structure_fixup lacks a 
__devinit
annotation or the annotation of pci_scan_bus is wrong.

WARNING: drivers/pci/built-in.o(.text+0x1cf2a): Section 
mismatch in reference from the function 
ibm_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
The function ibm_configure_device() references
the function __devinit pci_do_scan_bus().
This is often because ibm_configure_device lacks a 
__devinit
annotation or the annotation of pci_do_scan_bus is wrong.

WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x2c): 
Section mismatch in reference from the function 
libfcoe_init() to the function 
.exit.text:fcoe_transport_exit()
The function __init libfcoe_init() references
a function __exit fcoe_transport_exit().
This is often seen when error handling in the init 
function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
fcoe_transport_exit() so it may be used outside an exit 
section.

WARNING: drivers/scsi/fcoe/built-in.o(.init.text+0x1c8): 
Section mismatch in reference from the function 
libfcoe_init() to the function 
.exit.text:fcoe_transport_exit()
The function __init libfcoe_init() references
a function __exit fcoe_transport_exit().
This is often seen when error handling in the init 
function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
fcoe_transport_exit() so it may be used outside an exit 
section.

WARNING: drivers/scsi/built-in.o(.init.text+0x9c0): 
Section mismatch in reference from the function 
libfcoe_init() to the function 
.exit.text:fcoe_transport_exit()
The function __init libfcoe_init() references
a function __exit fcoe_transport_exit().
This is often seen when error handling in the init 
function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
fcoe_transport_exit() so it may be used outside an exit 
section.

WARNING: drivers/scsi/built-in.o(.data+0x2e3c): Section 
mismatch in reference from the variable sim710_eisa_driver 
to the function .init.text:sim710_eisa_probe()
The variable sim710_eisa_driver references
the function __init sim710_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: drivers/usb/gadget/g_audio.o(.text+0x6ba): 
Section mismatch in reference from the function 
audio_bind_config() to the function 
.init.text:afunc_bind()
The function audio_bind_config() references
the function __init afunc_bind().
This is often because audio_bind_config lacks a __init
annotation or the annotation of afunc_bind is wrong.

WARNING: drivers/usb/gadget/g_audio.o(.text+0xdd9): 
Section mismatch in reference from the function 
alsa_uac2_init() to the function 
.devinit.text:snd_uac2_probe()
The function alsa_uac2_init() references
the function __devinit snd_uac2_probe().
This is often because alsa_uac2_init lacks a __devinit
annotation or the annotation of snd_uac2_probe is wrong.

WARNING: drivers/usb/gadget/g_audio.o(.text+0xde9): 
Section mismatch in reference from the function 
alsa_uac2_init() to the function 
.devexit.text:snd_uac2_remove()
The function alsa_uac2_init() references a function in an 
exit section.
Often the function snd_uac2_remove() has valid usage 
outside the exit section
and the fix is to remove the __devexit annotation of 
snd_uac2_remove.

WARNING: drivers/usb/gadget/g_multi.o(.text+0xbcd): 
Section mismatch in reference from the function 
cdc_config_register() to the function 
.init.text:cdc_do_config()
The function cdc_config_register() references
the function __init cdc_do_config().
This is often because cdc_config_register lacks a __init
annotation or the annotation of cdc_do_config is wrong.

WARNING: drivers/usb/gadget/g_multi.o(.text+0xbfe): 
Section mismatch in reference from the function 
rndis_config_register() to the function 
.init.text:rndis_do_config()
The function rndis_config_register() references
the function __init rndis_do_config().
This is often because rndis_config_register lacks a __init
annotation or the annotation of rndis_do_config is wrong.

WARNING: drivers/built-in.o(.text+0x25814): Section 
mismatch in reference from the function 
cpqhp_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
The function cpqhp_configure_device() references
the function __devinit pci_do_scan_bus().
This is often because cpqhp_configure_device lacks a 
__devinit
annotation or the annotation of pci_do_scan_bus is wrong.

WARNING: drivers/built-in.o(.text+0x2671e): Section 
mismatch in reference from the function 
bus_structure_fixup() to the function 
.devinit.text:pci_scan_bus()
The function bus_structure_fixup() references
the function __devinit pci_scan_bus().
This is often because bus_structure_fixup lacks a 
__devinit
annotation or the annotation of pci_scan_bus is wrong.

WARNING: drivers/built-in.o(.text+0x2683e): Section 
mismatch in reference from the function 
ibm_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
The function ibm_configure_device() references
the function __devinit pci_do_scan_bus().
This is often because ibm_configure_device lacks a 
__devinit
annotation or the annotation of pci_do_scan_bus is wrong.

WARNING: drivers/built-in.o(.text+0x37d9f7): Section 
mismatch in reference from the function 
bmp085_init_client() to the function 
.init.text:bmp085_get_of_properties()
The function bmp085_init_client() references
the function __init bmp085_get_of_properties().
This is often because bmp085_init_client lacks a __init
annotation or the annotation of bmp085_get_of_properties 
is wrong.

WARNING: drivers/built-in.o(.init.text+0x17592): Section 
mismatch in reference from the function libfcoe_init() to 
the function .exit.text:fcoe_transport_exit()
The function __init libfcoe_init() references
a function __exit fcoe_transport_exit().
This is often seen when error handling in the init 
function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
fcoe_transport_exit() so it may be used outside an exit 
section.

WARNING: drivers/built-in.o(.devinit.text+0x26659): 
Section mismatch in reference from the function 
cpqarray_register_ctlr() to the function 
.init.text:ida_procinit()
The function __devinit cpqarray_register_ctlr() references
a function __init ida_procinit().
If ida_procinit is only used by cpqarray_register_ctlr 
then
annotate ida_procinit with a matching annotation.

WARNING: drivers/built-in.o(.data+0x47aec): Section 
mismatch in reference from the variable sim710_eisa_driver 
to the function .init.text:sim710_eisa_probe()
The variable sim710_eisa_driver references
the function __init sim710_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: sound/pci/hda/snd-hda-intel.o(.text+0x1201): 
Section mismatch in reference from the function 
azx_first_init() to the function 
.devinit.text:azx_init_stream()
The function azx_first_init() references
the function __devinit azx_init_stream().
This is often because azx_first_init lacks a __devinit
annotation or the annotation of azx_init_stream is wrong.

WARNING: sound/pci/hda/snd-hda-intel.o(.text+0x1f87): 
Section mismatch in reference from the function 
azx_probe_continue() to the function 
.devinit.text:azx_codec_configure()
The function azx_probe_continue() references
the function __devinit azx_codec_configure().
This is often because azx_probe_continue lacks a __devinit
annotation or the annotation of azx_codec_configure is 
wrong.

WARNING: sound/pci/hda/snd-hda-intel.o(.text+0x1f9e): 
Section mismatch in reference from the function 
azx_probe_continue() to the function 
.devinit.text:azx_mixer_create()
The function azx_probe_continue() references
the function __devinit azx_mixer_create().
This is often because azx_probe_continue lacks a __devinit
annotation or the annotation of azx_mixer_create is wrong.



   MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x62fda0): Section mismatch in 
reference from the function cpqhp_configure_device() to 
the function .devinit.text:pci_do_scan_bus()
The function cpqhp_configure_device() references
the function __devinit pci_do_scan_bus().
This is often because cpqhp_configure_device lacks a 
__devinit
annotation or the annotation of pci_do_scan_bus is wrong.

WARNING: vmlinux.o(.text+0x630caa): Section mismatch in 
reference from the function bus_structure_fixup() to the 
function .devinit.text:pci_scan_bus()
The function bus_structure_fixup() references
the function __devinit pci_scan_bus().
This is often because bus_structure_fixup lacks a 
__devinit
annotation or the annotation of pci_scan_bus is wrong.

WARNING: vmlinux.o(.text+0x630dca): Section mismatch in 
reference from the function ibm_configure_device() to the 
function .devinit.text:pci_do_scan_bus()
The function ibm_configure_device() references
the function __devinit pci_do_scan_bus().
This is often because ibm_configure_device lacks a 
__devinit
annotation or the annotation of pci_do_scan_bus is wrong.

WARNING: vmlinux.o(.text+0x987f83): Section mismatch in 
reference from the function bmp085_init_client() to the 
function .init.text:bmp085_get_of_properties()
The function bmp085_init_client() references
the function __init bmp085_get_of_properties().
This is often because bmp085_init_client lacks a __init
annotation or the annotation of bmp085_get_of_properties 
is wrong.

WARNING: vmlinux.o(.init.text+0x4103b): Section mismatch 
in reference from the function libfcoe_init() to the 
function .exit.text:fcoe_transport_exit()
The function __init libfcoe_init() references
a function __exit fcoe_transport_exit().
This is often seen when error handling in the init 
function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
fcoe_transport_exit() so it may be used outside an exit 
section.

WARNING: vmlinux.o(.devinit.text+0x27144): Section 
mismatch in reference from the function 
cpqarray_register_ctlr() to the function 
.init.text:ida_procinit()
The function __devinit cpqarray_register_ctlr() references
a function __init ida_procinit().
If ida_procinit is only used by cpqarray_register_ctlr 
then
annotate ida_procinit with a matching annotation.

WARNING: vmlinux.o(.data+0x4c40): Section mismatch in 
reference from the variable nmi_unk_cb_na.12435 to the 
function .init.text:nmi_unk_cb()
The variable nmi_unk_cb_na.12435 references
the function __init nmi_unk_cb()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: vmlinux.o(.data+0x4c54): Section mismatch in 
reference from the variable test_nmi_ipi_callback_na.12491 
to the function .init.text:test_nmi_ipi_callback()
The variable test_nmi_ipi_callback_na.12491 references
the function __init test_nmi_ipi_callback()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: vmlinux.o(.data+0x8cb2c): Section mismatch in 
reference from the variable sim710_eisa_driver to the 
function .init.text:sim710_eisa_probe()
The variable sim710_eisa_driver references
the function __init sim710_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

   GEN     .version
   CHK     include/generated/compile.h
   UPD     include/generated/compile.h
   CC      init/version.o
   LD      init/built-in.o
drivers/built-in.o: In function `_hardware_dequeue':
udc.c:(.text+0x85fd46): undefined reference to 
`usb_gadget_unmap_request'
drivers/built-in.o: In function `udc_stop':
udc.c:(.text+0x8605a2): undefined reference to 
`usb_del_gadget_udc'
drivers/built-in.o: In function `_hardware_enqueue':
udc.c:(.text+0x860861): undefined reference to 
`usb_gadget_map_request'
drivers/built-in.o: In function `udc_start':
udc.c:(.text+0x860bd3): undefined reference to 
`usb_add_gadget_udc'
drivers/built-in.o: In function `ep_dequeue':
udc.c:(.text+0x8614b2): undefined reference to 
`usb_gadget_unmap_request'
drivers/built-in.o: In function `gmux_probe':
apple-gmux.c:(.devinit.text+0x6b31a): undefined reference 
to `apple_bl_unregister'
drivers/built-in.o: In function `gmux_remove':
apple-gmux.c:(.devexit.text+0x8c22): undefined reference 
to `apple_bl_register'
make: [vmlinux] Error 1 (ignored)


   Building modules, stage 2.
   MODPOST 2494 modules
WARNING: drivers/leds/leds-lp5523.o(.devinit.text+0x262): 
Section mismatch in reference from the function 
lp5523_probe() to the function 
.init.text:lp5523_init_engine()
The function __devinit lp5523_probe() references
a function __init lp5523_init_engine().
If lp5523_init_engine is only used by lp5523_probe then
annotate lp5523_init_engine with a matching annotation.

WARNING: drivers/net/ethernet/3com/3c509.o(.data+0xf0): 
Section mismatch in reference from the variable 
el3_eisa_driver to the function 
.init.text:el3_eisa_probe()
The variable el3_eisa_driver references
the function __init el3_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: drivers/net/ethernet/3com/3c59x.o(.data+0x214): 
Section mismatch in reference from the variable 
vortex_eisa_driver to the function 
.init.text:vortex_eisa_probe()
The variable vortex_eisa_driver references
the function __init vortex_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: drivers/net/ethernet/8390/ne3210.o(.data+0x1c): 
Section mismatch in reference from the variable 
ne3210_eisa_driver to the function 
.init.text:ne3210_eisa_probe()
The variable ne3210_eisa_driver references
the function __init ne3210_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: drivers/net/ethernet/amd/depca.o(.data+0x1c): 
Section mismatch in reference from the variable 
depca_eisa_driver to the function 
.init.text:depca_eisa_probe()
The variable depca_eisa_driver references
the function __init depca_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: 
drivers/net/ethernet/amd/depca.o(.devinit.text+0x1b): 
Section mismatch in reference from the function 
depca_isa_probe() to the function 
.init.text:depca_common_init()
The function __devinit depca_isa_probe() references
a function __init depca_common_init().
If depca_common_init is only used by depca_isa_probe then
annotate depca_common_init with a matching annotation.

WARNING: 
drivers/net/ethernet/amd/depca.o(.devinit.text+0x2e): 
Section mismatch in reference from the function 
depca_isa_probe() to the function 
.init.text:depca_shmem_probe()
The function __devinit depca_isa_probe() references
a function __init depca_shmem_probe().
If depca_shmem_probe is only used by depca_isa_probe then
annotate depca_shmem_probe with a matching annotation.

WARNING: 
drivers/net/ethernet/amd/depca.o(.devinit.text+0x6a): 
Section mismatch in reference from the function 
depca_isa_probe() to the function 
.init.text:depca_hw_init()
The function __devinit depca_isa_probe() references
a function __init depca_hw_init().
If depca_hw_init is only used by depca_isa_probe then
annotate depca_hw_init with a matching annotation.

WARNING: 
drivers/net/ethernet/dec/tulip/de4x5.o(.data+0x94): 
Section mismatch in reference from the variable 
de4x5_eisa_driver to the function 
.init.text:de4x5_eisa_probe()
The variable de4x5_eisa_driver references
the function __init de4x5_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: drivers/net/ethernet/hp/hp100.o(.data+0x38): 
Section mismatch in reference from the variable 
hp100_eisa_driver to the function 
.init.text:hp100_eisa_probe()
The variable hp100_eisa_driver references
the function __init hp100_eisa_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, 
*_console

WARNING: 
drivers/staging/ipack/bridges/tpci200.o(.data+0x1c): 
Section mismatch in reference from the variable 
tpci200_pci_drv to the function 
.devexit.text:tpci200_pci_remove()
The variable tpci200_pci_drv references
the function __devexit tpci200_pci_remove()
If the reference is valid then annotate the
variable with __exit* (see linux/init.h) or name the 
variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, 
*_probe_one, *_console

WARNING: drivers/usb/gadget/g_audio.o(.text+0x6ba): 
Section mismatch in reference from the function 
audio_bind_config() to the function 
.init.text:afunc_bind()
The function audio_bind_config() references
the function __init afunc_bind().
This is often because audio_bind_config lacks a __init
annotation or the annotation of afunc_bind is wrong.

WARNING: drivers/usb/gadget/g_audio.o(.text+0xdd9): 
Section mismatch in reference from the function 
alsa_uac2_init() to the function 
.devinit.text:snd_uac2_probe()
The function alsa_uac2_init() references
the function __devinit snd_uac2_probe().
This is often because alsa_uac2_init lacks a __devinit
annotation or the annotation of snd_uac2_probe is wrong.

WARNING: drivers/usb/gadget/g_audio.o(.text+0xde9): 
Section mismatch in reference from the function 
alsa_uac2_init() to the function 
.devexit.text:snd_uac2_remove()
The function alsa_uac2_init() references a function in an 
exit section.
Often the function snd_uac2_remove() has valid usage 
outside the exit section
and the fix is to remove the __devexit annotation of 
snd_uac2_remove.

WARNING: drivers/usb/gadget/g_multi.o(.text+0xbcd): 
Section mismatch in reference from the function 
cdc_config_register() to the function 
.init.text:cdc_do_config()
The function cdc_config_register() references
the function __init cdc_do_config().
This is often because cdc_config_register lacks a __init
annotation or the annotation of cdc_do_config is wrong.

WARNING: drivers/usb/gadget/g_multi.o(.text+0xbfe): 
Section mismatch in reference from the function 
rndis_config_register() to the function 
.init.text:rndis_do_config()
The function rndis_config_register() references
the function __init rndis_do_config().
This is often because rndis_config_register lacks a __init
annotation or the annotation of rndis_do_config is wrong.

WARNING: drivers/usb/serial/mos7840.o(.data+0x4): Section 
mismatch in reference from the variable 
moschip7840_4port_device to the variable 
.devinit.rodata:id_table
The variable moschip7840_4port_device references
the variable __devinitconst id_table
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or 
name the variable:
*driver, *_template, *_timer, *_sht, *_ops, *_probe, 
*_probe_one, *_console

WARNING: 
drivers/watchdog/ie6xx_wdt.o(.devinit.text+0x122): Section 
mismatch in reference from the function ie6xx_wdt_probe() 
to the function .devexit.text:ie6xx_wdt_debugfs_exit()
The function __devinit ie6xx_wdt_probe() references
a function __devexit ie6xx_wdt_debugfs_exit().
This is often seen when error handling in the init 
function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
ie6xx_wdt_debugfs_exit() so it may be used outside an exit 
section.

WARNING: sound/pci/hda/snd-hda-intel.o(.text+0x1201): 
Section mismatch in reference from the function 
azx_first_init() to the function 
.devinit.text:azx_init_stream()
The function azx_first_init() references
the function __devinit azx_init_stream().
This is often because azx_first_init lacks a __devinit
annotation or the annotation of azx_init_stream is wrong.

WARNING: sound/pci/hda/snd-hda-intel.o(.text+0x1f87): 
Section mismatch in reference from the function 
azx_probe_continue() to the function 
.devinit.text:azx_codec_configure()
The function azx_probe_continue() references
the function __devinit azx_codec_configure().
This is often because azx_probe_continue lacks a __devinit
annotation or the annotation of azx_codec_configure is 
wrong.

WARNING: sound/pci/hda/snd-hda-intel.o(.text+0x1f9e): 
Section mismatch in reference from the function 
azx_probe_continue() to the function 
.devinit.text:azx_mixer_create()
The function azx_probe_continue() references
the function __devinit azx_mixer_create().
This is often because azx_probe_continue lacks a __devinit
annotation or the annotation of azx_mixer_create is wrong.




---
Professional hosting for everyone - http://www.host.ru
