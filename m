Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab2CAFlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 00:41:12 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33829 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab2CAFlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 00:41:10 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6635"; a="167909513"
X-IronPort-AV: E=Sophos;i="4.73,507,1325491200"; 
   d="scan'208";a="157725249"
From: Cloud Ren <cjren@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        Cloud Ren <cjren@qca.qualcomm.com>
Subject: [PATCH 0/3] atl1c: update some information of atl1c driver
Date: Thu, 1 Mar 2012 13:41:06 +0800
Message-ID: <1330580469-23348-1-git-send-email-cjren@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the series is to update some information of atl1c driver. Because the old author
has left, update author informatio for maintaining. and in a upstreamed driver,
driver doesn't need version information. the version of kernel will reflect its
version.

Cloud Ren (3):
  atl1c: remove ATL1C_DRV_VERSION stuff
  atl1c: change author
  atl1c: refine driver description

 drivers/net/ethernet/atheros/atl1c/atl1c.h         |    1 -
 drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c |    2 --
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |   13 ++++++-------
 3 files changed, 6 insertions(+), 10 deletions(-)

-- 
1.7.7

