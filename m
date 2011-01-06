Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab1AFUFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:05:07 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:42836 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751423Ab1AFUFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:05:05 -0500
Date: Thu, 6 Jan 2011 21:04:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V7 7/8] ptp: Added a clock driver for the IXP46x.
Message-ID: <20110106200456.GB1521@ucw.cz>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <d2e0a5ac5eb51e9e4c7fcc94723b67c72c2f57c1.1292512461.git.richard.cochran@omicron.at>
 <20110102084505.GA3980@ucw.cz>
 <20110102091233.GA2847@riccoc20.at.omicron.at>
 <20110102092042.GA14165@ucw.cz>
 <20110103170732.GA3700@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110103170732.GA3700@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Given the comments -- does manual really use camelCase crap?
> > And... the identifiers actually combine camelCase with _. Better fix
> > it.
> 
> Thats the way Intel likes it:
> 
> http://download.intel.com/design/network/manuals/30626204.pdf

Ok... I'd say that it is so ugly that it should be replaced, but it is
not huge deal.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
