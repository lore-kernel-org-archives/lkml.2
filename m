Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab0FAJER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 05:04:17 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:40221
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755532Ab0FAJEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 05:04:10 -0400
X-SpamScore: -19
X-BigFish: VPS-19(z21eWz936eMzz1202hzzz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L3BVUE-01-T60-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [git pull] amd iommu fixes for 2.6.35-rc1
Date: Tue, 1 Jun 2010 11:03:38 +0200
Message-ID: <1275383021-20172-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

The following changes since commit 67a3e12b05e055c0415c556a315a3d3eb637e29e:

  Linux 2.6.35-rc1 (2010-05-30 13:21:02 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-iommu.git amd-iommu/2.6.35

Joerg Roedel (3):
      Merge commit 'v2.6.35-rc1' into amd-iommu/2.6.35
      x86/amd-iommu: Fix crash when request_mem_region fails
      x86/amd-iommu: Fall back to GART if initialization fails

Julia Lawall (1):
      arch/x86/kernel: Add missing spin_unlock

 arch/x86/kernel/amd_iommu.c      |   16 +++++++++-------
 arch/x86/kernel/amd_iommu_init.c |   20 +++++++++++++++++---
 2 files changed, 26 insertions(+), 10 deletions(-)

These patches fix two bugs in the error-paths of the amd iommu
driver. One fix adds missing spin_unlocks and the other two patches fix
a problem with broken BIOSes where the driver can't allocate the mmio
region for the iommu hardware. Please pull.

	Joerg


