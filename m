Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab2AaKtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 05:49:05 -0500
Received: from mga01.intel.com ([192.55.52.88]:42805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab2AaKtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 05:49:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118484376"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 0/2] dmaengine: intel_mid_dma: minor fixes
Date: Tue, 31 Jan 2012 12:48:58 +0200
Message-Id: <1328006940-9101-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.6.4
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are 2 minor fixes for intel_mid_dma.


Adrian Hunter (2):
      dmaengine: intel_mid_dma: fix error status mask
      dmaengine: intel_mid_dma: move pm_runtime_put

 drivers/dma/intel_mid_dma.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


Regards
Adrian Hunter
