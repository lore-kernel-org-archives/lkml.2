Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011Ab0GJHUg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 03:20:36 -0400
Received: from mail0.unitn.it ([193.205.206.51]:56867 "EHLO mail0.unitn.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab0GJHUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 03:20:35 -0400
Subject: Re: periods and deadlines in SCHED_DEADLINE
From: Luca Abeni <lucabe72@email.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Raistlin <raistlin@linux.it>, linux-kernel <linux-kernel@vger.kernel.org>,
       Song Yuan <song.yuan@ericsson.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicola Manica <nicola.manica@disi.unitn.it>,
       Claudio Scordino <claudio@evidence.eu.com>,
       Harald Gustafsson <harald.gustafsson@ericsson.com>,
       Bjoern Brandenburg <bbb@email.unc.edu>, bastoni@cs.unc.edu,
       Giuseppe Lipari <lipari@retis.sssup.it>
In-Reply-To: <1278685470.1900.206.camel@laptop>
References: <1278682707.6083.227.camel@Palantir>
	 <1278685470.1900.206.camel@laptop>
Content-Type: text/plain
Date: Sat, 10 Jul 2010 09:11:47 +0200
Message-Id: <1278745907.5248.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 16:24 +0200, Peter Zijlstra wrote:
> On Fri, 2010-07-09 at 15:38 +0200, Raistlin wrote:
> > Basically, from the scheduling point of view, what it could happen is
> > that I'm still _NOT_ going to allow a task with runtime Q_i, deadline
> > D_i and period P_i to use more bandwidth than Q_i/P_i, I'm still using D
> > for scheduling but the passing of the simple in-kernel admission test
> > Sum_i(Q_i/P_i)<1 won't guarantee that the task will always finish its
> > jobs before D. 
> 
> But the tardiness would still be bounded, right? So its a valid Soft-RT
> model?
I think that if Sum_i(Q_i/P_i)<1 but Sum_i(Q_i/min{P_i,D_i})>=1 then you
can have sporadic deadline misses, but it should still be possible to
compute an upper bound for the tardiness.
But this is just a feeling, I have no proof... :)


				Luca

