Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1BFSDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 13:03:10 -0500
Received: from mga01.intel.com ([192.55.52.88]:15601 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1BFSDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 13:03:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,434,1291622400"; 
   d="scan'208";a="884836420"
From: Pierre Tardy <pierre.tardy@intel.com>
To: linux-pm@lists.linux-foundation.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Pierre Tardy <pierre.tardy@intel.com>
Subject: [PATCH v2 0/3] sdhci runtime_pm implementation using mmc clock gating fw
Date: Sun,  6 Feb 2011 19:02:47 +0100
Message-Id: <cover.1297014479.git.pierre.tardy@intel.com>
X-Mailer: git-send-email 1.7.1
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please find a simple sdhci runtime_pm implementation
that uses clock gating fw as a tip to know when 
our chip is idle.

Previous version was RFC and untested,
This version has been tested on intel medfield platform.

Pierre Tardy (2):
  mmc: put the led blinking code after clock ungating
  sdhci:v2:use ios->clock to know when sdhci is idle

Yunpeng Gao (1):
  sdhci-pci : Enable runtime PM support

 drivers/mmc/core/core.c      |    3 +-
 drivers/mmc/host/sdhci-pci.c |  124 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci.c     |   60 ++++++++++++++++++++
 drivers/mmc/host/sdhci.h     |    5 ++
 include/linux/mmc/sdhci.h    |    1 +
 5 files changed, 191 insertions(+), 2 deletions(-)

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

