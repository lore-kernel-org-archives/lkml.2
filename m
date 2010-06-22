Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753Ab0FVBH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 21:07:28 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:38191 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708Ab0FVBH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 21:07:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AVRMwaa/lD0f7uHq/f25XFhB1Yi7/3IdwRuQSH1sC2pfewHUhf/e4WQQZG9cYZ70oa
         k5EUMSXDMZwhNByw8eugOo4cDQ5IFFmTjR4YLmI3jDSrhZzotvX5R2x+GBa39AzUtJcm
         8xrA3uKJi0fUw1pKwBtpIbWfV7y4yr6LAC6lQ=
Date: Mon, 21 Jun 2010 18:07:04 -0700
From: mark gross <640e9920@gmail.com>
To: tytso@mit.edu, markgross@thegnar.org,
       Alan Stern <stern@rowland.harvard.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100622010704.GA12795@gvim.org>
Reply-To: markgross@thegnar.org
References: <201006202350.27143.rjw@sisk.pl>
 <Pine.LNX.4.44L0.1006202154260.29532-100000@netrider.rowland.org>
 <20100621061345.GF9735@gvim.org>
 <20100621121058.GF6199@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621121058.GF6199@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 08:10:58AM -0400, tytso@mit.edu wrote:
> So where are we at this point?

The patches are in James Bottomly's tree.
 
> Discussion had completely died down for a while, and it's picked up
> again, but it's not clear to me that we're any closer to reaching
> consensus.

I thought we (linux community and Android) where ok with the plist /
pm-qos implementation of the building blocks needed to implement the
suspend blocker feature on top of a pm-qos request class (I think the
name was "interactive")  pretty much the exact same symantecs as the
suspend blocker thing, just with pm-qos kernel api's.
 
> There's been one proposal that we simply merge in a set of no-op
> inline functions for suspend blockers, just so we can get let the
> drivers go in (assuming that Greg K-H believes this is still a
> problem), but with an automatical removal of N months (N to be
> decided, say 9 or 12 or 18 months).

I'd rather see the re-tooling of pmqos happen.

> 
> My concern is that if we do that, we will have simply kicked the ball
> down the road for N months.  Another approach is to simply merge in
> no-op functions and not leave any kind of deprecation schedule.
> That's sort of an implicit admission of the fact that we may not reach
> consensus on this issue.  Or we could simply ship the patches as-is to
> Linus after he gets back from vacation and ask him for a thumbs up or
> thumbs down vote, which might settle things once and for all.
> 
> How do we go forward from here?
> 
put the pm_qos -plist update into linux-next?

--mgross

