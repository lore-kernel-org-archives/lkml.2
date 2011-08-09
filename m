Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1HIOJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:09:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49879 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab1HIOJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:09:34 -0400
Date: Tue, 9 Aug 2011 16:09:23 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Tim Sander <tim.sander@hbm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt7 - Error with low latency desktop config
Message-ID: <20110809140923.GA11398@pengutronix.de>
References: <1312465990.16729.22.camel@twins>
 <201108091548.06875.tim.sander@hbm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201108091548.06875.tim.sander@hbm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 09, 2011 at 03:48:06PM +0200, Tim Sander wrote:
> Hi
> 
> When running a slightly patched 3.0-rt7 kernel  as a low latency desktop config 
> with the kconfig as attached i get appended error below. 
> 
> I'm not sure if you are interested in these errors but since you are aiming 
> for inclusion into mainline, i think these errors are also worthwhile?
> 
> Note this is not a vanilla 3.0-rt7 since that does not run on our hardware, 
> but tried to make sure that this error is not from my platform patches.
The config doesn't look like a 3.0-rt7 one. There is neither

	PREEMPT_RTB=y

nor

	# PREEMPT_RTB is not set

in it.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
