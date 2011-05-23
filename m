Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab1EWDZM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 23:25:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:43237 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab1EWDZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 23:25:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,254,1304319600"; 
   d="scan'208";a="2820044"
Date: Mon, 23 May 2011 05:25:04 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 00/13] Ux500 PRCMU into MFD v4
Message-ID: <20110523032503.GA22189@sortiz-mobl>
References: <1305967300-16337-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305967300-16337-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Sat, May 21, 2011 at 10:41:40AM +0200, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This is mainly a rebase to Torvald's HEAD to rid the merge
> conflict in drivers/cpufreq.
> 
> All but the last patch can be merged into Sam's MFD tree I
> believe, but ACKs from MFD work just as fine and I'll request
> pull.
I'd rather see this one going through your tree as it does contain many arch
related changes. Please add my ACK to the MFD parts.
Also, please cc me on your pull request so that I can fix the mfd_data from
patch #13 before sending my pull request.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
