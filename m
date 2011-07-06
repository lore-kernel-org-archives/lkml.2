Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab1GFCqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 22:46:50 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54908 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755919Ab1GFCqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 22:46:49 -0400
X-Sasl-enc: boOuFFRipRpcVUE/NLIMQvpffAPRYDGjSqc1GOeArOKW 1309920408
Date: Tue, 5 Jul 2011 19:45:25 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Ohlstein <johlstei@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>, stable@kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [stable] [PATCH v2] msm: timer: compensate for timer shift in
 msm_read_timer_count
Message-ID: <20110706024525.GB24734@kroah.com>
References: <1308344138-2862-1-git-send-email-johlstei@codeaurora.org>
 <20110620215922.GA21909@kroah.com>
 <8ya7h8gozhn.fsf@huya.qualcomm.com>
 <20110621162427.GA28836@kroah.com>
 <4E1362DD.7030001@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1362DD.7030001@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 12:15:41PM -0700, Jeff Ohlstein wrote:
> Greg KH wrote:
> > On Mon, Jun 20, 2011 at 04:27:16PM -0700, David Brown wrote:
> >> I don't think this patch was intended for stable in the first place.
> >> Jeff, this is a fix for 3.0-rcx, right?
> > 
> > Then why was it sent to stable@kernel.org?
> > 
> > confused,
> > 
> > greg k-h
> > 
> 
> Sorry, this was indeed intended for stable. I will include the Cc: tag
> in future patches stable. However, since this was already picked up in
> Linus's tree, how should I proceed to get it into stable?

Take a look at Documentation/stable_kernel_rules.txt for how to do this
(hint, send the git commit id to stable@kernel.org and let us know what
kernels you want it applied to.)

greg k-h
