Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab0JPAXo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:23:44 -0400
Received: from zfrontend2.aha.ru ([195.2.83.148]:55710 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751217Ab0JPAXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:23:43 -0400
From: "werner" <w.landgraf@ru.ru>
Subject: 2.6.36-rc1 problems
To: linux-kernel@vger.kernel.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Fri, 15 Oct 2010 19:23:38 -0400
Message-ID: <web-387129929@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/staging/comedi/drivers/das08_cs.c:225: error: 
'struct pcmcia_device' has
no member named 'io'
drivers/staging/spectra/ffsport.c:277: error: 
'REQ_TYPE_LINUX_BLOCK' undeclared (first
use in this function)
drivers/staging/spectra/ffsport.c:277: error: (Each 
undeclared identifier is reported
only once
drivers/staging/spectra/ffsport.c:277: error: for each 
function it appears in.)
drivers/staging/spectra/ffsport.c:279: error: 
'REQ_LB_OP_FLUSH' undeclared (first
use in this function)
drivers/staging/spectra/ffsport.c:299: error: 
'REQ_TYPE_LINUX_BLOCK' undeclared (first
use in this function)
drivers/staging/spectra/ffsport.c:300: error: 
'REQ_LB_OP_FLUSH' undeclared (first
use in this function)
drivers/staging/spectra/ffsport.c:604: error: unknown 
field 'locked_ioctl' specified
in initializer
drivers/staging/spectra/ffsport.c:654: error: too many 
arguments to function 'blk_queue_ordered'
fs/autofs/root.c:30: warning: 'autofs_root_compat_ioctl' 
declared 'static' but never
defined
fs/autofs4/root.c:31: warning: 'autofs4_root_compat_ioctl' 
declared 'static' but
never defined
fs/ceph/locks.c:85: warning: cast from pointer to integer 
of different size
fs/ceph/locks.c:95: warning: cast from pointer to integer 
of different size
fs/ceph/locks.c:135: warning: cast from pointer to integer 
of different size
fs/ceph/locks.c:144: warning: cast from pointer to integer 
of different size
fs/ceph/locks.c:238: warning: cast from pointer to integer 
of different size
drivers/acpi/apei/erst.c:273: warning: cast to pointer 
from integer of different
size
drivers/acpi/apei/erst.c:274: warning: cast to pointer 
from integer of different
size
drivers/char/tpm/tpm.c:1086: warning: 'tpm_suspend_setup' 
defined but not used
drivers/char/n_gsm.c:1580: warning: ignoring return value 
of '__kfifo_must_check_helper',
declared with attribute warn_unused_result
drivers/gpio/wm8994-gpio.c:85: warning: 
'wm8994_gpio_to_irq' defined but not used
drivers/hwmon/coretemp.c:521: warning: unused variable 'n'
drivers/hwmon/coretemp.c:521: warning: unused variable 'p'
drivers/infiniband/hw/amso1100/c2_vq.c:110: warning: cast 
from pointer to integer
of different size
drivers/infiniband/hw/amso1100/c2_vq.c:126: warning: cast 
from pointer to integer
of different size
drivers/infiniband/hw/amso1100/c2_vq.c:154: warning: cast 
from pointer to integer
of different size
drivers/infiniband/hw/cxgb4/cm.c:2326: warning: cast to 
pointer from integer of different
size
drivers/infiniband/hw/cxgb4/mem.c:74: warning: cast from 
pointer to integer of different
size
drivers/infiniband/hw/cxgb4/cq.c:58: warning: cast from 
pointer to integer of different
size
drivers/infiniband/hw/cxgb4/cq.c:135: warning: cast from 
pointer to integer of different
size
drivers/infiniband/hw/cxgb4/qp.c:147: warning: cast from 
pointer to integer of different
size
drivers/infiniband/hw/cxgb4/qp.c:988: warning: cast from 
pointer to integer of different
size
drivers/infiniband/hw/cxgb4/qp.c:1063: warning: cast from 
pointer to integer of different
size
drivers/isdn/gigaset/capi.c:302: warning: 'format_ie' 
defined but not used
drivers/isdn/hardware/mISDN/hfcpci.c:2320: warning: 
ignoring return value of 'driver_for_each_device',
declared with attribute warn_unused_result
drivers/isdn/icn/icn.c:721:4: warning: #warning TODO test 
headroom or use skb->nb
to flag ACK
drivers/isdn/sc/init.c:487: warning: passing argument 1 of 
'readl' makes pointer
from integer without a cast
drivers/isdn/sc/init.c:497: warning: passing argument 1 of 
'readl' makes pointer
from integer without a cast
drivers/isdn/sc/init.c:507: warning: passing argument 1 of 
'readl' makes pointer
from integer without a cast
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your
driver to the new sysfs api"
drivers/media/dvb/ngene/ngene-core.c:1308: warning: unused 
variable 'flags'
drivers/net/pcmcia/nmclan_cs.c:650: warning: 
'pcmcia_request_exclusive_irq' is deprecated
(declared at include/pcmcia/ds.h:202)
drivers/net/pcmcia/ibmtr_cs.c:235: warning: 
'pcmcia_request_exclusive_irq' is deprecated
(declared at include/pcmcia/ds.h:202)
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your
driver to the new sysfs api"
/usr/src/linux-2.6.36-rc1-i486-1sys/arch/x86/include/asm/io.h:62: 
warning: array
subscript is above array bounds
/usr/src/linux-2.6.36-rc1-i486-1sys/arch/x86/include/asm/io.h:62: 
warning: array
subscript is above array bounds
/usr/src/linux-2.6.36-rc1-i486-1sys/arch/x86/include/asm/io.h:62: 
warning: array
subscript is above array bounds
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your
driver to the new sysfs api"
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your
driver to the new sysfs api"
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your
driver to the new sysfs api"
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your
driver to the new sysfs api"
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your
driver to the new sysfs api"
drivers/rtc/rtc-m41t80.c:367: warning: passing argument 1 
of 'rtc_valid_tm' from
incompatible pointer type
drivers/scsi/sym53c8xx_2/sym_hipd.c:78: warning: 
zero-length printf format string
drivers/scsi/constants.c:1407: warning: zero-length printf 
format string
drivers/scsi/constants.c:1413: warning: zero-length printf 
format string
drivers/scsi/constants.c:1456: warning: zero-length printf 
format string
drivers/scsi/sd.c:2628: warning: zero-length printf format 
string
drivers/scsi/sd.c:2630: warning: zero-length printf format 
string
drivers/scsi/sd.c:2636: warning: zero-length printf format 
string
drivers/scsi/advansys.c:72:2: warning: #warning this 
driver is still not properly
converted to the DMA API
drivers/scsi/dpt_i2o.c:182: warning: 'dptids' defined but 
not used
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your
driver to the new sysfs api"
include/linux/mca-legacy.h:12:2: warning: #warning "MCA 
legacy - please move your
driver to the new sysfs api"
drivers/scsi/fdomain.c:1773: warning: 'fdomain_pci_tbl' 
defined but not used
drivers/scsi/g_NCR5380.c:943: warning: 'id_table' defined 
but not used
drivers/scsi/dtc.c:180: warning: 'dtc_setup' defined but 
not used
drivers/scsi/initio.c:131: warning: 'i91u_pci_devices' 
defined but not used
drivers/staging/comedi/drivers/ni_daq_700.c:587: warning: 
unused variable 'req'
drivers/staging/lirc/lirc_igorplugusb.c:393: warning: 
format '%lu' expects type 'long
unsigned int', but argument 3 has type 'unsigned int'
drivers/staging/lirc/lirc_imon.c:661: warning: 'chunk_num' 
may be used uninitialized
in this function
drivers/staging/lirc/lirc_it87.c:365: warning: 
initialization discards qualifiers
from pointer target type
drivers/staging/lirc/lirc_serial.c:1073: warning: 
initialization discards qualifiers
from pointer target type
drivers/staging/lirc/lirc_sir.c:482: warning: 
initialization discards qualifiers
from pointer target type
drivers/staging/lirc/lirc_zilog.c:1284: warning: 
assignment discards qualifiers from
pointer target type
drivers/staging/otus/80211core/ratectrl.c:433: warning: 
suggest parentheses around
comparison in operand of ==
drivers/staging/rtl8192u/r8192U_core.c:247:1: warning: 
"eqMacAddr" redefined
drivers/staging/rtl8192u/dot11d.h:35:1: warning: this is 
the location of the previous
definition
drivers/staging/spectra/ffsport.c:116:1: warning: 
"GLOB_VERSION" redefined
drivers/staging/spectra/spectraswconfig.h:24:1: warning: 
this is the location of
the previous definition
drivers/staging/spectra/flash.c:778: warning: unused 
variable 'i'
drivers/staging/spectra/flash.c:2016: warning: 
'FTL_Cache_Write_Back' defined but
not used
drivers/staging/spectra/flash.c:2397: warning: 
'FTL_Format_Flash' defined but not
used
drivers/staging/tm6000/tm6000-core.c:329: warning: ISO C90 
forbids mixed declarations
and code
drivers/staging/udlfb/udlfb.c:1362: warning: ignoring 
return value of 'device_create_file',
declared with attribute warn_unused_result
drivers/staging/udlfb/udlfb.c:1364: warning: ignoring 
return value of 'device_create_bin_file',
declared with attribute warn_unused_result
drivers/staging/xgifb/XGI_main_26.c:3416: warning: format 
'%lx' expects type 'long
unsigned int', but argument 2 has type 'unsigned int'
drivers/staging/xgifb/vb_setmode.c:4460: warning: 
'ModeIdIndex' is used uninitialized
in this function
drivers/staging/xgifb/vb_setmode.c:500: warning: 
'ModeIdIndex' may be used uninitialized
in this function
drivers/usb/host/whci/hcd.c:359: warning: 
'whci_hcd_id_table' defined but not used
drivers/usb/serial/ssu100.c:600: warning: 'flag' may be 
used uninitialized in this
function
drivers/usb/gadget/storage_common.c:720: warning: 
'fsg_show_nofua' defined but not
used
drivers/usb/gadget/storage_common.c:785: warning: 
'fsg_store_nofua' defined but not
used
drivers/usb/gadget/storage_common.c:720: warning: 
'fsg_show_nofua' defined but not
used
drivers/usb/gadget/storage_common.c:785: warning: 
'fsg_store_nofua' defined but not
used
drivers/uwb/whc-rc.c:452: warning: 'whcrc_id_table' 
defined but not used
drivers/video/s1d13xxxfb.c:422: warning: 
'bltbit_wait_bitset' defined but not used
drivers/video/s1d13xxxfb.c:465: warning: 
'bltbit_fifo_status' defined but not used
sound/oss/pss.c:676: warning: 'check_region' is deprecated 
(declared at include/linux/ioport.h:171)
sound/pcmcia/pdaudiocf/pdaudiocf.c:226: warning: 
'pcmcia_request_exclusive_irq' is
deprecated (declared at include/pcmcia/ds.h:202)
sound/pcmcia/vx/vxpocket.c:233: warning: 
'pcmcia_request_exclusive_irq' is deprecated
(declared at include/pcmcia/ds.h:202)
sound/usb/mixer.c:762: warning: unused variable 'chip'
sound/usb/misc/ua101.c:1172: warning: unused variable 'ua'
ERROR: "st_get_plat_device" 
[drivers/staging/ti-st/st_drv.ko] undefined!
WARNING: modpost: Found 13 section mismatch(es).
WARNING: modpost: Found 68 section mismatch(es).
---
Professional hosting for everyone - http://www.host.ru
