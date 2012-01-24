Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2AXJJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 04:09:06 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:65031 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754750Ab2AXJJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 04:09:00 -0500
Date: Tue, 24 Jan 2012 10:08:56 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org, peppe.cavallaro@st.com,
        netdev@vger.kernel.org
Cc: giancarlo.asnaghi@st.com
Subject: [PATCH 1/3] stmmac: added PCI identifiers
Message-ID: <e05c69415f05b3dbca26cd8255374de3656dcbff.1327394751.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1327394750.git.rubini@gnudd.com>
In-Reply-To: <cover.1327394750.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


STM has a device ID within its own VENDOR space, and it is being
used in the STA2X11 I/O Hub.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Acked-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 54a819a..c796de9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -170,9 +170,9 @@ static int stmmac_pci_resume(struct pci_dev *pdev)
 #define STMMAC_DEVICE_ID 0x1108
 
 static DEFINE_PCI_DEVICE_TABLE(stmmac_id_table) = {
-	{
-	PCI_DEVICE(STMMAC_VENDOR_ID, STMMAC_DEVICE_ID)}, {
-	}
+	{PCI_DEVICE(STMMAC_VENDOR_ID, STMMAC_DEVICE_ID)},
+	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_MAC)},
+	{}
 };
 
 MODULE_DEVICE_TABLE(pci, stmmac_id_table);
-- 
1.7.7.2
