Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0IJPAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 11:00:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:40722 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab0IJPAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 11:00:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,346,1280732400"; 
   d="scan'208";a="323182107"
Date: Fri, 10 Sep 2010 17:00:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] MFD: Align AB8500 with the abx500.h interface
Message-ID: <20100910150020.GG2561@sortiz-mobl>
References: <1282382428-10389-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282382428-10389-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sat, Aug 21, 2010 at 11:20:28AM +0200, Linus Walleij wrote:
> From: Mattias Wallin <mattias.wallin@stericsson.com>
> 
> This patch consolidates the ab8500 mixed signal chip to expose the
> same interface for register access as the ab3100, ab3550 and ab5500
> chips. The ab8500_read() and ab8500_write() are removed and replaced
> with abx500_get_register_interruptible() and
> abx500_set_register_interruptible() respectively.
> 
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
> This patch need be applied across the subsystems so as not to break
> bisection. Since it is mainly related to the core, the suggestion
> is to bring this in through Sam:s tree.
You're right here, sorry I didnt look at the patch carefully enough.
So this one below is ready to go except for the debugfs slip that Mark pointed
out. Would you mind spinning a new one for me ?

Cheers,
Samuel.

P.S.: And sorry for the delays, I was on holidays.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
