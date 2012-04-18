Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab2DRFcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 01:32:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35957 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab2DRFcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 01:32:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6684"; a="182658276"
X-IronPort-AV: E=Sophos;i="4.75,438,1330934400"; 
   d="scan'208";a="120453654"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 00/12] atl1c: update hardware settings - v1
Date: Wed, 18 Apr 2012 13:32:24 +0800
Message-ID: <1334727156-6830-1-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This update contains a serial of patches, most of them are hardware
settings related. register definitions are refined (or removed if 
meaningless) for each patch.

This is the first serial patches, after reviewed/applied the second
serial will be out.

These patches have addressed all sparse and checkpatch warnings.

Following NICs are tested:
AR8131/AR8132/AR8151A/AR8152A/AR8152B
Test item includes:
build/install/uninstall/dhcp/ping/iperf/wol/reboot/etc.


xiong (12):
  atl1c: update author contact info & company/driver desciption
  atl1c: remove multiple-RX-Q code
  atl1c: remove HDS register
  atl1c: remove VPD register
  atl1c: remove SMB/CMB DMA related code
  atl1c: split 2 32bit registers of TPD to 4 16bit registers
  atl1c: remove code related to rxq 1/2/3
  atl1c: wrong register used to stop TXQ
  atl1c: correct wrong definition of REG_DMA_CTRL
  atl1c: remove dmaw_block
  atl1c: using fixed TXQ configuration for l2cb and l1c
  atl1c: restore max-read-request-size in Device Conrol Register

 drivers/net/ethernet/atheros/atl1c/atl1c.h         |   54 +---
 drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c |    7 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h      |  196 ++++-------
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  356 ++++++--------------
 4 files changed, 184 insertions(+), 429 deletions(-)

-- 
1.7.7

