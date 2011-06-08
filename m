Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab1FHWQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 18:16:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40156 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937Ab1FHWQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 18:16:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management fixes for 3.0
Date: Thu, 9 Jun 2011 00:17:28 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: linux-pci@vger.kernel.org,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201106090017.28999.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull two power management fixes for 3.0 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

One of them is a build fix and the second one fixes an embarassing mistake
in common power management clocks manipulation code.


 drivers/base/power/clock_ops.c |   16 ++++++++--------
 drivers/pci/intel-iommu.c      |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

---------------

Rafael J. Wysocki (2):
      PM / Intel IOMMU: Fix init_iommu_pm_ops() for CONFIG_PM unset
      PM / Runtime: Fix loops in pm_runtime_clk_notify()

