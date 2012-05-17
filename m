Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030554Ab2EQWmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:42:24 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39348 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030531Ab2EQWmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:42:11 -0400
Date: Fri, 18 May 2012 00:42:05 +0200
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>, Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH] ARM: mx35: add cpufreq support
Message-ID: <20120517224205.GA7021@mars>
References: <20120507141437.GA9636@lovely.krouter>
 <20120509072239.GG27341@pengutronix.de>
 <20120509075618.GA4412@lovely.krouter>
 <20120509081306.GK27341@pengutronix.de>
 <1337276960.4970.4.camel@lovely>
 <20120517182036.GK30400@pengutronix.de>
 <1337280058.4970.6.camel@lovely>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337280058.4970.6.camel@lovely>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 08:40:58PM +0200, Christoph Fritz wrote:
> On Thu, 2012-05-17 at 20:20 +0200, Sascha Hauer wrote:
> > On Thu, May 17, 2012 at 07:49:20PM +0200, Christoph Fritz wrote:
> 
> > > Is there already a version I can rebase the patch?
> > > 
> > > On your repo at git://git.pengutronix.de/git/imx/linux-2.6.git I can't
> > > find the new clock framework or even a work-in-progress version.
> > 
> > They are in linux-next now.

There changed a lot of stuff: Where should I register the function to
set/get the cpu frequency?

To get an idea of how it should be done, I looked at imx51: Is there
cpufreq-support still implemented/working?  I can see the
arch/arm/mach-imx/cpu_op-mx51.c but not its correlating
clk_cpu_set_rate function in arch/arm/mach-imx/clk-imx51-imx53.c.

 Thanks,
  -- Christoph
 
