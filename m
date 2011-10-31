Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab1JaDZT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 23:25:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:9525 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918Ab1JaDZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 23:25:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="69184397"
Subject: Re: [PATCH v5] dmaengine: add CSR SiRFprimaII DMAC driver
From: Vinod Koul <vinod.koul@intel.com>
To: Barry Song <Barry.Song@csr.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jassi Brar <jaswinder.singh@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        Barry Song <Baohua.Song@csr.com>, linux-arm-kernel@lists.infradead.org
In-Reply-To: <1319768559-24200-1-git-send-email-Barry.Song@csr.com>
References: <1319768559-24200-1-git-send-email-Barry.Song@csr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Oct 2011 08:51:58 +0530
Message-ID: <1320031318.20054.234.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-27 at 19:22 -0700, Barry Song wrote:
> From: Rongjun Ying <Rongjun.Ying@csr.com>
> 
> Cc: Jassi Brar <jaswinder.singh@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Rongjun Ying <rongjun.ying@csr.com>
> Signed-off-by: Barry Song <Baohua.Song@csr.com>
> ---
>  -v5:
>  fix checkpatch issues;
>  fix compile warinings;
>  Note: This tree
>  git://gitorious.org/sirfprima2-kernel/sirfprima2-kernel.git prima2-dma-for-Vinod
>  merge both slave_dma interleaved branch and prima2 defconfig.
Applied thanks.
I will merge these after merging direction fixes.

-- 
~Vinod

