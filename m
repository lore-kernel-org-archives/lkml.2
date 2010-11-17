Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab0KQXyi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:54:38 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:9661 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab0KQXyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:54:37 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 0/2] of/phylib: Use device tree properties for PHY configuration.
Date: Wed, 17 Nov 2010 15:54:29 -0800
Message-Id: <1290038071-13296-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 17 Nov 2010 23:55:26.0613 (UTC) FILETIME=[E8143450:01CB86B2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is my first take at using the device tree to control PHY
configuration.  This first set enables some Marvell PHYs.  If the
scheme is deemed acceptable, I would probably do something similar for
Broadcom PHYs as well.

The first patch is the meat of the change.  The second adds support
for the 88E1149R PHY that I have on one of my boards.

David Daney (2):
  of/phylib: Use device tree properties to initialize Marvell PHYs.
  phylib: Add support for Marvell 88E1149R devices.

 drivers/net/phy/marvell.c   |  135 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/marvell_phy.h |    1 +
 2 files changed, 136 insertions(+), 0 deletions(-)

-- 
1.7.2.3

