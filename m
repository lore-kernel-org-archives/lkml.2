Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab1EYPTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:19:44 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56756 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794Ab1EYPTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:19:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:date:from:to:cc:message-id:in-reply-to:references;
        b=NnKbKlTsIuCyu/Ca94xPqIn7KP3AwfJZW2shZzQ70qjYfSpYUtB2+QqO+cnWiYGHQc
         kRXGBTYvxNLb6U0BBx3SB4fnd24Z70V8EcGhf0ir1O4YLE+yj7Ug2XOQoCvXsq1WrOZt
         02HiJ2/dh+zI0bGH6scYtk2uIcRG//QWsVJFY=
Subject: Re: UNIX Compatibility
Date: Wed, 25 May 2011 15:17:35 +0000
From: Michael Witten <mfwitten@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>
Cc: Mike Galbraith <efault@gmx.de>, Richard Yao <ryao@ic.sunysb.edu>,
        linux-kernel@vger.kernel.org
Message-ID: <c943132c8c364f95a91e3cf81cb0f2bd-mfwitten@gmail.com>
In-Reply-To: <20110525143602.GE8476@thunk.org>
References: <BANLkTin4wu1HNDeo8Rv7iddM9KkgZdhfgA@mail.gmail.com>
            <A7E21A2F-4338-465D-933A-66B0C4D15BE1@mit.edu>
            <BANLkTi=q7tDVkahrnng7+BJhvxh=gx71ng@mail.gmail.com>
            <20110524181619.GC26055@thunk.org>
            <BANLkTi=QUS5WfAMWTw7vuEwuBOVHsww3mA@mail.gmail.com>
            <1306297108.4819.28.camel@marge.simson.net>
            <64e4614dda6f4558a68a314d7b5979b5-mfwitten@gmail.com>
            <20110525143602.GE8476@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 10:36:02 -0400, Ted Ts'o wrote:

>On Wed, May 25, 2011 at 02:20:09PM +0000, Michael Witten wrote:
>> 
>> Ted just got finished telling Richard that Richard thinks about tiny,
>> nit-picky, really stupid stuff on which only egg-headed paper pushers
>> waste time that they'll never get back.
>
> There are people who spend hours and hours worrying about the fact
> that if you try to unlink a directory, Linux will return EISDIR
> instead of EPERM.  They will kill forests of trees, and cause tons and
> tons of carbon dioxide to be released into the atmosphere travelling
> to distant meetings in Singapore, Zurich, Japan, etc., to debate
> standards that specify this kind of detail.  How much value does this
> really add to the Linux ecosystem?    What would you call these people?

These are largely strawmen arguments.

> Now that the people who tried to lobby governments and academic
> institutions (mostly in Europe) not to use Linux, all in the name of,
> "because it's not Unix" are largely in full retreat, the answer is,
> why, pretty much none.  This kind of requirement is largely gone in
> most procurement contracts.

While that's good for the Linux world, it's not necessarily good for the
software world; I guess you have to be in a tower to see further than than
the trees.

> And of course, the supreme irony is that if your OS is encumbered with
> AT&T copyrighted code, you can use the Unix trademark even if you are
> not conformant to the Single Unix Specification.  (There's an escape
> clause for AT&T derived-Unix systems, which are automatically "Unix"
> even if they fail the SUS.)

That sounds like the work of the hacker class (or some subclass). After
all, you KNOW the eggheads wouldn't approve.

> Given all of that, what _use_ is the Single Unix Specification at this
> point?  What's the _point_?
>
> And what name would you propose to call people who are worried about
> whether or not Linux is "Unix compatible" (whatever the hell that
> means)?  Especially when the rest of the world is worried about being
> "Linux compatible", and a huge amount of software is targetted first
> for Linux.

You've got the game of modern society wrong.

The winner is not the one who smashes the competition; the winner is the
one who best eases the lives of as many people as possible.

The point of such a specification is to provide a single, relatively stable
source of documentation for how a complex system works. It sucks to have
to wade through the Linux codebase, out-dated and incomplete `Documentation/',
and haphazard asortments of blogs, webpages, and mailing list archives just
to figure out WTF Linux is doing TODAY (and then having to perform the same
research on other systems, which is even more difficult when they are
proprietary).

> This idea that Linux needs to care about being "Unix compatible" keeps
> coming back from the grave, like some Buffy-the-vampire-slayer
> monster.  It's time to slay it.

What needs to die is the tyranny of the hackers.

Humans are capable of organizing themselves better than just acquiscing to
whomever is capable of imposing himself fastest.

Sincerely,
Michael Witten
