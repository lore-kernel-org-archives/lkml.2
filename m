Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1CJPO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 10:14:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48690 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab1CJPO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:14:26 -0500
Date: Thu, 10 Mar 2011 15:13:55 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        David Collins <collinsd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@suse.de>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        Thomas Glexiner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Qualcomm PM8921 MFD v2 4/6] mfd: pm8xxx-mpp: Add pm8xxx MPP
	driver
Message-ID: <20110310151355.GD7411@sirena.org.uk>
References: <1299564590-30116-1-git-send-email-adharmap@codeaurora.org> <1299564590-30116-5-git-send-email-adharmap@codeaurora.org> <20110308233045.GB2717@opensource.wolfsonmicro.com> <4D784730.4010307@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D784730.4010307@codeaurora.org>
X-Cookie: QOTD:
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 07:36:16PM -0800, Abhijeet Dharmapurikar wrote:
> Mark Brown wrote:

>> It's seems really odd that you're adding gpiolib stuff here when you've
>> also got a separate gpiolib driver.  Possibly this all shouldn't
>> actually be split up as much as it is - there's also the issue with the
>> gpiolib driver needing to peer into the interrupt controller.  It might
>> simplify the code if things were merged more.

> I dont think merging code will help here. gpio lines and mpp lines are  
> very different piece of hardware,they have a different register map and  
> different config attributes. They do fall under the generic 'gpiolib'  
> umbrella, but it seems clean to keep them separate.

Oh, so the MFPs are completely separate pins to the GPIOs controlled by
the GPIO driver?  That's unusual - might be worth clarifying that
somehow.
