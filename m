Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751201Ab2LCRsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:48:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:45678 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab2LCRsf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:48:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,208,1355126400"; 
   d="scan'208";a="251182415"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: RE: [PATCH 3.7] dma: sh: Don't use ENODEV for failing slave lookup
Thread-Topic: [PATCH 3.7] dma: sh: Don't use ENODEV for failing slave lookup
Thread-Index: AQHNzTSY5gaIUQ8M4EuKC6A7xCfbk5gHYjiA
Date: Mon, 3 Dec 2012 17:48:27 +0000
Message-ID: <8D3F6266AEB6384E807C6FFC6FE195E302270D4C@BGSMSX101.gar.corp.intel.com>
References: <Pine.LNX.4.64.1211280740190.32652@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1211280740190.32652@axis700.grange>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> If dmaengine driver's .device_alloc_chan_resources() method returns -ENODEV,
> dma_request_channel() will decide, that the driver has been removed and will remove
> the device from its list. To prevent this use ENXIO if a slave lookup fails.
> 
> Reported-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Applied thanks, CCed stable as well

--
~Vinod
