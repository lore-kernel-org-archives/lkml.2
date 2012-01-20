Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab2ATTuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 14:50:50 -0500
Received: from zfrontend2.aha.ru ([195.2.83.148]:42411 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754533Ab2ATTup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 14:50:45 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: 3.3-rc1: compiling problems  nvme , l2cap_sock ,
 mc13892-regulator , and snd-pcsp don't work 
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 20 Jan 2012 14:52:37 -0400
Message-ID: <web-682421181@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-rc1 compiling problems


1) enabled and compiled as embedded, snd-pcsp dont work

2) nvme  dont compile

3) /include/bluetooth/l2cap_core   dont compile because 
l2cap_sock.connect is wrongly defined as "inline integer" 
,
    it compiles without the inline

4) mc13892-regulator   dont link, something undefined

5) plenty warnings and section mismatchs


Werner Landgraf
Linux SYS


===========================================================================

   CC      fs/xfs/xfs_error.o
   CC      drivers/acpi/acpica/utxferror.o
drivers/block/nvme.c:999: error: implicit declaration of 
function 'writeq'
drivers/block/nvme.c:1003: error: implicit declaration of 
function 'readq'
   CC      drivers/scsi/scsi_error.o
This is often seen when error handling in the init 
function
   CC      arch/x86/math-emu/errors.o
   CC [M]  net/9p/error.o
   CC      net/rxrpc/ar-error.o
make[2]: Target `arch/x86/boot/compressed/vmlinux' not 
remade because of errors.
make[1]: Target `arch/x86/boot/bzImage' not remade because 
of errors.
This is often seen when error handling in the init 
function
arch/x86/kvm/pmu.c:368: warning: integer constant is too 
large for 'long' type
kernel/trace/trace.c:3697: warning: 'page2' may be used 
uninitialized in this function
fs/btrfs/extent-tree.c:3314: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:3335: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:3698: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:3769: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:3915: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:4134: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:4141: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:4194: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:4713: warning: cast from pointer to 
integer of different size
fs/btrfs/inode-map.c:441: warning: cast from pointer to 
integer of different size
fs/btrfs/inode-map.c:503: warning: cast from pointer to 
integer of different size
fs/btrfs/transaction.c:330: warning: cast from pointer to 
integer of different size
fs/btrfs/backref.c:300: warning: 'ret' may be used 
uninitialized in this function
fs/btrfs/backref.c:395: warning: 'ret' may be used 
uninitialized in this function
fs/cifs/connect.c:3210: warning: 'tcon' may be used 
uninitialized in this function
fs/cifs/connect.c:3209: warning: 'pSesInfo' may be used 
uninitialized in this function
fs/cifs/connect.c:3208: warning: 'xid' may be used 
uninitialized in this function
fs/nfs/callback_proc.c:116: warning: 'ino' may be used 
uninitialized in this function
fs/nfs/callback_proc.c:115: warning: 'lo' may be used 
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
drivers/gpu/drm/nouveau/nv50_display.c:656: warning: 'mc' 
may be used uninitialized in this function
drivers/gpu/drm/nouveau/nv50_pm.c:75: warning: 'id' may be 
used uninitialized in this function
drivers/gpu/drm/sis/sis_drv.c:53: warning: 'ret' is used 
uninitialized in this function
drivers/hid/hid-wiimote-debug.c:40: warning: 'size' may be 
used uninitialized in this function
drivers/i2c/busses/i2c-pxa.c:1202: warning: unused 
variable 'i2c'
drivers/infiniband/hw/mlx4/qp.c:1366: warning: 'vlan' may 
be used uninitialized in this function
drivers/input/evdev.c:389: warning: 'retval' may be used 
uninitialized in this function
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
drivers/isdn/hardware/mISDN/hfcsusb.c:39: warning: 
'hfcsusb_rev' defined but not used
drivers/isdn/hardware/mISDN/netjet.c:319: warning: 
comparison is always false due to limited range of data 
type
drivers/isdn/icn/icn.c:721:4: warning: #warning TODO test 
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
drivers/leds/leds-lp5521.c:648: warning: 'ret' may be used 
uninitialized in this function
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
drivers/md/raid10.c:624: warning: 'rdev' may be used 
uninitialized in this function
drivers/media/radio/wl128x/fmdrv_common.c:745: warning: 
comparison is always false due to limited range of data 
type
drivers/media/radio/wl128x/fmdrv_rx.c:308: warning: 
comparison is always false due to limited range of data 
type
drivers/media/video/cx18/cx18-driver.c:113: warning: 
return from incompatible pointer type
drivers/media/video/cx18/cx18-driver.c:113: warning: 
initialization from incompatible pointer type
drivers/media/video/ivtv/ivtv-driver.c:142: warning: 
return from incompatible pointer type
drivers/media/video/ivtv/ivtv-driver.c:142: warning: 
initialization from incompatible pointer type
drivers/media/video/w9966.c:136: warning: return from 
incompatible pointer type
drivers/misc/ti-st/st_core.c:639: warning: comparison is 
always false due to limited range of data type
drivers/misc/apds990x.c:703: warning: comparison is always 
false due to limited range of data type
drivers/mmc/card/block.c:877: warning: 'arg' may be used 
uninitialized in this function
drivers/mmc/card/block.c:877: warning: 'nr' may be used 
uninitialized in this function
drivers/mmc/card/block.c:877: warning: 'from' may be used 
uninitialized in this function
drivers/mmc/card/block.c:831: warning: 'arg' may be used 
uninitialized in this function
drivers/mmc/card/block.c:831: warning: 'nr' may be used 
uninitialized in this function
drivers/mmc/card/block.c:831: warning: 'from' may be used 
uninitialized in this function
drivers/mtd/devices/doc2001plus.c:757: warning: passing 
argument 2 of 'MemWriteDOC' discards qualifiers from 
pointer target type
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
drivers/net/ethernet/alteon/acenic.c:754: warning: passing 
argument 3 of 'pci_free_consistent' discards qualifiers 
from pointer target type
drivers/net/ethernet/alteon/acenic.c:759: warning: passing 
argument 3 of 'pci_free_consistent' discards qualifiers 
from pointer target type
drivers/net/ethernet/alteon/acenic.c:765: warning: passing 
argument 3 of 'pci_free_consistent' discards qualifiers 
from pointer target type
drivers/net/ethernet/amd/nmclan_cs.c:626: warning: 
'pcmcia_request_exclusive_irq' is deprecated (declared at 
include/pcmcia/ds.h:203)
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:2784: 
warning: comparison of distinct pointer types lacks a cast
drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:1530: 
warning: comparison of distinct pointer types lacks a cast
drivers/net/ethernet/brocade/bna/bnad.c:2812: warning: 
comparison is always true due to limited range of data 
type
drivers/net/ethernet/dec/ewrk3.c:1912: warning: return 
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
drivers/net/ethernet/marvell/sky2.c:1762: warning: 'imask' 
is used uninitialized in this function
drivers/net/hamradio/baycom_par.c:483: warning: return 
from incompatible pointer type
drivers/net/hamradio/baycom_epp.c:1168: warning: return 
from incompatible pointer type
drivers/net/tokenring/ibmtr_cs.c:195: warning: 
'pcmcia_request_exclusive_irq' is deprecated (declared at 
include/pcmcia/ds.h:203)
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
drivers/net/wireless/ath/ath5k/base.c:84: warning: return 
from incompatible pointer type
drivers/net/wireless/brcm80211/brcmsmac/main.c:5582: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/brcm80211/brcmsmac/main.c:5682: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/brcm80211/brcmsmac/aiutils.c:1159: 
warning: 'val' is used uninitialized in this function
drivers/net/wireless/ipw2x00/libipw_wx.c:526: warning: 
unused variable 'dev'
drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:751: 
warning: passing argument 2 of 'dma_map_single_attrs' 
discards qualifiers from pointer target type
drivers/net/wireless/orinoco/orinoco_usb.c:1759: warning: 
'version' defined but not used
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'gf40_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'gf20_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'mm40_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'mm20_mode' may be used uninitialized in this function
drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:916: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/rtlwifi/rtl8192de/dm.c:1067: warning: 
comparison is always false due to limited range of data 
type
drivers/net/wireless/rtlwifi/rtl8192de/trx.c:124: warning: 
'rx_pwr_all' may be used uninitialized in this function
include/linux/of_net.h:12: warning: type qualifiers 
ignored on function return type
drivers/of/of_net.c:42: warning: type qualifiers ignored 
on function return type
drivers/parport/parport_pc.c:635: warning: passing 
argument 2 of 'dma_map_single_attrs' discards qualifiers 
from pointer target type
drivers/pci/hotplug/cpcihp_generic.c:219: warning: return 
from incompatible pointer type
drivers/platform/x86/intel_oaktrail.c:233: warning: 
comparison is always false due to limited range of data 
type
drivers/rtc/rtc-m41t80.c:217: warning: 
'm41t80_rtc_alarm_irq_enable' defined but not used
drivers/rtc/rtc-m41t80.c:239: warning: 
'm41t80_rtc_set_alarm' defined but not used
drivers/rtc/rtc-m41t80.c:309: warning: 
'm41t80_rtc_read_alarm' defined but not used
drivers/scsi/lpfc/lpfc_scsi.c:1309: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1335: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1346: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1369: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1380: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1414: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1436: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_debugfs.c:3946: warning: integer 
constant is too large for 'long' type
drivers/scsi/advansys.c:72:2: warning: #warning this 
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
drivers/scsi/fdomain.c:1775: warning: 'fdomain_pci_tbl' 
defined but not used
drivers/scsi/g_NCR5380.c:943: warning: 'id_table' defined 
but not used
drivers/scsi/dtc.c:180: warning: 'dtc_setup' defined but 
not used
drivers/scsi/initio.c:131: warning: 'i91u_pci_devices' 
defined but not used
drivers/scsi/stex.c:636: warning: passing argument 2 of 
'scsi_sg_copy_from_buffer' discards qualifiers from 
pointer target type
drivers/spi/spi-topcliff-pch.c:276: warning: 'bpw_len' may 
be used uninitialized in this function
drivers/spi/spi-topcliff-pch.c:276: warning: 'rx_index' 
may be used uninitialized in this function
drivers/spi/spi-topcliff-pch.c:276: warning: 'tx_index' 
may be used uninitialized in this function
drivers/staging/android/binder.c:106: warning: return from 
incompatible pointer type
drivers/staging/comedi/drivers/vmk80xx.c:962: warning: 
'reg[0]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:962: warning: 
'reg[1]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:588: warning: 
'reg[0]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:588: warning: 
'reg[1]' may be used uninitialized in this function
drivers/staging/iio/dac/ad5064.c:352: warning: type 
qualifiers ignored on function return type
drivers/staging/media/lirc/lirc_imon.c:74: warning: 
'imon_init' declared 'static' but never defined
drivers/staging/media/lirc/lirc_imon.c:75: warning: 
'imon_exit' declared 'static' but never defined
drivers/staging/media/lirc/lirc_sasem.c:84: warning: 
'sasem_init' declared 'static' but never defined
drivers/staging/media/lirc/lirc_sasem.c:85: warning: 
'sasem_exit' declared 'static' but never defined
drivers/staging/media/lirc/lirc_serial.c:1296: warning: 
return from incompatible pointer type
drivers/staging/rtl8192e/rtllib_softmac.c:2302: warning: 
'challenge' may be used uninitialized in this function
drivers/staging/rtl8192e/rtllib_softmac.c:2218: warning: 
'aid' may be used uninitialized in this function
drivers/staging/rtl8192e/rtllib_softmac.c:2218: warning: 
'aid' may be used uninitialized in this function
drivers/staging/rtl8192e/rtllib_softmac.c:2302: warning: 
'challenge' may be used uninitialized in this function
drivers/staging/rtl8192e/rtl819x_TSProc.c:321: warning: 
comparison is always true due to limited range of data 
type
drivers/staging/rtl8712/rtl8712_recv.c:752: warning: 
'rx_pwr_all' may be used uninitialized in this function
drivers/staging/usbip/usbip_common.c:770: warning: 'ret' 
is used uninitialized in this function
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
drivers/staging/wlags49_h2/wl_main.c:544: warning: 
comparison is always true due to limited range of data 
type
drivers/staging/wlags49_h25/../wlags49_h2/wl_wext.c:225: 
warning: comparison is always false due to limited range 
of data type
drivers/staging/wlags49_h25/../wlags49_h2/wl_wext.c:250: 
warning: comparison is always true due to limited range of 
data type
drivers/staging/wlags49_h25/../wlags49_h2/wl_main.c:544: 
warning: comparison is always true due to limited range of 
data type
drivers/staging/wlan-ng/cfg80211.c:404: warning: ignoring 
return value of 'cfg80211_inform_bss', declared with 
attribute warn_unused_result
drivers/tty/serial/ifx6x60.c:1357: warning: passing 
argument 1 of 'spi_unregister_driver' discards qualifiers 
from pointer target type
drivers/tty/vt/keyboard.c:736: warning: comparison is 
always true due to limited range of data type
drivers/usb/gadget/pch_udc.c:2867: warning: 'retval' may 
be used uninitialized in this function
drivers/usb/gadget/acm_ms.c:119: warning: return from 
incompatible pointer type
drivers/usb/gadget/acm_ms.c:119: warning: return from 
incompatible pointer type
drivers/usb/gadget/acm_ms.c:119: warning: return from 
incompatible pointer type
drivers/usb/gadget/acm_ms.c:119: warning: return from 
incompatible pointer type
drivers/usb/gadget/acm_ms.c:119: warning: return from 
incompatible pointer type
drivers/usb/gadget/mass_storage.c:94: warning: return from 
incompatible pointer type
drivers/usb/gadget/mass_storage.c:94: warning: return from 
incompatible pointer type
drivers/usb/gadget/mass_storage.c:94: warning: return from 
incompatible pointer type
drivers/usb/gadget/mass_storage.c:94: warning: return from 
incompatible pointer type
drivers/usb/gadget/mass_storage.c:94: warning: return from 
incompatible pointer type
drivers/usb/gadget/multi.c:147: warning: return from 
incompatible pointer type
drivers/usb/gadget/multi.c:147: warning: return from 
incompatible pointer type
drivers/usb/gadget/multi.c:147: warning: return from 
incompatible pointer type
drivers/usb/gadget/multi.c:147: warning: return from 
incompatible pointer type
drivers/usb/gadget/multi.c:147: warning: return from 
incompatible pointer type
drivers/usb/host/xhci-mem.c:685: warning: 'tt_info' may be 
used uninitialized in this function
drivers/usb/host/xhci-ring.c:1242: warning: 'hcd' may be 
used uninitialized in this function
drivers/usb/misc/emi26.c:40: warning: 'emi26_init' 
declared 'static' but never defined
drivers/usb/misc/emi26.c:41: warning: 'emi26_exit' 
declared 'static' but never defined
drivers/usb/misc/emi62.c:49: warning: 'emi62_init' 
declared 'static' but never defined
drivers/usb/misc/emi62.c:50: warning: 'emi62_exit' 
declared 'static' but never defined
drivers/usb/musb/musb_gadget.c:1085: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/musb/musb_gadget.c:1125: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/musb/musb_host.c:599: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/musb/musb_host.c:774: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/otg/ab8500-usb.c:156: warning: 'event' may be 
used uninitialized in this function
drivers/usb/serial/kobil_sct.c:719: warning: return from 
incompatible pointer type
drivers/video/via/hw.c:1423: warning: 'config.rshift' may 
be used uninitialized in this function
drivers/video/via/hw.c:1423: warning: 'config.divisor' may 
be used uninitialized in this function
drivers/video/via/hw.c:1423: warning: 'config.multiplier' 
may be used uninitialized in this function
drivers/video/udlfb.c:456: warning: passing argument 1 of 
'prefetch_range' discards qualifiers from pointer target 
type
sound/core/memory.c:74: warning: passing argument 1 of 
'copy_from_user' discards qualifiers from pointer target 
type
sound/isa/opti9xx/opti92x-ad1848.c:87: warning: return 
from incompatible pointer type
sound/isa/opti9xx/opti92x-ad1848.c:87: warning: return 
from incompatible pointer type
sound/isa/opti9xx/opti92x-ad1848.c:87: warning: return 
from incompatible pointer type
sound/pci/ctxfi/ctvmem.c:79: warning: 'entry' may be used 
uninitialized in this function
sound/pci/ctxfi/ctvmem.c:34: warning: 'entry' may be used 
uninitialized in this function
sound/soc/codecs/wm_hubs.c:119: warning: 'reg_r' may be 
used uninitialized in this function
sound/soc/codecs/wm_hubs.c:119: warning: 'reg_l' may be 
used uninitialized in this function
sound/soc/codecs/wm8996.c:1736: warning: 'bclk_reg' may be 
used uninitialized in this function
sound/soc/codecs/wm9090.c:496: warning: unused variable 
'ret'
sound/soc/codecs/wm9090.c:496: warning: unused variable 
'i'
sound/soc/codecs/wm9090.c:495: warning: unused variable 
'reg_cache'
sound/soc/codecs/wm9090.c:658: warning: unused variable 
'wm9090'
net/bluetooth/hci_core.c:2587: warning: return from 
incompatible pointer type
net/bluetooth/rfcomm/tty.c:218: warning: 'p' is used 
uninitialized in this function
net/bridge/br_netfilter.c:810: warning: passing argument 4 
of 'NF_HOOK' discards qualifiers from pointer target type
net/bridge/br_netfilter.c:810: warning: passing argument 5 
of 'NF_HOOK' discards qualifiers from pointer target type
net/ceph/ceph_fs.c:33: warning: 'mode' may be used 
uninitialized in this function
net/ieee802154/6lowpan.c:405: warning: passing argument 3 
of 'lowpan_raw_dump_inline' discards qualifiers from 
pointer target type
net/ieee802154/6lowpan.c:418: warning: passing argument 3 
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
net/netfilter/xt_time.c:171: warning: passing argument 1 
of '__net_timestamp' discards qualifiers from pointer 
target type
net/sctp/sm_statefuns.c:2053: warning: passing argument 1 
of 'SCTP_ASOC' discards qualifiers from pointer target 
type
WARNING: drivers/mfd/built-in.o(.text+0x842d): Section 
mismatch in reference from the function da9052_spi_probe() 
to the function .devinit.text:da9052_device_init()
WARNING: drivers/mtd/devices/built-in.o(.text+0x624f): 
Section mismatch in reference from the function 
doc_probe_device() to the function 
.init.text:doc_set_driver_info()
WARNING: drivers/mtd/built-in.o(.text+0x3588f): Section 
mismatch in reference from the function doc_probe_device() 
to the function .init.text:doc_set_driver_info()
WARNING: drivers/pci/built-in.o(.text+0x1b9dc): Section 
mismatch in reference from the function 
cpqhp_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/pci/built-in.o(.text+0x1c8e6): Section 
mismatch in reference from the function 
bus_structure_fixup() to the function 
.devinit.text:pci_scan_bus()
WARNING: drivers/pci/built-in.o(.text+0x1ca06): Section 
mismatch in reference from the function 
ibm_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/scsi/NCR_Q720_mod.o(.data+0x24): Section 
mismatch in reference from the variable NCR_Q720_driver to 
the function .init.text:NCR_Q720_probe()
WARNING: drivers/scsi/built-in.o(.data+0x2b74): Section 
mismatch in reference from the variable sim710_mca_driver 
to the function .init.text:sim710_mca_probe()
WARNING: drivers/scsi/built-in.o(.data+0x2bb0): Section 
mismatch in reference from the variable sim710_eisa_driver 
to the function .init.text:sim710_eisa_probe()
WARNING: drivers/scsi/built-in.o(.data+0x67ac): Section 
mismatch in reference from the variable NCR_Q720_driver to 
the function .init.text:NCR_Q720_probe()
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devexit.text+0x18): 
Section mismatch in reference from the function 
pio2_remove() to the function .exit.text:pio2_gpio_exit()
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x3bf): 
Section mismatch in reference from the function 
pio2_probe() to the function .init.text:pio2_gpio_init()
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x413): 
Section mismatch in reference from the function 
pio2_probe() to the function .exit.text:pio2_gpio_exit()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x96e): 
Section mismatch in reference from the function 
rndis_config_register() to the function 
.init.text:rndis_do_config()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x99f): 
Section mismatch in reference from the function 
cdc_config_register() to the function 
.init.text:cdc_do_config()
WARNING: drivers/leds/leds-lp5523.o(.devinit.text+0x262): 
Section mismatch in reference from the function 
lp5523_probe() to the function 
.init.text:lp5523_init_engine()
WARNING: drivers/misc/cs5535-mfgpt.o(.devinit.text+0x9a): 
Section mismatch in reference from the function 
cs5535_mfgpt_probe() to the function 
.init.text:scan_timers()
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
WARNING: drivers/spi/spi-topcliff-pch.o(.data+0x14): 
Section mismatch in reference from the variable 
pch_spi_pcidev to the function 
.devinit.text:pch_spi_probe()
WARNING: drivers/spi/spi-topcliff-pch.o(.data+0x18): 
Section mismatch in reference from the variable 
pch_spi_pcidev to the function 
.devexit.text:pch_spi_remove()
WARNING: 
drivers/staging/comedi/drivers/s626.o(.text+0x1f07): 
Section mismatch in reference from the function 
s626_attach() to the variable 
.devinit.rodata:s626_pci_table
WARNING: modpost: missing MODULE_LICENSE() in 
drivers/staging/media/go7007/go7007-usb.o
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devexit.text+0x18): 
Section mismatch in reference from the function 
pio2_remove() to the function .exit.text:pio2_gpio_exit()
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x3bf): 
Section mismatch in reference from the function 
pio2_probe() to the function .init.text:pio2_gpio_init()
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x413): 
Section mismatch in reference from the function 
pio2_probe() to the function .exit.text:pio2_gpio_exit()
WARNING: drivers/usb/gadget/g_ffs.o(.text+0x33c0): Section 
mismatch in reference from the function eth_bind_config() 
to the function .init.text:geth_bind_config()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x96e): 
Section mismatch in reference from the function 
rndis_config_register() to the function 
.init.text:rndis_do_config()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x99f): 
Section mismatch in reference from the function 
cdc_config_register() to the function 
.init.text:cdc_do_config()
   CC      fs/xfs/xfs_error.o
   CC      drivers/acpi/acpica/utxferror.o
   CC      drivers/scsi/scsi_error.o
This is often seen when error handling in the init 
function
   CC      arch/x86/math-emu/errors.o
   CC [M]  net/9p/error.o
   CC      net/rxrpc/ar-error.o
This is often seen when error handling in the init 
function
ERROR: "mc13xxx_parse_regulators_dt" 
[drivers/regulator/mc13892-regulator.ko] undefined!
ERROR: "mc13xxx_get_num_regulators_dt" 
[drivers/regulator/mc13892-regulator.ko] undefined!
arch/x86/kvm/pmu.c:368: warning: integer constant is too 
large for 'long' type
kernel/trace/trace.c:3697: warning: 'page2' may be used 
uninitialized in this function
fs/btrfs/extent-tree.c:3314: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:3335: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:3698: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:3769: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:3915: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:4134: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:4141: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:4194: warning: cast from pointer to 
integer of different size
fs/btrfs/extent-tree.c:4713: warning: cast from pointer to 
integer of different size
fs/btrfs/inode-map.c:441: warning: cast from pointer to 
integer of different size
fs/btrfs/inode-map.c:503: warning: cast from pointer to 
integer of different size
fs/btrfs/transaction.c:330: warning: cast from pointer to 
integer of different size
fs/btrfs/backref.c:300: warning: 'ret' may be used 
uninitialized in this function
fs/btrfs/backref.c:395: warning: 'ret' may be used 
uninitialized in this function
fs/cifs/connect.c:3210: warning: 'tcon' may be used 
uninitialized in this function
fs/cifs/connect.c:3209: warning: 'pSesInfo' may be used 
uninitialized in this function
fs/cifs/connect.c:3208: warning: 'xid' may be used 
uninitialized in this function
fs/nfs/callback_proc.c:116: warning: 'ino' may be used 
uninitialized in this function
fs/nfs/callback_proc.c:115: warning: 'lo' may be used 
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
drivers/gpu/drm/nouveau/nv50_display.c:656: warning: 'mc' 
may be used uninitialized in this function
drivers/gpu/drm/nouveau/nv50_pm.c:75: warning: 'id' may be 
used uninitialized in this function
drivers/gpu/drm/sis/sis_drv.c:53: warning: 'ret' is used 
uninitialized in this function
drivers/hid/hid-wiimote-debug.c:40: warning: 'size' may be 
used uninitialized in this function
drivers/i2c/busses/i2c-pxa.c:1202: warning: unused 
variable 'i2c'
drivers/infiniband/hw/mlx4/qp.c:1366: warning: 'vlan' may 
be used uninitialized in this function
drivers/input/evdev.c:389: warning: 'retval' may be used 
uninitialized in this function
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
drivers/isdn/hardware/mISDN/hfcsusb.c:39: warning: 
'hfcsusb_rev' defined but not used
drivers/isdn/hardware/mISDN/netjet.c:319: warning: 
comparison is always false due to limited range of data 
type
drivers/isdn/icn/icn.c:721:4: warning: #warning TODO test 
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
drivers/leds/leds-lp5521.c:648: warning: 'ret' may be used 
uninitialized in this function
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
drivers/md/raid10.c:624: warning: 'rdev' may be used 
uninitialized in this function
drivers/media/radio/wl128x/fmdrv_common.c:745: warning: 
comparison is always false due to limited range of data 
type
drivers/media/radio/wl128x/fmdrv_rx.c:308: warning: 
comparison is always false due to limited range of data 
type
drivers/media/video/cx18/cx18-driver.c:113: warning: 
return from incompatible pointer type
drivers/media/video/cx18/cx18-driver.c:113: warning: 
initialization from incompatible pointer type
drivers/media/video/ivtv/ivtv-driver.c:142: warning: 
return from incompatible pointer type
drivers/media/video/ivtv/ivtv-driver.c:142: warning: 
initialization from incompatible pointer type
drivers/media/video/w9966.c:136: warning: return from 
incompatible pointer type
drivers/misc/ti-st/st_core.c:639: warning: comparison is 
always false due to limited range of data type
drivers/misc/apds990x.c:703: warning: comparison is always 
false due to limited range of data type
drivers/mmc/card/block.c:877: warning: 'arg' may be used 
uninitialized in this function
drivers/mmc/card/block.c:877: warning: 'nr' may be used 
uninitialized in this function
drivers/mmc/card/block.c:877: warning: 'from' may be used 
uninitialized in this function
drivers/mmc/card/block.c:831: warning: 'arg' may be used 
uninitialized in this function
drivers/mmc/card/block.c:831: warning: 'nr' may be used 
uninitialized in this function
drivers/mmc/card/block.c:831: warning: 'from' may be used 
uninitialized in this function
drivers/mtd/devices/doc2001plus.c:757: warning: passing 
argument 2 of 'MemWriteDOC' discards qualifiers from 
pointer target type
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
drivers/net/ethernet/alteon/acenic.c:754: warning: passing 
argument 3 of 'pci_free_consistent' discards qualifiers 
from pointer target type
drivers/net/ethernet/alteon/acenic.c:759: warning: passing 
argument 3 of 'pci_free_consistent' discards qualifiers 
from pointer target type
drivers/net/ethernet/alteon/acenic.c:765: warning: passing 
argument 3 of 'pci_free_consistent' discards qualifiers 
from pointer target type
drivers/net/ethernet/amd/nmclan_cs.c:626: warning: 
'pcmcia_request_exclusive_irq' is deprecated (declared at 
include/pcmcia/ds.h:203)
drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:2784: 
warning: comparison of distinct pointer types lacks a cast
drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:1530: 
warning: comparison of distinct pointer types lacks a cast
drivers/net/ethernet/brocade/bna/bnad.c:2812: warning: 
comparison is always true due to limited range of data 
type
drivers/net/ethernet/dec/ewrk3.c:1912: warning: return 
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
drivers/net/ethernet/marvell/sky2.c:1762: warning: 'imask' 
is used uninitialized in this function
drivers/net/hamradio/baycom_par.c:483: warning: return 
from incompatible pointer type
drivers/net/hamradio/baycom_epp.c:1168: warning: return 
from incompatible pointer type
drivers/net/tokenring/ibmtr_cs.c:195: warning: 
'pcmcia_request_exclusive_irq' is deprecated (declared at 
include/pcmcia/ds.h:203)
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your driver to the new sysfs api"
drivers/net/wireless/ath/ath5k/base.c:84: warning: return 
from incompatible pointer type
drivers/net/wireless/brcm80211/brcmsmac/main.c:5582: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/brcm80211/brcmsmac/main.c:5682: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/brcm80211/brcmsmac/aiutils.c:1159: 
warning: 'val' is used uninitialized in this function
drivers/net/wireless/ipw2x00/libipw_wx.c:526: warning: 
unused variable 'dev'
drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:751: 
warning: passing argument 2 of 'dma_map_single_attrs' 
discards qualifiers from pointer target type
drivers/net/wireless/orinoco/orinoco_usb.c:1759: warning: 
'version' defined but not used
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'gf40_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'gf20_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'mm40_mode' may be used uninitialized in this function
drivers/net/wireless/rt2x00/rt2800lib.c:1291: warning: 
'mm20_mode' may be used uninitialized in this function
drivers/net/wireless/rtlwifi/rtl8192c/dm_common.c:916: 
warning: comparison is always false due to limited range 
of data type
drivers/net/wireless/rtlwifi/rtl8192de/dm.c:1067: warning: 
comparison is always false due to limited range of data 
type
drivers/net/wireless/rtlwifi/rtl8192de/trx.c:124: warning: 
'rx_pwr_all' may be used uninitialized in this function
include/linux/of_net.h:12: warning: type qualifiers 
ignored on function return type
drivers/of/of_net.c:42: warning: type qualifiers ignored 
on function return type
drivers/parport/parport_pc.c:635: warning: passing 
argument 2 of 'dma_map_single_attrs' discards qualifiers 
from pointer target type
drivers/pci/hotplug/cpcihp_generic.c:219: warning: return 
from incompatible pointer type
drivers/platform/x86/intel_oaktrail.c:233: warning: 
comparison is always false due to limited range of data 
type
drivers/rtc/rtc-m41t80.c:217: warning: 
'm41t80_rtc_alarm_irq_enable' defined but not used
drivers/rtc/rtc-m41t80.c:239: warning: 
'm41t80_rtc_set_alarm' defined but not used
drivers/rtc/rtc-m41t80.c:309: warning: 
'm41t80_rtc_read_alarm' defined but not used
drivers/scsi/lpfc/lpfc_scsi.c:1309: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1335: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1346: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1369: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1380: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1414: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_scsi.c:1436: warning: integer 
constant is too large for 'long' type
drivers/scsi/lpfc/lpfc_debugfs.c:3946: warning: integer 
constant is too large for 'long' type
drivers/scsi/advansys.c:72:2: warning: #warning this 
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
drivers/scsi/fdomain.c:1775: warning: 'fdomain_pci_tbl' 
defined but not used
drivers/scsi/g_NCR5380.c:943: warning: 'id_table' defined 
but not used
drivers/scsi/dtc.c:180: warning: 'dtc_setup' defined but 
not used
drivers/scsi/initio.c:131: warning: 'i91u_pci_devices' 
defined but not used
drivers/scsi/stex.c:636: warning: passing argument 2 of 
'scsi_sg_copy_from_buffer' discards qualifiers from 
pointer target type
drivers/spi/spi-topcliff-pch.c:276: warning: 'bpw_len' may 
be used uninitialized in this function
drivers/spi/spi-topcliff-pch.c:276: warning: 'rx_index' 
may be used uninitialized in this function
drivers/spi/spi-topcliff-pch.c:276: warning: 'tx_index' 
may be used uninitialized in this function
drivers/staging/android/binder.c:106: warning: return from 
incompatible pointer type
drivers/staging/comedi/drivers/vmk80xx.c:962: warning: 
'reg[0]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:962: warning: 
'reg[1]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:588: warning: 
'reg[0]' may be used uninitialized in this function
drivers/staging/comedi/drivers/vmk80xx.c:588: warning: 
'reg[1]' may be used uninitialized in this function
drivers/staging/iio/dac/ad5064.c:352: warning: type 
qualifiers ignored on function return type
drivers/staging/media/lirc/lirc_imon.c:74: warning: 
'imon_init' declared 'static' but never defined
drivers/staging/media/lirc/lirc_imon.c:75: warning: 
'imon_exit' declared 'static' but never defined
drivers/staging/media/lirc/lirc_sasem.c:84: warning: 
'sasem_init' declared 'static' but never defined
drivers/staging/media/lirc/lirc_sasem.c:85: warning: 
'sasem_exit' declared 'static' but never defined
drivers/staging/media/lirc/lirc_serial.c:1296: warning: 
return from incompatible pointer type
drivers/staging/rtl8192e/rtllib_softmac.c:2302: warning: 
'challenge' may be used uninitialized in this function
drivers/staging/rtl8192e/rtllib_softmac.c:2218: warning: 
'aid' may be used uninitialized in this function
drivers/staging/rtl8192e/rtllib_softmac.c:2218: warning: 
'aid' may be used uninitialized in this function
drivers/staging/rtl8192e/rtllib_softmac.c:2302: warning: 
'challenge' may be used uninitialized in this function
drivers/staging/rtl8192e/rtl819x_TSProc.c:321: warning: 
comparison is always true due to limited range of data 
type
drivers/staging/rtl8712/rtl8712_recv.c:752: warning: 
'rx_pwr_all' may be used uninitialized in this function
drivers/staging/usbip/usbip_common.c:770: warning: 'ret' 
is used uninitialized in this function
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
drivers/staging/wlags49_h2/wl_main.c:544: warning: 
comparison is always true due to limited range of data 
type
drivers/staging/wlags49_h25/../wlags49_h2/wl_wext.c:225: 
warning: comparison is always false due to limited range 
of data type
drivers/staging/wlags49_h25/../wlags49_h2/wl_wext.c:250: 
warning: comparison is always true due to limited range of 
data type
drivers/staging/wlags49_h25/../wlags49_h2/wl_main.c:544: 
warning: comparison is always true due to limited range of 
data type
drivers/staging/wlan-ng/cfg80211.c:404: warning: ignoring 
return value of 'cfg80211_inform_bss', declared with 
attribute warn_unused_result
drivers/tty/serial/ifx6x60.c:1357: warning: passing 
argument 1 of 'spi_unregister_driver' discards qualifiers 
from pointer target type
drivers/tty/vt/keyboard.c:736: warning: comparison is 
always true due to limited range of data type
drivers/usb/gadget/pch_udc.c:2867: warning: 'retval' may 
be used uninitialized in this function
drivers/usb/gadget/acm_ms.c:119: warning: return from 
incompatible pointer type
drivers/usb/gadget/acm_ms.c:119: warning: return from 
incompatible pointer type
drivers/usb/gadget/acm_ms.c:119: warning: return from 
incompatible pointer type
drivers/usb/gadget/acm_ms.c:119: warning: return from 
incompatible pointer type
drivers/usb/gadget/acm_ms.c:119: warning: return from 
incompatible pointer type
drivers/usb/gadget/mass_storage.c:94: warning: return from 
incompatible pointer type
drivers/usb/gadget/mass_storage.c:94: warning: return from 
incompatible pointer type
drivers/usb/gadget/mass_storage.c:94: warning: return from 
incompatible pointer type
drivers/usb/gadget/mass_storage.c:94: warning: return from 
incompatible pointer type
drivers/usb/gadget/mass_storage.c:94: warning: return from 
incompatible pointer type
drivers/usb/gadget/multi.c:147: warning: return from 
incompatible pointer type
drivers/usb/gadget/multi.c:147: warning: return from 
incompatible pointer type
drivers/usb/gadget/multi.c:147: warning: return from 
incompatible pointer type
drivers/usb/gadget/multi.c:147: warning: return from 
incompatible pointer type
drivers/usb/gadget/multi.c:147: warning: return from 
incompatible pointer type
drivers/usb/host/xhci-mem.c:685: warning: 'tt_info' may be 
used uninitialized in this function
drivers/usb/host/xhci-ring.c:1242: warning: 'hcd' may be 
used uninitialized in this function
drivers/usb/misc/emi26.c:40: warning: 'emi26_init' 
declared 'static' but never defined
drivers/usb/misc/emi26.c:41: warning: 'emi26_exit' 
declared 'static' but never defined
drivers/usb/misc/emi62.c:49: warning: 'emi62_init' 
declared 'static' but never defined
drivers/usb/misc/emi62.c:50: warning: 'emi62_exit' 
declared 'static' but never defined
drivers/usb/musb/musb_gadget.c:1085: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/musb/musb_gadget.c:1125: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/musb/musb_host.c:599: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/musb/musb_host.c:774: warning: 
'double_buffer_not_ok' is deprecated (declared at 
drivers/usb/musb/musb_core.h:452)
drivers/usb/otg/ab8500-usb.c:156: warning: 'event' may be 
used uninitialized in this function
drivers/usb/serial/kobil_sct.c:719: warning: return from 
incompatible pointer type
drivers/video/via/hw.c:1423: warning: 'config.rshift' may 
be used uninitialized in this function
drivers/video/via/hw.c:1423: warning: 'config.divisor' may 
be used uninitialized in this function
drivers/video/via/hw.c:1423: warning: 'config.multiplier' 
may be used uninitialized in this function
drivers/video/udlfb.c:456: warning: passing argument 1 of 
'prefetch_range' discards qualifiers from pointer target 
type
sound/core/memory.c:74: warning: passing argument 1 of 
'copy_from_user' discards qualifiers from pointer target 
type
sound/isa/opti9xx/opti92x-ad1848.c:87: warning: return 
from incompatible pointer type
sound/isa/opti9xx/opti92x-ad1848.c:87: warning: return 
from incompatible pointer type
sound/isa/opti9xx/opti92x-ad1848.c:87: warning: return 
from incompatible pointer type
sound/pci/ctxfi/ctvmem.c:79: warning: 'entry' may be used 
uninitialized in this function
sound/pci/ctxfi/ctvmem.c:34: warning: 'entry' may be used 
uninitialized in this function
sound/soc/codecs/wm_hubs.c:119: warning: 'reg_r' may be 
used uninitialized in this function
sound/soc/codecs/wm_hubs.c:119: warning: 'reg_l' may be 
used uninitialized in this function
sound/soc/codecs/wm8996.c:1736: warning: 'bclk_reg' may be 
used uninitialized in this function
sound/soc/codecs/wm9090.c:496: warning: unused variable 
'ret'
sound/soc/codecs/wm9090.c:496: warning: unused variable 
'i'
sound/soc/codecs/wm9090.c:495: warning: unused variable 
'reg_cache'
sound/soc/codecs/wm9090.c:658: warning: unused variable 
'wm9090'
net/bluetooth/hci_core.c:2587: warning: return from 
incompatible pointer type
net/bluetooth/rfcomm/tty.c:218: warning: 'p' is used 
uninitialized in this function
net/bridge/br_netfilter.c:810: warning: passing argument 4 
of 'NF_HOOK' discards qualifiers from pointer target type
net/bridge/br_netfilter.c:810: warning: passing argument 5 
of 'NF_HOOK' discards qualifiers from pointer target type
net/ceph/ceph_fs.c:33: warning: 'mode' may be used 
uninitialized in this function
net/ieee802154/6lowpan.c:405: warning: passing argument 3 
of 'lowpan_raw_dump_inline' discards qualifiers from 
pointer target type
net/ieee802154/6lowpan.c:418: warning: passing argument 3 
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
net/netfilter/xt_time.c:171: warning: passing argument 1 
of '__net_timestamp' discards qualifiers from pointer 
target type
net/sctp/sm_statefuns.c:2053: warning: passing argument 1 
of 'SCTP_ASOC' discards qualifiers from pointer target 
type
WARNING: drivers/block/built-in.o(.devinit.text+0x221): 
Section mismatch in reference from the function 
cpqarray_register_ctlr() to the function 
.init.text:ida_procinit()
WARNING: drivers/mfd/built-in.o(.text+0x842d): Section 
mismatch in reference from the function da9052_spi_probe() 
to the function .devinit.text:da9052_device_init()
WARNING: drivers/mtd/devices/built-in.o(.text+0x624f): 
Section mismatch in reference from the function 
doc_probe_device() to the function 
.init.text:doc_set_driver_info()
WARNING: drivers/mtd/built-in.o(.text+0x3588f): Section 
mismatch in reference from the function doc_probe_device() 
to the function .init.text:doc_set_driver_info()
WARNING: drivers/pci/built-in.o(.text+0x1b9dc): Section 
mismatch in reference from the function 
cpqhp_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/pci/built-in.o(.text+0x1c8e6): Section 
mismatch in reference from the function 
bus_structure_fixup() to the function 
.devinit.text:pci_scan_bus()
WARNING: drivers/pci/built-in.o(.text+0x1ca06): Section 
mismatch in reference from the function 
ibm_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/scsi/NCR_Q720_mod.o(.data+0x24): Section 
mismatch in reference from the variable NCR_Q720_driver to 
the function .init.text:NCR_Q720_probe()
WARNING: drivers/scsi/built-in.o(.data+0x2b74): Section 
mismatch in reference from the variable sim710_mca_driver 
to the function .init.text:sim710_mca_probe()
WARNING: drivers/scsi/built-in.o(.data+0x2bb0): Section 
mismatch in reference from the variable sim710_eisa_driver 
to the function .init.text:sim710_eisa_probe()
WARNING: drivers/scsi/built-in.o(.data+0x67ac): Section 
mismatch in reference from the variable NCR_Q720_driver to 
the function .init.text:NCR_Q720_probe()
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devexit.text+0x18): 
Section mismatch in reference from the function 
pio2_remove() to the function .exit.text:pio2_gpio_exit()
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x3bf): 
Section mismatch in reference from the function 
pio2_probe() to the function .init.text:pio2_gpio_init()
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x413): 
Section mismatch in reference from the function 
pio2_probe() to the function .exit.text:pio2_gpio_exit()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x96e): 
Section mismatch in reference from the function 
rndis_config_register() to the function 
.init.text:rndis_do_config()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x99f): 
Section mismatch in reference from the function 
cdc_config_register() to the function 
.init.text:cdc_do_config()
WARNING: drivers/built-in.o(.text+0x1f8f8): Section 
mismatch in reference from the function 
cpqhp_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/built-in.o(.text+0x20802): Section 
mismatch in reference from the function 
bus_structure_fixup() to the function 
.devinit.text:pci_scan_bus()
WARNING: drivers/built-in.o(.text+0x20922): Section 
mismatch in reference from the function 
ibm_configure_device() to the function 
.devinit.text:pci_do_scan_bus()
WARNING: drivers/built-in.o(.text+0x2c91b9): Section 
mismatch in reference from the function da9052_spi_probe() 
to the function .devinit.text:da9052_device_init()
WARNING: drivers/built-in.o(.text+0x5e81e7): Section 
mismatch in reference from the function doc_probe_device() 
to the function .init.text:doc_set_driver_info()
WARNING: drivers/built-in.o(.devinit.text+0x2373b): 
Section mismatch in reference from the function 
cpqarray_register_ctlr() to the function 
.init.text:ida_procinit()
WARNING: drivers/built-in.o(.data+0x3acd8): Section 
mismatch in reference from the variable sim710_mca_driver 
to the function .init.text:sim710_mca_probe()
WARNING: drivers/built-in.o(.data+0x3ad14): Section 
mismatch in reference from the variable sim710_eisa_driver 
to the function .init.text:sim710_eisa_probe()
WARNING: drivers/built-in.o(.data+0x3e910): Section 
mismatch in reference from the variable NCR_Q720_driver to 
the function .init.text:NCR_Q720_probe()
WARNING: vmlinux.o(.text+0x5fa0f4): Section mismatch in 
reference from the function cpqhp_configure_device() to 
the function .devinit.text:pci_do_scan_bus()
WARNING: vmlinux.o(.text+0x5faffe): Section mismatch in 
reference from the function bus_structure_fixup() to the 
function .devinit.text:pci_scan_bus()
WARNING: vmlinux.o(.text+0x5fb11e): Section mismatch in 
reference from the function ibm_configure_device() to the 
function .devinit.text:pci_do_scan_bus()
WARNING: vmlinux.o(.text+0x8a39b5): Section mismatch in 
reference from the function da9052_spi_probe() to the 
function .devinit.text:da9052_device_init()
WARNING: vmlinux.o(.text+0xbc29e3): Section mismatch in 
reference from the function doc_probe_device() to the 
function .init.text:doc_set_driver_info()
WARNING: vmlinux.o(.devinit.text+0x24230): Section 
mismatch in reference from the function 
cpqarray_register_ctlr() to the function 
.init.text:ida_procinit()
WARNING: vmlinux.o(.data+0x6ea18): Section mismatch in 
reference from the variable sim710_mca_driver to the 
function .init.text:sim710_mca_probe()
WARNING: vmlinux.o(.data+0x6ea54): Section mismatch in 
reference from the variable sim710_eisa_driver to the 
function .init.text:sim710_eisa_probe()
WARNING: vmlinux.o(.data+0x72650): Section mismatch in 
reference from the variable NCR_Q720_driver to the 
function .init.text:NCR_Q720_probe()
WARNING: drivers/leds/leds-lp5523.o(.devinit.text+0x262): 
Section mismatch in reference from the function 
lp5523_probe() to the function 
.init.text:lp5523_init_engine()
WARNING: drivers/misc/cs5535-mfgpt.o(.devinit.text+0x9a): 
Section mismatch in reference from the function 
cs5535_mfgpt_probe() to the function 
.init.text:scan_timers()
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
WARNING: drivers/spi/spi-topcliff-pch.o(.data+0x14): 
Section mismatch in reference from the variable 
pch_spi_pcidev to the function 
.devinit.text:pch_spi_probe()
WARNING: drivers/spi/spi-topcliff-pch.o(.data+0x18): 
Section mismatch in reference from the variable 
pch_spi_pcidev to the function 
.devexit.text:pch_spi_remove()
WARNING: 
drivers/staging/comedi/drivers/s626.o(.text+0x1f07): 
Section mismatch in reference from the function 
s626_attach() to the variable 
.devinit.rodata:s626_pci_table
WARNING: modpost: missing MODULE_LICENSE() in 
drivers/staging/media/go7007/go7007-usb.o
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devexit.text+0x18): 
Section mismatch in reference from the function 
pio2_remove() to the function .exit.text:pio2_gpio_exit()
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x3bf): 
Section mismatch in reference from the function 
pio2_probe() to the function .init.text:pio2_gpio_init()
WARNING: 
drivers/staging/vme/devices/vme_pio2.o(.devinit.text+0x413): 
Section mismatch in reference from the function 
pio2_probe() to the function .exit.text:pio2_gpio_exit()
WARNING: drivers/usb/gadget/g_ffs.o(.text+0x33c0): Section 
mismatch in reference from the function eth_bind_config() 
to the function .init.text:geth_bind_config()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x96e): 
Section mismatch in reference from the function 
rndis_config_register() to the function 
.init.text:rndis_do_config()
WARNING: drivers/usb/gadget/g_multi.o(.text+0x99f): 
Section mismatch in reference from the function 
cdc_config_register() to the function 
.init.text:cdc_do_config()
---
Professional hosting for everyone - http://www.host.ru
