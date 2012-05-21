Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2EUUgv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 16:36:51 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59817 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab2EUUgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 16:36:47 -0400
Date: Mon, 21 May 2012 13:36:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.3.7
Message-ID: <20120521203644.GA20695@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.3.7 kernel.

All users of the 3.3 kernel series must upgrade.

The updated 3.3.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.3.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/arm/mm/fault.c                           |    4 +
 arch/arm/vfp/vfpmodule.c                      |   10 ++-
 arch/sparc/kernel/central.c                   |    2=20
 arch/sparc/mm/ultra.S                         |    6 +-
 arch/tile/kernel/compat_signal.c              |   12 +---
 drivers/char/virtio_console.c                 |    7 ++
 drivers/crypto/Kconfig                        |    1=20
 drivers/i2c/busses/i2c-eg20t.c                |    2=20
 drivers/md/dm-mpath.c                         |    4 -
 drivers/md/md.c                               |    2=20
 drivers/media/dvb/dvb-core/dvb_frontend.c     |    4 +
 drivers/media/rc/ene_ir.c                     |   32 +++++-----
 drivers/media/rc/fintek-cir.c                 |   20 +++---
 drivers/media/rc/ite-cir.c                    |   20 +++---
 drivers/media/rc/nuvoton-cir.c                |   36 ++++++------
 drivers/media/rc/winbond-cir.c                |   78 +++++++++++++--------=
-----
 drivers/media/video/marvell-ccic/mmp-driver.c |    1=20
 drivers/media/video/s5p-fimc/fimc-capture.c   |    2=20
 drivers/mtd/mtdchar.c                         |    2=20
 drivers/net/ethernet/dlink/dl2k.c             |   52 +++--------------
 drivers/net/ethernet/dlink/dl2k.h             |    7 --
 drivers/net/ethernet/intel/e1000/e1000_main.c |    6 +-
 drivers/net/usb/cdc_ether.c                   |   30 +++++++++-
 drivers/net/usb/usbnet.c                      |   54 ++++++++++++------
 drivers/spi/spi-topcliff-pch.c                |   78 +++++++++++++++++++++=
+----
 drivers/target/target_core_file.c             |   22 +++++--
 drivers/target/target_core_pr.c               |    3 +
 drivers/target/target_core_tpg.c              |   22 -------
 drivers/video/omap2/dss/venc.c                |    5 +
 fs/cifs/cifsfs.c                              |    2=20
 fs/ext4/xattr.c                               |    7 +-
 fs/jffs2/gc.c                                 |    2=20
 fs/nfs/nfs4proc.c                             |   28 +++++----
 fs/nfs/nfs4xdr.c                              |   18 +++---
 include/linux/usb/usbnet.h                    |    3 -
 init/do_mounts.c                              |    2=20
 kernel/compat.c                               |   63 +++++++++++++++------
 kernel/fork.c                                 |    3 +
 mm/hugetlb.c                                  |    1=20
 mm/memcontrol.c                               |    6 ++
 mm/nobootmem.c                                |    3 -
 mm/percpu.c                                   |   12 ++++
 net/ipv4/tcp.c                                |    3 -
 sound/pci/echoaudio/echoaudio_dsp.c           |    2=20
 sound/pci/hda/hda_intel.c                     |    6 +-
 sound/pci/hda/patch_realtek.c                 |    1=20
 sound/pci/hda/patch_sigmatel.c                |    6 +-
 sound/soc/codecs/cs42l73.c                    |   16 ++---
 sound/soc/codecs/wm8994.c                     |    2=20
 50 files changed, 423 insertions(+), 289 deletions(-)


Alexander Clouter (1):
      crypto: mv_cesa requires on CRYPTO_HASH to build

Amit Shah (1):
      virtio: console: tell host of open ports after resume from s3/s4

Bernhard Kohl (1):
      target: Fix SPC-2 RELEASE bug for multi-session iSCSI client setups

Bj=F8rn Mork (1):
      cdc_ether: Ignore bogus union descriptor for RNDIS devices

Brian Austin (1):
      ASoC: cs42l73: Sync digital mixer kcontrols to allow for 0dB

Catalin Marinas (1):
      kmemleak: Fix the kmemleak tracking of the percpu areas with !SMP

Chris Metcalf (2):
      hugetlb: prevent BUG_ON in hugetlb_fault() -> hugetlb_cow()
      arch/tile: apply commit 74fca9da0 to the compat signal handling as we=
ll

Dan Carpenter (1):
      cifs: fix revalidation test in cifs_llseek()

Dan Williams (1):
      cdc_ether: add Novatel USB551L device IDs for FLAG_WWAN

Danny Kukawka (1):
      OMAPDSS: VENC: fix NULL pointer dereference in DSS2 VENC sysfs debug =
attr on OMAP4

David Henningsson (1):
      ALSA: HDA: Lessen CPU usage when waiting for chip to respond

David S. Miller (1):
      sparc64: Do not clobber %g2 in xcall_fetch_glob_regs().

Eric Sandeen (1):
      ext4: avoid deadlock on sync-mounted FS w/o journal

Greg Kroah-Hartman (1):
      Linux 3.3.7

Jan Kiszka (1):
      compat: Fix RT signal mask corruption via sigprocmask

Jeff Mahoney (1):
      dl2k: Clean up rio_ioctl

Jonathan Brassow (1):
      MD: Add del_timer_sync to mddev_suspend (fix nasty panic)

Jonathan Corbet (1):
      media: marvell-cam: fix an ARM build error

Josh Cartwright (1):
      jffs2: Fix lock acquisition order bug in gc path

Luis Henriques (1):
      media: rc: Postpone ISR registration

Mark Brown (1):
      ASoC: wm8994: Fix AIF2ADC power down

Mark Hills (1):
      ALSA: echoaudio: Remove incorrect part of assertion

Mauro Carvalho Chehab (1):
      media: dvb_frontend: fix a regression with DVB-S zig-zag

Mike Galbraith (1):
      namespaces, pid_ns: fix leakage on fork() failure

Mike Snitzer (1):
      dm mpath: check if scsi_dh module already loaded before trying to load

Ming Lei (1):
      usbnet: fix skb traversing races during unlink(v2)

Nicholas Bellinger (2):
      target: Drop incorrect se_lun_acl release for dynamic -> explict ACL =
conversion
      target: Fix bug in handling of FILEIO + block_device resize ops

Russ Anderson (1):
      mm: nobootmem: fix sign extend problem in __free_pages_memory()

Russell King (1):
      ARM: prevent VM_GROWSDOWN mmaps extending below FIRST_USER_ADDRESS

Sachin Prabhu (2):
      Avoid beyond bounds copy while caching ACL
      Avoid reading past buffer when calling GETACL

Sasha Levin (1):
      init: don't try mounting device as nfs root unless type fully matches

Sha Zhengju (1):
      memcg: free spare array to avoid memory leak

Sylwester Nawrocki (1):
      media: s5p-fimc: Fix locking in subdev set_crop op

Takashi Iwai (2):
      ALSA: hda/realtek - Add missing CD-input pin for MSI-7350 mobo
      ALSA: hda/idt - Fix power-map for speaker-pins with some HP laptops

Tejun Heo (1):
      percpu: pcpu_embed_first_chunk() should free unused parts after all a=
llocs are complete

Tomoya MORINAGA (5):
      i2c-eg20t: change timeout value 50msec to 1000msec
      spi-topcliff-pch: Modify pci-bus number dynamically to get DMA device=
 info
      spi-topcliff-pch: Fix issue for transmitting over 4KByte
      spi-topcliff-pch: supports a spi mode setup and bit order setup by IO=
 control
      spi-topcliff-pch: add recovery processing in case wait-event timeout

Tushar Dave (1):
      e1000: Prevent reset task killing itself.

Will Deacon (1):
      ARM: 7417/1: vfp: ensure preemption is disabled when enabling VFP acc=
ess

Will Newton (1):
      mtd: fix oops in dataflash driver

Willy Tarreau (1):
      tcp: do_tcp_sendpages() must try to push data out on oom conditions


--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJPuqdbAAoJEDjbvchgkmk+Jk4P/0RX9xlrn8mIw3k2sXgPlSBp
shDXm7z7aXIk4RdcOJre9p2XZb6VrG9qjRj9oHQbfp5fnK/BB3ZPWIsXBmj7jKuM
XU7rgjiGA9D40q6y6z0KHBf1K0jE9trb+HKJ2Gwc5SXbn1wZgbKUOjeInkJGpRGk
nbWxxqaizEBKb3/ygLLbISZjL/GN4PLRtLxkZpCvyXiQvGSEv+ZzGdxjcJMOmJv/
TFU39g9hq25dnWRZ9Bs1uZBJ1QgIA6C8rgRiNyTqcJPTddBwPTlISbGuwiEG1N4w
vTf3daBwrP6zBhNcse57/V4RWaRYgcGyiiIi9xVldNe9TN3CWR4bA3SzvnLdDl5O
BVtRTl9AjxGBFHwGPlEpIK1JbLHDNef0HH9ArJoRrTmvZuyZnQTqQcmMTWXAF5s5
HGiwXpdLK5ljU4tA5u20s2V7UEyPd7sMsEzi7uQ3DV2/LST1yL7191V7I6XJkvOl
mWlYSThlp8/A2kG2dk2aQwcPPH9Bq4lWxvtdB1T0LCDClEgeSpWpmPYsTXHHzIRD
dlG++/MtHabgNpB/r+37/hcb0YSH9BsZfPZwLw6r18umD8lety6ZJEotK7NNJ/Iw
lAoQFGjdV9983tREE7mJjRmy1/e7dkjk7yJLnK9ioCgdeHh0VEZxZ/jr+WuidUBD
9Vn970F7Js9+AXr5jYN1
=wv+S
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
