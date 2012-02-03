Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2BCRtM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:49:12 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49484 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756962Ab2BCRtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:49:09 -0500
X-Sasl-enc: 7npb7GmLkAnzhbnQjZ6VtWEBB6N5u/1BV0m2nC98KC9M 1328291348
Date: Fri, 3 Feb 2012 09:38:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.19
Message-ID: <20120203173831.GA18014@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWyiEgJYm5f9v55/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.19 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/arm/mach-ux500/Kconfig             |    1=20
 arch/arm/mm/proc-v7.S                   |    6 -
 arch/x86/include/asm/uv/uv_hub.h        |    4 -
 arch/x86/kernel/microcode_amd.c         |   24 ++++++-
 arch/x86/net/bpf_jit_comp.c             |   36 ++++++----
 crypto/sha512_generic.c                 |   62 ++++++++++--------
 drivers/gpu/drm/drm_auth.c              |    6 +
 drivers/gpu/drm/drm_fops.c              |    5 +
 drivers/gpu/drm/i915/intel_sdvo.c       |    8 --
 drivers/gpu/drm/radeon/radeon_irq_kms.c |    6 +
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c     |    2=20
 drivers/hwmon/f71805f.c                 |   10 +-
 drivers/hwmon/sht15.c                   |    3=20
 drivers/hwmon/w83627ehf.c               |    6 +
 drivers/net/bonding/bond_alb.c          |   27 ++------
 drivers/tty/serial/amba-pl011.c         |   14 ++++
 drivers/tty/serial/jsm/jsm_driver.c     |    1=20
 drivers/tty/tty_port.c                  |   12 ++-
 drivers/usb/class/cdc-wdm.c             |   59 +++++++++++------
 drivers/usb/host/ehci-fsl.c             |    2=20
 drivers/usb/host/xhci-ring.c            |    6 +
 drivers/usb/misc/usbsevseg.c            |    2=20
 drivers/usb/serial/cp210x.c             |  107 ++++++++++++++++++++++-----=
-----
 drivers/usb/serial/ftdi_sio.c           |   14 ++--
 drivers/usb/serial/ftdi_sio_ids.h       |   19 +++++
 drivers/usb/serial/io_ti.c              |   10 --
 drivers/usb/serial/option.c             |    5 +
 drivers/usb/serial/qcaux.c              |    7 +-
 fs/ecryptfs/crypto.c                    |   49 +-------------
 fs/ecryptfs/inode.c                     |   48 ++++++++++----
 fs/ecryptfs/miscdev.c                   |   56 +++++++++++-----
 fs/ecryptfs/read_write.c                |   19 ++++-
 fs/xfs/linux-2.6/xfs_discard.c          |    4 -
 fs/xfs/xfs_vnodeops.c                   |    3=20
 include/drm/drmP.h                      |    1=20
 include/net/netns/generic.h             |    1=20
 kernel/printk.c                         |    6 +
 kernel/trace/ftrace.c                   |   76 ++++++++++++++--------
 net/caif/caif_dev.c                     |   11 +--
 net/caif/cfcnfg.c                       |    1=20
 net/core/net_namespace.c                |   31 ++++-----
 net/ipv4/ah4.c                          |    2=20
 net/ipv4/tcp_ipv4.c                     |    2=20
 net/ipv4/tcp_output.c                   |    6 -
 net/ipv6/ah6.c                          |    2=20
 net/ipv6/tcp_ipv6.c                     |    2=20
 net/l2tp/l2tp_ip.c                      |    5 -
 net/rds/af_rds.c                        |   20 ++---
 sound/pci/hda/patch_realtek.c           |   11 +++
 sound/pci/hda/patch_sigmatel.c          |    8 +-
 51 files changed, 507 insertions(+), 323 deletions(-)

--pWyiEgJYm5f9v55/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPLBuXAAoJEDjbvchgkmk+dEEQAJevJinqe1T97ZDu0yZzDdJ3
OzZ5qBSFGgY/j5VIVtEhZQ/qE+n5GJJ9yz7FpqL3EJz+bKMeL4DzXmt53FQsd373
meaxX3F0wvw5N9pExJJlbF6CNqn29OTex25kfW1VHEhk3SKjWw5VzQJwoI5IkpKg
U3uN8GzSZR5W69Ikq9nL7UYic0eCm28Q2Q34vIH+hWU0GG+nQlHOZO3Uu/ctXNgq
Y0KrxmmVrKlgHJrUQ7Z1q5QjaErWn1nE7Qf0nyK9PJidv0LFY5FWi45hhYR0d3dw
JVE3/+2+jcbxWu2eR2ogeyg+5De9/yAc7YoaMgxpuns5I/ZBkVJ+s7O3YPBaM9Ck
eA8KFzXPayRDQ03FRQCUrrs9x7KdMfy8tZCIkgLABb/0Diq+XdMu0kr/4FLfSeLG
6Mb6NIzLfX01THT9q+UshapGdOhKsOYEL0yLHvs8A0Q+FnsvU8Q30r17tzDGKPhQ
/3KqF7N3UCnU78Qzb0gjE++ynYx0ViHaHYy21zqzx4947iO7M6o5LhctFQSSzTYL
Rotemj7+DepwRP7fxOLLXMOqEpnueFNqhzVxOsLJDiEDSzz5FQcR+upCTqOgSrlR
Aj6Kl2aOmjH80CECudKDK7xYeZen8YZ9wvxVotmmSxA1am0UrB4aPmg/Lk4Qau1p
PM/kIPo1SKcjRrP8uVhd
=JqN2
-----END PGP SIGNATURE-----

--pWyiEgJYm5f9v55/--
