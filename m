Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124Ab1J2OKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 10:10:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:54363 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932565Ab1J2OKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 10:10:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="69202876"
Subject: RE: [PATCH v4] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <Barry.Song@csr.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        DL-SHA-WorkGroupLinux <Workgroup.Linux@csr.com>,
        Rongjun Ying <Rongjun.Ying@csr.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
In-Reply-To: <5EB3BFCD089AD643B9BB63439F5FD5E98419FAC0@SHAASIEXM01.ASIA.ROOT.PRI>
References: <1318907324-17046-1-git-send-email-Barry.Song@csr.com>
	 <1319703535.20054.30.camel@vkoul-udesk3>
	 <5EB3BFCD089AD643B9BB63439F5FD5E98419F7FF@SHAASIEXM01.ASIA.ROOT.PRI>
	 <1319774982.20054.228.camel@vkoul-udesk3>
	 <5EB3BFCD089AD643B9BB63439F5FD5E98419FAC0@SHAASIEXM01.ASIA.ROOT.PRI>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 Oct 2011 19:37:30 +0530
Message-ID: <1319897250.20054.232.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 08:08 +0000, Barry Song wrote:
> Vinod, as I have acked interleaved dma API explicitly before, could
> you pls add: 
> Acked-by: Barry Song <Baohua.Song@csr.com>
> in the commit of " DMAEngine: Define interleaved transfer request api"
> in your tree too. I didn't find it after I fetch your tree :-) 
Sorry I must have missed that.
Fixed now :)

-- 
~Vinod

