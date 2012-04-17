Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340Ab2DQFsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 01:48:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:49201 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957Ab2DQFsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 01:48:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89863275"
From: Lin Ming <ming.m.lin@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.og>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        Huang Ying <huang.ying.caritas@gmail.com>, Aaron Lu <aaron.lu@amd.com>
Subject: [PATCH 5/6] PCI/ACPI: Map PCI D3cold state to ACPI D3cold state
Date: Tue, 17 Apr 2012 13:47:55 +0800
Message-Id: <1334641676-14566-6-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com>
References: <1334641676-14566-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/pci/pci-acpi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 0f150f2..e641953 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -224,7 +224,7 @@ static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 		[PCI_D1] = ACPI_STATE_D1,
 		[PCI_D2] = ACPI_STATE_D2,
 		[PCI_D3hot] = ACPI_STATE_D3,
-		[PCI_D3cold] = ACPI_STATE_D3
+		[PCI_D3cold] = ACPI_STATE_D3_COLD
 	};
 	int error = -EINVAL;
 
-- 
1.7.2.5

