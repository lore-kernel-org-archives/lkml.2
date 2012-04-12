Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761804Ab2DLCXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 22:23:41 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:64277 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752942Ab2DLCXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 22:23:38 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: YOUR DRIVER ? CHECK / FIX IT !!  trace btrfs cifs ubifs atm
 drbd nouveau radeon udl hid  i2c mlx4 keyboard tc3589x cma3000 gigaset
 isdn mISDN icn sc mca-legacy.h md raid10.c dvb-usb radio wl128x mfd
 wm8994-core.c twl4030-madc.c ti-st apds990x.c mmc alteon ethernet-amd
 nmclan_cs broadcom bnx2x brocade ethernet-dec ewrk3.c i825xx tokenring
 ibmtr_cs wireless-b43 brcm80211 ipw2x00 rt2x00 rtlwifi wl12xx of_net.h
 of_mtd.h of_mtd.c parport_pc.c intel_oaktrail.c rtc-m41t80 isci mvsas
 advansys dpt_i2o aic7xxx_old scsi fdomain.c g_NCR5380.c dtc.c initio.c
 stex.c  android-persistent_ram comedi vmk80xx iio dac ad5064.c lirc
 rtl8192e rtl8712 vme vme_pio2 wlags49_h2  zsmalloc ifx6x60.c
 vt-keyboard.c usb-gadget xhci musb otg twl6030-usb ab8500-usb
 video-via video-i740fb video/udlfb sound-core ctxfi-ctvmem soc-codecs
 wm8996 net-bridge br_netfilter ceph ceph_fs ieee802154 6lowpan
 ip_tables.c ipt_ULOG.c arp_tables ip6_tables mac80211-mlme.c xt_time
 sm_statefuns
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Wed, 11 Apr 2012 22:27:33 -0400
Message-ID: <web-724459719@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a list of compilation warnings and section 
mismatchs.

It could be checked and, if the case, corrected.

One never know, if such uncleannesses can result to small 
errors or side-effects difficult to discover.

wl

==============

kernel/trace/trace.c:3755: warning: 'page2' may be used 
uninitialized in this function
fs/btrfs/file-item.c:717: warning: comparison of distinct 
pointer types lacks a cast
fs/btrfs/file-item.c:767: warning: comparison of distinct 
pointer types lacks a cast
fs/btrfs/file-item.c:808: warning: comparison of distinct 
pointer types lacks a cast
fs/btrfs/file-item.c:808: warning: comparison of distinct 
pointer types lacks a cast
fs/btrfs/extent_io.h:279: warning: 'extent_buffer_page' 
declared inline after being called
fs/btrfs/extent_io.h:279: warning: previous declaration of 
'extent_buffer_page' was here
fs/btrfs/extent_io.h:278: warning: 'num_extent_pages' 
declared inline after being called
fs/btrfs/extent_io.h:278: warning: previous declaration of 
'num_extent_pages' was here
fs/cifs/connect.c:3681: warning: 'tcon' may be used 
uninitialized in this function
fs/cifs/connect.c:3680: warning: 'pSesInfo' may be used 
uninitialized in this function
fs/cifs/connect.c:3679: warning: 'xid' may be used 
uninitialized in this function
fs/ubifs/dir.c:980: warning: 'saved_nlink' may be used 
uninitialized in this function
drivers/atm/nicstar.c:957: warning: 'err' may be used 
uninitialized in this function
drivers/block/drbd/drbd_int.h:2233: warning: comparison is 
always false due to limited range of data type
drivers/block/drbd/drbd_int.h:2233: warning: comparison is 
always false due to limited range of data type
drivers/block/drbd/drbd_int.h:2233: warning: comparison is 
always false due to limited range of data type
drivers/block/drbd/drbd_int.h:2233: warning: comparison is 
always false due to limited range of data type
drivers/block/drbd/drbd_int.h:2233: warning: comparison is 
always false due to limited range of data type
drivers/block/drbd/drbd_int.h:2233: warning: comparison is 
always false due to limited range of data type
drivers/block/drbd/drbd_int.h:2233: warning: comparison is 
always false due to limited range of data type
drivers/block/drbd/drbd_int.h:2233: warning: comparison is 
always false due to limited range of data type
drivers/gpu/drm/nouveau/nv50_display.c:679: warning: 'mc' 
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
drivers/i2c/busses/i2c-pxa.c:1254: warning: unused 
variable 'i2c'
drivers/infiniband/hw/mlx4/qp.c:1366: warning: 'vlan' may 
be used uninitialized in this function
drivers/input/keyboard/tc3589x-keypad.c:107: warning: 
comparison is always false due to limited range of data 
type
drivers/input/keyboard/tc3589x-keypad.c:108: warning: 
comparison is always false due to limited range of data 
type
drivers/input/misc/cma3000_d0x.c:321: warning: comparison 
is always false due to limited range of data type
drivers/isdn/gigaset/capi.c:303: warning: 'format_ie' 
defined but not used
drivers/isdn/hardware/mISDN/hfcpci.c:2319: warning: 
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
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
drivers/md/raid10.c:681: warning: 'rdev' may be used 
uninitialized in this function
drivers/media/dvb/dvb-usb/lmedm04.c:383: warning: 'ret' is 
used uninitialized in this function
drivers/media/dvb/dvb-usb/mxl111sf.c:343: warning: unused 
variable 'tmp'
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
drivers/misc/ti-st/st_core.c:639: warning: comparison is 
always false due to limited range of data type
drivers/misc/apds990x.c:703: warning: comparison is always 
false due to limited range of data type
drivers/mmc/card/block.c:876: warning: 'arg' may be used 
uninitialized in this function
drivers/mmc/card/block.c:876: warning: 'nr' may be used 
uninitialized in this function
drivers/mmc/card/block.c:876: warning: 'from' may be used 
uninitialized in this function
drivers/mmc/card/block.c:830: warning: 'arg' may be used 
uninitialized in this function
drivers/mmc/card/block.c:830: warning: 'nr' may be used 
uninitialized in this function
drivers/mmc/card/block.c:830: warning: 'from' may be used 
uninitialized in this function
drivers/mtd/devices/doc2001plus.c:750: warning: passing 
argument 2 of 'MemWriteDOC' discards qualifiers from 
pointer target type
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
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
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:2780: 
warning: comparison of distinct pointer types lacks a cast
drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:1541: 
warning: comparison of distinct pointer types lacks a cast
drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c:941: 
warning: 'val' may be used uninitialized in this function
drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c:976: 
warning: 'val' may be used uninitialized in this function
drivers/net/ethernet/brocade/bna/bnad.c:2812: warning: 
comparison is always true due to limited range of data 
type
drivers/net/ethernet/dec/ewrk3.c:1914: warning: return 
from incompatible pointer type
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
drivers/net/ethernet/i825xx/3c523.c:1145: warning: passing 
argument 2 of 'skb_copy_from_linear_data' discards 
qualifiers from pointer target type
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
drivers/net/tokenring/ibmtr_cs.c:194: warning: 
'pcmcia_request_exclusive_irq' is deprecated (declared at 
include/pcmcia/ds.h:203)
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
drivers/net/wireless/b43/phy_n.c:2576: warning: 'idx' may 
be used uninitialized in this function
drivers/net/wireless/brcm80211/brcmsmac/main.c:5583: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/brcm80211/brcmsmac/main.c:5683: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/brcm80211/brcmsmac/aiutils.c:1159: 
warning: 'val' is used uninitialized in this function
drivers/net/wireless/ipw2x00/libipw_wx.c:526: warning: 
unused variable 'dev'
drivers/net/wireless/iwlwifi/iwl-mac80211.c:440: warning: 
unused variable 'img'
drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:786: 
warning: passing argument 2 of 'dma_map_single_attrs' 
discards qualifiers from pointer target type
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'gf40_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'gf20_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'mm40_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'mm20_mode' may be used uninitialized in this function
drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:906: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/rtlwifi/rtl8192de/dm.c:1052: warning: 
comparison is always false due to limited range of data 
type
drivers/net/wireless/rtlwifi/rtl8192de/trx.c:124: warning: 
'rx_pwr_all' may be used uninitialized in this function
drivers/net/wireless/wl12xx/tx.c:795: warning: comparison 
is always true due to limited range of data type
include/linux/of_net.h:12: warning: type qualifiers 
ignored on function return type
drivers/of/of_net.c:42: warning: type qualifiers ignored 
on function return type
include/linux/of_mtd.h:14: warning: type qualifiers 
ignored on function return type
drivers/of/of_mtd.c:36: warning: type qualifiers ignored 
on function return type
drivers/parport/parport_pc.c:635: warning: passing 
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
drivers/scsi/isci/port.c:1743: warning: 'iport' may be 
used uninitialized in this function
drivers/scsi/mvsas/mv_sas.c:888: warning: unused variable 
'dev'
drivers/scsi/advansys.c:71:2: warning: #warning this 
driver is still not properly converted to the DMA API
drivers/scsi/dpt_i2o.c:183: warning: 'dptids' defined but 
not used
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
drivers/scsi/aic7xxx_old.c:8484: warning: passing argument 
3 of 'pci_free_consistent' discards qualifiers from 
pointer target type
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
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
drivers/staging/android/persistent_ram.c:426: warning: 
format '%ld' expects type 'long int', but argument 2 has 
type 'size_t'
drivers/staging/android/persistent_ram.c:426: warning: 
format '%ld' expects type 'long int', but argument 3 has 
type 'size_t'
drivers/staging/android/persistent_ram.c:430: warning: 
format '%ld' expects type 'long int', but argument 2 has 
type 'size_t'
drivers/staging/android/persistent_ram.c:430: warning: 
format '%ld' expects type 'long int', but argument 3 has 
type 'size_t'
drivers/staging/android/alarm.c:344: warning: format '%ld' 
expects type 'long int', but argument 2 has type 'int'
drivers/staging/android/alarm.c:367: warning: format '%ld' 
expects type 'long int', but argument 2 has type 'int'
drivers/staging/comedi/drivers/vmk80xx.c:962: warning: 
'reg[0]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:962: warning: 
'reg[1]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:588: warning: 
'reg[0]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:588: warning: 
'reg[1]' may be used uninitialized in this function
drivers/staging/iio/dac/ad5064.c:433: warning: type 
qualifiers ignored on function return type
drivers/staging/media/lirc/lirc_imon.c:74: warning: 
'imon_init' declared 'static' but never defined
drivers/staging/media/lirc/lirc_imon.c:75: warning: 
'imon_exit' declared 'static' but never defined
drivers/staging/media/lirc/lirc_sasem.c:84: warning: 
'sasem_init' declared 'static' but never defined
drivers/staging/media/lirc/lirc_sasem.c:85: warning: 
'sasem_exit' declared 'static' but never defined
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
drivers/staging/rtl8712/rtl8712_recv.c:750: warning: 
'rx_pwr_all' may be used uninitialized in this function
drivers/staging/vme/devices/vme_pio2_core.c:512: warning: 
return from incompatible pointer type
drivers/staging/vme/devices/vme_pio2_core.c:516: warning: 
return from incompatible pointer type
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
drivers/staging/wlan-ng/cfg80211.c:404: warning: ignoring 
return value of 'cfg80211_inform_bss', declared with 
attribute warn_unused_result
drivers/staging/zsmalloc/zsmalloc-main.c:366: warning: 
'prev_page' may be used uninitialized in this function
drivers/tty/serial/ifx6x60.c:1357: warning: passing 
argument 1 of 'spi_unregister_driver' discards qualifiers 
from pointer target type
drivers/tty/vt/keyboard.c:742: warning: comparison is 
always true due to limited range of data type
drivers/usb/gadget/inode.c:1577: warning: label 'restart' 
defined but not used
drivers/usb/host/xhci-mem.c:799: warning: 'tt_info' may be 
used uninitialized in this function
drivers/usb/host/xhci-ring.c:1280: warning: 'hcd' may be 
used uninitialized in this function
drivers/usb/musb/musb_gadget.c:1103: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/musb/musb_gadget.c:1143: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/musb/musb_host.c:599: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/musb/musb_host.c:774: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/otg/twl6030-usb.c:131: warning: comparison is 
always true due to limited range of data type
drivers/usb/otg/ab8500-usb.c:156: warning: 'event' may be 
used uninitialized in this function
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
sound/soc/codecs/wm8996.c:1728: warning: 'bclk_reg' may be 
used uninitialized in this function
net/bridge/br_netfilter.c:816: warning: passing argument 4 
of 'NF_HOOK' discards qualifiers from pointer target type
net/bridge/br_netfilter.c:816: warning: passing argument 5 
of 'NF_HOOK' discards qualifiers from pointer target type
net/ceph/ceph_fs.c:33: warning: 'mode' may be used 
uninitialized in this function
net/ieee802154/6lowpan.c:406: warning: passing argument 3 
of 'lowpan_raw_dump_inline' discards qualifiers from 
pointer target type
net/ieee802154/6lowpan.c:419: warning: passing argument 3 
of 'lowpan_raw_dump_inline' discards qualifiers from 
pointer target type
net/ipv4/netfilter/ip_tables.c:183: warning: passing 
argument 1 of 'ipt_get_target' discards qualifiers from 
pointer target type
net/ipv4/netfilter/ipt_ULOG.c:208: warning: passing 
argument 1 of '__net_timestamp' discards qualifiers from 
pointer target type
net/ipv4/netfilter/arp_tables.c:234: warning: passing 
argument 1 of 'arpt_get_target' discards qualifiers from 
pointer target type
net/ipv6/netfilter/ip6_tables.c:221: warning: passing 
argument 1 of 'ip6t_get_target' discards qualifiers from 
pointer target type
net/mac80211/mlme.c:3060: warning: 'sta' may be used 
uninitialized in this function
net/netfilter/xt_time.c:171: warning: passing argument 1 
of '__net_timestamp' discards qualifiers from pointer 
target type
net/sctp/sm_statefuns.c:2053: warning: passing argument 1 
of 'SCTP_ASOC' discards qualifiers from pointer target 
type
WARNING: drivers/block/built-in.o(.devinit.text+0x229): 
Section mismatch in reference from the function 
cpqarray_register_ctlr() to the function 
.init.text:ida_procinit()
WARNING: drivers/pci/built-in.o(.text+0x1bcf8): Section 
mismatch in reference from the function 
cpqhp_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/pci/built-in.o(.text+0x1cc02): Section 
mismatch in reference from the function 
bus_structure_fixup() to the function 
.devinit.text:pci_scan_bus()
WARNING: drivers/pci/built-in.o(.text+0x1cd22): Section 
mismatch in reference from the function 
ibm_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/scsi/NCR_Q720_mod.o(.data+0x24): Section 
mismatch in reference from the variable NCR_Q720_driver to 
the function .init.text:NCR_Q720_probe()
WARNING: drivers/scsi/built-in.o(.data+0x2bc0): Section 
mismatch in reference from the variable sim710_mca_driver 
to the function .init.text:sim710_mca_probe()
WARNING: drivers/scsi/built-in.o(.data+0x2bfc): Section 
mismatch in reference from the variable sim710_eisa_driver 
to the function .init.text:sim710_eisa_probe()
WARNING: drivers/scsi/built-in.o(.data+0x684c): Section 
mismatch in reference from the variable NCR_Q720_driver to 
the function .init.text:NCR_Q720_probe()
WARNING: drivers/usb/gadget/g_audio.o(.text+0x6f9): 
Section mismatch in reference from the function 
audio_bind_config() to the function 
.init.text:afunc_bind()
WARNING: drivers/usb/gadget/g_audio.o(.text+0xe18): 
Section mismatch in reference from the function 
alsa_uac2_init() to the function 
.devinit.text:snd_uac2_probe()
WARNING: drivers/usb/gadget/g_audio.o(.text+0xe28): 
Section mismatch in reference from the function 
alsa_uac2_init() to the function 
.devexit.text:snd_uac2_remove()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x961): 
Section mismatch in reference from the function 
rndis_config_register() to the function 
.init.text:rndis_do_config()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x992): 
Section mismatch in reference from the function 
cdc_config_register() to the function 
.init.text:cdc_do_config()
WARNING: drivers/usb/host/xhci-hcd.o(.init.text+0x3c): 
Section mismatch in reference from the function 
xhci_hcd_init() to the function 
.exit.text:xhci_unregister_pci()
WARNING: drivers/usb/host/built-in.o(.init.text+0x1fd): 
Section mismatch in reference from the function 
xhci_hcd_init() to the function 
.exit.text:xhci_unregister_pci()
WARNING: drivers/usb/built-in.o(.init.text+0x537): Section 
mismatch in reference from the function xhci_hcd_init() to 
the function .exit.text:xhci_unregister_pci()
WARNING: drivers/built-in.o(.text+0x2497c): Section 
mismatch in reference from the function 
cpqhp_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/built-in.o(.text+0x25886): Section 
mismatch in reference from the function 
bus_structure_fixup() to the function 
.devinit.text:pci_scan_bus()
WARNING: drivers/built-in.o(.text+0x259a6): Section 
mismatch in reference from the function 
ibm_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/built-in.o(.init.text+0x2f171): Section 
mismatch in reference from the function xhci_hcd_init() to 
the function .exit.text:xhci_unregister_pci()
WARNING: drivers/built-in.o(.devinit.text+0x25c0c): 
Section mismatch in reference from the function 
cpqarray_register_ctlr() to the function 
.init.text:ida_procinit()
WARNING: drivers/built-in.o(.data+0x44200): Section 
mismatch in reference from the variable sim710_mca_driver 
to the function .init.text:sim710_mca_probe()
WARNING: drivers/built-in.o(.data+0x4423c): Section 
mismatch in reference from the variable sim710_eisa_driver 
to the function .init.text:sim710_eisa_probe()
WARNING: drivers/built-in.o(.data+0x47e8c): Section 
mismatch in reference from the variable NCR_Q720_driver to 
the function .init.text:NCR_Q720_probe()
WARNING: vmlinux.o(.text+0x60e028): Section mismatch in 
reference from the function cpqhp_configure_device() to 
the function .devinit.text:pci_do_scan_bus()
WARNING: vmlinux.o(.text+0x60ef32): Section mismatch in 
reference from the function bus_structure_fixup() to the 
function .devinit.text:pci_scan_bus()
WARNING: vmlinux.o(.text+0x60f052): Section mismatch in 
reference from the function ibm_configure_device() to the 
function .devinit.text:pci_do_scan_bus()
WARNING: vmlinux.o(.init.text+0x56ee8): Section mismatch 
in reference from the function xhci_hcd_init() to the 
function .exit.text:xhci_unregister_pci()
WARNING: vmlinux.o(.devinit.text+0x266f2): Section 
mismatch in reference from the function 
cpqarray_register_ctlr() to the function 
.init.text:ida_procinit()
WARNING: vmlinux.o(.data+0x79f80): Section mismatch in 
reference from the variable sim710_mca_driver to the 
function .init.text:sim710_mca_probe()
WARNING: vmlinux.o(.data+0x79fbc): Section mismatch in 
reference from the variable sim710_eisa_driver to the 
function .init.text:sim710_eisa_probe()
WARNING: vmlinux.o(.data+0x7dc0c): Section mismatch in 
reference from the variable NCR_Q720_driver to the 
function .init.text:NCR_Q720_probe()
WARNING: drivers/leds/leds-lp5523.o(.devinit.text+0x262): 
Section mismatch in reference from the function 
lp5523_probe() to the function 
.init.text:lp5523_init_engine()
WARNING: drivers/net/ethernet/3com/3c509.o(.data+0xf0): 
Section mismatch in reference from the variable 
el3_eisa_driver to the function 
.init.text:el3_eisa_probe()
WARNING: drivers/net/ethernet/3com/3c509.o(.data+0x110): 
Section mismatch in reference from the variable 
el3_mca_driver to the variable 
.init.data:el3_mca_adapter_ids
WARNING: drivers/net/ethernet/3com/3c509.o(.data+0x134): 
Section mismatch in reference from the variable 
el3_mca_driver to the function .init.text:el3_mca_probe()
WARNING: drivers/net/ethernet/3com/3c59x.o(.data+0x214): 
Section mismatch in reference from the variable 
vortex_eisa_driver to the function 
.init.text:vortex_eisa_probe()
WARNING: drivers/net/ethernet/8390/ne3210.o(.data+0x1c): 
Section mismatch in reference from the variable 
ne3210_eisa_driver to the function 
.init.text:ne3210_eisa_probe()
WARNING: drivers/net/ethernet/8390/smc-mca.o(.data+0x0): 
Section mismatch in reference from the variable 
ultra_driver to the variable 
.init.data:smc_mca_adapter_ids
WARNING: drivers/net/ethernet/8390/smc-mca.o(.data+0x24): 
Section mismatch in reference from the variable 
ultra_driver to the function .init.text:ultramca_probe()
WARNING: drivers/net/ethernet/amd/depca.o(.data+0x24): 
Section mismatch in reference from the variable 
depca_mca_driver to the function 
.init.text:depca_mca_probe()
WARNING: drivers/net/ethernet/amd/depca.o(.data+0x60): 
Section mismatch in reference from the variable 
depca_eisa_driver to the function 
.init.text:depca_eisa_probe()
WARNING: 
drivers/net/ethernet/amd/depca.o(.devinit.text+0x1b): 
Section mismatch in reference from the function 
depca_isa_probe() to the function 
.init.text:depca_common_init()
WARNING: 
drivers/net/ethernet/amd/depca.o(.devinit.text+0x2e): 
Section mismatch in reference from the function 
depca_isa_probe() to the function 
.init.text:depca_shmem_probe()
WARNING: 
drivers/net/ethernet/amd/depca.o(.devinit.text+0x6a): 
Section mismatch in reference from the function 
depca_isa_probe() to the function 
.init.text:depca_hw_init()
WARNING: 
drivers/net/ethernet/dec/tulip/de4x5.o(.data+0x94): 
Section mismatch in reference from the variable 
de4x5_eisa_driver to the function 
.init.text:de4x5_eisa_probe()
WARNING: drivers/net/ethernet/hp/hp100.o(.data+0x38): 
Section mismatch in reference from the variable 
hp100_eisa_driver to the function 
.init.text:hp100_eisa_probe()
WARNING: 
drivers/net/ethernet/natsemi/ibmlana.o(.data+0x0): Section 
mismatch in reference from the variable ibmlana_driver to 
the variable .init.data:ibmlana_adapter_ids
WARNING: drivers/net/tokenring/madgemc.o(.data+0x0): 
Section mismatch in reference from the variable 
madgemc_driver to the variable 
.init.data:madgemc_adapter_ids
WARNING: 
drivers/staging/comedi/drivers/s626.o(.text+0x1f16): 
Section mismatch in reference from the function 
s626_attach() to the variable 
.devinit.rodata:s626_pci_table
WARNING: drivers/usb/gadget/g_audio.o(.text+0x6f9): 
Section mismatch in reference from the function 
audio_bind_config() to the function 
.init.text:afunc_bind()
WARNING: drivers/usb/gadget/g_audio.o(.text+0xe18): 
Section mismatch in reference from the function 
alsa_uac2_init() to the function 
.devinit.text:snd_uac2_probe()
WARNING: drivers/usb/gadget/g_audio.o(.text+0xe28): 
Section mismatch in reference from the function 
alsa_uac2_init() to the function 
.devexit.text:snd_uac2_remove()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x961): 
Section mismatch in reference from the function 
rndis_config_register() to the function 
.init.text:rndis_do_config()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x992): 
Section mismatch in reference from the function 
cdc_config_register() to the function 
.init.text:cdc_do_config()
---
Professional hosting for everyone - http://www.host.ru
