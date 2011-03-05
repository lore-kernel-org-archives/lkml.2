Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab1CEUIN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 15:08:13 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:59320 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab1CEUIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 15:08:11 -0500
Subject: Re: [PATCH 2/3] ptp: add a software clock based on
 clock_monotonic_raw
From: john stultz <johnstul@us.ibm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: Torben Hohn <torbenh@gmx.de>, linux-kernel@vger.kernel.org,
        richard.cochran@omicron.at, tglx@linutronix.de
In-Reply-To: <20110304064639.GD3824@riccoc20.at.omicron.at>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
	 <1299173174-348-3-git-send-email-torbenh@gmx.de>
	 <1299180844.28285.111.camel@work-vm>
	 <20110304064639.GD3824@riccoc20.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 12:08:07 -0800
Message-ID: <1299355687.28285.130.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-03-04 at 07:46 +0100, Richard Cochran wrote:
> On Thu, Mar 03, 2011 at 11:34:04AM -0800, john stultz wrote:
> > On Thu, 2011-03-03 at 18:26 +0100, Torben Hohn wrote:
> > > First version of a software clock. Not very useful yet,
> > > as it doesnt generate events, but at least it allows
> > > for testing the ptp framework without special hardware.
> > 
> > So in the past, I pushed back on Richard for having something similar,
> > as I'm not psyched about duplicating interfaces. However, your
> > implementation is CLOCK_MONOTONIC_RAW instead of CLOCK_REALTIME and it
> > keeps the adjustments internal, I'm not as opposed.
> 
> (Aha! So it is okay after all ;)
> 
> I do think a software only PHC will make it easier for people to get
> started with the new interface. I have been carrying along such a
> patch privately for my own testing.

Consistency is but a hobgoblin... :)

But seriously, do forgive me if I misunderstood your earlier patches
with this respect. I thought it was just exporting CLOCK_REALTIME
directly through a new interface/clockid (which would be duplicative).

thanks
-john


