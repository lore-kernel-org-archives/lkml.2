Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab1FQUj5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 16:39:57 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:47701 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343Ab1FQUjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 16:39:55 -0400
Date: Fri, 17 Jun 2011 22:36:49 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [00/91] 2.6.32.42-longterm review
Message-ID: <20110617203649.GA29317@nik-comp.lan>
References: <20110616001900.GA25375@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20110616001900.GA25375@kroah.com>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5303625 records (last update: 20110617)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,
seems like only first 55 mails made it to the list, also the link seems to =
be wrong...
maybe some bug in the script?
n.

On Wed, Jun 15, 2011 at 05:19:00PM -0700, Greg KH wrote:
> This is the start of the longterm review cycle for the 2.6.32.42 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
>=20
> Responses should be made by Sat, Jun 18, 2011, 00:00:00 UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v2.6/longterm-review/patch-2.6.32.-rc1.gz
> and the diffstat can be found below.
>=20
> The full set of patches will be sent, as normal, however they will be
> delayed by a few hours out of respect for those still awake and trying
> to get work done.
>=20
> thanks,
>=20
> greg k-h
>=20
>  Makefile                                |    2 +-
>  arch/powerpc/kernel/misc_64.S           |   13 ++++--
>  arch/powerpc/oprofile/op_model_power4.c |   24 +++++++++++-
>  arch/x86/include/asm/uaccess.h          |    2 +-
>  arch/x86/kernel/amd_iommu_init.c        |    8 ++--
>  arch/x86/kernel/cpu/amd.c               |   16 +++++--
>  arch/x86/kernel/process_32.c            |    1 -
>  arch/x86/kernel/process_64.c            |    1 -
>  arch/x86/lib/copy_user_64.S             |    4 +-
>  arch/x86/xen/mmu.c                      |    2 +-
>  arch/x86/xen/multicalls.c               |   12 +++---
>  block/blk-core.c                        |    2 +
>  block/blk.h                             |    3 +-
>  drivers/acpi/scan.c                     |   12 +++---
>  drivers/ata/pata_cmd64x.c               |   66 ++++++++++++++++++++-----=
-----
>  drivers/ata/pata_hpt366.c               |    8 +---
>  drivers/ata/pata_hpt37x.c               |   21 ++++------
>  drivers/ata/pata_hpt3x2n.c              |   15 ++-----
>  drivers/ata/pata_sil680.c               |    6 +--
>  drivers/block/brd.c                     |   11 +++--
>  drivers/block/loop.c                    |   11 +++--
>  drivers/block/nbd.c                     |    6 +++
>  drivers/char/i8k.c                      |    4 +-
>  drivers/cpufreq/cpufreq.c               |   20 ++++++++-
>  drivers/cpufreq/cpufreq_stats.c         |   22 +++++++++-
>  drivers/cpuidle/governors/menu.c        |    4 +-
>  drivers/gpu/drm/i915/intel_lvds.c       |    8 ++++
>  drivers/gpu/drm/radeon/radeon_device.c  |    1 +
>  drivers/md/dm-table.c                   |   17 ++++++++
>  drivers/md/md.c                         |    2 +-
>  drivers/md/raid5.c                      |    8 ++--
>  drivers/mtd/mtdconcat.c                 |    4 +-
>  drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
>  drivers/net/wireless/p54/p54usb.c       |    1 +
>  drivers/pci/hotplug/pcihp_slot.c        |   45 +++++++++++++++++++++
>  drivers/pci/pci.c                       |    8 +++-
>  drivers/pci/quirks.c                    |   10 +++++
>  drivers/scsi/scsi_scan.c                |   11 +++--
>  drivers/scsi/scsi_sysfs.c               |   19 ++++-----
>  drivers/scsi/ultrastor.c                |    2 +-
>  drivers/staging/usbip/usbip_common.c    |    2 +-
>  drivers/usb/class/cdc-acm.c             |    2 +
>  drivers/usb/core/hub.c                  |    6 ++-
>  drivers/usb/gadget/at91_udc.c           |    2 +-
>  drivers/usb/gadget/f_rndis.c            |    3 +-
>  drivers/usb/host/ohci-pci.c             |   12 +++++-
>  drivers/usb/host/xhci-mem.c             |   18 +++++++--
>  drivers/usb/serial/cp210x.c             |    4 ++
>  drivers/usb/serial/ftdi_sio.c           |    2 +
>  drivers/usb/serial/ftdi_sio_ids.h       |    6 +++
>  drivers/usb/serial/garmin_gps.c         |   20 ++++++---
>  drivers/usb/serial/moto_modem.c         |    1 +
>  drivers/xen/events.c                    |    9 +----
>  fs/block_dev.c                          |   27 ++++++++----
>  fs/dcookies.c                           |    3 +
>  fs/ecryptfs/keystore.c                  |   46 ++++++++++------------
>  fs/exec.c                               |    5 +--
>  fs/ext3/namei.c                         |   13 +++++-
>  fs/ext4/mballoc.c                       |    2 +
>  fs/fat/file.c                           |    2 +-
>  fs/jbd/commit.c                         |    9 +++-
>  fs/jbd/journal.c                        |   16 ++++++-
>  fs/partitions/ldm.c                     |    5 ++
>  fs/ubifs/journal.c                      |    1 +
>  fs/ubifs/sb.c                           |    3 +-
>  fs/ubifs/shrinker.c                     |    6 ++-
>  fs/ubifs/super.c                        |    1 +
>  fs/xfs/linux-2.6/xfs_sync.c             |   16 ++++++--
>  fs/xfs/linux-2.6/xfs_sync.h             |    1 +
>  fs/xfs/xfs_iget.c                       |    1 +
>  include/linux/interrupt.h               |    3 +-
>  include/linux/pci_ids.h                 |    2 +
>  include/linux/seqlock.h                 |    4 +-
>  kernel/irq/manage.c                     |   11 +++++-
>  kernel/irq/pm.c                         |    3 -
>  kernel/lockdep.c                        |    2 +-
>  kernel/time/timekeeping.c               |    9 +++-
>  kernel/trace/ftrace.c                   |   12 +++--
>  lib/locking-selftest.c                  |    2 +-
>  mm/hugetlb.c                            |    4 +-
>  mm/kmemleak.c                           |    7 ++-
>  mm/page_alloc.c                         |    2 +-
>  net/atm/atm_sysfs.c                     |   10 +++++
>  net/ipv6/netfilter/ip6t_REJECT.c        |    4 +-
>  net/ipv6/netfilter/nf_conntrack_reasm.c |    8 +---
>  net/netfilter/xt_DSCP.c                 |    2 +-
>  net/sunrpc/xprtsock.c                   |   16 ++++++-
>  net/wireless/nl80211.c                  |    2 +-
>  sound/pci/hda/patch_realtek.c           |    1 +
>  sound/pci/hda/patch_sigmatel.c          |    2 +-
>  sound/soc/codecs/wm_hubs.c              |   24 +++++++-----
>  91 files changed, 552 insertions(+), 256 deletions(-)
>=20
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk37uuEACgkQ3xdJJrLygV4QVwCfZONzcOS8zc80Z8Jc8ND/NjXO
SIsAoOgdcG278G0nxcr5Jw8q/wZ5L/kN
=Am/S
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
