Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab1LPJB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 04:01:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:27690 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373Ab1LPJBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 04:01:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="102886125"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 0/3] dmaengine: intel_mid_dma: fixes
Date: Fri, 16 Dec 2011 11:01:37 +0200
Message-Id: <1324026100-3124-1-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.6.4
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Here are some minor fixes:

Adrian Hunter (2):
      dmaengine: intel_mid_dma: locking and freeing fixes
      dmaengine: intel_mid_dma: error path fix

Kristen Carlson Accardi (1):
      dmaengine: intel_mid_dma: remove legacy pm interface

 drivers/dma/intel_mid_dma.c      |   25 ++++++++++++++++++-------
 drivers/dma/intel_mid_dma_regs.h |    2 +-
 2 files changed, 19 insertions(+), 8 deletions(-)

Regards
Adrian
