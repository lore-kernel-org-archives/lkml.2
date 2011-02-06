Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab1BFSD4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 13:03:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:55174 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1BFSDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 13:03:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,434,1291622400"; 
   d="scan'208";a="654942314"
From: Pierre Tardy <pierre.tardy@intel.com>
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Pierre Tardy <pierre.tardy@intel.com>
Subject: [PATCH v2 0/3] introduce mmc per device quirks
Date: Sun,  6 Feb 2011 19:03:45 +0100
Message-Id: <cover.1297014807.git.pierre.tardy@intel.com>
X-Mailer: git-send-email 1.7.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is the resend and cleanup of
the mmc per device quirks patchset.

User of the quirks is attached, which allows
clock gating framework to be used for specific sdio
card that are known to work.

Pierre Tardy (3):
  mmc: add per device quirk placeholder
  mmc: add MMC_QUIRK_BROKEN_CLK_GATING
  mmc: remove BROCKEN_CLK_GATING quirk for wl1271

 drivers/mmc/core/Makefile |    3 +-
 drivers/mmc/core/core.h   |    2 +
 drivers/mmc/core/host.c   |    5 +--
 drivers/mmc/core/quirks.c |   85 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/core/sdio.c   |    1 +
 include/linux/mmc/card.h  |    3 ++
 6 files changed, 94 insertions(+), 5 deletions(-)
 create mode 100644 drivers/mmc/core/quirks.c

-- 
1.7.2.3

---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

