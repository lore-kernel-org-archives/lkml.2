Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989Ab2KEKLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:11:37 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:60326 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2KEKLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:11:01 -0500
Date: Mon, 5 Nov 2012 11:10:21 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.6.6
Message-ID: <20121105101021.GA24501@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.6.6 kernel.

All users of the 3.6 kernel series must upgrade.

The updated 3.6.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.6.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 block/blk-cgroup.c                      |    7 +
 drivers/block/floppy.c                  |   27 ++--
 drivers/gpio/gpio-timberdale.c          |    4=20
 drivers/gpio/gpiolib.c                  |   10 +
 drivers/gpu/drm/nouveau/nouveau_drv.c   |   20 +--
 drivers/gpu/drm/nouveau/nouveau_state.c |    4=20
 drivers/gpu/drm/nouveau/nv04_dac.c      |    8 -
 drivers/gpu/drm/nouveau/nv04_dfp.c      |    6=20
 drivers/gpu/drm/nouveau/nv04_tv.c       |    4=20
 drivers/hid/hid-microsoft.c             |   18 ++
 drivers/md/raid1.c                      |    2=20
 drivers/scsi/qla2xxx/qla_target.c       |   25 +---
 drivers/scsi/qla2xxx/qla_target.h       |    1=20
 drivers/scsi/qla2xxx/tcm_qla2xxx.c      |   73 +++++++++++
 drivers/target/target_core_sbc.c        |   18 ++
 drivers/target/target_core_transport.c  |    1=20
 drivers/usb/serial/io_edgeport.c        |    1=20
 drivers/usb/serial/iuu_phoenix.c        |    3=20
 drivers/usb/serial/mos7840.c            |  198 +++++++++++----------------=
-----
 fs/ceph/addr.c                          |   11 -
 fs/ceph/export.c                        |    2=20
 fs/ceph/mds_client.c                    |    3=20
 fs/ext4/ialloc.c                        |   19 +--
 include/linux/ceph/osd_client.h         |    2=20
 include/linux/ceph/osdmap.h             |    6=20
 net/ceph/messenger.c                    |    6=20
 net/ceph/osd_client.c                   |   32 +++--
 net/ceph/osdmap.c                       |   18 ++
 29 files changed, 309 insertions(+), 222 deletions(-)

Alex Elder (2):
      rbd: reset BACKOFF if unable to re-queue
      ceph: avoid 32-bit page index overflow

Ben Skeggs (3):
      drm/nouveau: silence modesetting spam on pre-gf8 chipsets
      drm/nouveau: fix suspend/resume when in headless mode
      drm/nouveau: headless mode by default if pci class !=3D vga display

Bernhard Kohl (1):
      target: reintroduce some obsolete SCSI-2 commands

Dan Carpenter (1):
      gpio-timberdale: fix a potential wrapping issue

David Zafman (1):
      ceph: fix dentry reference leak in encode_fh()

Eric Sandeen (1):
      ext4: fix unjournaled inode bitmap modification

Greg Kroah-Hartman (1):
      Linux 3.6.6

Herton Ronaldo Krzesinski (3):
      floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
      floppy: do put_disk on current dr if blk_init_queue fails
      floppy: properly handle failure on add_disk loop

Jiri Slaby (1):
      HID: microsoft: fix invalid rdesc for 3k kbd

Johan Hovold (2):
      USB: mos7840: fix port-data memory leak
      USB: iuu_phoenix: fix backported patches

Jun'ichi Nomura (1):
      blkcg: Fix use-after-free of q->root_blkg and q->root_rl.blkg

Mathias Nyman (1):
      gpiolib: Don't return -EPROBE_DEFER to sysfs, or for invalid gpios

NeilBrown (1):
      md/raid1: Fix assembling of arrays containing Replacements.

Nicholas Bellinger (1):
      target: Fix double-free of se_cmd in target_complete_tmr_failure

Paul Bolle (1):
      USB: io_edgeport: remove unused variable

Roland Dreier (1):
      qla2xxx: Update target lookup session tables when a target session ch=
anges

Sage Weil (2):
      libceph: avoid NULL kref_put when osd reset races with alloc_msg
      libceph: check for invalid mapping

Yan, Zheng (1):
      ceph: Fix oops when handling mdsmap that decreases max_mds


--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQl5CNAAoJEDjbvchgkmk+CysP/1jRCSDIbmWUA7SHV32FiGUv
ODTalVPTxuOKhORi5vdOCwxlD0ya21Rup1eTfvjyxCrEUJ9gCW9P8sNQlaol7S0U
hGB34FAhm4k3625QLDtiqyventOKYh8dEt04f1EtbSFjVwM06TLL54Uj6IsYwXuD
5YlOGrPdJHsUR6uBv05+7izLiG6drd2f1Bny+Tf1GXOsU0pXy5i18bAmNqf9lJ2S
iAxM8n9YZx7KbxyipRH7+eqqzEcOzKMgaEXoELuRHv5Kd5KXLzliWkWzx2gy2wyB
bwphWOrAFDQ4RuRk9Pd5krPeN+BH66SSsbDifA889K1v1N8CXcWBgVbP9DDe9pUc
hkX9mlAYmaXVnopqFS2E+hRLDpGhjidB0YmZRSztXn1bOwLIoGQSXQKsAsCh6mkW
XGuG3vYu2EY+eMIfzUeo6FCYsBS0xXXa1zAwkGiHOG5XCGogBdGt45CgFnE6L50Y
yLuzwlJdXZpCKo8TqO8j/+BuQhONH+UASQcg2CKq1y2YdbHWXvbtvSDlQWel8ri2
0TnM7Rw+Kt95OoGUeS+U3v8sLpcalWvcW+qUor/E2+zB6C2EzzRXV0GxgbW0PAgF
OFxGMLJmZd3sD1ZeubciCoMDK+eGCxwZD2RJ4DWOJpgkM+lse4ZpWmnItkMMaekX
MTOfNpjN2eGSDJhA41DW
=vXGP
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
