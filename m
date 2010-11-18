Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289Ab0KRWen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:34:43 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58584 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab0KRWem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:34:42 -0500
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
Date: Thu, 18 Nov 2010 23:33:46 +0100
User-Agent: KMail/1.9.10
Cc: Lennart Poettering <mzxreary@0pointer.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, david@lang.hm,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Vivek Goyal <vgoyal@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>
References: <1289916171.5169.117.camel@maggy.simson.net> <AANLkTimC_TWzKET-aabYK0TPG6fUUW06HDej6iOzYtKo@mail.gmail.com> <20101116211431.GA15211@tango.0pointer.de>
In-Reply-To: <20101116211431.GA15211@tango.0pointer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201011182333.48281.hpj@urpla.net>
X-Provags-ID: V02:K0:2kOaRpJGnAR76zE/ccFETiUfDxhXjDirzTSGPONZIi7
 mjMyFyZVG7wPafCmp/1xRDK4ZK46xuOYxMJr3UiKLdNhJdGb3z
 v/16GHynVHigg01iLum131RIdzuZWBH4Bc1Vg/jmXNN3qm+59j
 P/KMnzok2ojqo8sDlvfZwbvJ7zOFpAxeWawcHDlWBOKIC6PGc6
 m4Vd6dgVkBDQJE8ggvngIOzBjr7BHIjmtIxAFQ18yA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 November 2010, 22:14:31 Lennart Poettering wrote:
> On Tue, 16.11.10 12:38, Linus Torvalds (torvalds@linux-foundation.org) 
wrote:
> > On Tue, Nov 16, 2010 at 12:33 PM, Lennart Poettering
> >
> > <mzxreary@0pointer.de> wrote:
> > > No you don't. Because that is not a desktop use case.
> >
> > See my other response. You don't care AT ALL, because by your
> > judgement, all desktop is is a web browser and a word processor.
>
> Well, I do care. But I care more about *real* problems. For example
> the fact that "updatedb" makes your system sluggish while it runs. Or
> "man-db". Or anything else that runs from cron in the background.
>
> Doing this tty dance won't help you much with background tasks such
> as man-db, updatedb and cron and its jobs, will it? They don't have
> ttys. Sorry for you. meh! Meh! meh! meh! meh!
>
> (And along comes systemd, which actually handles this properly, since
> it actually has a proper notion of what a service is, and what a
> session is, and what an app is. And which hence can control all this
> sanely.)
>
> Binding this to a tty is just solves a tiny bit of the real problem:
> i.e. your own use of make -j. End of story.

Lennart, would you mind pointing me the the paragraph that states, 
autogroup excludes any other improvements in this area?

In contrary, Linus clearly states, that this solves a long standing use 
case, that _he_ is suffering from a lot, and I bet, most of us in one 
or another way.. And it contains all that is needed: a fine selection 
of knobs for switching on/off that beast. Hopefully it can be taught to 
reveal some of its internal mechanics to the world, then all is fine. 

If you think, that systemd can solve this and probably other aspects of 
responsiveness, go for it, compete with it, and _prove_ it with real 
facts and numbers, not just hand waving. 

As already mentioned countless times (and some of it was even renamed 
for this very fact): the grouping by tty is just a starter. There are 
plenty of other possibilities to group the scheduling. The hard part is 
to find the right grouping concepts, that are making sense in the 
usability department _and_ are easy enough to be picked up from our 
favorite system and desktop environments. That's where the generic 
cgroup concept seems to be lacking ATM..

In one year from now on, our preferred distros will show, who won this 
competition. Probably both of you ;-)

Pete
