Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2DNFox (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 01:44:53 -0400
Received: from 1wt.eu ([62.212.114.60]:65130 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828Ab2DNFov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 01:44:51 -0400
Date: Sat, 14 Apr 2012 07:44:01 +0200
From: Willy Tarreau <w@1wt.eu>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Adrian Chadd <adrian@freebsd.org>,
        Greg KH <gregkh@linuxfoundation.org>, Sergio Correia <lists@uece.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
Message-ID: <20120414054401.GC19802@1wt.eu>
References: <20120412144626.GA14868@kroah.com> <CAMP44s1T4EVwpzDuV_vV0Zh-5WcPCwdw9eeOfL17Geqp_UFN-Q@mail.gmail.com> <CAJ-VmonhwvnXPKa=LNOR4W0ZTXZqWmzw4UrsKLoE0YN_Bu0FzQ@mail.gmail.com> <CAMP44s2JPvhEB6Eb049Z_bToAFncHKMEheuyaxyhC=bnh2GJVg@mail.gmail.com> <20120413105746.10ffb120@stein> <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com> <20120413154216.476a02ac@stein> <CAMP44s10KVwL5pY=Q5hWfyUtU6CvvZZ4Bcg-fEY9dAhSL306aQ@mail.gmail.com> <20120413230525.GA13995@burratino> <CAMP44s0OdVBTwVtCoru-xvB=LVtO56jgku7X-0a7mUz1=iVCzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMP44s0OdVBTwVtCoru-xvB=LVtO56jgku7X-0a7mUz1=iVCzw@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 02:18:33AM +0300, Felipe Contreras wrote:
> On Sat, Apr 14, 2012 at 2:05 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> > Felipe Contreras wrote:
> >> On Fri, Apr 13, 2012 at 4:42 PM, Stefan Richter wrote:
> >
> >>> If you do not like to wait for Linus and Greg, you simply have to derive
> >>> an own kernel which additionally contains your preferred fixes.
> >>
> >> Yes, because clearly everybody thinks the process is perfect, and
> >> criticizing it is heresy.
> >
> > Close.  Not everyone.  For example, you do not think the process is
> > perfect.
> 
> So you think the process is *perfect*? I would have expected
> reasonable people to know that nothing is perfect, realize the
> sarcasm, and meditate for a second. But it seems expecting somebody to
> agree the process is not perfect is too much to ask.

Nobody has said it's perfect. Jonathan said it's "close" to perfect. I
personally think it's the best tradeoff we could find between a perfectly
stable branch and a perfect mainline. We manage to converge towards the
best quality in both branches by accepting a small delay in -stable.

The problem is that *you* don't accept to wait as soon as you know there's
a bug, and *you* don't want to make the necessary efforts to make things
move on. The process is clear and easy and has been explained to you several
times. If *you* want a fix, *you* just have to ask the fix's author to push
it to mainline and ask Greg to include it. There will always be a delay
between the moment a fix is written and the moment it boots on your host
anyway.

How would you have acted with 2.6.32 when there was this bug preventing
machines from living more than 208 days ? You think that just complaining
loudly that it's unacceptable to have this bug would have made things go
better ? Very few people were experiencing it and even fewer people were
able to understand it. Fortunately some users deployed a lot of efforts in
providing traces, configs, etc to narrow the bug down and it eventually got
fixed something like one year after the first report, thanks to everyone's
involvment. Linux is not only Linus or Greg's job, it's everyone's. You
have to take your part when you feel concerned about something. If you
don't want to participate, that's fine. Use a vendor's distro and file
a bug report, they'll do this job themselves and in the mean time they'll
probably provide you with the fix.

> > I don't think Stefan meant the above as tongue-in-cheek, for what it's
> > worth.  Another stable kernel with different rules really would be an
> > interesting exercise, and would probably fulfill a need for a certain
> > audience.

BTW this has been done a lot in the 2.4 era, by Alan, Andrew, Andrea, MCP,
myself. Yes it's interesting and useful. Experience shows that this ends
at one point because it requires a lot of work. And at this time there were
no such rules and it was very common to see that -ac or -aa kernels were
more stable than mainline for some workloads, which was a bit problematic,
especially when these kernels had to be rebased onto newer versions and
some patches had to be dropped at the risk of losing some stability fixes.

> > It's not like nobody does that already, anyway.  For example, I hear
> > Fedora has a kernel that they maintain well for a different audience,
> > using different rules.
> 
> Of course, although the difference with the stable kernel would be
> very small if the only thing added is an extra rule for acceptance:
> "It reverts an earlier patch to 'stable'."

Reverting patches that were not appropriate for -stable happens from
time to time, but only when the issue is specific to -stable (eg: build
issues). Here what you don't seem to understand is that the bug was
not specific to -stable but was present everywhere. So we had a bug
in mainline that we put in -stable, and we want mainline to be fixed
and we use -stable as a guarantee that mainline will be fixed. And it
works and has never failed yet. That's not hard to understand I think.

> But "we do this, and if you don't like it you can do whatever you
> want" is not a valid argument in favor of the status quo, even though
> it's used a lot in open source, and it's true, and there's nothing
> wrong with that... I yet have to see an answer to my arguments, and
> not a regurgitated answer for something nobody is proposing.

You've had many answers but you seem to selectively filter them. What you're
doing looks to me like "grep agree-with-me /dev/urandom && echo I was right".
Can take some time but it will eventually succeed. But please if you don't
want to listen to what people explain to you, at least stop polluting their
mailboxes with your looping arguments.

Willy

