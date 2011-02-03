Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab1BCXfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 18:35:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41467 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650Ab1BCXfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 18:35:20 -0500
Date: Thu, 3 Feb 2011 15:30:25 -0800
From: Greg KH <gregkh@suse.de>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] hvc_dcc cleanups and fixes
Message-ID: <20110203233025.GA7184@suse.de>
References: <1292649385-28771-1-git-send-email-sboyd@codeaurora.org>
 <1292875718-7980-1-git-send-email-sboyd@codeaurora.org>
 <20110203221742.GA4159@kroah.com>
 <4D4B37EB.7070401@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4B37EB.7070401@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 03:19:07PM -0800, Stephen Boyd wrote:
> > On Mon, Dec 20, 2010 at 12:08:35PM -0800, Stephen Boyd wrote:
> >> Here are the split patches.
> >>
> >> The first two patches cleanup and fix the hvc_dcc driver for my
> >> compiler. The final patch is more controversial, it removes the
> >> v6 and v7 differences in this driver.
> >>
> >> Stephen Boyd (3):
> >>   hvc_dcc: Fix bad code generation by marking assembly volatile
> >>   hvc_dcc: Simplify put_chars()/get_chars() loops
> >>   hvc_dcc: Simplify assembly for v6 and v7 ARM
> > 
> > Can you redo these against the linux-next tree as they don't apply
> > anymore and resend them so I can apply them?
> > 
> 
> Have you tried 'git am -3' on them? I assume it's the movement of the
> file that's causing the problem.
> 
> Either way, I'll resend and collect the acks in a bit.

thanks, that would be great.

greg k-h

