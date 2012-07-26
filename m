Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752646Ab2GZNHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:07:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:27248 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab2GZNHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:07:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="177820456"
Subject: Re: [PATCH] dma: imx-dma: Fix kernel crash due to missing clock
 conversion
From: Vinod Koul <vinod.koul@linux.intel.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <fabio.estevam@freescale.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        Fabio Estevam <festevam@gmail.com>
In-Reply-To: <CACKLOr0Q_S4Hh_=iCNSKQwTJhTs-KD5MVSGWzxaHcDghSq_YLw@mail.gmail.com>
References: <1341340409-9347-1-git-send-email-fabio.estevam@freescale.com>
	 <20120704070638.GI2698@pengutronix.de>
	 <CACKLOr0Q_S4Hh_=iCNSKQwTJhTs-KD5MVSGWzxaHcDghSq_YLw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Jul 2012 18:38:10 +0530
Message-ID: <1343308090.1726.9030.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 14:46 +0200, javier Martin wrote:
> Who is responsible of applying this patch?
> 
> It seems 3.5 has been released without it.
> 
The buck stops here :(

Sorry looks like this got missed while I was on vacation.

Now that 3.5 is released, I will CC stable and apply this to my fixes
and send to Linus for rc1. You should see this in -next once rc1 is
declared, if not please do yell.

-- 
~Vinod

