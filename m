Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab2LJTqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:46:36 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43188 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092Ab2LJTqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:46:32 -0500
Date: Mon, 10 Dec 2012 11:46:13 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.6.10
Message-ID: <20121210194613.GA19628@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.6.10 kernel.

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

 Makefile                                         |    2=20
 arch/arm/Kconfig                                 |    1=20
 arch/arm/mach-dove/include/mach/pm.h             |    2=20
 arch/arm/mach-dove/irq.c                         |   14 +
 arch/arm/mach-kirkwood/pcie.c                    |   11 -
 arch/x86/include/asm/fpu-internal.h              |   15 +
 arch/x86/kernel/cpu/amd.c                        |   14 +
 arch/x86/kernel/smpboot.c                        |    5=20
 drivers/acpi/processor_driver.c                  |    1=20
 drivers/edac/i7300_edac.c                        |    8=20
 drivers/edac/i7core_edac.c                       |    6=20
 drivers/gpu/drm/i915/intel_lvds.c                |    8=20
 drivers/gpu/drm/radeon/evergreen.c               |  191 +++++++++++-------=
-----
 drivers/gpu/drm/radeon/evergreen_reg.h           |    2=20
 drivers/gpu/drm/radeon/evergreend.h              |    7=20
 drivers/gpu/drm/radeon/radeon_asic.h             |    1=20
 drivers/md/raid1.c                               |    2=20
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c |   11 -
 drivers/net/ethernet/realtek/8139cp.c            |   22 +-
 drivers/net/usb/qmi_wwan.c                       |   42 +++++
 drivers/net/wireless/iwlwifi/dvm/rxon.c          |   12 -
 drivers/target/target_core_transport.c           |    6=20
 kernel/sched/auto_group.c                        |    4=20
 kernel/sched/auto_group.h                        |    5=20
 kernel/workqueue.c                               |    4=20
 mm/memory-failure.c                              |    8=20
 mm/sparse.c                                      |   10 -
 mm/vmscan.c                                      |   27 ++-
 net/mac80211/offchannel.c                        |    2=20
 29 files changed, 278 insertions(+), 165 deletions(-)

Alan Cox (1):
      ACPI: missing break

Alex Deucher (3):
      drm/radeon/dce4+: don't use radeon_crtc for vblank callback
      drm/radeon: properly handle mc_stop/mc_resume on evergreen+ (v2)
      drm/radeon: properly track the crtc not_enabled case evergreen_mc_sto=
p()

Andre Przywara (1):
      x86, amd: Disable way access filter on Piledriver CPUs

Ariel Elior (1):
      bnx2x: remove redundant warning log

Bj=F8rn Mork (2):
      net: qmi_wwan: adding more ZTE devices
      net: qmi_wwan: add Huawei E173

Chris Wilson (1):
      drm/i915: Add no-lvds quirk for Supermicro X7SPA-H

Emmanuel Grumbach (1):
      iwlwifi: fix the basic CCK rates calculation

Francois Romieu (1):
      8139cp: revert "set ring address before enabling receiver"

Greg Kroah-Hartman (1):
      Linux 3.6.10

Jason Gunthorpe (1):
      ARM: Kirkwood: Update PCI-E fixup

Jean Delvare (1):
      i7300_edac: Fix error flag testing

Jianguo Wu (1):
      mm/vmemmap: fix wrong use of virt_to_page

Johannes Berg (1):
      mac80211: fix remain-on-channel (non-)cancelling

Johannes Weiner (1):
      mm: vmscan: fix endless loop in kswapd balancing

Mike Galbraith (2):
      workqueue: exit rescuer_thread() as TASK_RUNNING
      Revert "sched, autogroup: Stop going ahead if autogroup is disabled"

Naoya Horiguchi (1):
      mm: soft offline: split thp at the beginning of soft_offline_page()

NeilBrown (1):
      md/raid1{,0}: fix deadlock in bitmap_unplug.

Prarit Bhargava (1):
      i7core_edac: fix panic when accessing sysfs files

Roland Dreier (1):
      target: Fix handling of aborted commands

Russell King - ARM Linux (2):
      Dove: Attempt to fix PMU/RTC interrupts
      Dove: Fix irq_to_pmu()

Vincent Palatin (1):
      x86, fpu: Avoid FPU lazy restore after suspend


--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxjwFAAoJEDjbvchgkmk+T1AQAMOv4/4wc9sZDB5xzX3DByyk
MCAUtkYxjSZgdUXFqRnEsT8HWKAT06R6Og1kXxtBCgMA0kOhwUWwlSjKo5zhlNCu
FR32Tf1xQXJu7ZuvmCD7TkJZzsH0qmSQgn1Mg3mNOYHvBSfvC4lLJAYibS9RLFTB
7c1AbbZxmzyFNhVxCAebBHXlvk+m3Fapqc6HIoqBPzEGvHtkvpJoTZFVQHnUUbTz
HOgDlEUMm/9jwPUGotZ9VVXS2JZ3ILXyu5ujfPE5SybSnaNjmRQdXkBvwZgZQpYW
HLziVo0ljQwDYdh9LGtstzOCH8fBJ/AcgzKuWyedoQ6Cw6EszMg3bma1FRF7sO7u
AfPqV1QRicqqev7HqIAGvykniF8bLwNT8EEHStAnIoqA1wVeerY90LHnNOoMXZrS
l2BiORMNmrbQeBu6WI7qdVJbwYSLibIyFil68xFa0j1/xq+snA57QrUtQusxEbVn
pjR5cnTaImIw2hEqSO9SqPAMCGS4DYL8ViP6FQAnmgvkKa/ccMXutguV3aq6uarV
kiEvS+hyyp0zo6jwY5zqIA729+uTVwiXXiD/O6/F9UFWwEtB30fKprI2thJ7V/4B
v6fjRR6UYFS6aDL2I8mn1Pb7Bt58bJmI2elZKHG0A10zJiMJgE29WW+9vOMjmX8T
1DM3GY0mjksosvVkr04G
=g4mf
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
