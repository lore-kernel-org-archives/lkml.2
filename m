Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1JYFAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 01:00:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63128 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab1JYFAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 01:00:08 -0400
Date: Tue, 25 Oct 2011 07:00:03 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@conan.davemloft.net>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        David Daney <ddaney@caviumnetworks.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 06/17] phy_driver: Add and use
 phy_driver_[un]register_multiple()
Message-ID: <20111025050003.GC798@ponder.secretlab.ca>
References: <1319144425-15547-1-git-send-email-Kyle.D.Moffett@boeing.com>
 <1319144425-15547-7-git-send-email-Kyle.D.Moffett@boeing.com>
 <201110201715.58441.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110201715.58441.vapier@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 05:15:54PM -0400, Mike Frysinger wrote:
> On Thursday 20 October 2011 17:00:13 Kyle Moffett wrote:
> > +	return phy_driver_register_multiple(bcm63xx_drivers,
> > +			ARRAY_SIZE(bcm63xx_drivers));
> 
> if only the arm ARRAY_AND_SIZE() macro could gain traction in the wider tree:
> 	return phy_driver_register_multiple(ARRAY_AND_SIZE(bcm63xx_drivers));

Propose a patch to move it from arch/arm to include/linux/kernel.h.
This is the first I've heard of this macro, but I would probably use
it.

> ignoring that, this patch looks cool
> 
> Acked-by: Mike Frysinger <vapier@gentoo.org>

Indeed, I like the diffstat.  :-)

Acked-by: Grant Likely <grant.likely@secretlab.ca>



