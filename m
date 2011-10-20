Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab1JTQou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 12:44:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:19144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab1JTQot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 12:44:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,380,1315206000"; 
   d="scan'208";a="75854802"
Date: Thu, 20 Oct 2011 18:48:17 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Virupax Sadashivpetimath 
	<virupax.sadashivpetimath@stericsson.com>,
        Philippe Langlais <philippe.langlais@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/4] mfd/ab8500-core: add interrupt disable hook
Message-ID: <20111020164817.GB3871@sortiz-mobl>
References: <1318322957-11435-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318322957-11435-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


On Tue, Oct 11, 2011 at 10:49:17AM +0200, Linus Walleij wrote:
> From: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
> 
> Add the missing interrupt disable hook in the irq_chip
> callbacks for ab8500.
> 
> Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
> Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
> Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
All 4 patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
