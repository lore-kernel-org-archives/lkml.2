Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab1IGTF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 15:05:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:37728 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab1IGTF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 15:05:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="45991879"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 8 Sep 2011 00:35:09 +0530
Subject: [GIT PULL] slave-dmaengine fixes
Thread-Topic: [GIT PULL] slave-dmaengine fixes
Thread-Index: AcxtkRCRNFr1UMEVRUifymBGhg7YEg==
Message-ID: <438BB0150E931F4B9CE701519A4463010871804A4D@bgsmsx502.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p87J5qNF022007

Hi Linus,

The following changes since commit
c6a389f123b9f68d605bb7e0f9b32ec1e3e14132 include fixing an OOPS and a
memory leak in ste_dma40 driver

are available in the git repository at:
  git://git.infradead.org/users/vkoul/slave-dma.git fixes

Per Forlin (4):
      dmaengine/ste_dma40: add missing kernel doc for pending_queue
      dmaengine/ste_dma40: remove duplicate call to d40_pool_lli_free().
      dmaengine/ste_dma40: fix Oops due to double free of client descriptor
      dmaengine/ste_dma40: fix memory leak due to prepared descriptors

 drivers/dma/ste_dma40.c |   42
+++++++++++++++++++++++++++++-------------
 1 files changed, 29 insertions(+), 13 deletions(-)

--
Thanks
~Vinod
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
