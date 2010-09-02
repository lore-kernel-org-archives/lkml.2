Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab0IBRNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 13:13:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:44277 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab0IBRNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 13:13:17 -0400
Date: Thu, 2 Sep 2010 18:12:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Subject: Re: [PATCH 14/24] msm: add hotplug stub functions
Message-ID: <20100902171253.GX26319@n2100.arm.linux.org.uk>
References: <1282712273-344-1-git-send-email-johlstei@codeaurora.org> <1282712273-344-15-git-send-email-johlstei@codeaurora.org> <20100902111157.GX26319@n2100.arm.linux.org.uk> <1283446177.3674.0.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283446177.3674.0.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 09:49:37AM -0700, Daniel Walker wrote:
> On Thu, 2010-09-02 at 12:11 +0100, Russell King - ARM Linux wrote:
> > On Tue, Aug 24, 2010 at 09:57:43PM -0700, Jeff Ohlstein wrote:
> > > From: Daniel Walker <dwalker@codeaurora.org>
> > > 
> > > We don't actually do anything for hotplug yet. This just lets
> > > everything compile, even when hotplug is enabled.
> > 
> > And the point of that is?  If you're not supporting hotplug CPU yet, then
> > don't allow it to be enabled.
> 
> How do we do that? I didn't see a easy way to prevent it.


config HOTPLUG_CPU
        bool "Support for hot-pluggable CPUs (EXPERIMENTAL)"
        depends on SMP && HOTPLUG && EXPERIMENTAL
+	depends on !ARCH_MSM
