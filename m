Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab2FODcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:32:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:50594 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab2FODcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:32:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165911896"
Date: Fri, 15 Jun 2012 11:32:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: MAINTAINERS: missing git trees
Message-ID: <20120615033202.GA9251@localhost>
References: <1339727661.25607.22.camel@joe2Laptop>
 <20120615025751.GB8250@localhost>
 <1339729657.25607.26.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339729657.25607.26.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 08:07:37PM -0700, Joe Perches wrote:
> On Fri, 2012-06-15 at 10:57 +0800, Fengguang Wu wrote:
> > On Thu, Jun 14, 2012 at 07:34:21PM -0700, Joe Perches wrote:
> > > These git trees listed in MAINTAINERS don't seem to exist.
> > Yeah I noticed this, too, several days ago.
> 
> https://lkml.org/lkml/2012/2/13/341

Okay, it's already warned. Unfortunately there are only a few
responses. We may get more responses if sending emails directly to the
"M:" addresses.

On the other hand, I put the git trees that is active during the past
half year to file "trees" and use the below script to show the trees
that are not included in MAINTAINERS. When deleting the dead trees, we
may check in this list whether the owner (eg. /mason/) created a new
tree for the same subsystem :)

while read git; do
grep -F "$git" -q MAINTAINERS || echo git: git://git.kernel.org/pub/scm/$git.git
done < trees

git: git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/fio.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jh/bluetooth-next.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-unstable.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next-history.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/sarah/xhci.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/tyhicks/ecryptfs.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/hda-emu.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jj/linux-apparmor.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/kasatkin/linux-digsig.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/alsa-driver-build-unstable.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-nomadik.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/alsa-driver-build.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/ralf/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-3.2.y-queue.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-3.2.y.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/perfbook.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-regdb.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux-android-ia.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/patches.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-for-linus.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-omap-pm.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/hjl/binutils.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware-backup.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/agk/linux-dm.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-testing.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/davem/silo.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/geoff/ps3-linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/kay/patches.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas-backport.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/uemacs.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rw/misc.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-modsign.git
git: git://git.kernel.org/pub/scm/linux/storage/autofs/autofs.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/mattst88/alpha.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rw/ubi2.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/lrg/asoc.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/apw/overlayfs.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-work.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jeremy/xen.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/ido/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/kgdb.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-extable.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/galak/powerpc.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux.git
git: git://git.kernel.org/pub/scm/linux/hotplug/udev.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/kristoffer/linux-gma500.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/arne/linux-btrfs.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/paulg/3.4-rt-patches.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/geoff/libtwin.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/viro/um-headers.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jikos/apm.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/pjw/omap-devel.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/pjw/omap-pending.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/geoff/petitboot.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rteval.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/kas/3.0-mid.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/amit/virtio-console.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-asm_system.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/klassert/linux-stk.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-earlyinitramfs.git
git: git://git.kernel.org/pub/scm/linux/pcmcia/pcmciautils.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/sysctl.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/kyle/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/olof/tegra.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/for-greg.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/geoff/nohz-tests.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/linux-firmware.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/pjt/linsched.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/davej/cpufreq.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-next.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/olof/misc.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/longterm/longterm-queue-2.6.32.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/brodo/cpupowerutils.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/sfr/next-fixes.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-utils.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/warthog9/hook-test.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/axboe/blktrace.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fscache.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-arm-arch.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jh/wireless.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/nico/orion.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/apw/checkpatch.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/salsa-lib.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-test.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/pesconvert.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/joern/cancd.git
git: git://git.kernel.org/pub/scm/linux/storage/multipath/hare/multipath-tools.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-kconfig.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/rusty/modules.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/kay/libabc.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/ohad/rpmsg.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/konrad/ibft.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/hch/qemu-iotests.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/legion/kbd.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/cachefilesd.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-x86-syscalls.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/arne/btrfs-progs.git
git: git://git.kernel.org/pub/scm/linux/kernel/git/jkacur/linux-rt.git
