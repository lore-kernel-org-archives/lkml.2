Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2DPOdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:33:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:1032 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512Ab2DPOdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:33:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="89574311"
Date: Mon, 16 Apr 2012 16:42:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: srinidhi.kasagar@stericsson.com, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd : dbx500 : fix compilation error
Message-ID: <20120416144213.GC24130@sortiz-mobl>
References: <1333382148-14137-1-git-send-email-daniel.lezcano@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333382148-14137-1-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Mon, Apr 02, 2012 at 05:55:48PM +0200, Daniel Lezcano wrote:
> The ux500 default config enables the db5500 and the db8500.
> The incoming cpuidle driver uses the 'prcmu_enable_wakeups'
> and the 'prcmu_set_power_state' functions but these ones
> are defined but not implemented for the db5500, leading to
> an unresolved symbol error at link time. In order to compile,
> we have to disable the db5500 support which is not acceptable
> for the default config.
> 
> I noticed there are also some other functions which are
> defined but not implemented.
> 
> This patch fix this by removing the functions definitions
> and move out of the config section the empty functions which
> are normally used when the DB550 config is disabled.
> Only the functions which are not implemented are concerned
> by this modification.
>
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Applied to my for-linus branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
