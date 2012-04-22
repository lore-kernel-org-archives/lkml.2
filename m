Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2DVUZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 16:25:10 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:58093 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752191Ab2DVUZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 16:25:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
Date: Sun, 22 Apr 2012 22:29:46 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Per Olofsson <pelle@debian.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204221347.52883.rjw@sisk.pl> <22aaaccf-5898-460c-b1e4-a87c153d9e0c@email.android.com>
In-Reply-To: <22aaaccf-5898-460c-b1e4-a87c153d9e0c@email.android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204222229.47160.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 22, 2012, Bojan Smojver wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> >On Sunday, April 22, 2012, Bojan Smojver wrote:
> >> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> >> 
> >> >On Wednesday, April 18, 2012, Bojan Smojver wrote:
> >> >> Per Olofsson <pelle@debian.org> wrote:
> >> >> 
> >> >> >OK, let's say Reviewed-by then.
> >> >> >
> >> >> >Reviewed-by: Per Olofsson <pelle@debian.org>
> >> >> >
> >> >> 
> >> >> Rafael,
> >> >> 
> >> >> Anything you still need here?
> >> >
> >> >No, thanks, I'm going to apply the patch.
> >> >
> >> >Rafael
> >> 
> >> Any chance of it in 3.3.3?
> >
> >Nope.
> >
> >> Looks like rc1 of it is already out there...
> >
> >I'm going to push it for v3.5, so it will only appear in 3.4.y I guess.
> >
> >Thanks,
> >Rafael
> 
> Don't understand why not. This is a fix for a regression in 3.2 and above.

Yes, in 3.2, so it is old enough.  If this were a regression in 3.3, I'd push
it for 3.4.

> Is there a new policy on regression fixes? I thought this should be queued
> for 3.4, 3.3 and 3.2. Otherwise, people will continue to see hangs in those
> versions.

Well, it was late for the 3.4 merge window and it wasn't clear whether or
not the patch was a regression fix at that time.  It is not very
straightforward and in my opinion it should be tested a bit wider before it
goes into -stable.

So as I said, v3.5 is the target with whatever -stable trees are relevant at
the time the patch is merged.

Thanks,
Rafael
