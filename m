Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab2FUCrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 22:47:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:36286 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757705Ab2FUCrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 22:47:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="168295961"
Subject: Re: [PATCHv2.1] dw_dmac: introduce dwc_chan_disable
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Viresh Kumar <viresh.linux@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <1340102792-7633-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <CAOh2x=k024nEQ3_K03YTFw+inWerB3N+Tjvwh8RiqYA4qSieOg@mail.gmail.com>
	 <1340102792-7633-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Jun 2012 08:09:47 +0530
Message-ID: <1340246387.1927.1660.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 13:46 +0300, Andy Shevchenko wrote:
> This piece of code is used often. Make it as a separate function.
> 
Applied, Thanks

-- 
~Vinod

