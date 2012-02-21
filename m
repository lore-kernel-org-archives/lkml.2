Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2BUK6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:58:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:28725 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab2BUK6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:58:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="127670397"
Date: Tue, 21 Feb 2012 11:58:29 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 0/4] AB8500 fixes and AB9540 support v2
Message-ID: <20120221105829.GS5387@sortiz-mobl>
References: <1329770508-9451-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329770508-9451-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Feb 20, 2012 at 09:41:48PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This fixes the comments from Maxime and Samuel:
> 
> - Isolate the fix in [1/4] so it can be pushed to the
>   rc series if desired.
> 
> - Remove pointless touching of board-mop500.c in [2/4]
> 
> - Rebased the rest for simplicity to apply.
Thanks, all 4 patches applied. And patch #1 applied to both my for-next and
for-linus branches.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
