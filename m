Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab1ABJU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 04:20:59 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:54867 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751828Ab1ABJU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 04:20:57 -0500
Date: Sun, 2 Jan 2011 10:20:42 +0100
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
Message-ID: <20110102092042.GA14165@ucw.cz>
References: <cover.1292512461.git.richard.cochran@omicron.at>
 <d2e0a5ac5eb51e9e4c7fcc94723b67c72c2f57c1.1292512461.git.richard.cochran@omicron.at>
 <20110102084505.GA3980@ucw.cz>
 <20110102091233.GA2847@riccoc20.at.omicron.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110102091233.GA2847@riccoc20.at.omicron.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2011-01-02 10:12:33, Richard Cochran wrote:
> On Sun, Jan 02, 2011 at 09:45:05AM +0100, Pavel Machek wrote:
> > Hi!!
> > 
> > > +struct ixp46x_channel_ctl {
> > > +	u32 Ch_Control; /* 0x40 Time Synchronization Channel Control */
> > > +	u32 Ch_Event;   /* 0x44 Time Synchronization Channel Event */
> > > +	u32 TxSnapLo;   /* 0x48 Transmit Snapshot Low Register */
> > > +	u32 TxSnapHi;   /* 0x4C Transmit Snapshot High Register */
> > 
> > CouldWeGetRidOfCamelCase?
> 
> I agree that CamelCase is ugly and in bad taste. However, I make an
> exception when the register level programmer's manual uses this style.
> 
> IMHO, it is better to use the exact same mnemonics as in the
> manual. That way, when the next person comes along to make a change to

Given the comments -- does manual really use camelCase crap?
And... the identifiers actually combine camelCase with _. Better fix
it.
							Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
