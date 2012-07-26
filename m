Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab2GZGOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 02:14:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:27374 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266Ab2GZGOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 02:14:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="186508541"
Subject: Re: [PATCH] dw_dmac: use devm_* functions to simplify code
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, spear-devel@list.st.com,
        Viresh Kumar <viresh.linux@gmail.com>
In-Reply-To: <1343116855-6804-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1343116855-6804-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Jul 2012 11:45:07 +0530
Message-ID: <1343283307.1726.8935.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 11:00 +0300, Andy Shevchenko wrote:
> Use devm_kzalloc, devm_clk_get, devm_request_irq, and devm_request_and_ioremap
> to reduce the code and to simplify the error path.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Viresh Kumar <viresh.linux@gmail.com>
Applied thanks

-- 
~Vinod

