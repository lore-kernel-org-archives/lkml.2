Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab1HIRdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 13:33:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41309 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab1HIRdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 13:33:19 -0400
Date: Tue, 9 Aug 2011 19:33:10 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Tim Sander <tim.sander@hbm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt7 - Error with low latency desktop config
Message-ID: <20110809173310.GB11398@pengutronix.de>
References: <1312465990.16729.22.camel@twins>
 <201108091548.06875.tim.sander@hbm.com>
 <20110809140923.GA11398@pengutronix.de>
 <201108091707.49832.tim.sander@hbm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201108091707.49832.tim.sander@hbm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On Tue, Aug 09, 2011 at 05:07:49PM +0200, Tim Sander wrote:
> Hi Uwe
> 
> I just double checked.
> > The config doesn't look like a 3.0-rt7 one. There is neither
> > 
> > 	PREEMPT_RTB=y
> > 
> > nor
> > 
> > 	# PREEMPT_RTB is not set
> If i switch the configs with "Kernel Feature"-> "Preemption Model" -
> >"(Preemtible Kernel) Low-Latency Desktop"
> there are no such config options visible even with a -rt7 kernel.
> (My workflow in ptxdist is
> comment (in/out) rtpatch in patches/linux-3.0/series
> ptxdist clean kernel && ptxdist targetinstall kernel
> deploy.sh
I think targetinstall should ask about the changed config items.

> Otherwise ptxdist would cheat on me and at 
> $(PROJECT_DIR)/configs/$(PLATFORM)/kernelconfig would be out of sync.)
check if ${PROJECT_DIR}/${PLATFORMNAME}/build/linux-3.0/ (or similar)
really has the rt patch applied. (e.g. is there a localversion-rt file?)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
