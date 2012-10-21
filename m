Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399Ab2JURX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 13:23:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49201 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329Ab2JURXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 13:23:55 -0400
Date: Sun, 21 Oct 2012 10:24:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.47
Message-ID: <20121021172417.GA5313@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.47 kernel.

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

 Documentation/kernel-parameters.txt             |    5 +
 Makefile                                        |    2=20
 arch/arm/Kconfig                                |   10 +++
 arch/arm/include/asm/vfpmacros.h                |    4 -
 arch/arm/mm/cache-v7.S                          |    3=20
 arch/mips/kernel/kgdb.c                         |    9 ++
 arch/x86/Kconfig                                |    9 ++
 arch/x86/include/asm/archrandom.h               |   75 +++++++++++++++++++=
+++++
 arch/x86/kernel/cpu/Makefile                    |    1=20
 arch/x86/kernel/cpu/common.c                    |    2=20
 arch/x86/kernel/cpu/rdrand.c                    |   73 +++++++++++++++++++=
++++
 arch/x86/xen/enlighten.c                        |   18 +++++
 block/blk-core.c                                |    2=20
 drivers/acpi/ec.c                               |   30 ++++++++-
 drivers/char/tpm/tpm.c                          |   21 ++++--
 drivers/firewire/core-cdev.c                    |    4 -
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |    6 -
 drivers/net/tg3.c                               |    5 -
 drivers/usb/class/cdc-acm.c                     |    3=20
 drivers/video/udlfb.c                           |    2=20
 drivers/video/via/via_clock.c                   |   19 ++++++
 fs/autofs4/root.c                               |    6 +
 fs/ceph/export.c                                |   18 ++++-
 fs/gfs2/export.c                                |    4 +
 fs/isofs/export.c                               |    2=20
 fs/jbd/commit.c                                 |   45 ++++++++++----
 fs/jbd/transaction.c                            |   64 ++++++++++++++------
 fs/lockd/mon.c                                  |    4 -
 fs/reiserfs/inode.c                             |    6 +
 fs/udf/super.c                                  |    5 +
 fs/xfs/linux-2.6/xfs_export.c                   |    3=20
 include/net/ip_vs.h                             |    2=20
 include/net/netfilter/nf_conntrack_ecache.h     |    1=20
 kernel/module.c                                 |    4 +
 kernel/timer.c                                  |   10 +--
 mm/shmem.c                                      |    6 +
 net/core/pktgen.c                               |    2=20
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c  |    8 ++
 net/ipv4/netfilter/nf_nat_sip.c                 |   10 ++-
 net/netfilter/ipvs/ip_vs_ctl.c                  |    5 -
 net/netfilter/nf_conntrack_core.c               |   16 +++--
 net/netfilter/nf_conntrack_expect.c             |   29 +--------
 net/netfilter/xt_hashlimit.c                    |    8 --
 net/netfilter/xt_limit.c                        |   13 +---
 net/sunrpc/xprtsock.c                           |   21 +++++-
 sound/pci/ac97/ac97_codec.c                     |    2=20
 sound/pci/emu10k1/emu10k1_main.c                |    9 ++
 47 files changed, 480 insertions(+), 126 deletions(-)

Alexander Holler (1):
      video/udlfb: fix line counting in fb_write

Amerigo Wang (1):
      pktgen: fix crash when generating IPv6 packets

Daniel Drake (1):
      viafb: don't touch clock state on OLPC XO-1.5

Egbert Eich (1):
      drm/radeon: Don't destroy I2C Bus Rec in radeon_ext_tmds_enc_destroy(=
).

Feng Tang (2):
      ACPI: EC: Make the GPE storm threshold a module parameter
      ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop

Florian Westphal (1):
      netfilter: limit, hashlimit: avoid duplicated inline

Greg Kroah-Hartman (1):
      Linux 3.0.47

H. Peter Anvin (2):
      x86, random: Architectural inlines to get random integers with RDRAND
      x86, random: Verify RDRAND functionality and allow it to be disabled

Hildner, Christian (1):
      timers: Fix endless looping between cascade() and internal_add_timer()

Hugh Dickins (1):
      tmpfs,ceph,gfs2,isofs,reiserfs,xfs: fix fh_len checking

Ian Kent (1):
      autofs4 - fix reset pending flag on mount fail

Jan Engelhardt (1):
      netfilter: xt_limit: have r->cost !=3D 0 case work

Jan Kara (1):
      jbd: Fix assertion failure in commit code due to lacking transaction =
credits

Jason Wessel (1):
      mips,kgdb: fix recursive page fault with CONFIG_KPROBES

Jean-Christian de Rivaz (1):
      Add CDC-ACM support for the CX93010-2x UCMxx USB Modem

Jozsef Kadlecsik (1):
      netfilter: nf_ct_ipv4: packets with wrong ihl are invalid

Julian Anastasov (1):
      ipvs: fix oops in ip_vs_dst_event on rmmod

Konrad Rzeszutek Wilk (2):
      xen/bootup: allow {read|write}_cr8 pvops call.
      xen/bootup: allow read_tscp call for Xen PV guests.

Lin Ming (1):
      ipvs: fix oops on NAT reply in br_nf context

Matt Carlson (1):
      tg3: Apply short DMA frag workaround to 5906

Matthew Garrett (1):
      module: taint kernel when lve module is loaded

Maxim Kachur (1):
      ALSA: emu10k1: add chip details for E-mu 1010 PCIe card

Nikola Pajkovsky (1):
      udf: fix retun value on error path in udf_load_logicalvol

Pablo Neira Ayuso (3):
      netfilter: nf_conntrack: fix racy timer handling with reliable events
      netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP expec=
tation
      netfilter: nf_ct_expect: fix possible access to uninitialized timer

Patrick McHardy (1):
      netfilter: nf_nat_sip: fix via header translation with multiple param=
eters

Peter Huewe (1):
      tpm: Propagate error from tpm_transmit to fix a timeout hang

Russell King (1):
      ARM: vfp: fix saving d16-d31 vfp registers on v6+ kernels

Simon Horman (1):
      ARM: 7541/1: Add ARM ERRATA 775420 workaround

Stanislav Kinsbursky (1):
      lockd: use rpc client's cl_nodename for id encoding

Stefan Richter (1):
      firewire: cdev: fix user memory corruption (i386 userland on amd64 ke=
rnel)

Takashi Iwai (1):
      ALSA: ac97 - Fix missing NULL check in snd_ac97_cvol_new()

Tejun Heo (1):
      block: fix request_queue->flags initialization

Trond Myklebust (1):
      SUNRPC: Ensure that the TCP socket is closed when in CLOSE_WAIT


--huq684BweRXVnRxX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQhC/BAAoJEDjbvchgkmk+XM8QAKrrK3zbnkDp0yNakMbWoQFq
tujE9ZLDYi2ONsva9IMTv6hTW9pmv2Ix8H/IKbFwdBzW4RT34ZsZaCyLEGd15g6g
HPVZ8W7AxdeQS0aGzq6V7u0ntHRdOl8PSzsXBhNMU3a4aaiGX8b5GoNTX/dBKr7c
KG6wogdDuwO8rXcxqOcku+MGxYohW1INWPul41KTC2PAvXbRUIkaKi2Gzq+DWo4a
F9HvapMlDu4roNghUpqbtACfgYKk8EAlCKPERjipZEi3c99lMcs4y6AeKoOvfuhW
TH4/Hl78xe/HXpGW/I3HLU56CXMxJFc0zDp4eh95276TN3SxESsSndJch3ylz1nn
LZM7bHh3KtWr8vg6ntXO9OZYtzTeXaXmhQ1sVtclcYCSA4REh+TITW1fI+yTjLiw
EZrKXQBdACSoPfD4r5J9UTDETNulKXAKbk7aaA/pNv4P0QqCG0MnjIkmaauWTHVl
593SJLybL7PexINHCS/tV22v6HOG/uzgCE718NTmBh0CeSkLT/Q/nK8aECNhsMz+
wcbuOPqnapW3FTVuj3FsbUSk0N2Gwv1yAtk2GmVQmnBvMCWRL4Okv/uTZ3uyI8W4
w0kDBUjVduH2zRtY5tR1ovmT1C1GTzmUG5FTWA9IQXh7T1HE4baxV80i0ecRS0Ib
vxgIMA6D2NYYGb0GI2qM
=sXZx
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
