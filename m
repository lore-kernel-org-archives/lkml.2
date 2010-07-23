Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab0GWE2Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 00:28:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:42673 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835Ab0GWE2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 00:28:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,245,1278313200"; 
   d="scan'208";a="820845889"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.ml.walleij@gmail.com" <linus.ml.walleij@gmail.com>
CC: Alan Cox <alan@linux.intel.com>
Date: Fri, 23 Jul 2010 09:57:27 +0530
Subject: RE: Resend [PATCH] intel_mid: Add Mrst & Mfld DMA Drivers
Thread-Topic: Resend [PATCH] intel_mid: Add Mrst & Mfld DMA Drivers
Thread-Index: Acsoqq90mP7DpZeBRNKtPIU5n4V9QgBdGcsA
Message-ID: <438BB0150E931F4B9CE701519A44630104A39147D8@bgsmsx502.gar.corp.intel.com>
References: <1279699090-26032-1-git-send-email-vinod.koul@intel.com>
In-Reply-To: <1279699090-26032-1-git-send-email-vinod.koul@intel.com>
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

> Hello Dan,
> 
> The second rev of patch fixes the comments recieved last time.
> I have also cleaned up the driver and few more cosmetic changes
> 
> This patch add DMA drivers for DMA controllers in Langwell chipset
> of Intel(R) Moorestown platform and DMA controllers in Penwell of
> Intel(R) Medfield platfrom

Dan, 

Do you have any more comments on this patch. How do you want this to be
coordinated wrt DMA engine patch by Linus.

-Vinod
