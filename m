Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1I1IlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:41:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:42795 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab1I1IlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:41:06 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 28 Sep 2011 10:40:22 +0200
In-Reply-To: <1317164216.3112.711.camel@work-vm>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <1317119870.15383.29.camel@twins> <1317164216.3112.711.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317199222.5781.40.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 15:56 -0700, John Stultz wrote:
> 
> > IOW you should stop tasks from being runnable in the first place, once
> > you're in a situation where you've got random runnable processes you've
> > failed.
> 
> Consider your desktop. Consider servers. Are really ontop of every task
> and are sure its not inefficient, or doesn't have some edge case bug
> where it just flips out and chews cpu (I'm looking at you flashplayer!).
> The real world is filled with crap.

Yes, this is why I loathe to update to a new distro, there's bound to
new and improved *kit-daemon crap about which does random wakeups even
though you know you're not using any of it, and when you're trying to
uninstall that junk it thinks it needs to uninstall the world :-(

On servers you mostly can, and I mostly have, wiped all that stuff.

As for the Desktop, yes it is an unforgivable pile of shit. Even without
flash, I've got 4G of memory and I can't read email and browse the web
at the same time. Something is broken.

About Flash, just say no, its one of the things Apple did get right ;-)

> > Nothing the scheduler can do about that.
> 
> I disagree. Why are the inmates running the asylum? The scheduler
> decides what runs when and where. We're not at the mercy of bad
> applications, they're at the mercy of the scheduler. 

How the fuck does the scheduler know your bouncing cows crap really
shouldn't be running because the screen is off? There is absolutely
_NOTHING_ the scheduler can do about that.

The user said he wanted this app to run, the app is runnable, we run it.
That simple.

