Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1EKQGF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:06:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:35906 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997Ab1EKQFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:05:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,353,1301900400"; 
   d="scan'208";a="906292"
Date: Wed, 11 May 2011 16:41:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] Ux500 PRCMU into MFD and update deps
Message-ID: <20110511144119.GC23897@sortiz-mobl>
References: <1304687090-23401-1-git-send-email-linus.walleij@stericsson.com>
 <BANLkTikHwd-Nsoq9eVwf1jTfSAUiA59R5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikHwd-Nsoq9eVwf1jTfSAUiA59R5g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, May 11, 2011 at 02:39:03PM +0200, Linus Walleij wrote:
> 2011/5/6 Linus Walleij <linus.walleij@stericsson.com>:
> 
> > I will attempt to slim this down a bit, mainly the set is a
> > review point for the MFD maintainer to check out if the PRCMU
> > driver fits within MFD.
> 
> Sam will you be able to provide some feedback on this so I know
> whether I shall plan to polish it up for the 2.6.40 merge window or
> not? 
I quickly looked at this patchset, and I hope to be able to review it better
next week. But overall I think this fits into the MFD mapped registers model.
So please go ahead and prepare this stuff for the .40 merge window (I'd
appreciate to see the "slimming this down a bit" part, while I expect to come
back to you with some more comments by next week.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
