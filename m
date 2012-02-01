Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2BAMCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 07:02:36 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56777 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688Ab2BAMCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 07:02:34 -0500
Date: Wed, 1 Feb 2012 07:02:09 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 4/6] netprio_cgroup: use IS_ENABLED() and family
Message-ID: <20120201120209.GA12818@hmsreliant.think-freely.org>
References: <4F28E203.10502@cn.fujitsu.com>
 <20120201.015954.2098592611164231843.davem@davemloft.net>
 <4F28E48D.3040505@cn.fujitsu.com>
 <20120201.020738.1965865410881089752.davem@davemloft.net>
 <4F28E853.7000104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F28E853.7000104@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 03:22:59PM +0800, Li Zefan wrote:
> >>> Do not mix genuine bug fixes and cleanups.
> >>>
> >>> Otherwise I cannot apply your bug fixes to the 'net' tree.
> >>>
> >>> Seperate things out, submit only pure bug fixes first, then
> >>> later once those changes propagate you can submit the cleanups.
> >>>
> >>
> >> I did seperate them out, so the first three patches are fixes,
> >> and others are cleanups. I can resend cleanup patches once
> >> fixes hit mainline.
> > 
> > Seperate them in different groups, don't submit them as one
> > collection.  And definitely don't submit them all at the
> > same damn time!  You have to wait with the dependent cleanups
> > until the fixes go in, and subsequently show up in my net-next
> > tree.
> > 
> > I'm not applying this stuff until you submit it properly, in
> > two stages.
> > 
> 
> I'll do this when I get some comments/acks.
> 

The changes look fine to me.
I'll ack them once you submit them properly.
Thanks
Neil

