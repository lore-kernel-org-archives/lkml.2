Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab2EUOCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:02:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45301 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757861Ab2EUOCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:02:33 -0400
Message-ID: <1337608943.10262.10.camel@deadeye>
Subject: Linux 3.2.18
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Mon, 21 May 2012 15:02:23 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KtoL7pT4qgihmxnJDP31"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KtoL7pT4qgihmxnJDP31
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.18 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 Documentation/networking/ip-sysctl.txt             |    4 +-
 Makefile                                           |    2 +-
 .../include/mach/ctrl_module_pad_core_44xx.h       |    8 +-
 arch/arm/mach-orion5x/mpp.h                        |    4 +-
 arch/arm/mm/fault.c                                |    4 +-
 arch/arm/vfp/vfpmodule.c                           |   10 ++-
 arch/ia64/include/asm/unistd.h                     |    3 +-
 arch/ia64/kernel/entry.S                           |    1 +
 arch/sparc/kernel/central.c                        |    2 +-
 arch/sparc/mm/ultra.S                              |    6 +-
 arch/tile/kernel/compat_signal.c                   |   12 ++-
 drivers/crypto/Kconfig                             |    1 +
 drivers/gpio/gpio-ml-ioh.c                         |    1 +
 drivers/md/dm-mpath.c                              |    4 +-
 drivers/md/md.c                                    |    2 +
 drivers/media/rc/ene_ir.c                          |   32 ++++----
 drivers/media/rc/fintek-cir.c                      |   20 ++---
 drivers/media/rc/ite-cir.c                         |   20 ++---
 drivers/media/rc/nuvoton-cir.c                     |   36 ++++-----
 drivers/media/rc/winbond-cir.c                     |   78 ++++++++++------=
----
 drivers/media/video/marvell-ccic/mmp-driver.c      |    1 -
 drivers/media/video/s5p-fimc/fimc-capture.c        |    2 +-
 drivers/net/ethernet/broadcom/tg3.c                |   18 ++++-
 drivers/net/ethernet/intel/e1000/e1000_main.c      |    6 +-
 drivers/net/ethernet/marvell/sky2.c                |   31 +++++---
 drivers/net/ethernet/marvell/sky2.h                |    1 -
 drivers/net/ethernet/stmicro/stmmac/mmc_core.c     |    1 +
 drivers/net/ethernet/sun/sungem.c                  |    2 +-
 drivers/net/phy/icplus.c                           |    3 +-
 drivers/net/usb/asix.c                             |    4 +-
 drivers/net/usb/cdc_ether.c                        |   30 +++++++-
 drivers/net/usb/usbnet.c                           |   54 ++++++++++----
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    2 +-
 drivers/regulator/max8997.c                        |    2 +-
 drivers/spi/spi-topcliff-pch.c                     |   78 ++++++++++++++++=
+---
 drivers/target/target_core_file.c                  |   22 ++++--
 drivers/target/target_core_pr.c                    |    3 +
 drivers/target/target_core_tpg.c                   |   22 ------
 fs/ext4/xattr.c                                    |    7 +-
 fs/jffs2/gc.c                                      |    2 +-
 fs/nfs/nfs4proc.c                                  |    1 +
 include/linux/mtd/map.h                            |    2 +-
 include/linux/usb/usbnet.h                         |    3 +-
 kernel/fork.c                                      |    3 +
 mm/hugetlb.c                                       |    1 -
 mm/nobootmem.c                                     |    3 +-
 mm/percpu.c                                        |   10 +++
 net/core/dev.c                                     |   20 +++++
 net/core/pktgen.c                                  |   10 ++-
 net/ipv4/tcp.c                                     |   12 +--
 net/ipv4/tcp_input.c                               |   11 ++-
 net/l2tp/l2tp_ip.c                                 |    3 +-
 net/sched/sch_netem.c                              |    6 +-
 sound/pci/echoaudio/echoaudio_dsp.c                |    2 +-
 sound/pci/hda/hda_intel.c                          |    6 +-
 sound/pci/hda/patch_sigmatel.c                     |    6 +-
 sound/soc/codecs/wm8994.c                          |    2 +-
 58 files changed, 408 insertions(+), 240 deletions(-)

Alexander Clouter (1):
      crypto: mv_cesa requires on CRYPTO_HASH to build

Archit Taneja (1):
      ARM: OMAP: Revert "ARM: OMAP: ctrl: Fix CONTROL_DSIPHY register field=
s"

Arend van Spriel (1):
      brcm80211: smac: fix endless retry of A-MPDU transmissions

Artem Bityutskiy (1):
      mtd: map.h: fix arm cross-build failure

Axel Lin (2):
      regulator: Fix the logic to ensure new voltage setting in valid range
      gpio: Add missing spin_lock_init in gpio-ml-ioh driver

Ben Hutchings (2):
      ARM: orion5x: Fix GPIO enable bits for MPP9
      Linux 3.2.18

Bernhard Kohl (1):
      target: Fix SPC-2 RELEASE bug for multi-session iSCSI client setups

Bj=C3=B8rn Mork (1):
      cdc_ether: Ignore bogus union descriptor for RNDIS devices

Chris Metcalf (2):
      hugetlb: prevent BUG_ON in hugetlb_fault() -> hugetlb_cow()
      arch/tile: apply commit 74fca9da0 to the compat signal handling as we=
ll

Dan Williams (1):
      cdc_ether: add Novatel USB551L device IDs for FLAG_WWAN

David Henningsson (1):
      ALSA: HDA: Lessen CPU usage when waiting for chip to respond

David S. Miller (1):
      sparc64: Do not clobber %g2 in xcall_fetch_glob_regs().

Eric Dumazet (4):
      netem: fix possible skb leak
      tcp: change tcp_adv_win_scale and tcp_rmem[2]
      pktgen: fix crash at module unload
      pktgen: fix module unload for good

Eric Sandeen (1):
      ext4: avoid deadlock on sync-mounted FS w/o journal

Eric W. Biederman (1):
      net: In unregister_netdevice_notifier unregister the netdevices.

Gerard Lledo (1):
      sungem: Fix WakeOnLan

Ingo van Lil (1):
      asix: Fix tx transfer padding for full-speed USB

Jonathan Brassow (1):
      MD: Add del_timer_sync to mddev_suspend (fix nasty panic)

Jonathan Corbet (1):
      marvell-cam: fix an ARM build error

Jonathan Nieder (2):
      brcm80211: smac: pass missing argument to 'brcms_b_mute'
      NFSv4: Revalidate uid/gid after open

Josh Cartwright (1):
      jffs2: Fix lock acquisition order bug in gc path

Luis Henriques (1):
      rc: Postpone ISR registration

Mark Brown (1):
      ASoC: wm8994: Fix AIF2ADC power down

Mark Hills (1):
      ALSA: echoaudio: Remove incorrect part of assertion

Matt Carlson (1):
      tg3: Avoid panic from reserved statblk field access

Mike Galbraith (1):
      namespaces, pid_ns: fix leakage on fork() failure

Mike Snitzer (1):
      dm mpath: check if scsi_dh module already loaded before trying to loa=
d

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

Sasha Levin (1):
      net: l2tp: unlock socket lock before returning from l2tp_ip_sendmsg

Srinivas Kandagatla (1):
      phy:icplus:fix Auto Power Saving in ip101a_config_init.

Stefan Roese (1):
      stmmac: Fix compilation error in mmc_core.c

Sylwester Nawrocki (1):
      s5p-fimc: Fix locking in subdev set_crop op

Takashi Iwai (1):
      ALSA: hda/idt - Fix power-map for speaker-pins with some HP laptops

Tejun Heo (1):
      percpu: pcpu_embed_first_chunk() should free unused parts after all a=
llocs are complete

Tomoya MORINAGA (4):
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

Willy Tarreau (1):
      tcp: do_tcp_sendpages() must try to push data out on oom conditions

Yuchung Cheng (1):
      tcp: fix infinite cwnd in tcp_complete_cwr()

stephen hemminger (2):
      sky2: propogate rx hash when packet is copied
      sky2: fix receive length error in mixed non-VLAN/VLAN traffic

=C3=89meric Maschino (1):
      ia64: Add accept4() syscall

--=20
Ben Hutchings
Life is what happens to you while you're busy making other plans.
                                                               - John Lenno=
n


--=-KtoL7pT4qgihmxnJDP31
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT7pK7+e/yOyVhhEJAQp5EQ//cKft3qlOtCw4TH6uOf7IaFFj+wS1NLdI
Pyj9iXbGXzA03B9OG1AizpKEHnnZxqY1XYHqRNLSgHS5ojLhSyFBlXWRkcKTIFcY
zfhdb/VkxLkmzVyoLhGbDM8dRZLwPW9jizuJSmkH2Eeo/PW3q2kE5EiEw30uV5Be
AxoPFpvfqpC95zEOEyZg+mw4IuIYZDdFW7WVpsya6iVbW0S/y8rwtwhu/CQLWmpL
mUrS6n0+ffvRXKb4X69saX0oS+EMJuc1ZGa756XbZC7v7U8fBhjtELQrMzB7Y9YA
AUs9cJbjV043NF15B9YAciD0Oc0s7qEFDeRbmFKkYSu276tEDJO8X4fgOBkG9W5J
BO5vfOvJLckEZ5uMEVKCva6IcZY2DAvOmNBVQRB/YiNAWXpNOUJ364/1joohkkWA
VhDKY3Iy6Y3EbmtxYWIkBfIqt0pr9wjr4/mza/ftMkmnqKBBwC/tSLMnXbZVfdFl
IXUOx7hzCWE/ixtXZRvFbaniSn0NylSRn1fWbvVSg8mW0+Y5ThoGm4GEmcBqODNy
fYyViSU3uLjyoz+wHzcFv7PwsD+qoYeIB0XkpTJL+zrfN9BuguWRLxVL7xdnuiwI
rfWSAecasjLBFO5rEqvnncEqJyJJIeI490TXmJl0xumriDICDgD9ecf7KsZPxBMS
Im3DxblURM0=
=F725
-----END PGP SIGNATURE-----

--=-KtoL7pT4qgihmxnJDP31--
