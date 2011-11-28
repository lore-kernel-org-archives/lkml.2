Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1K1I76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 03:59:58 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:49505 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752272Ab1K1I74 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 03:59:56 -0500
From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
To: David Daney <ddaney.cavm@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Moore, Eric" <Eric.Moore@lsi.com>,
        "James Bottomley" <jejb@kernel.org>,
        "Desai, Kashyap" <Kashyap.Desai@lsi.com>,
        "DL-MPT Fusion Linux" <DL-MPTFusionLinux@lsi.com>,
        Support <support@lsi.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC: Chandrakala Chavva <cchavva@caviumnetworks.com>,
        David Daney <david.daney@cavium.com>
Date: Mon, 28 Nov 2011 14:29:49 +0530
Subject: RE: [PATCH] mptsas: Add device ID for SAS1068_820XELP.
Thread-Topic: [PATCH] mptsas: Add device ID for SAS1068_820XELP.
Thread-Index: AcymP1qPx6xroV9hRW23l/W3FQiHFAHbJggw
Message-ID: <A6888A6805518E4EA4AF7072A28264A604726F2879@inbmail02.lsi.com>
References: <1321654422-27617-1-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1321654422-27617-1-git-send-email-ddaney.cavm@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider this patch as an Acked by me.

Regards,
Nagalakshmi


-----Original Message-----
From: David Daney [mailto:ddaney.cavm@gmail.com] 
Sent: Saturday, November 19, 2011 3:44 AM
To: linux-kernel@vger.kernel.org; Moore, Eric; James Bottomley; Desai, Kashyap; DL-MPT Fusion Linux; Support; linux-scsi@vger.kernel.org
Cc: Chandrakala Chavva; David Daney
Subject: [PATCH] mptsas: Add device ID for SAS1068_820XELP.

From: Chandrakala Chavva <cchavva@caviumnetworks.com>

We need this new devid to be able to use this board.

Signed-off-by: Chandrakala Chavva <cchavva@caviumnetworks.com>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/message/fusion/lsi/mpi_cnfg.h |    1 +
 drivers/message/fusion/mptsas.c       |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/lsi/mpi_cnfg.h b/drivers/message/fusion/lsi/mpi_cnfg.h
index 22027e7..d9bcfba 100644
--- a/drivers/message/fusion/lsi/mpi_cnfg.h
+++ b/drivers/message/fusion/lsi/mpi_cnfg.h
@@ -583,6 +583,7 @@ typedef struct _MSG_CONFIG_REPLY
 #define MPI_MANUFACTPAGE_DEVID_SAS1066E             (0x005A)
 #define MPI_MANUFACTPAGE_DEVID_SAS1068              (0x0054)
 #define MPI_MANUFACTPAGE_DEVID_SAS1068E             (0x0058)
+#define MPI_MANUFACTPAGE_DEVID_SAS1068_820XELP      (0x0059)
 #define MPI_MANUFACTPAGE_DEVID_SAS1078              (0x0062)
 
 
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 9d95042..551262e 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -5376,6 +5376,8 @@ static struct pci_device_id mptsas_pci_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID },
 	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1078,
 		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_SAS1068_820XELP,
+		PCI_ANY_ID, PCI_ANY_ID },
 	{0}	/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(pci, mptsas_pci_table);
-- 
1.7.2.3

