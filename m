Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab0JHSzE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:55:04 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:35594 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0JHSzC (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 8 Oct 2010 14:55:02 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] x86/ia64/iommu: Bugfixes to IOMMU_INIT macros and its friends.
Date: Fri,  8 Oct 2010 14:53:46 -0400
Message-Id: <1286564028-2352-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fix two issues with the IOMMU "modularize" system
that was posted on LKML:
http://marc.info/?i=1282845485-8991-2-git-send-email-konrad.wilk@oracle.com

The first:
 ia64/iommu: Add a dummy iommu_table.h file in IA64.

is to fix a compile error on IA64, where the DMAR IOMMU is utilized. For right
I am just posting a compile fix. I do have a experimental branch where the
IA64 support also utilizes this mechanism, but it is not ready yet for prime-time.

The other:
 x86/iommu: Update header comments with appropriate naming.

just updates the header comments as they diverged a bit.

Please pull both of these patches in your x86/iommu branch.

They are also available at:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/swiotlb-2.6.git devel/iommu-0.3.ontip.bugfix

Thank you!

Konrad Rzeszutek Wilk (2):
      ia64/iommu: Add a dummy iommu_table.h file in IA64.
      x86/iommu: Update header comments with appropriate naming.


 arch/ia64/include/asm/iommu_table.h |    6 ++++++
 arch/x86/include/asm/iommu_table.h  |    7 +++----
 2 files changed, 9 insertions(+), 4 deletions(-)

