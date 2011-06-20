Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab1FTWSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 18:18:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42650 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756177Ab1FTWRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 18:17:39 -0400
X-Sasl-enc: QfUg5Lz+lFYvdclVw4ouf8Ae1WnA6gkGUk/GHrxsERIv 1308608256
Date: Mon, 20 Jun 2011 14:59:22 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [stable] [PATCH v2] msm: timer: compensate for timer shift in
 msm_read_timer_count
Message-ID: <20110620215922.GA21909@kroah.com>
References: <1308344138-2862-1-git-send-email-johlstei@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308344138-2862-1-git-send-email-johlstei@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 01:55:38PM -0700, Jeff Ohlstein wrote:
> Some msm targets have timers whose lower bits are unreliable. So, we
> present our timers as lower frequency than they actually are, and ignore
> the bottom 5 bits on such targets. This compensation was erroneously
> removed from the msm_read_timer_count function, so restore it.
> 
> This was broken by 94790ec25 "msm: timer: SMP timer support for msm".
> 
> Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>
> ---
>  arch/arm/mach-msm/timer.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
