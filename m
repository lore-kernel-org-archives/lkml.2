Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab0HCMCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 08:02:33 -0400
Received: from soto.provo.novell.com ([137.65.250.214]:58048 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab0HCMCb convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com:13:1>);
	Tue, 3 Aug 2010 08:02:31 -0400
X-Greylist: delayed 1209 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Aug 2010 08:02:31 EDT
Message-Id: <4C57C8580200005A0006E50B@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 03 Aug 2010 05:42:16 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Bjoern Brandenburg" <bbb@email.unc.edu>,
        "Peter Zijlstra" <peterz@infradead.org>
Cc: <bastoni@cs.unc.edu>, "Nicola Manica" <nicola.manica@disi.unitn.it>,
        "Luca Abeni" <lucabe72@email.it>,
        "Harald Gustafsson" <harald.gustafsson@ericsson.com>,
        "Song Yuan" <song.yuan@ericsson.com>,
        "Claudio Scordino" <claudio@evidence.eu.com>,
        "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
        "rostedt" <rostedt@goodmis.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Raistlin" <raistlin@linux.it>,
        "Giuseppe Lipari" <lipari@retis.sssup.it>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: periods and deadlines in SCHED_DEADLINE
References: <1278682707.6083.227.camel@Palantir>
 <1278685133.1900.201.camel@laptop>
 <51F8E441-58D7-45E1-B7A0-7A717EDF08B5@email.unc.edu>
 <1278745706.4390.2.camel@Palantir>
 <21AA2C13-8831-47A2-9464-28E84DBD72B0@email.unc.edu>
 <1280823360.1923.419.camel@laptop>
In-Reply-To: <1280823360.1923.419.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Peter, Steven, Thomas, et al. !

Its been a while.

>>> On 8/3/2010 at 04:16 AM, in message <1280823360.1923.419.camel@laptop>, Peter
Zijlstra <peterz@infradead.org> wrote: 

[snip]

>
> So we replace the global lock with cmpxchg like loops using 2 per-cpu
> locks. Our current SCHED_FIFO balancer does just this and is found to be
> a very good approximation of global-fifo (iirc there's one funny case,
> but I can't remember, maybe Steve or Gregory can remember the details).

The only thing I remember at the moment is that Steven and I found one last remaining bug in an extreme corner
case where priority order may be violated.  Sadly, I can no longer recall the exact specifics and would have to dig
into the code to remember.  The good news is I believe the issue is fixable.  Its just a matter of impl+test, which
neither of us ever seem to have found the time to properly dedicate.  Perhaps this will be the catalyst ;)

-Greg


