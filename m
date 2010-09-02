Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab0IBSxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:53:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58953 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756186Ab0IBSxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:53:15 -0400
Date: Thu, 2 Sep 2010 19:52:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brown <davidb@codeaurora.org>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH 20/24] msm: MSM8X60 simulator board support
Message-ID: <20100902185255.GA26319@n2100.arm.linux.org.uk>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org> <1282712273-344-21-git-send-email-johlstei@codeaurora.org> <20100902111310.GY26319@n2100.arm.linux.org.uk> <20100902181914.GB2589@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902181914.GB2589@huya.qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 11:19:14AM -0700, David Brown wrote:
> On Thu, Sep 02, 2010 at 12:13:10PM +0100, Russell King - ARM Linux wrote:
> 
> > > +config MACH_MSM8X60_SIM
> > > +	depends on ARCH_MSM8X60
> > > +	default n
> > 
> > All these 'default n' statements can be removed - n is the default anyway.
> 
> Isn't the behavior different, though?  If I do a 'make oldconfig'
> after a kernel upgrade, new options that don't have defaults will stop
> and prompt me, whereas ones with a listed default will just select the
> default without asking.

You always get asked about new options which have an option text - but
'default' sets what you get when you just hit 'enter' on them.
