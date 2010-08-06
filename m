Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab0HFAob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:44:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43561 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389Ab0HFAo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:44:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Brian Swetland <swetland@google.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Fri, 6 Aug 2010 02:42:41 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
References: <20100801054816.GI2470@linux.vnet.ibm.com> <201008060141.46109.rjw@sisk.pl> <AANLkTin245wZsxeUh2HuONHqDNXFWpyzPsYv4PPuZYSb@mail.gmail.com>
In-Reply-To: <AANLkTin245wZsxeUh2HuONHqDNXFWpyzPsYv4PPuZYSb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008060242.41595.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 06, 2010, Brian Swetland wrote:
> 2010/8/5 Rafael J. Wysocki <rjw@sisk.pl>:
> >>
> >> Our wakelock stats currently have
> >> (name,)count,expire_count,wake_count,active_since,total_time,sleep_time,max_time
> >> and last_change. Not all of these are equally important (total_time is
> >> most important followed by active_since), but you only have count.
> >> Also as discussed before, many wakelocks/suspendblockers are not
> >> associated with a struct device.
> >
> > OK
> >
> > How much of that is used in practice and what for exactly?
> >
> > Do you _really_ have to debug the wakelocks in drivers that much?
> 
> Debugging power related issues is pretty critical to building
> competitive mobile devices.

Well, I don't think anyone will disagree with that.

> Throughout the several months of this discussion I have been
> continually scratching my head at this "debugability considered
> harmful" attitude that I see in reaction to our interest in having the
> ability (gated behind a config option even -- really, that'd be fine,
> not everyone need enable it) to gather useful stats and examine the
> state of the system.

The problem is what kind of stats would be actually sufficient and we haven't
seriously discussed that.  You said you'd need statistics and we took that for
granted, but we didn't really go into details here.

> At this point it sounds like there's no interest in the solution we
> have, which works and has worked for a few years, and has been revised
> 10+ times based on feedback here, and no interest in providing a
> solution that accomplishes similar functionality, so perhaps it's time
> for us to cut our losses and just go back to maintaining our patches
> instead of having the same arguments over and over again.

Please remember that I also have spent considerable amount of time trying to
push your solution upstream and defending it.  I might have spent that time
on other things instead, so please don't tell me about "losses".

If you want to stay in your ivory tower, that's perfectly fine by me, but
I guess that won't really benefit anyone in the long run.

Thanks,
Rafael
