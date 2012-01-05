Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932549Ab2AET1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:27:20 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35020 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932498Ab2AET1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:27:16 -0500
X-Sasl-enc: YLOPTZ0rPNMfnJ84Dz8k8oCz2p1CDk/a1QBwJAn/emHl 1325791635
Date: Thu, 5 Jan 2012 11:26:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [00/75] 3.1.8-stable review
Message-ID: <20120105192640.GA27891@kroah.com>
References: <20120103223332.GA4112@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20120103223332.GA4112@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 03, 2012 at 02:33:32PM -0800, Greg KH wrote:
> This is the start of the stable review cycle for the 3.1.8 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.
>=20
> Responses should be made by Friday, January 6, 2012, 20:00:00 UTC.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.1.8-rc1.gz

Due to a few noted issues in this series, and a few last-minute
straggler patches being applied to the final 3.2 release, there's a new
3.1.8-rc2 release, which can be found at:
        kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.1.8-rc2.gz
and the diffstat can be found below.

thanks,

greg k-h


 Makefile                                     |    4 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 arch/arm/oprofile/common.c                   |    2 +-
 arch/arm/plat-mxc/pwm.c                      |   16 +-
 arch/s390/oprofile/init.c                    |    2 +-
 arch/sh/oprofile/common.c                    |    4 +-
 arch/sparc/include/asm/pgtable_32.h          |   20 +-
 arch/sparc/include/asm/pgtable_64.h          |   20 +-
 arch/sparc/kernel/entry.h                    |    7 +
 arch/sparc/kernel/module.c                   |   27 +
 arch/sparc/kernel/pci_sun4v.c                |    4 +-
 arch/sparc/kernel/setup_64.c                 |   48 +-
 arch/sparc/kernel/signal32.c                 |   18 +-
 arch/sparc/kernel/signal_32.c                |   30 +-
 arch/sparc/kernel/signal_64.c                |   42 +-
 arch/sparc/kernel/visemul.c                  |   32 +-
 arch/sparc/lib/memcpy.S                      |  804 ++++------------------=
----
 arch/sparc/mm/Makefile                       |    1 -
 arch/sparc/mm/btfixup.c                      |    3 +-
 arch/sparc/mm/generic_32.c                   |   98 ----
 arch/sparc/mm/generic_64.c                   |  164 ------
 arch/x86/net/bpf_jit_comp.c                  |    4 +-
 block/blk-core.c                             |   14 +-
 block/cfq-iosched.c                          |   16 +-
 drivers/gpu/drm/i915/i915_dma.c              |   10 +
 drivers/gpu/drm/i915/i915_drv.h              |    1 +
 drivers/gpu/drm/i915/i915_reg.h              |    8 +-
 drivers/gpu/drm/i915/intel_sdvo.c            |    8 +-
 drivers/gpu/drm/radeon/evergreen.c           |   12 +
 drivers/gpu/drm/radeon/radeon_atombios.c     |    6 +-
 drivers/infiniband/hw/mlx4/main.c            |    6 +-
 drivers/input/mouse/synaptics.c              |   11 +
 drivers/media/video/omap/omap_vout.c         |    1 +
 drivers/media/video/s5p-fimc/fimc-core.c     |    2 +-
 drivers/mfd/twl-core.c                       |   16 +-
 drivers/mfd/twl4030-madc.c                   |   22 +
 drivers/mmc/host/mmci.c                      |   14 +-
 drivers/mmc/host/vub300.c                    |    2 +-
 drivers/net/pptp.c                           |    4 +-
 drivers/net/wireless/ath/ath9k/main.c        |    3 +
 drivers/net/wireless/ath/ath9k/rc.c          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |    5 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c     |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/phy.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c |    2 +-
 drivers/oprofile/oprofile_files.c            |    7 +-
 drivers/oprofile/oprofilefs.c                |   11 +-
 drivers/rtc/interface.c                      |   44 +--
 drivers/rtc/rtc-m41t80.c                     |    9 +
 drivers/s390/scsi/zfcp_scsi.c                |    4 +
 drivers/scsi/fcoe/fcoe.c                     |    1 +
 drivers/scsi/mpt2sas/mpt2sas_base.c          |   59 +--
 drivers/scsi/mpt2sas/mpt2sas_base.h          |    4 -
 drivers/scsi/mpt2sas/mpt2sas_scsih.c         |    2 +-
 drivers/ssb/driver_pcicore.c                 |    8 +-
 drivers/watchdog/hpwdt.c                     |    5 +-
 fs/nfs/file.c                                |    2 +-
 fs/nfs/nfs4state.c                           |    8 +-
 fs/nilfs2/ioctl.c                            |   13 +
 include/linux/blkdev.h                       |    3 -
 include/linux/i2c/twl4030-madc.h             |    4 +
 include/linux/lglock.h                       |   36 +-
 include/net/dst.h                            |    1 +
 include/net/flow.h                           |    1 +
 include/net/sctp/structs.h                   |    4 +
 kernel/cgroup.c                              |    5 -
 kernel/exit.c                                |    9 +-
 kernel/futex.c                               |   28 +-
 kernel/hung_task.c                           |   14 +-
 kernel/ptrace.c                              |   13 +-
 kernel/signal.c                              |    2 -
 kernel/sysctl_binary.c                       |    2 +-
 mm/filemap.c                                 |    7 +-
 mm/hugetlb.c                                 |    2 +-
 mm/memcontrol.c                              |    3 +-
 mm/mempolicy.c                               |   11 +-
 mm/oom_kill.c                                |    2 +-
 mm/percpu.c                                  |    6 +-
 net/bridge/br_netfilter.c                    |    2 +-
 net/core/flow.c                              |   12 +
 net/ipv4/devinet.c                           |    5 +
 net/ipv4/ipconfig.c                          |    4 +
 net/ipv4/ipip.c                              |    7 +-
 net/ipv4/route.c                             |  111 ++++-
 net/ipv6/ip6_output.c                        |    2 +-
 net/ipv6/route.c                             |    2 +-
 net/ipv6/sit.c                               |    7 +-
 net/llc/af_llc.c                             |   14 +-
 net/mac80211/agg-tx.c                        |   86 ++--
 net/sched/sch_gred.c                         |    2 +-
 net/sched/sch_mqprio.c                       |    2 +-
 net/sctp/associola.c                         |    2 +-
 net/sctp/output.c                            |    8 +-
 net/sctp/outqueue.c                          |    6 +-
 net/sctp/protocol.c                          |    3 +
 net/sctp/socket.c                            |    2 -
 net/sctp/sysctl.c                            |   13 +
 net/sunrpc/xprt.c                            |   10 +-
 net/xfrm/xfrm_policy.c                       |   18 +-
 security/selinux/netport.c                   |    4 +-
 sound/pci/hda/hda_intel.c                    |    1 +
 sound/soc/codecs/wm8996.c                    |    1 +
 105 files changed, 852 insertions(+), 1335 deletions(-)

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPBflwAAoJEDjbvchgkmk+UUMP/06t3JLYleayUF+H6xV6TH96
sv89OpKG6w/Vdel7Yv2vfENxUz5858NLJDie/uo7D+gFHOsQ5Dp8PrJTmn9Jj0VU
Qs370Eed7xws1uVxRr95UqllkV1XGP13CSpzo/MLR0gNTMTJvkzYDEu9I8Zrmkvd
6eBMUQ3y+9NOXyIkwXNv2oJOYIuwCR62zqW0kP6lrDlsmOvf/nSEKzh6n5TJ6IGv
zxCMddfVCEB3Zs70ib86BDQ9KPWmaTXfpPvo55+5B0EqabTWzoYi9QROgSKmwl7w
fCcHUY8u0S5bpPhXi6djJLIZmEvrEsKvRgP8PxbOikUT5CiEVO4/q7dvWddaqP4h
/hsTw65RSrRus0PuLVl5z+v3iTTFh6s1x7lf2QOVzUJw0xR8MPAEfybH3qkMcFjm
6f36UER9hR5qV2ohD0b24aTrJf1FR8wWpZO4Kb9hsxYeiHSCjJZuEAgVXjN9sZLR
AbgH7UeGW9FJ3E8uLOL1WSrUhtJQ9KjvTtq8YgcNzPpfUPWEiabafsTYPKSDbxGq
qzqtU6KHuQ1u8fRxmiqMfAs6fEC4Yu+CVvA3+e5kOAHTXRRyxs6QNwYeVf6EmLjs
6B9S18RELdorxEX/n7Rj0uzEB/WKFNqGapBPlFOF53bCR2eD97NCxgC+DKbh2anO
Tpey0jK48kf9z1DeOCuf
=+lc6
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
