Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab2DNJ77 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 05:59:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6723 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2DNJ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 05:59:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6679"; a="181704064"
X-IronPort-AV: E=Sophos;i="4.75,420,1330934400"; 
   d="scan'208";a="196913607"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 00/12] atl1c: update hardware settings -v1
Date: Sat, 14 Apr 2012 17:59:16 +0800
Message-ID: <1334397568-8444-1-git-send-email-xiong@qca.qualcomm.com>
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

 drivers/net/ethernet/atheros/atl1c/atl1c.h         |   52 +---
 drivers/net/ethernet/atheros/atl1c/atl1c_ethtool.c |    1 -
 drivers/net/ethernet/atheros/atl1c/atl1c_hw.h      |  211 +++++-------
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c    |  358 ++++++--------------
 4 files changed, 198 insertions(+), 424 deletions(-)

-- 
1.7.7

