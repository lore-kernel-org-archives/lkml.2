Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1IFKHG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 06:07:06 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:47809
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753316Ab1IFKHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 06:07:02 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz936eKzz1202hzz15d4R8275dhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LR3IRH-02-0BV-02
X-M-MSG: 
Date: Tue, 6 Sep 2011 12:06:55 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>
Subject: [GIT PULL] AMD IOMMU fixes for 3.1
Message-ID: <20110906100655.GS16691@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit c6a389f123b9f68d605bb7e0f9b32ec1e3e14132:

  Linux 3.1-rc4 (2011-08-28 21:16:01 -0700)

are available in the git repository at:
  git://git.8bytes.org/scm/iommu.git amd/fixes

Joerg Roedel (2):
      iommu/amd: Make sure iommu->need_sync contains correct value
      iommu/amd: Don't take domain->lock recursivly

 drivers/iommu/amd_iommu.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

These patches fix a performance regression because of too many
unnecessary completion-wait commands being sent and a dead-lock
situation for drivers that allocate more than 1GB of dma address space.
Please pull.

Regards,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

