Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422672Ab2JDPbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 11:31:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:25666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965609Ab2JDPbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 11:31:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,535,1344236400"; 
   d="scan'208";a="201570061"
Subject: RE: [PATCH] dma: tegra: fix interrupt name issue with apb dma.
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>, "djbw@fb.com" <djbw@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
In-Reply-To: <8D3F6266AEB6384E807C6FFC6FE195E30181BBF0@BGSMSX101.gar.corp.intel.com>
References: <1349284913-22350-1-git-send-email-ldewangan@nvidia.com>
	 <506CA5D8.1050201@wwwdotorg.org> <201210040816.35500.arnd@arndb.de>
	 <8D3F6266AEB6384E807C6FFC6FE195E30181BBF0@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Oct 2012 20:53:21 +0530
Message-ID: <1349364201.1648.46.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 08:26 +0000, Koul, Vinod wrote:
> > >
> > > (Dropping stable Cc; Olof/Arnd or Vinod, is it possible you could add
> > > that into the patch description when applying this?)
> > >
> > > Reported-by: Stephen Warren <swarren@nvidia.com>
> > > Acked-by: Stephen Warren <swarren@nvidia.com>
> > 
> > Should be no problem. If Vinod wants to pick it up:
> > 
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> Will do it later today... am travelling so slow on email :(
Done, applied ith Stephen's credits :) Thanks


-- 
~Vinod

