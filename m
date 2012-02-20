Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab2BTOy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:54:59 -0500
Received: from mga03.intel.com ([143.182.124.21]:28562 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab2BTOy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:54:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="68357107"
Date: Mon, 20 Feb 2012 16:02:07 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org,
        Mattias Nilsson <mattias.i.nilsson@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 0/8] DB8500 PRCMU update
Message-ID: <20120220150207.GU5387@sortiz-mobl>
References: <1326467986-11648-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326467986-11648-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Fri, Jan 13, 2012 at 04:19:46PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This is a set of updates to the DB8500 driver that mainly expand
> clock handling and tries to get a more clean approach to the
> various register access. This is targeted at next (v3.4) merge
> window, but we'd like to see it mature in linux-next as soon as
> possible so I'm sending it early.
So much for being early, sorry for taking me so long to look at those patches.
I applied the whole patchset now, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
