Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111Ab2IYWY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 18:24:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:33874 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab2IYWY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 18:24:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,486,1344236400"; 
   d="scan'208";a="226679386"
From: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH] MAINTAINERS: update Intel C600 SAS driver maintainers
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: lukasz.dorau@intel.com, maciej.patelczyk@intel.com,
        jeffrey.d.skirvin@intel.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Date: Tue, 25 Sep 2012 15:24:56 -0700
Message-ID: <20120925222456.26307.21809.stgit@djiang5-linux.ch.intel.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

 MAINTAINERS |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b17587d..162f602 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3552,11 +3552,12 @@ K:	\b(ABS|SYN)_MT_
 
 INTEL C600 SERIES SAS CONTROLLER DRIVER
 M:	Intel SCU Linux support <intel-linux-scu@intel.com>
+M:	Lukasz Dorau <lukasz.dorau@intel.com>
+M:	Maciej Patelczyk <maciej.patelczyk@intel.com>
 M:	Dave Jiang <dave.jiang@intel.com>
-M:	Ed Nadolski <edmund.nadolski@intel.com>
 L:	linux-scsi@vger.kernel.org
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git
-S:	Maintained
+T:	git git://git.code.sf.net/p/intel-sas/isci
+S:	Supported
 F:	drivers/scsi/isci/
 F:	firmware/isci/
 

