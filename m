Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab2HaLzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 07:55:49 -0400
Received: from hulk.biessmann.org ([62.75.166.25]:36323 "EHLO
	hulk.biessmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab2HaLzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 07:55:32 -0400
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
To: linux-kernel@vger.kernel.org
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-omap@vger.kernel.org,
        =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <andreas@biessmann.de>
Subject: [PATCH 0/2] fixes for omap2 nand driver
Date: Fri, 31 Aug 2012 13:35:40 +0200
Message-Id: <1346412942-4015-1-git-send-email-andreas@biessmann.de>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SPAM_bar: --
X-SPAM_score: -28
X-ChkData-Signature: 3f6bca98659a95ed08cd8d7b849a93b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches fixes the omap_nand_remove function to release all resources
properly and be able to re-load the driver later on.

Andreas Bießmann (2):
  mtd/nand/omap2: fix omap_nand_remove segfault
  mtd/nand/omap2: fix module loading

 drivers/mtd/nand/omap2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
1.7.10.4

