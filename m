Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab2JBHz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 03:55:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:19572 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab2JBHz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 03:55:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,522,1344236400"; 
   d="scan'208";a="199512512"
Subject: Re: [PATCH] dw_dmac: fix a regression in dwc_prep_dma_memcpy
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: viresh.kumar@linaro.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1349085985-1128-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1349085985-1128-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Oct 2012 13:18:47 +0530
Message-ID: <1349164127.1648.40.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 13:06 +0300, Andy Shevchenko wrote:
> Sometimes memory-to-memory test is failed, that's why we need to choose minimum
> data portion between source and destination limits together.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Applied, thanks for taking care of this

-- 
~Vinod

