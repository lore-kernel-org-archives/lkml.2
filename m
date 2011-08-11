Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab1HKKVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:21:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60894 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab1HKKVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:21:50 -0400
Date: Thu, 11 Aug 2011 12:21:39 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Tim Sander <tim.sander@hbm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt7 - Error with low latency desktop config
Message-ID: <20110811102138.GC11398@pengutronix.de>
References: <1312465990.16729.22.camel@twins>
 <201108091707.49832.tim.sander@hbm.com>
 <20110809173310.GB11398@pengutronix.de>
 <201108101833.54661.tim.sander@hbm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201108101833.54661.tim.sander@hbm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 06:33:54PM +0200, Tim Sander wrote:
> Hi Uwe
> 
> I triple checked.
> > I think targetinstall should ask about the changed config items.
> It only asks one way, when going from an upatched kernel to an patched one.
> Since i was coming from an preempt rt kernel to an unpatched one no questions
> where asked (probably since all settings where still in place as i wasn't 
> using the preempt rt feature with the preempt rt patched kernel source
> aka "Low latency desktop")
I guess that when the kernel build updates .config your
${PROJECT_DIR}/config/${PLATFORMNAME}/kernelconfig isn't adapted
accordingly. So yes, it might be out of sync. So better provide
${PROJECT_DIR}/${PLATFORMNAME}/build/linux-3.0/.config please.
 
> But i think the regression when going from 3.0-rt7 to 3.0.1-rt8 with 
> CONFIG_PREEMPT_RTB is more worthwhile to discuss. Which i detailed in the 
> other mail.
You didn't talk about CONFIG_PREEMPT_RTB before, did you? I just used it
as indicator that the .config you sent isn't for an -rt kernel.

Your machine is based on Phytec's pcm043? I could try to test on one of
those an unpatched -rt kernel, but I don't promise to come around to do it.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
