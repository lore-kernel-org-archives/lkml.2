Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215Ab1JKRAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:00:38 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43546 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755051Ab1JKRAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:00:36 -0400
X-Sasl-enc: lsQDDa/WAhVQYwgOV45YkRtWzqCKOIpiLQSr5N+QarC3 1318352435
Date: Tue, 11 Oct 2011 10:59:03 -0600
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [00/38] 3.0.7-stable review
Message-ID: <20111011165903.GA30976@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is the start of the stable review cycle for the 3.0.7 release.
There are 38 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let us know.  If anyone is a maintainer of the proper subsystem, and
wants to add a Signed-off-by: line to the patch, please respond with it.

Responses should be made by Thursday, October 13, 17:00:00 UTC.
Anything received after that time might be too late.

The whole patch series can be found in one patch in the message
following this one and the diffstat can be found below.

thanks,

greg k-h

 Makefile                                   |    4 +-
 arch/arm/mach-ux500/Kconfig                |    1 +
 arch/mips/jz4740/gpio.c                    |   52 ++++-----
 arch/sparc/mm/init_64.c                    |    5 +
 arch/x86/pci/acpi.c                        |   25 +++++
 drivers/ata/ahci.c                         |   12 ++
 drivers/gpu/drm/radeon/atombios_dp.c       |   28 ++++--
 drivers/gpu/drm/radeon/evergreen.c         |   44 --------
 drivers/gpu/drm/radeon/ni.c                |   32 ------
 drivers/gpu/drm/radeon/radeon_connectors.c |    8 +-
 drivers/gpu/drm/radeon/radeon_cursor.c     |   12 ++-
 drivers/gpu/drm/radeon/radeon_encoders.c   |    9 +-
 drivers/gpu/drm/radeon/rv770.c             |   51 ---------
 drivers/ide/ide-disk.c                     |    7 +-
 drivers/md/dm-table.c                      |   13 ++-
 drivers/md/md.c                            |   22 ++++-
 drivers/md/md.h                            |    2 +-
 drivers/md/multipath.c                     |    3 +-
 drivers/md/raid1.c                         |    3 +-
 drivers/md/raid10.c                        |    5 +-
 drivers/md/raid5.c                         |    6 +-
 drivers/misc/lis3lv02d/lis3lv02d.c         |   14 ++-
 drivers/mmc/host/mxs-mmc.c                 |   30 +++---
 drivers/net/e1000e/ich8lan.c               |   19 +++-
 drivers/net/wireless/rt2x00/rt2x00queue.c  |   21 +++-
 drivers/net/wireless/rt2x00/rt2x00queue.h  |    2 +
 drivers/pci/hotplug/pcihp_slot.c           |   47 +--------
 drivers/pci/pci.c                          |   71 ++++++++++++
 drivers/pci/probe.c                        |  159 ++++++++++++++++++++++++++++
 drivers/scsi/libsas/sas_expander.c         |   10 +-
 drivers/scsi/qla2xxx/qla_os.c              |    9 +-
 fs/exec.c                                  |    2 +
 include/linux/ftrace.h                     |    7 +-
 include/linux/pci.h                        |   16 +++-
 include/linux/ptp_classify.h               |   13 ++-
 include/linux/sched.h                      |    1 -
 include/net/ipv6.h                         |    2 +-
 kernel/posix-cpu-timers.c                  |    5 +-
 kernel/sched.c                             |   26 +-----
 kernel/sched_rt.c                          |    4 +-
 kernel/trace/ftrace.c                      |   42 ++++++--
 kernel/trace/trace_functions.c             |    3 +-
 net/ipv6/ip6_output.c                      |   10 +-
 net/ipv6/udp.c                             |    4 +-
 sound/soc/codecs/wm8753.c                  |    4 +-
 sound/soc/pxa/zylonite.c                   |    8 +-
 46 files changed, 525 insertions(+), 348 deletions(-)

--DocE+STaALJfprDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOlHXXAAoJEDjbvchgkmk+T5YP/0cTstjPMrO6e+mTObh8//HV
v8tS4/Ea8HhRgmxHoUkKdASj5in9TiclbOr8Klu+TBqyqUb5bYqSOL/kv1g992Ww
QRhI2/p5eYkKJI3ubmtviWB2t0SOqF/wgP9QtM2m44aniAOLSicqaDOI1N9dX0Qg
KkGPlyR15bef429EZj6qmpsO5Arqr1Xxwx39IrH5sBvxI6716+5/Yeu6wIHXzmoK
gknlngc6MbIuZay0hZtDk1Kv1j7g/qzjfbedBWJUtTGvTZ0jcVG/iKUxJoP9rFwK
eetCqq6oP3/jG3bCJiFPDTOrT+3iO9hiNo65Nvs4uiHoOOfdqWgOPF2uhjsBnvwJ
YJSM4lCG7PScE3oH5d9C54HdGWD9SC0l5Czo7pjMs7VzS8scEAEE3ZJqnmfxVmNA
7UN8Dyw/YdeTyTv10+eBuG5IT55FHnk2j8YfEFjQB/ebiHB1F8rJvu87zWiTq59H
QXwQr+gr1wIBNaN+mI9BA7GXdAhOW1iioAz+qTZpcCUQzVuQf3m8XpNVCMob+295
l07R6hWpbqPoTrxj/ccQL71fwbhN0SFtALFYEVQYiu4mO9RNsjOLTM7in1g2ZsAV
sLlOmBv7cg3Gmld3EOElLrGtD/n8w2K6tNyOIU+j3K5S8LoAl1BGQpp/emWcBn5t
640rJCYqTCHVfHxdIG6q
=MUlZ
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
