Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab1KDNHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 09:07:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:22928 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab1KDNHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 09:07:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,455,1315206000"; 
   d="scan'208";a="86115571"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>, Kukjin Kim <kgene.kim@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Fri, 4 Nov 2011 18:36:56 +0530
Subject: RE: arm-soc samsung patches blocked on dmaengine patches
Thread-Topic: arm-soc samsung patches blocked on dmaengine patches
Thread-Index: Acya8dkXhEbzRwLOT4CKmSFfW7NbWgAAC6uA
Message-ID: <438BB0150E931F4B9CE701519A446301087AA53D66@bgsmsx502.gar.corp.intel.com>
References: <201111041400.44486.arnd@arndb.de>
In-Reply-To: <201111041400.44486.arnd@arndb.de>
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

> Hi Vinod and Kukjin,
> 
> Right now, all the patches from the arm-soc tree are merged into 3.2, but the
> samsung/cleanup and samsung/devel series are missing because they depend on
> patches in the dmaengine tree. I'm not sure about the status of that tree,
> but I didn't see a pull request for them yet.
> 
> Should I just submit the samsung tree with the dmaengine patches included,
> or keep waiting?
> 
Arnd,

I have already sent pull request to Linus on Monday[1], still waiting for
these to get merged

--
~Vinod

[1]: http://comments.gmane.org/gmane.linux.kernel/1209052
