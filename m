Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1CFU0i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 15:26:38 -0500
Received: from mga11.intel.com ([192.55.52.93]:42671 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754200Ab1CFU0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 15:26:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,272,1297065600"; 
   d="scan'208";a="894375311"
Subject: Re: [PATCH] drivers, pch_dma: Fix warning when CONFIG_PM=n.
From: "Koul, Vinod" <vinod.koul@intel.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <AANLkTimPwqTnjNNZx6zVef6n=X00+G5dZSzp2aOSRp1b@mail.gmail.com>
References: <AANLkTimPwqTnjNNZx6zVef6n=X00+G5dZSzp2aOSRp1b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 01:28:29 +0530
Message-ID: <1299441509.6974.160.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-03-06 at 17:26 +0600, Rakib Mullick wrote:
> When CONFIG_PM=n, we get the following warning:
> 
> drivers/dma/pch_dma.c:741: warning: ‘pch_dma_suspend’ defined but not used
> drivers/dma/pch_dma.c:755: warning: ‘pch_dma_resume’ defined but not used
> 
> To fix it, wrap pch_dma_{suspend,resume} and
> pch_dma_{save,restore}_regs functions with CONFIG_PM.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
Applied, thanks

-- 
~Vinod

