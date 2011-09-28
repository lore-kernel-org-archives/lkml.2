Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab1I1BUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 21:20:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:40589 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab1I1BUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 21:20:09 -0400
Subject: Re: [PATCH 0/6] [RFC] Proposal for optimistic suspend idea.
From: John Stultz <john.stultz@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, lkml <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>,
        amit.kucheria@linaro.org, farrowg@sg.ibm.com,
        "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com
In-Reply-To: <alpine.LFD.2.02.1109280145150.2711@ionos>
References: <1317064434-1829-1-git-send-email-john.stultz@linaro.org>
	 <1317068164.1763.39.camel@twins> <1317076065.3112.539.camel@work-vm>
	 <alpine.LFD.2.02.1109280145150.2711@ionos>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Sep 2011 18:19:58 -0700
Message-ID: <1317172798.3112.742.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11092801-7282-0000-0000-000001E25EB8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 02:09 +0200, Thomas Gleixner wrote:
> On Mon, 26 Sep 2011, John Stultz wrote:
> > Another use case I've heard about are systems that have firmware updates
> 
> Yes, I have heard about people wanting O_PONIES ...

O_PONIES_WITH_HEADMOUNTED_WOODCUTTING_LASERS?

> > that are remotely triggered. Should the system go into suspend while the
> > firmware update is going on, you end up with a brick.
> 
> If someone came up with a firmware update mechanism which is not
> coping with unexpected interruption of any kind, then wakelocks are
> not making any difference.
> 
> Please collect the resulting bricks and shove them back to those who
> thought that remote firmware updates do not have to be engineered and
> the resulting fallout can be blamed on the kernel.
> 
> We have proper mechanisms in place to handle such stuff, but they need
> proper overall design and definitely a bit more brain usage than just
> yelling "wakelock".

And it would be great if some of that brain usage was spent to review
and critique what I'm actually proposing, rather then just yelling
"wakelock". :P

I apologize for being probably too verbose in my mails, but I did
originally admit that the firmware update issue is a simpler problem and
doesn't necessarily need the same solution as the races around my
nightly backups. But I do think that some thought should be put into the
different use cases that seem to desire similar things, so that an
appropriate design can be created, instead of a collection of short-term
hacks.

More brain usage, and proper design. At least with that, I think we
agree. :)

thanks
-john


