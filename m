Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1CKUM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:12:58 -0500
Received: from www.tglx.de ([62.245.132.106]:48245 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1CKUM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:12:56 -0500
Date: Fri, 11 Mar 2011 21:12:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, davidb@codeaurora.org,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Linus Walleij <linus.walleij@sterricsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Qualcomm PM8921 MFD v2 2/6] mfd: pm8xxx: Add irq support
In-Reply-To: <20110311195719.GX1760@opensource.wolfsonmicro.com>
Message-ID: <alpine.LFD.2.00.1103112100240.2787@localhost6.localdomain6>
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org> <1299564590-30116-3-git-send-email-adharmap@codeaurora.org> <alpine.LFD.2.00.1103081201520.2787@localhost6.localdomain6> <4D770E47.6050402@codeaurora.org>
 <alpine.LFD.2.00.1103101126100.2787@localhost6.localdomain6> <4D79A85D.8000301@codeaurora.org> <alpine.LFD.2.00.1103111853480.2787@localhost6.localdomain6> <4D7A71B9.9000306@codeaurora.org> <alpine.LFD.2.00.1103112020370.2787@localhost6.localdomain6>
 <20110311195719.GX1760@opensource.wolfsonmicro.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011, Mark Brown wrote:

> On Fri, Mar 11, 2011 at 08:43:08PM +0100, Thomas Gleixner wrote:
> 
> > Sigh, why insist people on working around core code instead of talking
> > to the responsible maintainers about their problem in the first place?
> 
> I don't know if it's the case here but with a lot of the people I speak
> to it's because they're used to working on proprietary OSs where there's
> no possibility of fixing the core and they haven't yet realised that
> this is a possibility.

Good point. If I only knew a way to get this message to those folks
once and forever.

There are several good reasons to avoid working around core code:

 - It's usually simpler and faster as the core code has all the
   necessary information. So that's even an argument which managers
   might understand.

 - Such workarounds, when not caught, tend to spread themself
   magically because driver writers checkout the existing code of
   similar devices and copy/paste/modify^Wuglify them over and over.

 - In the worst case such workarounds make the core maintainence
   harder and in some cases impossible, because they silently imply
   semantics on the core w/o the core maintainer knowing about them.

I'm going to give a talk about that at the collab summit :)

Thanks,

	tglx

