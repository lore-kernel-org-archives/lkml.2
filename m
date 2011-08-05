Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab1HEJ3C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 05:29:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36239 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab1HEJ27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 05:28:59 -0400
Date: Fri, 5 Aug 2011 11:28:45 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [ANNOUNCE] 3.0-rt6
Message-ID: <20110805092845.GP31521@pengutronix.de>
References: <alpine.LFD.2.02.1107282213000.31246@ionos>
 <4E3A3D7C.6050403@localhost>
 <1312450965.16729.7.camel@twins>
 <4E3AED68.5060506@ccrma.stanford.edu>
 <20110804201500.GL31521@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110804201500.GL31521@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 10:15:00PM +0200, Uwe Kleine-König wrote:
> On Thu, Aug 04, 2011 at 12:05:12PM -0700, Fernando Lopez-Lezcano wrote:
> > Was going to try this but it appears it is in rt7, trying to build
> > rt7 fails with:
> > 
> > ERROR: "of_find_property" [drivers/tty/serial/of_serial.ko] undefined!
> > ERROR: "of_find_property" [drivers/hwmon/ltc4245.ko] undefined!
> This is known but unfixed, see
> http://mid.gmane.org/20110722065711.GD16561@pengutronix.de
> 
> You should be able to workaround that by jugling with the .config. I.e.
> disable OF or something like that.
Can you send me a .config, then I'd look into that.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
