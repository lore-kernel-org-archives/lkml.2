Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab0JDKuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:50:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:40958 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab0JDKuB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:50:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,277,1283756400"; 
   d="scan'208";a="613061048"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>,
        "K V, Ramesh B" <ramesh.b.k.v@intel.com>,
        Yong Wang <yong.y.wang@linux.intel.com>
Date: Mon, 4 Oct 2010 16:18:36 +0530
Subject: [PATCH 0/6] intel_mid_dma updates
Thread-Topic: [PATCH 0/6] intel_mid_dma updates
Thread-Index: ActjsbI+Z1n8MTC0QJaqnZSyot3PCw==
Message-ID: <438BB0150E931F4B9CE701519A44630104B74BDBBC@bgsmsx502.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Please find attached 6 patches for intel_mid_dma driver, below gives brief 
summary of each patch

1/6: This adds runtime PM support in dma driver, this also adds the driver PCI 
suspend and resume

2/6 & 3/6: These two patches are from Yong Wang: These enable the irq to be 
Shared which is required on some platforms.

4/6: This adds sg list support in dma driver. This is enabled for only two of 4 
devices it supports due to hw support (rest of the two controller don't support 
this in hardware)
In order to support a circular link list approach which we use in our devices, 
we have added a flag DMA_PREP_CIRCULAR_LIST in dma driver header file.
If you agree to this we can move it to dmaengine header file, currently this 
patch adds this in driver header. I will send a new patch for that.

5/6: This is in WARN_ON fix you had request last time

6/6: Last patch moves the new driver to dma_slave_config structure, as agreed 
upon when you accepted last patchset

Thanks
Vinod Koul
Intel Corp.
