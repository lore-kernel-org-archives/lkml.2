Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab0FUR00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:26:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:30601 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145Ab0FUR0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:26:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,454,1272870000"; 
   d="scan'208";a="528840055"
Date: Mon, 21 Jun 2010 10:24:32 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fix
Message-ID: <20100621102432.2e206889@intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
7e27d6e778cd87b6f2415515d7127eba53fe5d02: Linus Torvalds (1):
        Linux 2.6.35-rc3

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Just one regression fix from Rafael right now.  I hope to get one or
two more regression fixes in before the final release too.

Rafael J. Wysocki (1):
      PCI/PM: Do not use native PCIe PME by default

 Documentation/kernel-parameters.txt |    4 +++-
 drivers/pci/pcie/pme/pcie_pme.c     |   19 +++++++++++++------
 2 files changed, 16 insertions(+), 7 deletions(-)


-- 
Jesse Barnes, Intel Open Source Technology Center
