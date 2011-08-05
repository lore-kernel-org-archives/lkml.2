Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab1HEHtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 03:49:50 -0400
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:49949 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755966Ab1HEHts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 03:49:48 -0400
X-AuditID: c1b4fb3d-b7c17ae00000262e-47-4e3b9d0e3c37
From: Nils Carlson <nils.carlson@ericsson.com>
To: mchehab@redhat.com
CC: linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
Subject: [PATCH] i7core_edac: Add xeon 5600 generic non core registers v2
Date: Fri, 5 Aug 2011 10:09:10 +0200
Message-ID: <1312531750-14933-2-git-send-email-nils.carlson@ericsson.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1312531750-14933-1-git-send-email-nils.carlson@ericsson.com>
References: <1312531750-14933-1-git-send-email-nils.carlson@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>

Changes since v1:
Reposted as a single patch and not as part of a series.

Signed-off-by: Samuel Gabrielsson <samuel.gabrielsson@gmail.com>
---
 drivers/edac/i7core_edac.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 465cbc2..b1f6889 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -322,6 +322,9 @@ static const struct pci_id_descr pci_dev_descr_lynnfield[] = {
 };
 
 static const struct pci_id_descr pci_dev_descr_i7core_westmere[] = {
+		/* Generic Non-core registers */
+	{ PCI_DESCR(0, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_NONCORE_REV2) },
+
 		/* Memory controller */
 	{ PCI_DESCR(3, 0, PCI_DEVICE_ID_INTEL_LYNNFIELD_MCR_REV2)     },
 	{ PCI_DESCR(3, 1, PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_TAD_REV2)  },
-- 
1.6.0.2

