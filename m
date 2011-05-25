Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab1EYMNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 08:13:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:13423 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757001Ab1EYMNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 08:13:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,266,1304319600"; 
   d="scan'208";a="8442343"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dan <dan.j.williams@intel.com>, Per Forlin <per.forlin@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [PATCH v2 0/2] dmaengine: add slave documentation
Date: Wed, 25 May 2011 17:09:28 +0530
Message-Id: <1306323570-11133-1-git-send-email-vinod.koul@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

Version 2:
Added a TODO file for tracking future work
Merged the slave documentation updates to dmaengine.txt
Resolved commenst recieved on v1

Vinod Koul (2):
  dmaengine: Add API documentation for slave dma usage
  dmaengine: add TODO items for future work on dma drivers

 Documentation/dmaengine.txt |   97 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/dma/TODO            |   12 +++++
 2 files changed, 108 insertions(+), 1 deletions(-)
 create mode 100644 drivers/dma/TODO

