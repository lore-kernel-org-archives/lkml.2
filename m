Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab2AIQQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 11:16:52 -0500
Received: from 8bytes.org ([88.198.83.132]:46859 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170Ab2AIQQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 11:16:51 -0500
Date: Mon, 9 Jan 2012 17:16:45 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] IOMMU updates for 3.3-rc1
Message-ID: <20120109161644.GA2551@8bytes.org>
References: <20120105172827.GA3809@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20120105172827.GA3809@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

On Thu, Jan 05, 2012 at 06:28:27PM +0100, Joerg Roedel wrote:
> When I did a test-pull of the branch against v3.2 there was a conflict
> in drivers/pci/hotplug/acpiphp_glue.c (due to the changes I pulled in
> from the PCI tree). Please let me know in case you want me to fix that.

Okay, I re-merged the branches on a v3.2 base. This makes the conflict
go away and the shortlog against v3.2 looks much cleaner now. Also my
test-pull worked fine. The patches in the branches have not changed or
rebased. The patches pulled in from Jesse's PCI tree are also still
in here too. So I updated the next branch with the result. The
top-commit on my local machine is now

	f93ea733878733f3e98475bc3e2ccf789bebcfb8

and here is the updated pull-request. Please pull:

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git next

Alex Williamson (7):
      iommu: Add iommu_device_group callback and iommu_group sysfs entry
      iommu/intel: Implement iommu_device_group
      iommu/amd: Implement iommu_device_group
      iommu: Add option to group multi-function devices
      PCI: Fix PRI and PASID consistency
      PCI: Enable is not exposed as a PASID capability
      PCI: More PRI/PASID cleanup

Eric W. Biederman (1):
      PCI: msi: Disable msi interrupts when we initialize a pci device

Joerg Roedel (33):
      iommu: Fix compile error with !IOMMU_API
      Merge branch 'for-joerg' of git://git.kernel.org/.../ohad/linux into arm/omap
      iommu/amd: Convert dev_table_entry to u64
      iommu/amd: Get the maximum number of PASIDs supported
      iommu/amd: Setup PPR log when supported by IOMMU
      iommu/amd: Enable GT mode when supported by IOMMU
      iommu/amd: Add iommuv2 flag to struct amd_iommu
      iommu/amd: Put IOMMUv2 capable devices in pt_domain
      iommu/amd: Implement notifier for PPR faults
      iommu/amd: Add amd_iommu_domain_direct_map function
      iommu/amd: Add support for IOMMUv2 domain mode
      iommu/amd: Implement IOMMUv2 TLB flushing routines
      iommu/amd: Implement functions to manage GCR3 table
      iommu/amd: Implement function to send PPR completions
      iommu/amd: Add function to get IOMMUv2 domain for pdev
      iommu/amd: Add device errata handling
      iommu/amd: Add stat counter for IOMMUv2 events
      iommu/amd: Add driver stub for AMD IOMMUv2 support
      iommu/amd: Implement device aquisition code for IOMMUv2
      iommu/amd: Add routines to bind/unbind a pasid
      iommu/amd: Implement IO page-fault handler
      iommu/amd: Implement notifiers for IOMMUv2
      iommu/amd: Add invalid_ppr callback
      Merge branch 'iommu/page-sizes' into x86/amd
      Merge remote-tracking branch 'pci/pri-changes' into x86/amd
      iommu/amd: Adapt IOMMU driver to PCI register name changes
      iommu/amd: Add amd_iommu_device_info() function
      iommu/amd: Add invalidate-context call-back
      iommu/amd: Remove unnecessary cache flushes in amd_iommu_resume
      iommu/amd: Init stats for iommu=pt
      iommu/amd: Set IOTLB invalidation timeout
      Merge branches 'iommu/fixes', 'arm/omap' and 'x86/amd' into next
      Merge branches 'iommu/page-sizes' and 'iommu/group-id' into next

Kenji Kaneshige (2):
      PCI: pciehp: Fix wrong workqueue cleanup
      PCI: pciehp: Handle push button event asynchronously

Matthew Garrett (1):
      PCI: Rework ASPM disable code

Neil Horman (1):
      PCI/sysfs: add per pci device msi[x] irq listing (v5)

Ohad Ben-Cohen (11):
      iommu/core: stop converting bytes to page order back and forth
      iommu/core: split mapping to page sizes as supported by the hardware
      iommu/omap: announce supported page sizes
      iommu/msm: announce supported page sizes
      iommu/amd: announce supported page sizes
      iommu/intel: announce supported page sizes
      iommu/core: remove the temporary pgsize settings
      ARM: OMAP: iommu: declare a private iommu binding struct
      ARM: OMAP3: bind omap3isp_device to its iommu device
      iommu/omap: eliminate the public omap_find_iommu_device() method
      iommu/omap: be verbose when omap_iommu_iova_to_phys fails

Rafael J. Wysocki (2):
      PCI/ACPI: Make acpiphp ignore root bridges using SHPC native hotplug
      PCI/ACPI/PM: Avoid resuming devices that don't signal PME

 Documentation/ABI/testing/sysfs-bus-pci |   18 +
 Documentation/kernel-parameters.txt     |    9 +-
 arch/arm/mach-omap2/devices.c           |    7 +
 arch/arm/plat-omap/include/plat/iommu.h |   31 +-
 arch/arm/plat-omap/include/plat/iovmm.h |   12 +-
 arch/ia64/include/asm/iommu.h           |    2 +
 arch/ia64/kernel/pci-dma.c              |    1 +
 arch/x86/include/asm/iommu.h            |    1 +
 arch/x86/kernel/pci-dma.c               |   11 +
 drivers/acpi/pci_root.c                 |    7 +
 drivers/iommu/Kconfig                   |   13 +-
 drivers/iommu/Makefile                  |    1 +
 drivers/iommu/amd_iommu.c               |  883 ++++++++++++++++++++++++++--
 drivers/iommu/amd_iommu_init.c          |  133 ++++-
 drivers/iommu/amd_iommu_proto.h         |   24 +
 drivers/iommu/amd_iommu_types.h         |  118 ++++-
 drivers/iommu/amd_iommu_v2.c            |  994 +++++++++++++++++++++++++++++++
 drivers/iommu/intel-iommu.c             |   79 +++-
 drivers/iommu/iommu.c                   |  177 +++++-
 drivers/iommu/msm_iommu.c               |   25 +-
 drivers/iommu/omap-iommu.c              |   80 ++--
 drivers/iommu/omap-iovmm.c              |   48 +-
 drivers/media/video/omap3isp/isp.c      |   30 +-
 drivers/media/video/omap3isp/isp.h      |    2 -
 drivers/media/video/omap3isp/ispccdc.c  |   18 +-
 drivers/media/video/omap3isp/ispstat.c  |    8 +-
 drivers/media/video/omap3isp/ispvideo.c |    4 +-
 drivers/pci/ats.c                       |   90 ++--
 drivers/pci/hotplug/pciehp.h            |    1 -
 drivers/pci/hotplug/pciehp_core.c       |   11 +-
 drivers/pci/hotplug/pciehp_ctrl.c       |    4 +-
 drivers/pci/hotplug/pciehp_hpc.c        |    1 -
 drivers/pci/msi.c                       |  121 ++++
 drivers/pci/pci-acpi.c                  |   13 +-
 drivers/pci/pcie/aspm.c                 |   58 ++-
 include/linux/acpi.h                    |    4 +
 include/linux/amd-iommu.h               |  138 +++++-
 include/linux/iommu.h                   |   33 +-
 include/linux/msi.h                     |    3 +
 include/linux/pci-aspm.h                |    4 +-
 include/linux/pci.h                     |    1 +
 include/linux/pci_regs.h                |   34 +-
 virt/kvm/iommu.c                        |    8 +-
 43 files changed, 2943 insertions(+), 317 deletions(-)
 create mode 100644 drivers/iommu/amd_iommu_v2.c

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPCxLsAAoJECvwRC2XARrjEVAQAIC9e9TpXp0f5vZoz92UYlcU
SKfFA+q1bSR2ylav7iwu+lSUsnrauJroS/wTyqVotrFAhQsu6dIgpIOH6jEgGpPb
ubVBIZAgMzPUjH9D3Na8t4scaQkB2lJ6owajdgi1/+tqvtE2gSSfnVSNzM/k1HyA
rjm0QKFgHFtJDxPPOHMagTgG0VQgR6+ZKlD7N/+1kCUhZIbWaHW6mEaDuZjnm6Fd
8MzG3PCMSSGV/dLmG8iTnL1906ImATup4pUa2p2yML9Q7wbda1fuhzJllNwByHXR
TndgVkEEifulrLDT4NglzCiDk2Y088mTUoGLvOWyyh8RYuJEYeZ3wfGTRcu9jiUJ
PoabGrXFsPQOe14frWKozgh/njPL3MkxrbCeFATjZAPzfKgymJ46IlT6w3rUufPk
aDZYwrIB1HyB+GucedQcOUhNtU3HGatf1UQbCwVApXJUoeNAFQ5ncyZBx2gcKPDW
frYqPHgkFO7GcvESWOmWLH8h/t6zefbT/y4Q7VyOoLyX6iPQ68Sj6gNO0mZqh+RJ
zdf56exQx+H7XQVl0rQ5rMvfmO0Ut2UWRAPPOo9djCkZOYIetehbh+ZK/OFcb0+4
AE7gqi3qPa8YyWc2IIqTM0aS12yCN7XGjfO+gHlwZMVl9/Il7NVn1oQ+KCm7bKLw
0le5g2/pdUFNP1+0/m+v
=YpbI
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
