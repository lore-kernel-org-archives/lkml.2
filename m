Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532Ab2JDI0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:26:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:61192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964998Ab2JDI0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:26:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,533,1344236400"; 
   d="scan'208";a="200416757"
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Arnd Bergmann <arnd@arndb.de>, Stephen Warren <swarren@wwwdotorg.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>, "arm@kernel.org" <arm@kernel.org>,
        "djbw@fb.com" <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: RE: [PATCH] dma: tegra: fix interrupt name issue with apb dma.
Thread-Topic: [PATCH] dma: tegra: fix interrupt name issue with apb dma.
Thread-Index: AQHNoZAdgCE0+r/h/0am4nMWvFf8k5enswYAgAC+yYCAAF6yQA==
Date: Thu, 4 Oct 2012 08:26:31 +0000
Message-ID: <8D3F6266AEB6384E807C6FFC6FE195E30181BBF0@BGSMSX101.gar.corp.intel.com>
References: <1349284913-22350-1-git-send-email-ldewangan@nvidia.com>
 <506CA5D8.1050201@wwwdotorg.org> <201210040816.35500.arnd@arndb.de>
In-Reply-To: <201210040816.35500.arnd@arndb.de>
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

> >
> > (Dropping stable Cc; Olof/Arnd or Vinod, is it possible you could add
> > that into the patch description when applying this?)
> >
> > Reported-by: Stephen Warren <swarren@nvidia.com>
> > Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> Should be no problem. If Vinod wants to pick it up:
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
Will do it later today... am travelling so slow on email :(

--
~Vinod
