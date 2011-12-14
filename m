Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab1LNDSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 22:18:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:53347 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab1LNDSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 22:18:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="86301861"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 0/3] fixes for ata port runtime pm support
Date: Wed, 14 Dec 2011 11:17:58 +0800
Message-Id: <1323832681-7177-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Here are some fixes for ata port runtime pm support.
Applied on top of libata tree.

Lin Ming (3):
      [SCSI] sd: fix runtime status check in sd_shutdown
      [SCSI]: runtime resume parent for child's system-resume
      ata: update ata port's runtime status during system resume

 drivers/ata/libata-core.c |   18 ++++++++++++++++--
 drivers/scsi/scsi_pm.c    |   11 ++++++++++-
 drivers/scsi/sd.c         |    7 ++++++-
 3 files changed, 32 insertions(+), 4 deletions(-)

Thanks,
Lin Ming

