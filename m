Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1BSUUL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 15:20:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45851 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab1BSUUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 15:20:09 -0500
Date: Sat, 19 Feb 2011 21:20:03 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Deadlock in gpiolib
Message-ID: <20110219202002.GN22310@pengutronix.de>
References: <20110218225407.GL22310@pengutronix.de>
 <alpine.LFD.2.00.1102190028400.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.1102190028400.2701@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On Sat, Feb 19, 2011 at 01:27:04AM +0100, Thomas Gleixner wrote:
> On Fri, 18 Feb 2011, Uwe Kleine-König wrote:
> > I tried to wrap my head around all that sysfs stuff and the implied
> > locking, but I failed.
> 
> You did not even think about providing the information about the
> already decoded problem and instead you post your findings as
> something completely new and unexplainable.
Sorry, really wasn't a very clever and thanks for providing the
necessary details.

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
