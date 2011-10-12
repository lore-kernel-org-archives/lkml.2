Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1JLQSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:18:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:60905 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752967Ab1JLQSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:18:17 -0400
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/5] intel: Logging cleanups
Date: Wed, 12 Oct 2011 09:18:05 -0700
Message-Id: <cover.1318436085.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just some conversions of printks to pr_<level>
and some trivial defect corrections.

Joe Perches (5):
  e1000e: Convert printks to pr_<level>
  ixgbevf: Convert printks to pr_<level>
  igbvf: Convert printks to pr_<level>
  igb: Convert printks to pr_<level>
  igb: Convert bare printk to pr_notice

 drivers/net/ethernet/intel/e1000e/netdev.c        |  232 +++++++++------------
 drivers/net/ethernet/intel/igb/e1000_82575.c      |    5 +-
 drivers/net/ethernet/intel/igb/igb_main.c         |  155 +++++++--------
 drivers/net/ethernet/intel/igbvf/netdev.c         |   14 +-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c      |    6 +-
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c |   26 ++--
 6 files changed, 201 insertions(+), 237 deletions(-)

-- 
1.7.6.405.gc1be0

