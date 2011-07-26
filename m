Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab1GZJNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:13:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35796 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1GZJNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:13:13 -0400
Date: Tue, 26 Jul 2011 11:13:10 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt3
Message-ID: <20110726091310.GP16561@pengutronix.de>
References: <alpine.LFD.2.02.1107241223560.2702@ionos>
 <4E2DF459.3030509@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4E2DF459.3030509@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 03:55:21PM -0700, Fernando Lopez-Lezcano wrote:
> On 07/24/2011 03:33 AM, Thomas Gleixner wrote:
> >Dear RT Folks,
> >
> >I'm pleased to announce the 3.0-rt3 release.
> 
> Thanks!!... testing on a dual core laptop, fedora 15, 32 bit:
> 
> [   32.169727] BUG: MAX_LOCKDEP_ENTRIES too low!
> [   32.169730] turning off the locking correctness validator.
> 
> (where do I change this?)
I'd guess you need to increase MAX_LOCKDEP_ENTRIES which is defined in
kernel/lockdep_internals.h.

BTW, I hit that, too.

Best regards
Uwe


-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
