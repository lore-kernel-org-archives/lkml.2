Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2LJTsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:48:02 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:52923 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2LJTr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:47:59 -0500
Date: Mon, 10 Dec 2012 11:47:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.56
Message-ID: <20121210194749.GA19817@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.56 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 +-
 arch/arm/mach-dove/include/mach/pm.h |    2 +-
 arch/arm/mach-dove/irq.c             |   14 +++++++++++++-
 block/scsi_ioctl.c                   |    5 ++++-
 drivers/acpi/processor_driver.c      |    1 +
 drivers/gpu/drm/i915/intel_lvds.c    |   16 ++++++++++++++++
 kernel/sched_autogroup.c             |    4 ----
 kernel/sched_autogroup.h             |    5 -----
 kernel/workqueue.c                   |    4 +++-
 mm/memory-failure.c                  |    8 ++++++++
 mm/sparse.c                          |   10 ++++------
 net/ipv4/route.c                     |    4 ++++
 12 files changed, 55 insertions(+), 20 deletions(-)

Alan Cox (1):
      ACPI: missing break

Calvin Walton (1):
      i915: Quirk no_lvds on Gigabyte GA-D525TUD ITX motherboard

Chris Wilson (1):
      drm/i915: Add no-lvds quirk for Supermicro X7SPA-H

Greg Kroah-Hartman (1):
      Linux 3.0.56

Jan Kara (1):
      scsi: Silence unnecessary warnings about ioctl to partition

Jianguo Wu (1):
      mm/vmemmap: fix wrong use of virt_to_page

Michal Kubecek (1):
      route: release dst_entry.hh_cache when handling redirects

Mike Galbraith (2):
      workqueue: exit rescuer_thread() as TASK_RUNNING
      Revert "sched, autogroup: Stop going ahead if autogroup is disabled"

Naoya Horiguchi (1):
      mm: soft offline: split thp at the beginning of soft_offline_page()

Russell King - ARM Linux (2):
      Dove: Attempt to fix PMU/RTC interrupts
      Dove: Fix irq_to_pmu()


--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQxjxkAAoJEDjbvchgkmk+n8IP/3vFEsD+P1HHF9s/kUKhLbrW
jlpqWeAMQo0rMhQxIOT0vPDTJcPIXgjqN76Tm620/rYfMg0k0kxTwRqQUyA2NZn7
5u2GvLbjGp1acZ4925Z04QiFzYWV7H4/AGbWO2WjYaPBmln5Kqji5suEkdLKRWT6
mY15ElIhgPbcaM+Br++PTj8cKvTs2+EI8j9jRUQGq/frYTO0ddVoWvnM90euMD2Z
axjIjqliec3Ouh7KPrIuVJ6EssFrodDew1qK3vsRIxdZVOLKxjC01ootdH1th2Qr
olFpJj5DXuhSfsmEfGsk6p9vsDyYW90kfJvL1OjzOLXTbHqDpqksF8tJg6LAnki6
/Daw60HLaFmfYke5w48zww/4E8e/Ttu9dgl+urcfxTgff57CmVC8deCSWTrOGeZe
uUfYlcuioikWPD7nLZA/R0GYngEcJBK76n3K2AlM3PziIOL2/YP6htnG1+RzOPU9
6fXFpdQhAg5rChZAN6o54r6gQGVmBbUDYlfz58OkS/wf7I2Wj6ZcrfXu5aAwHF2F
J7m4TLOZ10B0NY6v1D0stWbpE4gpM8Sqa+TN1Ku0bw2cvVOrUnUCL9vU/eXhWWud
X3KZYQczHa7SL8g9KV8BEDAGBC2RftgFWgGDrZckzCGw6RLK1f+yJ0QXkfXASCs1
4UxzPD4n+mw3KIbhX0OD
=mZSy
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
