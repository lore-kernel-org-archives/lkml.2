Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993Ab1KRO2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:28:53 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:21214 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab1KRO2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:28:51 -0500
Date: Fri, 18 Nov 2011 09:28:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, stefano.stabellini@eu.citrix.com,
        dan.carpenter@oracle.com, dgdegra@tycho.nsa.gov,
        david.vrabel@citrix.com, zhenzhong.duan@oracle.com, monstr@monstr.eu
Subject: [GIT PULL] (xen) stable/for-linus-fixes-3.2 for 3.2-rc2.
Message-ID: <20111118142832.GA17041@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090207.4EC66B9B.00D8,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Linus,

Please git pull the following branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-linus-fixes-3.2

which is based off git commit 1ea6b8f48918282bdca0b32a34095504ee65bab5
Linus Torvalds (1):
    Linux 3.2-rc1

There are three security fixes by Dan, one bug-fixes in the balloon code,
one with the drop of XEN_PLATFORM_PCI option, fixes to make Linux kernel
boot with more than 32 VCPUs, and lastly an update in the vmalloc code
to remove a temporary fix (added in v3.1) in said code and replace it with
a proper fix.

Please pull!

Dan Carpenter (3):
      xen-gntdev: integer overflow in gntdev_alloc_map()
      xen-gntalloc: integer overflow in gntalloc_ioctl_alloc()
      xen-gntalloc: signedness bug in add_grefs()

Daniel De Graaf (2):
      xen: Remove hanging references to CONFIG_XEN_PLATFORM_PCI
      xen/balloon: Avoid OOM when requesting highmem

David Vrabel (1):
      xen: map foreign pages for shared rings by updating the PTEs directly

Zhenzhong Duan (1):
      xen:pvhvm: enable PVHVM VCPU placement when using more than 32 CPUs.

 arch/x86/xen/enlighten.c           |    3 +--
 arch/x86/xen/grant-table.c         |    2 +-
 drivers/xen/balloon.c              |    4 ++--
 drivers/xen/gntalloc.c             |    4 ++--
 drivers/xen/gntdev.c               |   10 +++++-----
 drivers/xen/xenbus/xenbus_client.c |   11 ++++++++---
 include/linux/vmalloc.h            |    2 +-
 include/xen/platform_pci.h         |    6 ++----
 mm/nommu.c                         |    2 +-
 mm/vmalloc.c                       |   27 +++++++++++++--------------
 10 files changed, 36 insertions(+), 35 deletions(-)

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOxmuPAAoJEFKFlzJcLqlYELMP/2PVFjYc09sT7eCQ2oP0m83Q
0n19Na8iLfgHPlq5loNC45Hdx6wWHwDeHE5SH/th7N2rz4g8S1ScQbyAKLGRN8fv
0icjXKySHcn+PRAF43qNxoE+HZ2SIrGVr1eVrf8AyUT9nLBfPeIOQBs4sjdMW6al
BPkpTz+QQMpygR15tl2Ylez01xOUl1FEVAwfK0A3onvBgwEEwmSA+M16WNqiuRmL
jlM8KL8zUODCUGpPy8U+jEuWKPue5lXoRnCbudVmWgocWa3hL7adPbs7A5Ra8UED
ETq/Km3FCU/wcmJOsMQ9EO0arCFujQOEadaH7gVxNLhK8Gth8J3eInP+GphhIweJ
hrAEKAJLHI8BFsiMpGNh93rGlyoRPUgx5SfITX6PPXwaUjRKoEcZGV9nvLlGoKn6
RV82ocpF0AYrbmIFavksjmULIGIXLFhcZFRiSzIwQpV1wreezv0o/llthXrrXhdo
lWzb9BWdXIe+pO5lhlBQHA6hAY6FAQzbtKGivpSELTIohgIHd9chgqiHUvcqd4EV
OvLRfZiXvxLUIq7NBA7NffJSKGV47capozabzt7kYe4CWUikr68pYWvDzQdwlIzJ
QNrW0L3tCwtvDkNxauTsF/MtAN7Rphept2NX7YllhVlRPKrb495fNl04qdY+W5ZL
kMDCR2RdIXTZ49fYTgId
=LJ4z
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
