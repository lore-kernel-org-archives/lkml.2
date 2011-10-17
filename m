Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab1JQQ57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 12:57:59 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56839 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757Ab1JQQ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 12:57:57 -0400
X-Sasl-enc: wWwR93B0eG0l1ICi/8m6OPUzzKEDvrI9ppj55k8N+aL9 1318870676
Date: Mon, 17 Oct 2011 09:56:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net
Subject: Linux 3.0.7
Message-ID: <20111017165654.GA5442@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.0.7 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE):
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

Note, I've had some boot problems with this kernel, and I can't seem to
narrow the issue down, but I think it's due to something not related to
the kernel itself, but am not positive.  Please test to verify that I
didn't mess something up.

thanks,

greg k-h

------------

 Makefile                                   |    2 -
 arch/arm/mach-ux500/Kconfig                |    1=20
 arch/mips/jz4740/gpio.c                    |   52 ++++++++++++------------=
-----
 arch/sparc/mm/init_64.c                    |    5 ++
 arch/x86/pci/acpi.c                        |   11 ++++++
 drivers/ata/ahci.c                         |   12 ++++++
 drivers/gpu/drm/radeon/atombios_dp.c       |   28 ++++++++++-----
 drivers/gpu/drm/radeon/evergreen.c         |   44 ------------------------
 drivers/gpu/drm/radeon/ni.c                |   32 -----------------
 drivers/gpu/drm/radeon/radeon_connectors.c |    8 ++--
 drivers/gpu/drm/radeon/radeon_cursor.c     |   12 +++---
 drivers/gpu/drm/radeon/radeon_encoders.c   |    9 +++--
 drivers/gpu/drm/radeon/rv770.c             |   51 ------------------------=
----
 drivers/ide/ide-disk.c                     |    7 +++
 drivers/md/dm-table.c                      |   13 +++----
 drivers/md/md.c                            |   22 ++++++++++--
 drivers/md/md.h                            |    2 -
 drivers/md/multipath.c                     |    3 -
 drivers/md/raid1.c                         |    3 -
 drivers/md/raid10.c                        |    5 +-
 drivers/md/raid5.c                         |    6 +--
 drivers/misc/lis3lv02d/lis3lv02d.c         |   14 ++++---
 drivers/mmc/host/mxs-mmc.c                 |   30 +++++++---------
 drivers/net/e1000e/ich8lan.c               |   19 +++++++---
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   21 ++++++++---
 drivers/net/wireless/rt2x00/rt2x00queue.h  |    2 +
 drivers/scsi/libsas/sas_expander.c         |   10 +++--
 drivers/scsi/qla2xxx/qla_os.c              |    9 ++---
 fs/exec.c                                  |    2 +
 include/linux/ftrace.h                     |    7 ++-
 include/linux/ptp_classify.h               |   13 +++++--
 include/linux/sched.h                      |    1=20
 include/net/ipv6.h                         |    2 -
 kernel/posix-cpu-timers.c                  |    5 +-
 kernel/sched.c                             |   26 --------------
 kernel/sched_rt.c                          |    4 +-
 kernel/trace/ftrace.c                      |   42 +++++++++++++++++------
 kernel/trace/trace_functions.c             |    3 +
 net/ipv6/ip6_output.c                      |   10 ++---
 net/ipv6/udp.c                             |    4 +-
 sound/soc/codecs/wm8753.c                  |    4 +-
 sound/soc/pxa/zylonite.c                   |    8 ++--
 42 files changed, 262 insertions(+), 302 deletions(-)


Alex Deucher (6):
      drm/radeon/kms: Fix logic error in DP HPD handler
      drm/radeon/kms: fix regression in DP aux defer handling
      drm/radeon/kms: add retry limits for native DP aux defer
      drm/radeon/kms: fix channel_remap setup (v2)
      drm/radeon/kms: retry aux transactions if there are status flags
      drm/radeon/kms: use hardcoded dig encoder to transmitter mapping for =
DCE4.1

Arnd Bergmann (1):
      ASoC: use a valid device for dev_err() in Zylonite

Axel Lin (1):
      ASoC: Fix setting update bits for WM8753_LADC and WM8753_RADC

Borislav Petkov (1):
      ide-disk: Fix request requeuing

Bruce Allan (1):
      e1000e: workaround for packet drop on 82579 at 100Mbps

David S. Miller (1):
      sparc64: Force the execute bit in OpenFirmware's translation entries.

Gertjan van Wingerde (1):
      rt2x00: Serialize TX operations on a queue.

Greg Kroah-Hartman (1):
      Linux 3.0.7

Jason Wang (1):
      ipv6: fix NULL dereference in udp6_ufo_fragment()

Koen Beel (1):
      mmc: mxs-mmc: fix clock rate setting

Mark Nelson (1):
      ahci: Enable SB600 64bit DMA on Asus M3A

Mark Salyzyn (1):
      libsas: fix panic when single phy is disabled on a wide port

Michel D=E4nzer (1):
      drm/radeon: Update AVIVO cursor coordinate origin before x/yorigin ca=
lculation.

Mike Snitzer (1):
      dm table: avoid crash if integrity profile changes

NeilBrown (1):
      md: Avoid waking up a thread after it has been freed.

Paul Menzel (1):
      x86/PCI: use host bridge _CRS info on ASUS M2V-MX SE

Peter Zijlstra (1):
      posix-cpu-timers: Cure SMP wobbles

Rafael J. Wysocki (1):
      MIPS: PM: Use struct syscore_ops instead of sysdevs for PM (v2)

Richard Cochran (1):
      ptp: fix L2 event message recognition

Roland Dreier (1):
      qla2xxx: Fix crash in qla2x00_abort_all_cmds() on unload

Shawn Bohrer (1):
      sched/rt: Migrate equal priority tasks to available CPUs

Simon Kirby (1):
      sched: Fix up wchan borkage

Steven Rostedt (3):
      ftrace: Fix regression of :mod:module function enabling
      ftrace: Fix regression where ftrace breaks when modules are loaded
      ftrace: Fix warning when CONFIG_FUNCTION_TRACER is not defined

Takashi Iwai (1):
      lis3: fix regression of HP DriveGuard with 8bit chip

Tetsuo Handa (1):
      exec: do not call request_module() twice from search_binary_handler()

srinidhi kasagar (1):
      ARM: mach-ux500: enable fix for ARM errata 754322


--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOnF5WAAoJEDjbvchgkmk+7isQAJoiOli7xxV2s6ltiImtBsID
Paj7Ngx3dJkhk+nCbzTWhQRsfkFkqXUdUF6R/6q4MgE76OQCeEaK4Hx5sW2MiaFR
FmZsCjLu/abwZx4zLBFoU4iKLyALDxtDhylL2tC+9EGGiEy1AAEMXP4ZiPAoo7/g
IzLVPc0FyfPtQWwRnYPuwJINKSm+NWDOfoL5pVrBYJ3y6b9Mq9uUv2JmyZjtH2oW
Q5I8YSEulBUudv4iM+9n1fxk6zwr2I6lE6TFVNPQxoXtbWzHlVITv+qpeOhLF6Ts
Ky5xVAHZS6dHe2qiV+VyiJxyeUiGc8YChrrqaP4nOiecCCg4b6INR4x7Njkj0Wgs
R80fKxsuV5SIMvFKXC6sBwCozEW0ouUWAanneFijHTXELhy8ZYWD940hfS4ajPRc
w6lAk08pGmlIc81Y1HBPEFpIVP6XITyrG5RKeVu4AjLALP40rg/PexVdsOEayUpm
9wwUhshx+FR9yjEqIPwvM10wUpkk6kCLOAfmefMvGl0dkIY7n57K1cKDDDhE+MMu
waPTDom1Vofffa/9qvQZc61BC9bkKXsKLcw7VFBO3plS+wO1m2krrXWa/RbtutQE
X3zlx1bZhcbnPluE0vNd2YSzNHo2GhLejoE26UWcg7BXZT921kxicCv4tlEiEmSe
lACAZzyfZ4WG2jH9r81v
=3Ocb
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
