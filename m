Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671Ab1CDQK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:10:29 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48970 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758521Ab1CDQK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:10:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZPbOc+jYtMz3X4auKhPlg/pJuTtAp8zcugs4nsCkr2xlS9ogmGCO6Unt9TMUyvYp1G
         0lJnV62lZbm9fmXoVUpEkdgksK0xAl6aX6VGuessEVsD9HRnalOtlvy4XtzevQHHGkxx
         /aO2BwZFTdE3VOgYvucBrWF+1k9953fUlVsP0=
Date: Fri, 4 Mar 2011 17:10:18 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: linux-kernel@vger.kernel.org, richard.cochran@omicron.at,
        johnstul@us.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 2/3] ptp: add a software clock based on
 clock_monotonic_raw
Message-ID: <20110304161018.GA4527@riccoc20.at.omicron.at>
References: <1299173174-348-1-git-send-email-torbenh@gmx.de>
 <1299173174-348-3-git-send-email-torbenh@gmx.de>
 <20110304064251.GC3824@riccoc20.at.omicron.at>
 <20110304113032.GC3237@siel.b>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304113032.GC3237@siel.b>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 12:30:32PM +0100, torbenh wrote:
> On Fri, Mar 04, 2011 at 07:42:51AM +0100, Richard Cochran wrote:
> > 
> > Better yet, why not just use the V6 example instead?  If we are going
> > to have a testing driver, then I would want the simulated ancillary
> > code as well.
> 
> well... your example code messes with clock_realtime.

But could you take the file and replace the CLOCK_REALTIME code with
your SW implemented offset/frequency corrections?

And, just keep my code for simulating the ancillary stuff as is.

> i was planning to emit real timed events, not just some simulation.
> but i dont completely understand this part of the code yet.

??? (None of my PHC patches implement any user timers.)

I am not sure where you are going with the AVB clock idea, but it will
be fun to find out.

Thanks,

Richard

