Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab2BCRtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:49:21 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53789 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757412Ab2BCRtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:49:12 -0500
X-Sasl-enc: A2LWPOZxWyGQCTB45yoGuxv0eHD/4E2nlb/c+kSwOmNE 1328291351
Date: Fri, 3 Feb 2012 09:47:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.2.3
Message-ID: <20120203174758.GA18584@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.3 kernel.

All users of the 3.2 kernel series must upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                         |    2=20
 arch/arm/mach-at91/setup.c                       |    7 +
 arch/arm/mach-ux500/Kconfig                      |    1=20
 arch/arm/mach-ux500/board-mop500-sdi.c           |    2=20
 arch/arm/mm/proc-v7.S                            |    6 -
 arch/m68k/atari/config.c                         |    8 -
 arch/m68k/kernel/process_mm.c                    |    4=20
 arch/m68k/kernel/process_no.c                    |    4=20
 arch/m68k/kernel/traps.c                         |   36 +++----
 arch/m68k/mm/cache.c                             |    6 -
 arch/x86/include/asm/uv/uv_hub.h                 |    4=20
 arch/x86/kernel/microcode_amd.c                  |   24 ++++-
 arch/x86/net/bpf_jit_comp.c                      |   36 ++++---
 arch/x86/platform/uv/tlb_uv.c                    |    2=20
 arch/x86/platform/uv/uv_irq.c                    |    2=20
 arch/x86/xen/spinlock.c                          |   27 ++++-
 crypto/sha512_generic.c                          |   62 +++++++------
 drivers/char/tpm/tpm_tis.c                       |    3=20
 drivers/gpu/drm/drm_auth.c                       |    6 +
 drivers/gpu/drm/drm_fops.c                       |    5 +
 drivers/gpu/drm/i915/i915_suspend.c              |    4=20
 drivers/gpu/drm/i915/intel_ringbuffer.c          |   27 +++++
 drivers/gpu/drm/i915/intel_sdvo.c                |    8 -
 drivers/gpu/drm/radeon/atombios_dp.c             |   22 ++--
 drivers/gpu/drm/radeon/atombios_encoders.c       |   26 ++++-
 drivers/gpu/drm/radeon/radeon_irq_kms.c          |    6 +
 drivers/gpu/drm/radeon/radeon_mode.h             |    3=20
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c              |    2=20
 drivers/hwmon/f71805f.c                          |   10 +-
 drivers/hwmon/sht15.c                            |    3=20
 drivers/hwmon/w83627ehf.c                        |    6 +
 drivers/net/bonding/bond_alb.c                   |   27 +----
 drivers/net/macvlan.c                            |    1=20
 drivers/net/wireless/brcm80211/brcmsmac/main.c   |   10 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c |    4=20
 drivers/scsi/mpt2sas/mpt2sas_base.c              |   20 +---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c             |    3=20
 drivers/tty/serial/amba-pl011.c                  |   14 +++
 drivers/tty/serial/jsm/jsm_driver.c              |    1=20
 drivers/tty/tty_port.c                           |   12 +-
 drivers/usb/class/cdc-wdm.c                      |   59 ++++++++----
 drivers/usb/dwc3/ep0.c                           |   14 ---
 drivers/usb/gadget/langwell_udc.c                |   18 +--
 drivers/usb/gadget/storage_common.c              |    6 -
 drivers/usb/host/ehci-fsl.c                      |    2=20
 drivers/usb/host/xhci-ring.c                     |    6 -
 drivers/usb/misc/usbsevseg.c                     |    2=20
 drivers/usb/musb/davinci.c                       |    3=20
 drivers/usb/serial/cp210x.c                      |  107 ++++++++++++++++--=
-----
 drivers/usb/serial/ftdi_sio.c                    |   14 ++-
 drivers/usb/serial/ftdi_sio_ids.h                |   19 ++++
 drivers/usb/serial/io_ti.c                       |   10 --
 drivers/usb/serial/option.c                      |    5 +
 drivers/usb/serial/qcaux.c                       |    7 +
 drivers/usb/storage/realtek_cr.c                 |    2=20
 fs/ecryptfs/crypto.c                             |   49 +---------
 fs/ecryptfs/inode.c                              |   48 +++++++---
 fs/ecryptfs/miscdev.c                            |   56 ++++++++----
 fs/ecryptfs/read_write.c                         |   19 +++-
 fs/jbd/checkpoint.c                              |   27 ++++-
 fs/jbd/recovery.c                                |    4=20
 fs/sysfs/file.c                                  |    6 +
 fs/sysfs/inode.c                                 |    5 -
 fs/xfs/xfs_vnodeops.c                            |    3=20
 include/drm/drmP.h                               |    1=20
 include/net/netns/generic.h                      |    1=20
 net/caif/caif_dev.c                              |   11 --
 net/caif/cfcnfg.c                                |    1=20
 net/core/net-sysfs.c                             |    6 -
 net/core/net_namespace.c                         |   31 +++---
 net/core/netpoll.c                               |    2=20
 net/decnet/dn_dev.c                              |    4=20
 net/ipv4/devinet.c                               |    2=20
 net/ipv4/fib_trie.c                              |   10 +-
 net/ipv4/igmp.c                                  |    8 -
 net/ipv4/ipip.c                                  |    8 -
 net/ipv4/ipmr.c                                  |    2=20
 net/ipv4/tcp_ipv4.c                              |    2=20
 net/ipv4/tcp_output.c                            |    6 -
 net/ipv6/addrconf.c                              |    2=20
 net/ipv6/ip6_tunnel.c                            |    8 -
 net/ipv6/raw.c                                   |    2=20
 net/ipv6/sit.c                                   |   10 +-
 net/ipv6/tcp_ipv6.c                              |    2=20
 net/l2tp/l2tp_ip.c                               |    5 -
 net/mac80211/agg-rx.c                            |    2=20
 net/mac80211/cfg.c                               |    4=20
 net/mac80211/ibss.c                              |    2=20
 net/mac80211/mlme.c                              |   38 +++++---
 net/mac80211/sta_info.c                          |    6 -
 net/netfilter/nf_conntrack_core.c                |    2=20
 net/netfilter/nf_conntrack_ecache.c              |    4=20
 net/netfilter/nf_conntrack_extend.c              |    2=20
 net/netfilter/nf_conntrack_helper.c              |    2=20
 net/netfilter/nf_conntrack_netlink.c             |    2=20
 net/netfilter/nf_log.c                           |    6 -
 net/netfilter/nf_queue.c                         |    2=20
 net/netfilter/nfnetlink.c                        |    4=20
 net/netlabel/netlabel_domainhash.c               |    4=20
 net/netlabel/netlabel_unlabeled.c                |    6 -
 net/phonet/af_phonet.c                           |    2=20
 net/phonet/pn_dev.c                              |    2=20
 net/phonet/socket.c                              |    2=20
 net/rds/af_rds.c                                 |   20 +---
 net/socket.c                                     |    2=20
 net/sunrpc/auth_gss/auth_gss.c                   |    2=20
 net/unix/af_unix.c                               |   19 ----
 net/xfrm/xfrm_user.c                             |    2=20
 sound/pci/hda/hda_intel.c                        |    6 -
 sound/pci/hda/patch_realtek.c                    |   11 ++
 sound/pci/hda/patch_sigmatel.c                   |   17 ++-
 sound/soc/codecs/wm5100.c                        |    3=20
 sound/soc/codecs/wm8996.c                        |    7 +
 sound/soc/codecs/wm8996.h                        |    4=20
 114 files changed, 766 insertions(+), 490 deletions(-)

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPLB3OAAoJEDjbvchgkmk+6jUP/A9jPZwCcN9Rvzl6mO7670fe
0aUlAUrxznMBeSX10ws5b4I4pWosaYoBepgnrx6FJF29yX70EkOj3A1Npeo23o9g
5J5hrGM69zrx9gLX8AkwKCyLn3zy24SzNAvonNVPiTMR7Mde4AMn1c2fA1yn8bJc
XWlMS1RI6PX+nbmUfhxH09IGba8KUfNegG9NGRl4TEtdmXGhQo0F8nzv0BsLi5Ro
ptG0mFRm938AMr1+NNz85L1wxB/mhW47maN69RQmj+cm0KN5oECvdZC+V+H8Q+sC
arNxZ1uGOd2efZVsX5A3lI2883ztb3iFr4ZQX9myrv0KFOqrSoDpdCk50plnw4de
j7gooSTjze3bdVlX6cg7k9Z8jXQz7BSb4yB4C6+ToqFNpO7YnAGlEoqJa8rikebt
IKkkALdTjUPtnboWPp0kpyTenO3qme1KlHpzZzweuBy78O3C4hjqbqeLjezA338h
fMA99XTwJ9kW6z+oy/DAQryh4lMOcB1MaaZ7e97FRsTtCdfymvP90vpHTSrRL32E
/wThJGDrCYJAl7qS97yNL+Fe9l9rqcfbJftCrqnRsm5+2rH8/B4GiNXNjtKQmYc0
H5FShoY08jUVht0VLJMPyPsGDG/h/5vTiAsvJej5Pou0FJZIX0AmBLxTbqNJ8/5n
/SutqERbi3S+uNVY2C8l
=SioI
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
