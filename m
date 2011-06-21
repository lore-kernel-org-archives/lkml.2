Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab1FUQ0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:26:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46997 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018Ab1FUQ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:26:06 -0400
X-Sasl-enc: K6cCnwMFxuqtYdAX0Zmteku1mQyyGk081G3ipZRyzWUo 1308673564
Date: Tue, 21 Jun 2011 09:24:27 -0700
From: Greg KH <greg@kroah.com>
To: David Brown <davidb@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        Jeff Ohlstein <johlstei@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>, stable@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [stable] [PATCH v2] msm: timer: compensate for timer shift in
 msm_read_timer_count
Message-ID: <20110621162427.GA28836@kroah.com>
References: <1308344138-2862-1-git-send-email-johlstei@codeaurora.org>
 <20110620215922.GA21909@kroah.com>
 <8ya7h8gozhn.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ya7h8gozhn.fsf@huya.qualcomm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 04:27:16PM -0700, David Brown wrote:
> On Mon, Jun 20 2011, Greg KH wrote:
> 
> > On Fri, Jun 17, 2011 at 01:55:38PM -0700, Jeff Ohlstein wrote:
> >> Some msm targets have timers whose lower bits are unreliable. So, we
> >> present our timers as lower frequency than they actually are, and ignore
> >> the bottom 5 bits on such targets. This compensation was erroneously
> >> removed from the msm_read_timer_count function, so restore it.
> >> 
> >> This was broken by 94790ec25 "msm: timer: SMP timer support for msm".
> >> 
> >> Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
> >> ---
> >>  arch/arm/mach-msm/timer.c |    6 +++++-
> >>  1 files changed, 5 insertions(+), 1 deletions(-)
> >> 
> >
> > <formletter>
> >
> > This is not the correct way to submit patches for inclusion in the
> > stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> > for how to do this properly.
> >
> > </formletter>
> 
> I don't think this patch was intended for stable in the first place.
> Jeff, this is a fix for 3.0-rcx, right?

Then why was it sent to stable@kernel.org?

confused,

greg k-h
