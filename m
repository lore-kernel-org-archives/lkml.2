Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2ILX22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:28:28 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62362 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2ILX2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:28:22 -0400
Date: Wed, 12 Sep 2012 16:28:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 000/108] 3.5.4-stable review
Message-ID: <20120912232816.GA1655@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[NOTE 1:
 Linus, Alan, Andrew, I've taken you off of every individual patch in
 the stable review cycle, based on feedback from Linus.  Below I
 summarize the patches in this release, with the original git commit id
 and who wrote them.  Hopefully this is in a format that is
 understandable.  If there's anything else you want in the summary
 email, just let me know.

 Alan and Andrew, if you want back on every email in the series, just
 let me know and I'll do so.]

[NOTE 2:
 I know there are still pending patches for this release that have been
 sent to me.  Due to vacation, and the kernel summit, I'm behind on
 them, and I figured it was best to get the outstanding patch queue out
 now, instead of waiting until next week for the whole batch.  I should
 be caught up soon, thanks for your understanding.]

This is the start of the stable review cycle for the 3.5.4 release.
There are 108 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Sep 14 23:24:47 UTC 2012.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.5.4-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Shortlog of commits:

Patch Name                                                  	Original Commit ID	Author
USB: vt6656: remove __devinit* from the struct usb_device_id	4d088876f24887cd15a2	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
USB: emi62: remove __devinit* from the struct usb_device_id 	83957df21dd94655d2b0	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
ALSA: hda - fix Copyright debug message                     	088c820b732dbfd515fc	Wang Xingchao <xingchao.wang@intel.com>
ARM: 7483/1: vfp: only advertise VFPv4 in hwcaps if CONFIG_V	3d9fb0038a9b02febb01	Will Deacon <will.deacon@arm.com>
ARM: 7487/1: mm: avoid setting nG bit for user mappings that	47f1204329237a0f8655	Will Deacon <will.deacon@arm.com>
ARM: 7488/1: mm: use 5 bits for swapfile type encoding      	f5f2025ef3e2cdb59370	Will Deacon <will.deacon@arm.com>
ARM: 7489/1: errata: fix workaround for erratum #720789 on U	730a8128cd8978467eb1	Will Deacon <will.deacon@arm.com>
ARM: OMAP2+: Fix dmtimer set source clock failure           	54f32a35f4d3a653a18a	Jon Hunter <jon-hunter@ti.com>
ARM: S3C24XX: Add missing DMACH_DT_PROP                     	e1267371eacf2cbcf580	Heiko Stuebner <heiko@sntech.de>
ARM: S3C24XX: Fix s3c2410_dma_enqueue parameters            	b01858c7806e7e6f6121	Heiko Stuebner <heiko@sntech.de>
xen/p2m: Reuse existing P2M leafs if they are filled with 1:	250a41e0ecc433cdd553	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
xen/setup: Fix one-off error when adding for-balloon PFNs to	c96aae1f7f393387d160	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
ARM: imx6: spin the cpu until hardware takes it down        	c944b0b9354ea06ffb0c	Shawn Guo <shawn.guo@linaro.org>
ARM: imx: build pm-imx5 code only when PM is enabled        	a28eecef8ac2671dce7d	Arnd Bergmann <arnd@arndb.de>
ARM: imx: select CPU_FREQ_TABLE when needed                 	f637c4c9405e21f44cf0	Arnd Bergmann <arnd@arndb.de>
ARM: imx: build i.MX6 functions only when needed            	1fc593feaf8e440511f3	Arnd Bergmann <arnd@arndb.de>
MIPS: pci-ar724x: avoid data bus error due to a missing PCIe	a1dca315ce3f78347bca	Gabor Juhos <juhosg@openwrt.org>
ASoC: wm9712: Fix microphone source selection               	ccf795847a38235ee4a5	Mark Brown <broonie@opensource.wolfsonmicro.com>
ASoC: omap-mcbsp: Fix 6pin mux configuration                	d0db84e713eaaccea2a4	Peter Ujfalusi <peter.ujfalusi@ti.com>
vfs: missed source of ->f_pos races                         	0e665d5d1125f9f4ccff	Al Viro <viro@ZenIV.linux.org.uk>
vfs: canonicalize create mode in build_open_flags()         	e68726ff72cf7ba5e7d7	Miklos Szeredi <mszeredi@suse.cz>
alpha: fix fpu.h usage in userspace                         	0be421862b857e619644	Mike Frysinger <vapier@gentoo.org>
alpha: Don't export SOCK_NONBLOCK to user space.            	a2fa3ccd7b43665fe14c	Michael Cree <mcree@orcon.net.nz>
USB: winbond: remove __devinit* from the struct usb_device_i	43a34695d9cd79c6659f	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
mm: hugetlbfs: correctly populate shared pmd                	eb48c071464757414538	Michal Hocko <mhocko@suse.cz>
ALSA: hda - don't create dysfunctional mixer controls for ca	c41999a23929f30808ba	David Henningsson <david.henningsson@canonical.com>
ALSA: hda - Fix leftover codec->power_transition            	535b6c51fe8293c88ce9	Takashi Iwai <tiwai@suse.de>
target: fix NULL pointer dereference bug alloc_page() fails 	d0e27c88d795fb964715	Yi Zou <yi.zou@intel.com>
NFSv3: Ensure that do_proc_get_root() reports errors correct	086600430493e04b802b	Trond Myklebust <Trond.Myklebust@netapp.com>
pnfs: defer release of pages in layoutget                   	8554116e17eef055d9dd	Idan Kedar <idank@tonian.com>
nfs: tear down caches in nfs_init_writepagecache when alloca	3dd4765fce04c0b4af1e	Jeff Layton <jlayton@redhat.com>
NFSv4.1: Remove a bogus BUG_ON() in nfs4_layoutreturn_done  	47fbf7976e0b7d9dcdd7	Trond Myklebust <Trond.Myklebust@netapp.com>
NFS: Clear key construction data if the idmap upcall fails  	c5066945b7ea346a1142	Bryan Schumaker <bjschuma@netapp.com>
NFS: return -ENOKEY when the upcall fails to map the name   	12dfd080556124088ed6	Bryan Schumaker <bjschuma@netapp.com>
nfsd4: fix security flavor of NFSv4.0 callback              	39307655a1effa8d913b	"J. Bruce Fields" <bfields@redhat.com>
UBIFS: fix crash on error path                              	11e3be0be2a1314e0861	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
UBIFS: fix complaints about too small debug buffer size     	65b455b123c7e2b835a0	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Bluetooth: Fix using NULL inquiry entry                     	c810089c27e48b816181	Ram Malovany <ramm@ti.com>
Bluetooth: Fix using a NULL inquiry cache entry             	7cc8380eb10347016d95	Ram Malovany <ramm@ti.com>
Bluetooth: Set name_state to unknown when entry name is empt	c3e7c0d90b14a3e7ac09	Ram Malovany <ramm@ti.com>
Bluetooth: Fix legacy pairing with some devices             	a9ea3ed9b71cc3271dd5	Szymon Janc <szymon.janc@tieto.com>
NFS: Alias the nfs module to nfs4                           	425e776d93a7a5070b77	"bjschuma@gmail.com" <bjschuma@gmail.com>
audit: don't free_chunk() after fsnotify_add_mark()         	0fe33aae0e94b4097dd4	Miklos Szeredi <mszeredi@suse.cz>
audit: fix refcounting in audit-tree                        	a2140fc0cb0325bb6384	Miklos Szeredi <mszeredi@suse.cz>
drm: stop vmgfx driver explosion                            	f5869a8308f77e3dfdc2	Alan Cox <alan@linux.intel.com>
Revert "drm/radeon: fix bo creation retry path"             	676bc2e1e4f9072f7a64	Alex Deucher <alexander.deucher@amd.com>
Btrfs: revert checksum error statistic which can cause a BUG	5ee0844d6427e7338e0a	Stefan Behrens <sbehrens@giantdisaster.de>
svcrpc: fix BUG() in svc_tcp_clear_pages                    	be1e44441a560c43c136	"J. Bruce Fields" <bfields@redhat.com>
svcrpc: fix svc_xprt_enqueue/svc_recv busy-looping          	d10f27a750312ed5638c	"J. Bruce Fields" <bfields@redhat.com>
svcrpc: sends on closed socket should stop immediately      	f06f00a24d76e168ecb3	"J. Bruce Fields" <bfields@redhat.com>
cciss: fix incorrect scsi status reporting                  	b0cf0b118c90477d1a68	"Stephen M. Cameron" <scameron@beardog.cce.hp.com>
ACPI: export symbol acpi_get_table_with_size                	4f81f986761a7663db7d	Alex Deucher <alexander.deucher@amd.com>
ath9k: stop btcoex on device suspend                        	e19f15ac6437624b6214	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
ath9k: fix decrypt_error initialization in ath_rx_tasklet() 	e1352fde5682ab1bdd2a	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
PCI: EHCI: Fix crash during hibernation on ASUS computers   	0b68c8e2c3afaf9807eb	"Rafael J. Wysocki" <rjw@sisk.pl>
gma500: Consider CRTC initially active.                     	4a68a74ba04e7ccf798d	Forest Bond <forest.bond@rapidrollout.com>
block: replace __getblk_slow misfix by grow_dev_page fix    	676ce6d5ca3098339c02	Hugh Dickins <hughd@google.com>
jbd: don't write superblock when unmounting an ro filesystem	2e84f2641ea91a730642	Jan Kara <jack@suse.cz>
ALSA: usb-audio: Fix scheduling-while-atomic bug in PCM capt	e9ba389c5ffc4dd29dfe	Takashi Iwai <tiwai@suse.de>
sched,cgroup: Fix up task_groups list                       	35cf4e50b16331def6cf	Mike Galbraith <efault@gmx.de>
sched: fix divide by zero at {thread_group,task}_times      	bea6832cc8c4a0a9a65d	Stanislaw Gruszka <sgruszka@redhat.com>
[media] uvcvideo: Reset the bytesused field when recycling a	8a3f0ede2b3f54771220	Jayakrishnan Memana <jayakrishnan.memana@maxim-ic.com>
rapidio/tsi721: fix inbound doorbell interrupt handling     	3670e7e12e582c6d6776	Alexandre Bounine <alexandre.bounine@idt.com>
rapidio/tsi721: fix unused variable compiler warning        	9a9a9a7adafe62a34de8	Alexandre Bounine <alexandre.bounine@idt.com>
regulator: twl-regulator: fix up VINTANA1/VINTANA2          	908d6d52928a7f2a4b31	Aaro Koskinen <aaro.koskinen@iki.fi>
x32: Use compat shims for {g,s}etsockopt                    	515c7af85ed92696c311	Mike Frysinger <vapier@gentoo.org>
USB: spca506: remove __devinit* from the struct usb_device_i	e694d518886c7afedcdd	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
USB: jl2005bcd: remove __devinit* from the struct usb_device	ec063351684298e295dc	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
USB: p54usb: remove __devinit* from the struct usb_device_id	b9c4167cbbafddac3462	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
USB: rtl8187: remove __devinit* from the struct usb_device_i	a3433179d0822ccfa8e8	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
USB: smsusb: remove __devinit* from the struct usb_device_id	d04dbd1c0ec17a13326c	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
USB: CDC ACM: Fix NULL pointer dereference                  	99f347caa4568cb80386	Sven Schnelle <svens@stackframe.org>
ALSA: snd-usb: Fix URB cancellation at stream start         	015618b902ae8e28705b	Daniel Mack <zonque@gmail.com>
ALSA: snd-usb: use list_for_each_safe for endpoint resources	03d2f44e967b3c2cf79a	Pavel Roskin <proski@gnu.org>
ALSA: snd-usb: restore delay information                    	fbcfbf5f673847657ccd	Daniel Mack <zonque@gmail.com>
ALSA: snd-usb: fix calls to next_packet_size                	245baf983cc39524cce3	Daniel Mack <zonque@gmail.com>
ALSA: snd-usb: fix cross-interface streaming devices        	2e4a263ca80a203ac610	Daniel Mack <zonque@gmail.com>
powerpc: Update DSCR on all CPUs when writing sysfs dscr_def	1b6ca2a6fe56e7697d57	Anton Blanchard <anton@samba.org>
powerpc: Keep thread.dscr and thread.dscr_inherit in sync   	00ca0de02f80924dfff6	Anton Blanchard <anton@samba.org>
powerpc: Fix DSCR inheritance in copy_thread()              	1021cb268b3025573c48	Anton Blanchard <anton@samba.org>
powerpc: Restore correct DSCR in context switch             	714332858bfd40dcf8f7	Anton Blanchard <anton@samba.org>
powerpc: Make sure IPI handlers see data written by IPI send	9fb1b36ca1234e64a5d1	Paul Mackerras <paulus@samba.org>
Remove user-triggerable BUG from mpol_to_str                	80de7c3138ee9fd86a98	Dave Jones <davej@redhat.com>
Fix order of arguments to compat_put_time[spec|val]         	ed6fe9d614fc1bca95eb	Mikulas Patocka <mpatocka@redhat.com>
usbnet: fix deadlock in resume                              	ab6f148de28261682d30	Oliver Neukum <oliver@neukum.org>
SCSI: megaraid_sas: Move poll_aen_lock initializer          	bd8d6dd43a77bfd2b8fe	Kashyap Desai <Kashyap.Desai@lsi.com>
SCSI: scsi_lib: fix scsi_io_completion's SG_IO error propaga	27c419739b67decced46	Mike Snitzer <snitzer@redhat.com>
SCSI: mpt2sas: Fix for Driver oops, when loading driver with	338b131a3269881c7431	"sreekanth.reddy@lsi.com" <sreekanth.reddy@lsi.com>
SCSI: Fix 'Device not ready' issue on mpt2sas               	14216561e164671ce147	James Bottomley <JBottomley@Parallels.com>
udf: Fix data corruption for files in ICB                   	9c2fc0de1a6e638fe58c	Jan Kara <jack@suse.cz>
ext3: Fix fdatasync() for files with only i_size changes    	156bddd8e505b295540f	Jan Kara <jack@suse.cz>
fuse: fix retrieve length                                   	c9e67d483776d8d2a5f3	Miklos Szeredi <mszeredi@suse.cz>
i2c-designware: Fix build error if CONFIG_I2C_DESIGNWARE_PLA	e68bb91baa0bb9817567	Axel Lin <axel.lin@gmail.com>
i2c-i801: Add Device IDs for Intel Lynx Point-LP PCH        	4a8f1ddde942e232387e	James Ralston <james.d.ralston@intel.com>
HID: add NOGET quirk for Eaton Ellipse MAX UPS              	67ddbb3e6568fb1820b2	Alan Stern <stern@rowland.harvard.edu>
Input: i8042 - add Gigabyte T1005 series netbooks to noloop 	7b125b94ca16b7e618c6	Dmitry Torokhov <dmitry.torokhov@gmail.com>
UBI: fix a horrible memory deallocation bug                 	78b495c39add820ab66a	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
drm/vmwgfx: add MODULE_DEVICE_TABLE so vmwgfx loads at boot 	c4903429a92be60e6fe5	Dave Airlie <airlied@redhat.com>
OMAPFB: fix framebuffer console colors                      	c1c52848cef52e157468	Grazvydas Ignotas <notasas@gmail.com>
e1000e: DoS while TSO enabled caused by link partner with sm	d821a4c4d11ad160925d	Bruce Allan <bruce.w.allan@intel.com>
PARISC: Redefine ATOMIC_INIT and ATOMIC64_INIT to drop the c	bba3d8c3b3c0f2123be5	Mel Gorman <mgorman@suse.de>
xen: Use correct masking in xen_swiotlb_alloc_coherent.     	b5031ed1be0aa4192505	Ronny Hegewald <ronny.hegewald@online.de>
xen/p2m: Fix one-off error in checking the P2M tree director	50e900417b8096939d12	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
xen/pciback: Fix proper FLR steps.                          	80ba77dfbce85f2d1be5	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
uprobes: Fix mmap_region()'s mm->mm_rb corruption if uprobe_	c7a3a88c938fbe3d70c2	Oleg Nesterov <oleg@redhat.com>
x86, microcode, AMD: Fix broken ucode patch size check      	36bf50d7697be18c6bfd	Andreas Herrmann <andreas.herrmann3@amd.com>
dccp: check ccid before dereferencing                       	276bdb82dedb29051146	Mathias Krause <minipli@googlemail.com>
hwmon: (asus_atk0110) Add quirk for Asus M5A78L             	43ca6cb28c871f2fbad1	Luca Tettamanti <kronos.it@gmail.com>

-------------

Diffstat:

 Documentation/i2c/busses/i2c-i801          |    1 +
 Makefile                                   |    4 ++--
 arch/alpha/include/asm/fpu.h               |    2 ++
 arch/alpha/include/asm/socket.h            |    2 ++
 arch/arm/Kconfig                           |    1 +
 arch/arm/include/asm/pgtable.h             |   40 +++++++++++++++++++++-------------------
 arch/arm/mach-imx/Makefile                 |   10 +++++-----
 arch/arm/mach-imx/head-v7.S                |  106 ----------------------------------------------------------------------------------------------------------
 arch/arm/mach-imx/headsmp.S                |  106 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-imx/hotplug.c                |   23 +++--------------------
 arch/arm/mach-s3c24xx/include/mach/dma.h   |    3 ++-
 arch/arm/mm/flush.c                        |    2 --
 arch/arm/mm/tlb-v7.S                       |    6 +++---
 arch/arm/plat-omap/dmtimer.c               |    2 +-
 arch/arm/plat-s3c24xx/dma.c                |    2 +-
 arch/arm/vfp/vfpmodule.c                   |    2 ++
 arch/mips/pci/pci-ar724x.c                 |   22 ++++++++++++++++++++++
 arch/parisc/include/asm/atomic.h           |    4 ++--
 arch/powerpc/kernel/asm-offsets.c          |    1 +
 arch/powerpc/kernel/dbell.c                |    2 ++
 arch/powerpc/kernel/entry_64.S             |   23 +++++++++++++++++------
 arch/powerpc/kernel/process.c              |   12 ++----------
 arch/powerpc/kernel/smp.c                  |   11 +++++++++--
 arch/powerpc/kernel/sysfs.c                |   10 ++++++++++
 arch/powerpc/kernel/traps.c                |    3 ++-
 arch/powerpc/sysdev/xics/icp-hv.c          |    6 +++++-
 arch/x86/kernel/microcode_amd.c            |    7 ++++---
 arch/x86/mm/hugetlbpage.c                  |   21 ++++++++++++++++-----
 arch/x86/syscalls/syscall_64.tbl           |    6 ++++--
 arch/x86/xen/p2m.c                         |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 arch/x86/xen/setup.c                       |    9 ++++++++-
 drivers/acpi/acpica/tbxface.c              |    1 +
 drivers/block/cciss_scsi.c                 |   11 +----------
 drivers/gpu/drm/gma500/psb_intel_display.c |    3 +++
 drivers/gpu/drm/radeon/radeon_object.c     |    3 +--
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c        |    1 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c        |    6 +++++-
 drivers/hid/usbhid/hid-quirks.c            |    1 +
 drivers/hwmon/asus_atk0110.c               |    6 ++++++
 drivers/i2c/busses/Kconfig                 |    6 ++++++
 drivers/i2c/busses/Makefile                |    5 +++--
 drivers/i2c/busses/i2c-designware-core.c   |   11 +++++++++++
 drivers/i2c/busses/i2c-i801.c              |    3 +++
 drivers/input/serio/i8042-x86ia64io.h      |   14 ++++++++++++++
 drivers/media/dvb/siano/smsusb.c           |    2 +-
 drivers/media/video/gspca/jl2005bcd.c      |    2 +-
 drivers/media/video/gspca/spca506.c        |    2 +-
 drivers/media/video/uvc/uvc_queue.c        |    1 +
 drivers/mtd/ubi/vtbl.c                     |    4 ++--
 drivers/net/ethernet/intel/e1000e/e1000.h  |    1 +
 drivers/net/ethernet/intel/e1000e/netdev.c |   48 +++++++++++++++++++++++-------------------------
 drivers/net/usb/usbnet.c                   |    2 +-
 drivers/net/wireless/ath/ath9k/pci.c       |    1 +
 drivers/net/wireless/ath/ath9k/recv.c      |    2 +-
 drivers/net/wireless/p54/p54usb.c          |    2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c |    2 +-
 drivers/pci/pci-driver.c                   |    7 +++++++
 drivers/rapidio/devices/tsi721.c           |   12 +++++++++++-
 drivers/regulator/twl-regulator.c          |    4 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c  |    3 ++-
 drivers/scsi/mpt2sas/mpt2sas_base.c        |   13 ++++++++-----
 drivers/scsi/scsi_error.c                  |   10 ++++++++++
 drivers/scsi/scsi_lib.c                    |    5 ++++-
 drivers/scsi/scsi_scan.c                   |   10 ++++++++++
 drivers/staging/vt6656/main_usb.c          |    2 +-
 drivers/staging/winbond/wbusb.c            |    2 +-
 drivers/target/target_core_transport.c     |    4 ++--
 drivers/usb/class/cdc-acm.c                |    3 ++-
 drivers/usb/misc/emi62.c                   |    2 +-
 drivers/video/omap2/omapfb/omapfb-main.c   |    2 +-
 drivers/xen/swiotlb-xen.c                  |    2 +-
 drivers/xen/xen-pciback/pci_stub.c         |    8 ++++----
 fs/btrfs/extent_io.c                       |   17 ++---------------
 fs/btrfs/volumes.c                         |   22 ----------------------
 fs/btrfs/volumes.h                         |    2 --
 fs/buffer.c                                |   66 ++++++++++++++++++++++++++++++------------------------------------
 fs/compat.c                                |   10 ++++++++--
 fs/ext3/inode.c                            |   17 ++++++++++++++---
 fs/fuse/dev.c                              |    1 +
 fs/jbd/journal.c                           |    5 +++++
 fs/nfs/idmap.c                             |   62 ++++++++++++++++++++++++++++++++++++++++++++------------------
 fs/nfs/nfs3proc.c                          |    2 +-
 fs/nfs/nfs4proc.c                          |   65 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 fs/nfs/pnfs.c                              |   39 +--------------------------------------
 fs/nfs/pnfs.h                              |    2 +-
 fs/nfs/super.c                             |    2 ++
 fs/nfs/write.c                             |   15 ++++++++++++---
 fs/nfsd/nfs4callback.c                     |    4 ++--
 fs/nfsd/state.h                            |    1 -
 fs/open.c                                  |    7 ++++---
 fs/ubifs/debug.h                           |    2 +-
 fs/ubifs/lpt.c                             |    5 ++++-
 fs/udf/file.c                              |   35 +++++++++++++++++++++++++++++------
 kernel/audit_tree.c                        |   11 +++++------
 kernel/fork.c                              |    4 ++--
 kernel/sched/core.c                        |   35 +++++++++++++++++++++--------------
 kernel/sched/sched.h                       |    2 +-
 mm/mempolicy.c                             |    2 +-
 mm/mmap.c                                  |    5 ++---
 net/bluetooth/hci_event.c                  |   28 ++++++++++++++++++++++------
 net/bluetooth/l2cap_core.c                 |    1 +
 net/dccp/ccid.h                            |    4 ++--
 net/socket.c                               |    4 ++--
 net/sunrpc/svc_xprt.c                      |   10 ++++------
 net/sunrpc/svcsock.c                       |    2 +-
 sound/pci/hda/hda_codec.c                  |    2 ++
 sound/pci/hda/hda_proc.c                   |    2 +-
 sound/pci/hda/patch_ca0132.c               |    8 ++++++++
 sound/soc/codecs/wm9712.c                  |   19 +++++++++++++++++--
 sound/soc/omap/mcbsp.c                     |    2 +-
 sound/usb/card.c                           |    4 ++--
 sound/usb/endpoint.c                       |   24 ++++++++----------------
 sound/usb/endpoint.h                       |    3 ++-
 sound/usb/pcm.c                            |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 114 files changed, 882 insertions(+), 505 deletions(-)

