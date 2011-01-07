Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab1AGKv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 05:51:28 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53476 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab1AGKv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 05:51:27 -0500
Date: Fri, 7 Jan 2011 11:51:35 +0100
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] amd64_edac changes for .38
Message-ID: <20110107105134.GC16507@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the branch below to receive the current amd64_edac
patchqueue. This has been cooking in linux-next and here internally
without issues for more than a month now.

Please note that I've rebased the branch ontop of your merge commit of
-tip's x86-amd-nb-for-linus since the edac changes depend on amd-nb
code. Please let me know if that's crap and you would rather like to see
a resolved merge diff.

Thanks.

The following changes since commit 42cbd8efb0746b55112de45173219f76c54390da:

  Merge branch 'x86-amd-nb-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip (2011-01-06 10:50:28 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git edac-for-linus

Borislav Petkov (16):
      amd64_edac: Remove F11h support
      amd64_edac: Use cached extended CPU model
      amd64_edac: Add per-family init function
      amd64_edac: Simplify CPU family detection
      amd64_edac: Cleanup the CPU PCI device reservation
      amd64_edac: Concentrate per-family init even more
      amd64_edac: Rename CPU PCI devices
      amd64_edac: Rework printk macros
      amd64_edac: Allocate driver instances dynamically
      amd64_edac: Remove explicit Kconfig PCI dependency
      amd64_edac: Remove PCI ECS enabling functions
      amd64_edac: Carve out ECC-related hw settings
      amd64_edac: Check ECC capabilities initially
      amd64_edac: Remove two-stage initialization
      EDAC: Fixup scrubrate manipulation
      amd64_edac: Disable DRAM ECC injection on K8

 drivers/edac/Kconfig          |    8 +-
 drivers/edac/amd64_edac.c     |  823 +++++++++++++++++------------------------
 drivers/edac/amd64_edac.h     |   86 ++---
 drivers/edac/amd64_edac_inj.c |   25 +-
 drivers/edac/cpc925_edac.c    |    9 +-
 drivers/edac/e752x_edac.c     |    8 +-
 drivers/edac/edac_core.h      |    5 +-
 drivers/edac/edac_mc.c        |    4 +-
 drivers/edac/edac_mc_sysfs.c  |   57 ++--
 drivers/edac/i5100_edac.c     |    9 +-
 10 files changed, 436 insertions(+), 598 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
