Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab0JYD76 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 23:59:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55651 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab0JYD74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 23:59:56 -0400
Date: Mon, 25 Oct 2010 14:59:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 25
Message-Id: <20101025145950.8e15ea90.sfr@canb.auug.org.au>
In-Reply-To: <20101025145834.9b68e026.sfr@canb.auug.org.au>
References: <20101025145834.9b68e026.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Oct_2010_14_59_50_+1100_V7_lesKYlgLGPXNA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Oct_2010_14_59_50_+1100_V7_lesKYlgLGPXNA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Oct 2010 14:58:34 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Below is a summary of the state of the merge.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master
Merging fixes/fixes
Merging arm-current/master
Merging m68k-current/for-linus
Merging powerpc-merge/merge
Merging sparc-current/master
Merging scsi-rc-fixes/master
Merging net-current/master
Merging sound-current/for-linus
Merging pci-current/for-linus
Merging wireless-current/master
Merging kbuild-current/rc-fixes
Merging quilt/driver-core.current
Merging quilt/tty.current
Merging quilt/usb.current
Merging quilt/staging.current
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-linus
Merging audit-current/for-linus
Merging crypto-current/master
Merging ide-curent/master
Merging dwmw2/master
Merging gcl-current/merge
Merging arm/devel
Merging davinci/davinci-next
Merging i.MX/for-next
Merging msm/for-next
Merging omap/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-zoom-periph=
erals.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/devices.c
Merging pxa/for-next
Merging samsung/next-samsung
Merging s5p/for-next
Merging tegra/for-next
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
Merging mips/mips-for-linux-next
CONFLICT (content): Merge conflict in drivers/usb/host/Kconfig
CONFLICT (content): Merge conflict in drivers/usb/host/Makefile
Merging parisc/next
Merging powerpc/next
Merging 4xx/next
Merging 52xx-and-virtex/next
Merging galak/next
Merging s390/features
CONFLICT (content): Merge conflict in drivers/s390/kvm/kvm_virtio.c
Merging sh/master
CONFLICT (content): Merge conflict in arch/sh/kernel/perf_event.c
Merging genesis/master
Merging sparc/master
Merging tile/master
Merging xtensa/master
CONFLICT (content): Merge conflict in arch/xtensa/configs/iss_defconfig
Merging ceph/for-next
Merging cifs/master
Merging configfs/linux-next
Merging ecryptfs/next
Merging ext3/for_next
Merging ext4/next
CONFLICT (content): Merge conflict in fs/ext4/mballoc.c
Applying: ext4: merge fix for blkdev_issue_zeroout API change
Merging fatfs/master
Merging fuse/for-next
Merging gfs2/master
Merging hfsplus/for-next
Merging jfs/next
Merging logfs/master
CONFLICT (content): Merge conflict in fs/logfs/logfs.h
Merging nfs/linux-next
Merging nfsd/nfsd-next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging nilfs2/for-next
Merging ocfs2/linux-next
Merging omfs/for-next
Merging squashfs/master
Merging udf/for_next
Merging v9fs/for-next
Merging ubifs/linux-next
Merging xfs/master
Merging vfs/for-next
Merging pci/linux-next
Merging hid/for-next
CONFLICT (content): Merge conflict in drivers/hid/hid-ids.h
Merging quilt/i2c
CONFLICT (content): Merge conflict in drivers/i2c/algos/Kconfig
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
Merging hwmon-staging/hwmon-next
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging idle-test/idle-test
Merging ieee1394/for-next
CONFLICT (delete/modify): drivers/ieee1394/eth1394.c deleted in ieee1394/fo=
r-next and modified in HEAD. Version HEAD of drivers/ieee1394/eth1394.c lef=
t in tree.
$ git rm -f drivers/ieee1394/eth1394.c
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging swiotlb/master
Merging ibft/master
Merging scsi/master
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging bluetooth/master
Merging mtd/master
Merging crypto/master
Merging sound/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-s3c64xx/dev-audio.c
CONFLICT (content): Merge conflict in drivers/video/sh_mobile_hdmi.c
Merging sound-asoc/for-next
Merging cpufreq/next
Merging quilt/rr
Merging input/next
CONFLICT (content): Merge conflict in drivers/input/keyboard/Kconfig
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in fs/ocfs2/file.c
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging mmc/mmc-next
$ git reset --hard HEAD^
Merging refs/next/20101022/mmc
CONFLICT (content): Merge conflict in drivers/mmc/card/block.c
[master f0fd311] Merge commit 'refs/next/20101022/mmc'
Merging kgdb/kgdb-next
CONFLICT (content): Merge conflict in drivers/char/sysrq.c
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
CONFLICT (content): Merge conflict in drivers/mfd/sh_mobile_sdhi.c
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Merging hdlc/hdlc-next
Merging drm/drm-next
CONFLICT (content): Merge conflict in drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
Merging viafb/viafb-next
Merging voltage/for-next
Merging security-testing/next
Merging lblnet/master
Merging agp/agp-next
Merging uwb/for-upstream
Merging watchdog/master
Merging bdev/master
Merging dwmw2-iommu/master
Merging cputime/cputime
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
Merging audit/for-next
Merging quilt/aoe
Merging suspend/linux-next
Merging fsnotify/for-next
Merging irda/for-next
Merging catalin/for-next
CONFLICT (content): Merge conflict in arch/arm/kernel/Makefile
CONFLICT (content): Merge conflict in arch/arm/mach-vexpress/ct-ca9x4.c
CONFLICT (content): Merge conflict in arch/arm/mm/flush.c
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in include/linux/Kbuild
CONFLICT (content): Merge conflict in lib/Kconfig
Merging i7core_edac/linux_next
Merging i7300_edac/linux_next
Merging devicetree/next-devicetree
Merging spi/next-spi
Merging omap_dss2/for-next
Merging tip/auto-latest
Merging rcu/rcu/next
Merging oprofile/for-next
Merging xen/upstream/xen
$ git reset --hard HEAD^
Merging refs/next/20101021/xen
CONFLICT (content): Merge conflict in arch/x86/mm/fault.c
[master 04af380] Merge commit 'refs/next/20101021/xen'
Merging swiotlb-xen/master
CONFLICT (content): Merge conflict in drivers/pci/Makefile
Merging xen-pvhvm/linux-next
Merging edac-amd/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging drivers-x86/linux-next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Merging quilt/tty
Merging quilt/usb
CONFLICT (content): Merge conflict in arch/powerpc/sysdev/fsl_soc.c
CONFLICT (content): Merge conflict in drivers/scsi/sd.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/rndis.c
CONFLICT (content): Merge conflict in drivers/usb/host/Kconfig
CONFLICT (content): Merge conflict in drivers/usb/host/Makefile
Merging staging-next/staging-next
CONFLICT (rename/modify): Merge conflict in drivers/misc/ti-st/st_core.c
CONFLICT (rename/modify): Merge conflict in drivers/misc/ti-st/st_kim.c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/devices.c
CONFLICT (content): Merge conflict in drivers/misc/Makefile
CONFLICT (content): Merge conflict in drivers/staging/Makefile
CONFLICT (content): Merge conflict in drivers/staging/batman-adv/hard-inter=
face.c
CONFLICT (content): Merge conflict in drivers/staging/cx25821/cx25821-audio=
-upstream.c
CONFLICT (content): Merge conflict in drivers/staging/cx25821/cx25821-audio=
.h
CONFLICT (delete/modify): drivers/staging/mrst-touchscreen/Makefile deleted=
 in HEAD and modified in staging-next/staging-next. Version staging-next/st=
aging-next of drivers/staging/mrst-touchscreen/Makefile left in tree.
CONFLICT (delete/modify): drivers/staging/mrst-touchscreen/intel-mid-touch.=
c deleted in HEAD and modified in staging-next/staging-next. Version stagin=
g-next/staging-next of drivers/staging/mrst-touchscreen/intel-mid-touch.c l=
eft in tree.
CONFLICT (delete/modify): drivers/staging/ti-st/st.h deleted in staging-nex=
t/staging-next and modified in HEAD. Version HEAD of drivers/staging/ti-st/=
st.h left in tree.
CONFLICT (delete/modify): drivers/staging/ti-st/st_core.h deleted in stagin=
g-next/staging-next and modified in HEAD. Version HEAD of drivers/staging/t=
i-st/st_core.h left in tree.
CONFLICT (content): Merge conflict in fs/compat_ioctl.c
$ git rm -f drivers/staging/mrst-touchscreen/Makefile drivers/staging/mrst-=
touchscreen/intel-mid-touch.c
$ git rm -f drivers/staging/ti-st/st.h drivers/staging/ti-st/st_core.h
Applying: staging: ath6kl: Fixing the driver to use modified mmc_host struc=
ture
Merging slabh/slabh
Merging bkl-trivial/trivial
Merging bkl-llseek/llseek
Merging bkl-vfs/vfs
Merging bkl-config/config
Merging irqflags/master
Merging cleancache/linux-next
CONFLICT (content): Merge conflict in include/linux/fs.h
CONFLICT (content): Merge conflict in mm/Kconfig
Merging scsi-post-merge/merge-base:master
Applying: l2tp: static functions should not be exported

--Signature=_Mon__25_Oct_2010_14_59_50_+1100_V7_lesKYlgLGPXNA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxQC2AAoJEDMEi1NhKgbsUh0H/07/wJZrHTfV+qV881dl2W1g
rxJ98tEzubINGSOQNfPxdRrBsfirrc58oDyLiaXlWCJMC7tPDG5z0nn8OY2advYb
x6qLW6kvzWzAzK+u9S1EjE3W+bYq4WfzzV6Y2Prj37tKeCEyNE8HTHjjqYxfn2/7
vEPh6l5uxbNLnfKnEi87CkvbYbsTE04125ZteLJLbOGYXDuFtrZZgMU6YkrXxDQr
OvFXT9jZaBzFxBdnxUZqvFAGT67dUxo+WOY7Cpdjf0KWdC4hiOmi7tMnWL56k+mq
CfyipaK9moTa6/9nqYKGIZIu+dDOso5Zb+cFPIz7/BXoC/vK5I2hqrX0lWzfBfo=
=PGtN
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Oct_2010_14_59_50_+1100_V7_lesKYlgLGPXNA--
