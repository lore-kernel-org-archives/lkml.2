Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab1JJMhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:37:43 -0400
Received: from mga14.intel.com ([143.182.124.37]:35610 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333Ab1JJMhm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:37:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,517,1312182000"; 
   d="scan'208";a="24834064"
Date: Mon, 10 Oct 2011 14:40:53 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd/db8500-prcmu: convert panic() to pr_crit()
Message-ID: <20111010124053.GL3686@sortiz-mobl>
References: <1318244684-3049-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318244684-3049-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Oct 10, 2011 at 01:04:44PM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> panic() is too heavy for this, indeed the PRCMU is critical for
> the system but not to the point that we should stop everything,
> if we can still get a prompt or so.
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
