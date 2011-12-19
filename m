Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab1LSLTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 06:19:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:13340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab1LSLTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 06:19:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="97855818"
Date: Mon, 19 Dec 2011 12:23:56 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] mfd/abx500: unify abx500 headers in mfd/abx500
Message-ID: <20111219112356.GF11800@sortiz-mobl>
References: <1322831793-25602-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322831793-25602-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Dec 02, 2011 at 02:16:33PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This moves all the header files related to the abx500 family into
> a common include directory below mfd. From now on we place any
> subchip header in that directory. Headers previously in e.g.
> <linux/mfd/ab8500/gpio.h> get prefixed and are now e.g.
> <linux/mfd/abx500/ab8500-gpio.h>. The top-level abstract interface
> remains in <linux/mfd/abx500.h>.
It looks good, I applied this one.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
