Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab0KSV7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:59:08 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13470 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757630Ab0KSV7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:59:03 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>, Cyril Chemparathy <cyril@ti.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 0/2] phylib: Cleanup marvell.c and add 88E1149R support.
Date: Fri, 19 Nov 2010 13:58:51 -0800
Message-Id: <1290203933-28251-1-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 19 Nov 2010 21:59:54.0049 (UTC) FILETIME=[18C66310:01CB8835]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second iteration of this patch.  I have split out the
device tree support from the first version to a different patch set.
The 88E1149R support is useful 'stand alone', so if it is acceptable,
it can be merged first.

The first patch is a small cleanup suggested by Cyril Chemparathy, the
second one adds basic 88E1149R support.

David Daney (2):
  phylib: Use common page register definition for Marvell PHYs.
  phylib: Add support for Marvell 88E1149R devices.

 drivers/net/phy/marvell.c   |   67 ++++++++++++++++++++++++++++++++++--------
 include/linux/marvell_phy.h |    1 +
 2 files changed, 55 insertions(+), 13 deletions(-)

Cc: Cyril Chemparathy <cyril@ti.com>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>
-- 
1.7.2.3

