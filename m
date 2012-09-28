Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030907Ab2I1TKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:10:48 -0400
Received: from 8bytes.org ([85.214.48.195]:46688 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030675Ab2I1TKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:10:46 -0400
Date: Fri, 28 Sep 2012 21:10:42 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU Fixes for v3.6-rc7
Message-ID: <20120928191041.GA3965@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Sep 28 21:10:43 2012
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5065f63322972392168013
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 979570e02981d4a8fc20b3cc8fd651856c98ee9d:

  Linux 3.6-rc7 (2012-09-23 18:10:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.6-rc7

for you to fetch changes up to 0774e392555a128cff7a94929b9ce957927fef49:

  iommu/amd: Fix wrong assumption in iommu-group specific code (2012-09-28 16:14:44 +0200)

----------------------------------------------------------------
IOMMU fixes for Linux v3.6-rc7

Two small patches:

	* One patch to fix the function declarations for
	  !CONFIG_IOMMU_API. This is causing build errors
	  in linux-next and should be fixed for v3.6.

	* Another patch to fix an IOMMU group related NULL pointer
	  dereference.

----------------------------------------------------------------
Alex Williamson (1):
      iommu: static inline iommu group stub functions

Joerg Roedel (1):
      iommu/amd: Fix wrong assumption in iommu-group specific code

 drivers/iommu/amd_iommu.c |    6 ++++--
 include/linux/iommu.h     |   42 ++++++++++++++++++++++++------------------
 2 files changed, 28 insertions(+), 20 deletions(-)

Please pull.

Regards,

	Joerg


