Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab1LVGvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 01:51:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:2769 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751765Ab1LVGvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 01:51:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="49654445"
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>,
        James Bottomley <JBottomley@parallels.com>,
        Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH v3 0/3] fixes for ata port runtime pm support
Date: Thu, 22 Dec 2011 14:50:46 +0800
Message-Id: <1324536649-5796-1-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,

Here are the v3 fixes for ata port runtime pm support.

Could you consider applying these fixes?
Thanks.

Changes in v3:
- Add ata port hibernate callbacks

Changes in v2:
- Drop the patch "[SCSI] sd: fix runtime status check in sd_shutdown".
 It's no longer needed with commit fe6b91f(PM / Driver core: leave
 runtime PM enabled during system shutdown).
- Add Ack from Alan

v1: https://lkml.org/lkml/2011/12/13/443
v2: https://lkml.org/lkml/2011/12/14/516

Lin Ming (3):
      [SCSI]: runtime resume parent for child's system-resume
      ata: update ata port's runtime status during system resume
      ata: add ata port hibernate callbacks

 drivers/ata/libata-core.c |   58 ++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/scsi_pm.c    |   11 +++++++-
 2 files changed, 62 insertions(+), 7 deletions(-)

