Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab2B1IR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:17:28 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48682 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511Ab2B1IR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:17:27 -0500
Message-ID: <1330417040.2340.344.camel@work-vm>
Subject: Re: [PATCH 1/7] time: Condense timekeeper.xtime into xtime_sec
From: John Stultz <john.stultz@linaro.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Date: Tue, 28 Feb 2012 00:17:20 -0800
In-Reply-To: <20120228080647.GC21106@elte.hu>
References: <1330388974-27793-1-git-send-email-john.stultz@linaro.org>
	 <1330388974-27793-2-git-send-email-john.stultz@linaro.org>
	 <20120228080647.GC21106@elte.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022808-5112-0000-0000-000005ABC1CC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-28 at 09:06 +0100, Ingo Molnar wrote:
> * John Stultz <john.stultz@linaro.org> wrote:
> > +
> > +static void timekeeper_set_xtime(struct timekeeper *tk,
> > +					const struct timespec *ts)
> 
> Pointless (because ugly) line break.
> 
> > +{
> > +	tk->xtime_sec = ts->tv_sec;
> > +	tk->xtime_nsec = ts->tv_nsec << tk->shift;
> > +}
> > +
> > +
> > +static void timekeeper_xtime_add(struct timekeeper *tk,
> > +					const struct timespec *ts)
> 
> Pointless (because ugly) line break.

Ack on your other comments, but I'm not sure I'm following you here.
What would you rather see in this case?

(I know the 80col limit was discussed recently, but it didn't sound like
the consensus was for extending it.)

thanks
-john

