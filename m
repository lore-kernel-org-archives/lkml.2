Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932688Ab2KXA13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 19:27:29 -0500
Received: from smtp-02.mandic.com.br ([200.225.81.133]:39100 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab2KXA1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 19:27:22 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-kernel@vger.kernel.org
Cc: Cesar Eduardo Barros <cesarb@cesarb.net>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 07/24] MAINTAINERS: adjust for UAPI
Date: Fri, 23 Nov 2012 22:26:31 -0200
Message-Id: <1353716808-16375-8-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several headers were moved or split to uapi/.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 160 ++++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 118 insertions(+), 42 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 05054ad..c382ff9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -442,6 +442,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/char/agp/
 F:	include/linux/agp*
+F:	include/uapi/linux/agp*
 
 AHA152X SCSI DRIVER
 M:	"Juergen E. Fischer" <fischer@norbit.de>
@@ -582,6 +583,7 @@ M:	Jiri Kosina <jkosina@suse.cz>
 S:	Odd fixes
 F:	arch/x86/kernel/apm_32.c
 F:	include/linux/apm_bios.h
+F:	include/uapi/linux/apm_bios.h
 F:	drivers/char/apm-emulation.c
 
 APPLE BCM5974 MULTITOUCH DRIVER
@@ -1363,6 +1365,7 @@ W:	http://linux-atm.sourceforge.net
 S:	Maintained
 F:	drivers/atm/
 F:	include/linux/atm*
+F:	include/uapi/linux/atm*
 
 ATMEL AT91 MCI DRIVER
 M:	Ludovic Desroches <ludovic.desroches@atmel.com>
@@ -1450,6 +1453,7 @@ W:	http://people.redhat.com/sgrubb/audit/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/viro/audit-current.git
 S:	Maintained
 F:	include/linux/audit.h
+F:	include/uapi/linux/audit.h
 F:	kernel/audit*
 
 AUXILIARY DISPLAY DRIVERS
@@ -1480,7 +1484,7 @@ M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
-F:	include/linux/ax25.h
+F:	include/uapi/linux/ax25.h
 F:	include/net/ax25.h
 F:	net/ax25/
 
@@ -1533,7 +1537,7 @@ M:	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
 S:	Maintained
 F:	Documentation/filesystems/bfs.txt
 F:	fs/bfs/
-F:	include/linux/bfs_fs.h
+F:	include/uapi/linux/bfs_fs.h
 
 BLACKFIN ARCHITECTURE
 M:	Mike Frysinger <vapier@gentoo.org>
@@ -1630,7 +1634,7 @@ L:	netdev@vger.kernel.org
 W:	http://sourceforge.net/projects/bonding/
 S:	Supported
 F:	drivers/net/bonding/
-F:	include/linux/if_bonding.h
+F:	include/uapi/linux/if_bonding.h
 
 BROADCOM B44 10/100 ETHERNET DRIVER
 M:	Gary Zambrano <zambrano@broadcom.com>
@@ -1710,6 +1714,7 @@ L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	block/bsg.c
 F:	include/linux/bsg.h
+F:	include/uapi/linux/bsg.h
 
 BT87X AUDIO DRIVER
 M:	Clemens Ladisch <clemens@ladisch.de>
@@ -1780,7 +1785,7 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	Documentation/networking/caif/
 F:	drivers/net/caif/
-F:	include/linux/caif/
+F:	include/uapi/linux/caif/
 F:	include/net/caif/
 F:	net/caif/
 
@@ -1801,11 +1806,11 @@ W:	http://gitorious.org/linux-can
 T:	git git://gitorious.org/linux-can/linux-can-next.git
 S:	Maintained
 F:	net/can/
-F:	include/linux/can.h
 F:	include/linux/can/core.h
-F:	include/linux/can/bcm.h
-F:	include/linux/can/raw.h
-F:	include/linux/can/gw.h
+F:	include/uapi/linux/can.h
+F:	include/uapi/linux/can/bcm.h
+F:	include/uapi/linux/can/raw.h
+F:	include/uapi/linux/can/gw.h
 
 CAN NETWORK DRIVERS
 M:	Wolfgang Grandegger <wg@grandegger.com>
@@ -1816,15 +1821,16 @@ T:	git git://gitorious.org/linux-can/linux-can-next.git
 S:	Maintained
 F:	drivers/net/can/
 F:	include/linux/can/dev.h
-F:	include/linux/can/error.h
-F:	include/linux/can/netlink.h
 F:	include/linux/can/platform/
+F:	include/uapi/linux/can/error.h
+F:	include/uapi/linux/can/netlink.h
 
 CAPABILITIES
 M:	Serge Hallyn <serge.hallyn@canonical.com>
 L:	linux-security-module@vger.kernel.org
 S:	Supported
 F:	include/linux/capability.h
+F:	include/uapi/linux/capability.h
 F:	security/capability.c
 F:	security/commoncap.c
 F:	kernel/capability.c
@@ -1837,6 +1843,7 @@ W:	http://www.ibm.com/developerworks/power/cell/
 S:	Supported
 F:	arch/powerpc/include/asm/cell*.h
 F:	arch/powerpc/include/asm/spu*.h
+F:	arch/powerpc/include/uapi/asm/spu*.h
 F:	arch/powerpc/oprofile/*cell*
 F:	arch/powerpc/platforms/cell/
 
@@ -1885,7 +1892,7 @@ W:	http://wireless.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
 S:	Maintained
-F:	include/linux/nl80211.h
+F:	include/uapi/linux/nl80211.h
 F:	include/net/cfg80211.h
 F:	net/wireless/*
 X:	net/wireless/wext*
@@ -1988,6 +1995,7 @@ S:	Maintained
 F:	Documentation/filesystems/coda.txt
 F:	fs/coda/
 F:	include/linux/coda*.h
+F:	include/uapi/linux/coda*.h
 
 COMMON CLK FRAMEWORK
 M:	Mike Turquette <mturquette@ti.com>
@@ -2233,6 +2241,7 @@ W:	http://www.cyclades.com/
 S:	Orphan
 F:	drivers/tty/cyclades.c
 F:	include/linux/cyclades.h
+F:	include/uapi/linux/cyclades.h
 
 CYCLADES PC300 DRIVER
 W:	http://www.cyclades.com/
@@ -2290,6 +2299,7 @@ L:	dccp@vger.kernel.org
 W:	http://www.linuxfoundation.org/collaborate/workgroups/networking/dccp
 S:	Maintained
 F:	include/linux/dccp.h
+F:	include/uapi/linux/dccp.h
 F:	include/linux/tfrc.h
 F:	net/dccp/
 
@@ -2316,7 +2326,7 @@ M:	Massimo Dal Zotto <dz@debian.org>
 W:	http://www.debian.org/~dz/i8k/
 S:	Maintained
 F:	drivers/char/i8k.c
-F:	include/linux/i8k.h
+F:	include/uapi/linux/i8k.h
 
 DELL SYSTEMS MANAGEMENT BASE DRIVER (dcdbas)
 M:	Doug Warzecha <Douglas_Warzecha@dell.com>
@@ -2389,6 +2399,7 @@ S:	Maintained
 F:	Documentation/filesystems/quota.txt
 F:	fs/quota/
 F:	include/linux/quota*.h
+F:	include/uapi/linux/quota*.h
 
 DISPLAYLINK USB 2.0 FRAMEBUFFER DRIVER (UDLFB)
 M:	Bernie Thompson <bernie@plugable.com>
@@ -2495,6 +2506,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git
 S:	Maintained
 F:	drivers/gpu/drm/
 F:	include/drm/
+F:	include/uapi/drm/
 
 INTEL DRM DRIVERS (excluding Poulsbo, Moorestown and derivative chipsets)
 M:	Daniel Vetter <daniel.vetter@ffwll.ch>
@@ -2504,6 +2516,7 @@ T:	git git://people.freedesktop.org/~danvet/drm-intel
 S:	Supported
 F:	drivers/gpu/drm/i915
 F:	include/drm/i915*
+F:	include/uapi/drm/i915*
 
 DRM DRIVERS FOR EXYNOS
 M:	Inki Dae <inki.dae@samsung.com>
@@ -2515,6 +2528,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos.git
 S:	Supported
 F:	drivers/gpu/drm/exynos
 F:	include/drm/exynos*
+F:	include/uapi/drm/exynos*
 
 DSCC4 DRIVER
 M:	Francois Romieu <romieu@fr.zoreil.com>
@@ -2680,6 +2694,7 @@ L:	netfilter-devel@vger.kernel.org
 W:	http://ebtables.sourceforge.net/
 S:	Maintained
 F:	include/linux/netfilter_bridge/ebt_*.h
+F:	include/uapi/linux/netfilter_bridge/ebt_*.h
 F:	net/bridge/netfilter/ebt*.c
 
 EC100 MEDIA DRIVER
@@ -2993,6 +3008,7 @@ M:	Eric Paris <eparis@redhat.com>
 S:	Maintained
 F:	fs/notify/fanotify/
 F:	include/linux/fanotify.h
+F:	include/uapi/linux/fanotify.h
 
 FARSYNC SYNCHRONOUS DRIVER
 M:	Kevin Curtis <kevin.curtis@farsite.co.uk>
@@ -3016,6 +3032,7 @@ F:	drivers/scsi/fcoe/
 F:	include/scsi/fc/
 F:	include/scsi/libfc.h
 F:	include/scsi/libfcoe.h
+F:	include/uapi/scsi/fc/
 
 FILE LOCKING (flock() and fcntl()/lockf())
 M:	Matthew Wilcox <matthew@wil.cx>
@@ -3023,6 +3040,8 @@ L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
 F:	include/linux/fcntl.h
 F:	include/linux/fs.h
+F:	include/uapi/linux/fcntl.h
+F:	include/uapi/linux/fs.h
 F:	fs/fcntl.c
 F:	fs/locks.c
 
@@ -3103,6 +3122,8 @@ F:	Documentation/devicetree/bindings/fb/
 F:	drivers/video/
 F:	include/video/
 F:	include/linux/fb.h
+F:	include/uapi/video/
+F:	include/uapi/linux/fb.h
 
 FREESCALE DMA DRIVER
 M:	Li Yang <leoli@freescale.com>
@@ -3231,7 +3252,7 @@ L:	fuse-devel@lists.sourceforge.net
 W:	http://fuse.sourceforge.net/
 S:	Maintained
 F:	fs/fuse/
-F:	include/linux/fuse.h
+F:	include/uapi/linux/fuse.h
 
 FUTURE DOMAIN TMC-16x0 SCSI DRIVER (16-bit)
 M:	Rik Faith <faith@cs.unc.edu>
@@ -3278,6 +3299,7 @@ L:	linux-arch@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
 S:	Maintained
 F:	include/asm-generic
+F:	include/uapi/asm-generic
 
 GENERIC UIO DRIVER FOR PCI DEVICES
 M:	"Michael S. Tsirkin" <mst@redhat.com>
@@ -3294,7 +3316,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-nmw.git
 S:	Supported
 F:	Documentation/filesystems/gfs2*.txt
 F:	fs/gfs2/
-F:	include/linux/gfs2_ondisk.h
+F:	include/uapi/linux/gfs2_ondisk.h
 
 GIGASET ISDN DRIVERS
 M:	Hansjoerg Lipp <hjlipp@web.de>
@@ -3304,7 +3326,7 @@ W:	http://gigaset307x.sourceforge.net/
 S:	Maintained
 F:	Documentation/isdn/README.gigaset
 F:	drivers/isdn/gigaset/
-F:	include/linux/gigaset_dev.h
+F:	include/uapi/linux/gigaset_dev.h
 
 GPIO SUBSYSTEM
 M:	Grant Likely <grant.likely@secretlab.ca>
@@ -3461,6 +3483,7 @@ S:	Supported
 F:	Documentation/scsi/hpsa.txt
 F:	drivers/scsi/hpsa*.[ch]
 F:	include/linux/cciss*.h
+F:	include/uapi/linux/cciss*.h
 
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
 M:	Mike Miller <mike.miller@hp.com>
@@ -3469,6 +3492,7 @@ S:	Supported
 F:	Documentation/blockdev/cciss.txt
 F:	drivers/block/cciss*
 F:	include/linux/cciss_ioctl.h
+F:	include/uapi/linux/cciss_ioctl.h
 
 HFS FILESYSTEM
 L:	linux-fsdevel@vger.kernel.org
@@ -3503,6 +3527,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid.git
 S:	Maintained
 F:	drivers/hid/
 F:	include/linux/hid*
+F:	include/uapi/linux/hid*
 
 HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS
 M:	Thomas Gleixner <tglx@linutronix.de>
@@ -3534,7 +3559,7 @@ M:	Jes Sorensen <jes@trained-monkey.org>
 L:	linux-hippi@sunsite.dk
 S:	Maintained
 F:	include/linux/hippidevice.h
-F:	include/linux/if_hippi.h
+F:	include/uapi/linux/if_hippi.h
 F:	net/802/hippi.c
 F:	drivers/net/hippi/
 
@@ -3562,6 +3587,7 @@ S:	Maintained
 F:	Documentation/timers/hpet.txt
 F:	drivers/char/hpet.c
 F:	include/linux/hpet.h
+F:	include/uapi/linux/hpet.h
 
 HPET:	x86
 M:	"Venkatesh Pallipadi (Venki)" <venki@google.com>
@@ -3663,6 +3689,8 @@ F:	Documentation/i2c/
 F:	drivers/i2c/
 F:	include/linux/i2c.h
 F:	include/linux/i2c-*.h
+F:	include/uapi/linux/i2c.h
+F:	include/uapi/linux/i2c-*.h
 
 I2C-TAOS-EVM DRIVER
 M:	Jean Delvare <khali@linux-fr.org>
@@ -3814,7 +3842,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
 S:	Supported
 F:	Documentation/infiniband/
 F:	drivers/infiniband/
-F:	include/linux/if_infiniband.h
+F:	include/uapi/linux/if_infiniband.h
 
 INOTIFY
 M:	John McCutchan <john@johnmccutchan.com>
@@ -3824,6 +3852,7 @@ S:	Maintained
 F:	Documentation/filesystems/inotify.txt
 F:	fs/notify/inotify/
 F:	include/linux/inotify.h
+F:	include/uapi/linux/inotify.h
 
 INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
 M:	Dmitry Torokhov <dmitry.torokhov@gmail.com>
@@ -3834,6 +3863,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
 S:	Maintained
 F:	drivers/input/
 F:	include/linux/input.h
+F:	include/uapi/linux/input.h
 F:	include/linux/input/
 
 INPUT MULTITOUCH (MT) PROTOCOL
@@ -3981,7 +4011,7 @@ S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.i2400m
 F:	drivers/net/wimax/i2400m/
-F:	include/linux/wimax/i2400m.h
+F:	include/uapi/linux/wimax/i2400m.h
 
 INTEL WIRELESS 3945ABG/BG, 4965AGN (iwlegacy)
 M:	Stanislaw Gruszka <sgruszka@redhat.com>
@@ -4003,7 +4033,7 @@ INTEL MANAGEMENT ENGINE (mei)
 M:	Tomas Winkler <tomas.winkler@intel.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
-F:	include/linux/mei.h
+F:	include/uapi/linux/mei.h
 F:	drivers/misc/mei/*
 F:	Documentation/mei/*
 
@@ -4045,6 +4075,7 @@ S:	Supported
 F:	Documentation/IPMI.txt
 F:	drivers/char/ipmi/
 F:	include/linux/ipmi*
+F:	include/uapi/linux/ipmi*
 
 IPS SCSI RAID DRIVER
 M:	Adaptec OEM Raid Solutions <aacraid@adaptec.com>
@@ -4062,7 +4093,7 @@ L:	lvs-devel@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/ipvs-sysctl.txt
 F:	include/net/ip_vs.h
-F:	include/linux/ip_vs.h
+F:	include/uapi/linux/ip_vs.h
 F:	net/netfilter/ipvs/
 
 IPWIRELESS DRIVER
@@ -4075,8 +4106,8 @@ IPX NETWORK LAYER
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	include/linux/ipx.h
 F:	include/net/ipx.h
+F:	include/uapi/linux/ipx.h
 F:	net/ipx/
 
 IRDA SUBSYSTEM
@@ -4139,6 +4170,8 @@ F:	Documentation/isdn/
 F:	drivers/isdn/
 F:	include/linux/isdn.h
 F:	include/linux/isdn/
+F:	include/uapi/linux/isdn.h
+F:	include/uapi/linux/isdn/
 
 ISDN SUBSYSTEM (Eicon active card driver)
 M:	Armin Schindler <mac@melware.de>
@@ -4163,7 +4196,7 @@ W:	http://www.ivtvdriver.org
 S:	Maintained
 F:	Documentation/video4linux/*.ivtv
 F:	drivers/media/pci/ivtv/
-F:	include/linux/ivtv*
+F:	include/uapi/linux/ivtv*
 
 JC42.4 TEMPERATURE SENSOR DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
@@ -4193,7 +4226,7 @@ L:	linux-mtd@lists.infradead.org
 W:	http://www.linux-mtd.infradead.org/doc/jffs2.html
 S:	Maintained
 F:	fs/jffs2/
-F:	include/linux/jffs2.h
+F:	include/uapi/linux/jffs2.h
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
 M:	Andrew Morton <akpm@linux-foundation.org>
@@ -4277,11 +4310,13 @@ W:	http://nfs.sourceforge.net/
 S:	Supported
 F:	fs/nfsd/
 F:	include/linux/nfsd/
+F:	include/uapi/linux/nfsd/
 F:	fs/lockd/
 F:	fs/nfs_common/
 F:	net/sunrpc/
 F:	include/linux/lockd/
 F:	include/linux/sunrpc/
+F:	include/uapi/linux/sunrpc/
 
 KERNEL VIRTUAL MACHINE (KVM)
 M:	Marcelo Tosatti <mtosatti@redhat.com>
@@ -4293,6 +4328,7 @@ F:	Documentation/*/kvm.txt
 F:	arch/*/kvm/
 F:	arch/*/include/asm/kvm*
 F:	include/linux/kvm*
+F:	include/uapi/linux/kvm*
 F:	virt/kvm/
 
 KERNEL VIRTUAL MACHINE (KVM) FOR AMD-V
@@ -4338,6 +4374,7 @@ W:	http://kernel.org/pub/linux/utils/kernel/kexec/
 L:	kexec@lists.infradead.org
 S:	Maintained
 F:	include/linux/kexec.h
+F:	include/uapi/linux/kexec.h
 F:	kernel/kexec.c
 
 KEYS/KEYRINGS:
@@ -4579,6 +4616,7 @@ LLC (802.2)
 M:	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
 S:	Maintained
 F:	include/linux/llc.h
+F:	include/uapi/linux/llc.h
 F:	include/net/llc*
 F:	net/llc/
 
@@ -4774,7 +4812,7 @@ MATROX FRAMEBUFFER DRIVER
 L:	linux-fbdev@vger.kernel.org
 S:	Orphan
 F:	drivers/video/matrox/matroxfb_*
-F:	include/linux/matroxfb.h
+F:	include/uapi/linux/matroxfb.h
 
 MAX16065 HARDWARE MONITOR DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
@@ -4806,6 +4844,8 @@ F:	drivers/staging/media/
 F:	include/media/
 F:	include/linux/dvb/
 F:	include/linux/videodev*.h
+F:	include/uapi/linux/dvb/
+F:	include/uapi/linux/videodev*.h
 
 MEGARAID SCSI DRIVERS
 M:	Neela Syam Kolli <megaraidlinux@lsi.com>
@@ -4843,7 +4883,7 @@ T:	git git://git.infradead.org/mtd-2.6.git
 S:	Maintained
 F:	drivers/mtd/
 F:	include/linux/mtd/
-F:	include/mtd/
+F:	include/uapi/mtd/
 
 MICROBLAZE ARCHITECTURE
 M:	Michal Simek <monstr@monstr.eu>
@@ -4879,7 +4919,7 @@ W:	http://popies.net/meye/
 S:	Orphan
 F:	Documentation/video4linux/meye.txt
 F:	drivers/media/pci/meye/
-F:	include/linux/meye.h
+F:	include/uapi/linux/meye.h
 
 MOTOROLA IMX MMC/SD HOST CONTROLLER INTERFACE DRIVER
 M:	Pavel Pisa <ppisa@pikron.com>
@@ -4918,6 +4958,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git
 S:	Maintained
 F:	drivers/mmc/
 F:	include/linux/mmc/
+F:	include/uapi/linux/mmc/
 
 MULTIMEDIA CARD (MMC) ETC. OVER SPI
 S:	Orphan
@@ -5018,6 +5059,8 @@ S:	Supported
 F:	include/linux/netfilter*
 F:	include/linux/netfilter/
 F:	include/net/netfilter/
+F:	include/uapi/linux/netfilter*
+F:	include/uapi/linux/netfilter/
 F:	net/*/netfilter.c
 F:	net/*/netfilter/
 F:	net/netfilter/
@@ -5036,8 +5079,8 @@ M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
-F:	include/linux/netrom.h
 F:	include/net/netrom.h
+F:	include/uapi/linux/netrom.h
 F:	net/netrom/
 
 NETWORK BLOCK DEVICE (NBD)
@@ -5046,6 +5089,7 @@ S:	Maintained
 F:	Documentation/blockdev/nbd.txt
 F:	drivers/block/nbd.c
 F:	include/linux/nbd.h
+F:	include/uapi/linux/nbd.h
 
 NETWORK DROP MONITOR
 M:	Neil Horman <nhorman@tuxdriver.com>
@@ -5067,6 +5111,9 @@ F:	include/net/
 F:	include/linux/in.h
 F:	include/linux/net.h
 F:	include/linux/netdevice.h
+F:	include/uapi/linux/in.h
+F:	include/uapi/linux/net.h
+F:	include/uapi/linux/netdevice.h
 
 NETWORKING [IPv4/IPv6]
 M:	"David S. Miller" <davem@davemloft.net>
@@ -5112,6 +5159,7 @@ F:	net/rfkill/
 F:	net/wireless/
 F:	include/net/ieee80211*
 F:	include/linux/wireless.h
+F:	include/uapi/linux/wireless.h
 F:	include/net/iw_handler.h
 F:	drivers/net/wireless/
 
@@ -5130,6 +5178,8 @@ F:	include/linux/fcdevice.h
 F:	include/linux/fddidevice.h
 F:	include/linux/hippidevice.h
 F:	include/linux/inetdevice.h
+F:	include/uapi/linux/if_*
+F:	include/uapi/linux/netdevice.h
 
 NETXEN (1/10) GbE SUPPORT
 M:	Sony Chacko <sony.chacko@qlogic.com>
@@ -5147,8 +5197,8 @@ L:	linux-wireless@vger.kernel.org
 L:	linux-nfc@lists.01.org (moderated for non-subscribers)
 S:	Maintained
 F:	net/nfc/
-F:	include/linux/nfc.h
 F:	include/net/nfc/
+F:	include/uapi/linux/nfc.h
 F:	drivers/nfc/
 
 NFS, SUNRPC, AND LOCKD CLIENTS
@@ -5164,6 +5214,8 @@ F:	net/sunrpc/
 F:	include/linux/lockd/
 F:	include/linux/nfs*
 F:	include/linux/sunrpc/
+F:	include/uapi/linux/nfs*
+F:	include/uapi/linux/sunrpc/
 
 NI5010 NETWORK DRIVER
 M:	Jan-Pascal van Best <janpascal@vanbest.org>
@@ -5344,6 +5396,7 @@ M:	Harald Welte <laforge@gnumonks.org>
 S:	Maintained
 F:	drivers/char/pcmcia/cm4000_cs.c
 F:	include/linux/cm4000_cs.h
+F:	include/uapi/linux/cm4000_cs.h
 
 OMNIKEY CARDMAN 4040 DRIVER
 M:	Harald Welte <laforge@gnumonks.org>
@@ -5502,7 +5555,7 @@ S:	Orphan
 F:	drivers/parport/
 F:	include/linux/parport*.h
 F:	drivers/char/ppdev.c
-F:	include/linux/ppdev.h
+F:	include/uapi/linux/ppdev.h
 
 PARAVIRT_OPS INTERFACE
 M:	Jeremy Fitzhardinge <jeremy@goop.org>
@@ -5643,6 +5696,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/core
 S:	Supported
 F:	kernel/events/*
 F:	include/linux/perf_event.h
+F:	include/uapi/linux/perf_event.h
 F:	arch/*/kernel/perf_event*.c
 F:	arch/*/kernel/*/perf_event*.c
 F:	arch/*/kernel/*/*/perf_event*.c
@@ -5656,6 +5710,7 @@ M:	Christoph Hellwig <hch@infradead.org>
 L:	linux-abi-devel@lists.sourceforge.net
 S:	Maintained
 F:	include/linux/personality.h
+F:	include/uapi/linux/personality.h
 
 PHONET PROTOCOL
 M:	Remi Denis-Courmont <courmisch@gmail.com>
@@ -5663,6 +5718,7 @@ S:	Supported
 F:	Documentation/networking/phonet.txt
 F:	include/linux/phonet.h
 F:	include/net/phonet/
+F:	include/uapi/linux/phonet.h
 F:	net/phonet/
 
 PHRAM MTD DRIVER
@@ -5705,6 +5761,7 @@ M:	Jiri Kosina <jkosina@suse.cz>
 S:	Maintained
 F:	drivers/block/pktcdvd.c
 F:	include/linux/pktcdvd.h
+F:	include/uapi/linux/pktcdvd.h
 
 PKUNITY SOC DRIVERS
 M:	Guan Xuetao <gxt@mprc.pku.edu.cn>
@@ -5779,7 +5836,7 @@ PPP OVER ATM (RFC 2364)
 M:	Mitchell Blank Jr <mitch@sfgoth.com>
 S:	Maintained
 F:	net/atm/pppoatm.c
-F:	include/linux/atmppp.h
+F:	include/uapi/linux/atmppp.h
 
 PPP OVER ETHERNET
 M:	Michal Ostrowski <mostrows@earthlink.net>
@@ -5792,6 +5849,7 @@ M:	James Chapman <jchapman@katalix.com>
 S:	Maintained
 F:	net/l2tp/l2tp_ppp.c
 F:	include/linux/if_pppol2tp.h
+F:	include/uapi/linux/if_pppol2tp.h
 
 PPS SUPPORT
 M:	Rodolfo Giometti <giometti@enneenne.com>
@@ -5889,6 +5947,7 @@ F:	include/asm-generic/syscall.h
 F:	include/linux/ptrace.h
 F:	include/linux/regset.h
 F:	include/linux/tracehook.h
+F:	include/uapi/linux/ptrace.h
 F:	kernel/ptrace.c
 
 PVRUSB2 VIDEO4LINUX DRIVER
@@ -6006,8 +6065,8 @@ M:	Anders Larsen <al@alarsen.net>
 W:	http://www.alarsen.net/linux/qnx4fs/
 S:	Maintained
 F:	fs/qnx4/
-F:	include/linux/qnx4_fs.h
-F:	include/linux/qnxtypes.h
+F:	include/uapi/linux/qnx4_fs.h
+F:	include/uapi/linux/qnxtypes.h
 
 QT1010 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
@@ -6041,7 +6100,7 @@ M:	Benjamin Herrenschmidt <benh@kernel.crashing.org>
 L:	linux-fbdev@vger.kernel.org
 S:	Maintained
 F:	drivers/video/aty/radeon*
-F:	include/linux/radeonfb.h
+F:	include/uapi/linux/radeonfb.h
 
 RAGE128 FRAMEBUFFER DISPLAY DRIVER
 M:	Paul Mackerras <paulus@samba.org>
@@ -6127,6 +6186,7 @@ S:	Maintained
 F:	Documentation/rtc.txt
 F:	drivers/rtc/
 F:	include/linux/rtc.h
+F:	include/uapi/linux/rtc.h
 
 REISERFS FILE SYSTEM
 L:	reiserfs-devel@vger.kernel.org
@@ -6181,8 +6241,8 @@ M:	Ralf Baechle <ralf@linux-mips.org>
 L:	linux-hams@vger.kernel.org
 W:	http://www.linux-ax25.org/
 S:	Maintained
-F:	include/linux/rose.h
 F:	include/net/rose.h
+F:	include/uapi/linux/rose.h
 F:	net/rose/
 
 RTL2830 MEDIA DRIVER
@@ -6342,6 +6402,8 @@ S:	Supported
 F:	include/linux/clocksource.h
 F:	include/linux/time.h
 F:	include/linux/timex.h
+F:	include/uapi/linux/time.h
+F:	include/uapi/linux/timex.h
 F:	kernel/time/clocksource.c
 F:	kernel/time/time*.c
 F:	kernel/time/ntp.c
@@ -6366,6 +6428,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
 S:	Maintained
 F:	kernel/sched/
 F:	include/linux/sched.h
+F:	include/uapi/linux/sched.h
 
 SCORE ARCHITECTURE
 M:	Chen Liqin <liqin.chen@sunplusct.com>
@@ -6518,7 +6581,7 @@ SENSABLE PHANTOM
 M:	Jiri Slaby <jirislaby@gmail.com>
 S:	Maintained
 F:	drivers/misc/phantom.c
-F:	include/linux/phantom.h
+F:	include/uapi/linux/phantom.h
 
 SERIAL ATA (SATA) SUBSYSTEM
 M:	Jeff Garzik <jgarzik@pobox.com>
@@ -6755,6 +6818,7 @@ L:	linux-raid@vger.kernel.org
 S:	Supported
 F:	drivers/md/
 F:	include/linux/raid/
+F:	include/uapi/linux/raid/
 
 SONIC NETWORK DRIVER
 M:	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
@@ -6795,6 +6859,7 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
 S:	Maintained
 F:	Documentation/sound/
 F:	include/sound/
+F:	include/uapi/sound/
 F:	sound/
 
 SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEMENT (ASoC)
@@ -6895,6 +6960,7 @@ S:	Maintained
 F:	Documentation/spi/
 F:	drivers/spi/
 F:	include/linux/spi/
+F:	include/uapi/linux/spi/
 
 SPIDERNET NETWORK DRIVER for CELL
 M:	Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
@@ -7157,8 +7223,8 @@ TC CLASSIFIER
 M:	Jamal Hadi Salim <jhs@mojatatu.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	include/linux/pkt_cls.h
 F:	include/net/pkt_cls.h
+F:	include/uapi/linux/pkt_cls.h
 F:	net/sched/
 
 TCP LOW PRIORITY MODULE
@@ -7234,6 +7300,7 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/team/
 F:	include/linux/if_team.h
+F:	include/uapi/linux/if_team.h
 
 TEGRA SUPPORT
 M:	Stephen Warren <swarren@wwwdotorg.org>
@@ -7319,7 +7386,7 @@ L:	netdev@vger.kernel.org (core kernel code)
 L:	tipc-discussion@lists.sourceforge.net (user apps, general discussion)
 W:	http://tipc.sourceforge.net/
 S:	Maintained
-F:	include/linux/tipc*.h
+F:	include/uapi/linux/tipc*.h
 F:	net/tipc/
 
 TILE ARCHITECTURE
@@ -7369,6 +7436,7 @@ W:	http://www.buzzard.org.uk/toshiba/
 S:	Maintained
 F:	drivers/char/toshiba.c
 F:	include/linux/toshiba.h
+F:	include/uapi/linux/toshiba.h
 
 TMIO MMC DRIVER
 M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
@@ -7427,6 +7495,9 @@ F:	drivers/tty/serial/serial_core.c
 F:	include/linux/serial_core.h
 F:	include/linux/serial.h
 F:	include/linux/tty.h
+F:	include/uapi/linux/serial_core.h
+F:	include/uapi/linux/serial.h
+F:	include/uapi/linux/tty.h
 
 TUA9001 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
@@ -7507,7 +7578,7 @@ M:	David Herrmann <dh.herrmann@googlemail.com>
 L:	linux-input@vger.kernel.org
 S:	Maintained
 F:	drivers/hid/uhid.c
-F:	include/linux/uhid.h
+F:	include/uapi/linux/uhid.h
 
 ULTRA-WIDEBAND (UWB) SUBSYSTEM:
 L:	linux-usb@vger.kernel.org
@@ -7536,6 +7607,7 @@ S:	Maintained
 F:	Documentation/cdrom/
 F:	drivers/cdrom/cdrom.c
 F:	include/linux/cdrom.h
+F:	include/uapi/linux/cdrom.h
 
 UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER
 M:	Vinayak Holikatti <vinholikatti@gmail.com>
@@ -7553,7 +7625,7 @@ T:	git git://git.infradead.org/ubi-2.6.git
 S:	Maintained
 F:	drivers/mtd/ubi/
 F:	include/linux/mtd/ubi.h
-F:	include/mtd/ubi-user.h
+F:	include/uapi/mtd/ubi-user.h
 
 UNSORTED BLOCK IMAGES (UBI) Fastmap
 M:	Richard Weinberger <richard@nod.at>
@@ -7587,7 +7659,7 @@ M:	Oliver Neukum <oliver@neukum.org>
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/net/usb/cdc_*.c
-F:	include/linux/usb/cdc.h
+F:	include/uapi/linux/usb/cdc.h
 
 USB CYPRESS C67X00 DRIVER
 M:	Peter Korsgaard <jacmet@sunsite.dk>
@@ -7907,6 +7979,7 @@ S:	Maintained
 F:	Documentation/vfio.txt
 F:	drivers/vfio/
 F:	include/linux/vfio.h
+F:	include/uapi/linux/vfio.h
 
 VIDEOBUF2 FRAMEWORK
 M:	Pawel Osciak <pawel@osciak.com>
@@ -7923,6 +7996,7 @@ L:	virtualization@lists.linux-foundation.org
 S:	Maintained
 F:	drivers/char/virtio_console.c
 F:	include/linux/virtio_console.h
+F:	include/uapi/linux/virtio_console.h
 
 VIRTIO CORE, NET AND BLOCK DRIVERS
 M:	Rusty Russell <rusty@rustcorp.com.au>
@@ -7941,7 +8015,7 @@ L:	virtualization@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/vhost/
-F:	include/linux/vhost.h
+F:	include/uapi/linux/vhost.h
 
 VIA RHINE NETWORK DRIVER
 M:	Roger Luethi <rl@hellgate.ch>
@@ -8081,6 +8155,7 @@ S:	Maintained
 F:	Documentation/watchdog/
 F:	drivers/watchdog/
 F:	include/linux/watchdog.h
+F:	include/uapi/linux/watchdog.h
 
 WD7000 SCSI DRIVER
 M:	Miroslav Zagorac <zaga@fly.cc.fer.hr>
@@ -8106,9 +8181,9 @@ L:	wimax@linuxwimax.org
 S:	Supported
 W:	http://linuxwimax.org
 F:	Documentation/wimax/README.wimax
-F:	include/linux/wimax.h
 F:	include/linux/wimax/debug.h
 F:	include/net/wimax.h
+F:	include/uapi/linux/wimax.h
 F:	net/wimax/
 
 WISTRON LAPTOP BUTTON DRIVER
@@ -8218,6 +8293,7 @@ F:	drivers/*/xen-*front.c
 F:	drivers/xen/
 F:	arch/x86/include/asm/xen/
 F:	include/xen/
+F:	include/uapi/xen/
 
 XEN HYPERVISOR ARM
 M:	Stefano Stabellini <stefano.stabellini@eu.citrix.com>
-- 
1.7.11.7

