Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0IBSTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 14:19:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22174 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab0IBSTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 14:19:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6093"; a="53178304"
Date: Thu, 2 Sep 2010 11:19:14 -0700
From: David Brown <davidb@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH 20/24] msm: MSM8X60 simulator board support
Message-ID: <20100902181914.GB2589@huya.qualcomm.com>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org>
 <1282712273-344-21-git-send-email-johlstei@codeaurora.org>
 <20100902111310.GY26319@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902111310.GY26319@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 12:13:10PM +0100, Russell King - ARM Linux wrote:

> > +config MACH_MSM8X60_SIM
> > +	depends on ARCH_MSM8X60
> > +	default n
> 
> All these 'default n' statements can be removed - n is the default anyway.

Isn't the behavior different, though?  If I do a 'make oldconfig'
after a kernel upgrade, new options that don't have defaults will stop
and prompt me, whereas ones with a listed default will just select the
default without asking.

I though the desire was to not have it stop and ask unless it really
was something that the user needed to make a decision about.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
