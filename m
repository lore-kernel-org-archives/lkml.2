Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab0FIWya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:54:30 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:37123 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758277Ab0FIWy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:54:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Subject:Message-ID:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=AhcrceelJRtw+hCrxpqI8KwWfy3/pCer7e4zMxkaA6fLZfukspCRuS1fV2XhrMjrOQBq/lAp0RSf2SPizhjZXXhHS/WgUYn6s/4IvYNyKOuxpyYpmExDbX2J0L29uTHB;
Date: Wed, 9 Jun 2010 15:53:21 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20100609155321.299cadd9@virtuousgeek.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit
9dda696f0de87a2e5cfabb147e28c76b7d3c6846: Linus Torvalds (1):
        Merge branch 'release' of
git://git.kernel.org/.../aegl/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6 for-linus

Nothing too big here; I do have a couple of fixes in the queue that
aren't included here though.  I'll be pulling them together over the
next couple of days.

Bjorn Helgaas (1):
      PCI: change resource collision messages from KERN_ERR to KERN_INFO

Clemens Ladisch (1):
      PCI quirk: AMD 780: work around wrong vendor ID on APC bridge

Dan Carpenter (1):
      PCI: hotplug/shpchp_hpc: add parenthesis in SLOT_REG_RSVDZ_MASK

Linus Torvalds (1):
      PCI aerdrv: fix annoying warnings

Stephen Hemminger (1):
      PCI: sparse warning (trivial)

Tejun Heo (1):
      PCI: disable MSI on VIA K8M800

 drivers/pci/bus.c                  |    2 +-
 drivers/pci/hotplug/shpchp_hpc.c   |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c |   17 +++++++++--------
 drivers/pci/quirks.c               |   24 +++++++++++++++++++++---
 drivers/pci/setup-res.c            |   10 +++++-----
 5 files changed, 37 insertions(+), 18 deletions(-)


-- 
Jesse Barnes, Intel Open Source Technology Center
