Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab2CAHNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 02:13:10 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21380 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758145Ab2CAHNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 02:13:06 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6635"; a="167923349"
X-IronPort-AV: E=Sophos;i="4.73,507,1325491200"; 
   d="scan'208";a="207294414"
From: "Rodriguez, Luis" <rodrigue@qca.qualcomm.com>
To: "Ren, Cloud" <cjren@qca.qualcomm.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Subject: RE: [PATCH 2/3] atl1c: change author
Thread-Topic: [PATCH 2/3] atl1c: change author
Thread-Index: AQHM923yUHdhR4y1BEy3YqqejNViSJZVBny8
Date: Thu, 1 Mar 2012 07:13:04 +0000
Message-ID: <7A9ADFFA56024346AAE90B6BABC3BD15D2F8A8@nasanexd02b.na.qualcomm.com>
References: <1330580469-23348-1-git-send-email-cjren@qca.qualcomm.com>,<1330580469-23348-3-git-send-email-cjren@qca.qualcomm.com>
In-Reply-To: <1330580469-23348-3-git-send-email-cjren@qca.qualcomm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.106.114.130]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Um, actually, for now can you please use QCA or Qualcomm Atheros, Inc. QCA != Qualcomm.

  Luis
________________________________________
From: Ren, Cloud
Sent: Wednesday, February 29, 2012 9:41 PM
To: davem@davemloft.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.org
Cc: qca-linux-team; nic-devel; Ren, Cloud
Subject: [PATCH 2/3] atl1c: change author

The author, jie yang, has left. please use nic-devel@qualcomm.com report bugs to
us.

Signed-off-by: Cloud Ren <cjren@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 6bf387b..815f683 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -52,7 +52,7 @@ static DEFINE_PCI_DEVICE_TABLE(atl1c_pci_tbl) = {
 };
 MODULE_DEVICE_TABLE(pci, atl1c_pci_tbl);

-MODULE_AUTHOR("Jie Yang <jie.yang@atheros.com>");
+MODULE_AUTHOR("Qualcomm Corporation, <nic-devel@qualcomm.com>");
 MODULE_DESCRIPTION("Atheros 1000M Ethernet Network Driver");
 MODULE_LICENSE("GPL");

--
1.7.7

