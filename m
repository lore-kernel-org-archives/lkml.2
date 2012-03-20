Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011Ab2CTNvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:51:10 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:36814 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2CTNvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:51:07 -0400
Date: Tue, 20 Mar 2012 14:51:05 +0100
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AMD64 EDAC fixes for 3.4
Message-ID: <20120320135105.GA11343@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following fixes for 3.4. I hope the signed tag commit
message is verbose enough for the contents of the pull request.

Thanks.

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git tags/amd64-edac-updates-for-3.4

for you to fetch changes up to ebe2aea86872622d4352cd71d55298fedf69a7bb:

  MCE, AMD: Constify error tables (2012-03-19 12:06:26 +0100)

----------------------------------------------------------------
A bunch of fixes/updates for the AMD side of EDAC including

* MCE decoding updates
* tree-wide EDAC sweep making pci_device_ids __devinitconst
* Scrub rate API correction
* two amd64_edac corrections for K8 boxes and sysfs csrow nodes

----------------------------------------------------------------
Ashish Shenoy (1):
      amd64_edac: Fix missing csrows sysfs nodes

Borislav Petkov (8):
      amd64_edac: Fix K8 revD and later chip select sizes
      EDAC: Correct scrub rate API
      MCE, AMD: Correct some MC0 error types
      MCE, AMD: Correct ucode patch buffer description
      MCE, AMD: Correct VB data error description
      MCE, AMD: Rework NB MCE signatures
      MCE, AMD: Correct bank 5 error signatures
      MCE, AMD: Constify error tables

Lionel Debroux (1):
      EDAC: Make pci_device_id tables __devinitconst.

 Documentation/edac.txt         |    4 +-
 drivers/edac/amd64_edac.c      |   50 +++++++---
 drivers/edac/amd76x_edac.c     |    2 +-
 drivers/edac/e752x_edac.c      |    2 +-
 drivers/edac/e7xxx_edac.c      |    2 +-
 drivers/edac/edac_mc_sysfs.c   |    4 +-
 drivers/edac/i3000_edac.c      |    2 +-
 drivers/edac/i3200_edac.c      |    2 +-
 drivers/edac/i5000_edac.c      |    2 +-
 drivers/edac/i5100_edac.c      |    2 +-
 drivers/edac/i5400_edac.c      |    2 +-
 drivers/edac/i7300_edac.c      |    2 +-
 drivers/edac/i7core_edac.c     |    2 +-
 drivers/edac/i82443bxgx_edac.c |    2 +-
 drivers/edac/i82860_edac.c     |    2 +-
 drivers/edac/i82875p_edac.c    |    2 +-
 drivers/edac/i82975x_edac.c    |    2 +-
 drivers/edac/mce_amd.c         |  208 +++++++++++++---------------------------
 drivers/edac/mce_amd.h         |   13 ++-
 drivers/edac/r82600_edac.c     |    2 +-
 drivers/edac/sb_edac.c         |    2 +-
 drivers/edac/x38_edac.c        |    2 +-
 22 files changed, 127 insertions(+), 186 deletions(-)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
