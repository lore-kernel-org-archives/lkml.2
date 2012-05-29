Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2E2NjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:39:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:55463 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab2E2NjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:39:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158216565"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com,
        devel@linuxdriverproject.org
Subject: misc: mei: fixes for 3.5
Date: Tue, 29 May 2012 16:39:08 +0300
Message-Id: <1338298752-15445-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
please consider this batch for queuing into 3.5
1. patch 2/4 bug in probe: visible only after merging with the trunk
2. patch 3/4 fixes kernel oops that was revealed when probe failed
3. patch 4/4 is regression fix and should be merged also to stable 3.4
4. patch 1/4 is a minor documentation fix 

 

[PATCH 1/4 V2] mei: mei.txt: minor grammar fixes
[PATCH 2/4] misc: mei: set IRQF_ONESHOT for msi
[PATCH 3/4] misc: mei: unregister misc device in pci_remove
[PATCH 4/4] misc: mei: fix stalled read
