Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab1CDLNJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 06:13:09 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45399 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759340Ab1CDLNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 06:13:06 -0500
Date: Fri, 4 Mar 2011 11:12:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Collins <collinsd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Linus Walleij <linux.walleij@sterricsson.com>,
        Joe Perches <joe@perches.com>, Daniel Walker <dwalker@fifo99.com>,
        davidb@codeaurora.org, "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [Qualcomm PM8921 MFD 2/6] mfd: pm8xxx: Add irq support
Message-ID: <20110304111253.GA17653@sirena.org.uk>
References: <1299104001-5240-1-git-send-email-adharmap@codeaurora.org> <1299104001-5240-3-git-send-email-adharmap@codeaurora.org> <20110302224616.GB32325@opensource.wolfsonmicro.com> <4D6F1B2B.3090706@codeaurora.org> <20110303152242.GB32234@opensource.wolfsonmicro.com> <4D701C44.7090506@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D701C44.7090506@codeaurora.org>
X-Cookie: There are no games on this system.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 02:55:00PM -0800, Abhijeet Dharmapurikar wrote:
> Mark Brown wrote:

>> Could you deal with this with a library instead?

> Can you please clarify what a library means here?

You can share the code without creating a struct device, just have the
driver for each chip call into the common code.
