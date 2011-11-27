Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1K0TLJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 14:11:09 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57442 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754591Ab1K0TLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 14:11:02 -0500
X-Sasl-enc: AFaAYTuo4LKydJtYa7mbXZ0FFHBVqmoGZirMGvGm+s06 1322421061
Date: Mon, 28 Nov 2011 04:10:15 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.49
Message-ID: <20111127191015.GA11946@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 2.6.32.49 kernel.

All users of the 2.6.32 kernel series must upgrade.

The updated 2.6.32.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-2.6.32.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsh=
ortlog;h=3Drefs/heads/linux-2.6.32.y

thanks,

greg k-h

------------

 Documentation/Makefile              |    2=20
 Documentation/kbuild/makefiles.txt  |   12 ++
 Documentation/video4linux/Makefile  |    8 -
 Documentation/video4linux/v4lgrab.c |  201 -------------------------------=
-----
 Makefile                            |    7 -
 arch/ia64/hp/sim/simserial.c        |   12 --
 drivers/base/sys.c                  |    6 +
 drivers/char/amiserial.c            |   56 +++++-----
 drivers/char/cyclades.c             |   49 ++++----
 drivers/char/ip2/ip2main.c          |   72 +++++++-----
 drivers/char/mxser.c                |   62 ++++++-----
 drivers/char/nozomi.c               |   37 +++---
 drivers/char/pcmcia/synclink_cs.c   |   60 ++++------
 drivers/char/synclink.c             |   73 ++++++-------
 drivers/char/synclink_gt.c          |   56 +++++-----
 drivers/char/synclinkmp.c           |   61 +++++-----
 drivers/char/tty_io.c               |   21 +++
 drivers/gpu/drm/i915/i915_gem.c     |   44 ++++---
 drivers/md/raid5.c                  |   32 +++--
 drivers/mtd/mtdchar.c               |    1=20
 drivers/scsi/hosts.c                |    9 +
 drivers/scsi/scsi_lib.c             |    9 +
 drivers/scsi/st.c                   |    4=20
 drivers/serial/68360serial.c        |   51 ++++-----
 drivers/serial/serial_core.c        |   35 ++----
 drivers/usb/core/quirks.c           |   27 ++++
 drivers/usb/serial/ftdi_sio.c       |   14 +-
 drivers/usb/serial/pl2303.c         |    1=20
 drivers/usb/serial/pl2303.h         |    4=20
 drivers/usb/serial/usb-serial.c     |   13 ++
 drivers/usb/storage/protocol.c      |    7 -
 drivers/xen/events.c                |    2=20
 fs/hfs/trans.c                      |    2=20
 include/linux/interrupt.h           |    6 +
 include/linux/tty_driver.h          |    9 +
 include/linux/usb/serial.h          |    2=20
 include/linux/vmalloc.h             |    1=20
 kernel/irq/pm.c                     |   35 +++++-
 kernel/power/suspend.c              |    2=20
 lib/nlattr.c                        |    1=20
 mm/vmalloc.c                        |   67 ++++++++----
 net/bluetooth/rfcomm/tty.c          |    4=20
 net/ipv6/udp.c                      |    2=20
 net/sunrpc/auth_unix.c              |    3=20
 scripts/Kbuild.include              |    5=20
 sound/pci/hda/patch_realtek.c       |    1=20
 sound/soc/codecs/wm8940.c           |    1=20
 47 files changed, 586 insertions(+), 603 deletions(-)


Alan Cox (2):
      tty: Make tiocgicount a handler
      tty: icount changeover for other main devices

Alan Stern (1):
      usb-storage: Accept 8020i-protocol commands longer than 12 bytes

Andrew Worsley (1):
      USB: Fix Corruption issue in USB ftdi driver ftdi_sio.c

Axel Lin (1):
      ASoC: wm8940: Properly set codec->dapm.bias_level

Bart Van Assche (1):
      Make scsi_free_queue() kill pending SCSI commands

Chris Wilson (2):
      drm/i915: Sanity check pread/pwrite
      drm/i915: Rephrase pwrite bounds checking to avoid any potential over=
flow

Dan Carpenter (2):
      PM / Suspend: Off by one in pm_suspend()
      hfs: add sanity check for file name length

Dave Jones (1):
      kbuild: Disable -Wunused-but-set-variable for gcc 4.6.0

Greg Kroah-Hartman (1):
      Linux 2.6.32.49

Herton Ronaldo Krzesinski (1):
      Revert "ALSA: hda: Fix quirk for Dell Inspiron 910"

Ian Campbell (1):
      genirq: Add IRQF_RESUME_EARLY and resume such IRQs earlier

Johannes Berg (1):
      netlink: validate NLA_MSECS length

Josh Boyer (1):
      USB: add quirk for Logitech C600 web cam

Mauro Carvalho Chehab (1):
      Remove the old V4L1 v4lgrab.c file

Michal Marek (1):
      kbuild: Fix passing -Wno-* options to gcc 4.4+

Mitsuo Hayasaka (1):
      mm: avoid null pointer access in vm_struct via /proc/vmallocinfo

NeilBrown (2):
      NFS/sunrpc: don't use a credential with extra groups.
      md/raid5: abort any pending parity operations when array fails.

Peter Wippich (1):
      mtd: mtdchar: add missing initializer on raw write

Petr Uzel (1):
      st: fix race in st_scsi_execute_end

Shan Wei (1):
      ipv6: udp: fix the wrong headroom check

sordna (1):
      USB: quirks: adding more quirky webcams to avoid squeaky audio

wangyanqing (1):
      USB: serial: pl2303: rm duplicate id


--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJO0osXAAoJEDjbvchgkmk+9GsP/RmF64OfDdHThJhpDci+C4YI
H2wc0fw939HjWRhPsOgnZ8xAMMc2aTLaP+TLpAImwkaU5oh08GuMqa13sYidojpg
alh520YQnRITN77qLoxL50O9pou+WoadQpIjm11lcouB6mo73ig2PpCaX1XT1PDM
Je4P4RRHrKIg+6P2oNXqmJB3KqnzaJQdouGi6zHk8G342n/RFYwV2epFZ4XTR3G6
1Zt1GYbu+vQphBkdyysl5eXAcFkwMCuHVHz/O7MtQjwwm00OLWjEAlLVV1r3Tc2+
Yr/MjOM51LB2v2y93LVhm/PzoifWGjfB7jsUDIb8rZyiqwT5o3GMtTB1pFnvu3H3
7q2GMY8qMWZUX6DsSjfysy1gUtpQY2iqM6qLdpEYC5Ms64vo4H7OCE26nZ5vrtin
myfYg+4uZOpRU2rnPLAIBH7GSdt/JQanr/lAn2EXPgIy7ZKJY53t1wNn33Dixd9W
ZyVaxnSobFb/zwDp01X0VfAEYfhFcYEBIlyyR1DycmnqG1oXzsnT0o58HwMfb1/q
6mNh+xE9F6xJn2RwWmm+TM3sh5Z1rtlzSyKrGoe8zfW1RtBoGZx/wqpv0lEOwWyF
0RL7+0JMvUYXJfykH41a3KXZtyq6xVX3EPnhfmrbQbbJ34OGA3Du1kwCuoUJA70G
ztqdTgzA5VF/l/iy+55d
=s2kz
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
