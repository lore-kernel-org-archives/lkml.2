Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab0FUMLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 08:11:17 -0400
Received: from THUNK.ORG ([69.25.196.29]:40129 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040Ab0FUMLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 08:11:15 -0400
Date: Mon, 21 Jun 2010 08:10:58 -0400
From: tytso@mit.edu
To: markgross@thegnar.org
Cc: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
Subject: Re: [RFC][PATCH] PM: Avoid losing wakeup events during suspend
Message-ID: <20100621121058.GF6199@thunk.org>
Mail-Followup-To: tytso@mit.edu, markgross@thegnar.org,
	Alan Stern <stern@rowland.harvard.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
	Neil Brown <neilb@suse.de>, mark gross <640e9920@gmail.com>
References: <201006202350.27143.rjw@sisk.pl>
 <Pine.LNX.4.44L0.1006202154260.29532-100000@netrider.rowland.org>
 <20100621061345.GF9735@gvim.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621061345.GF9735@gvim.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So where are we at this point?

Discussion had completely died down for a while, and it's picked up
again, but it's not clear to me that we're any closer to reaching
consensus.

There's been one proposal that we simply merge in a set of no-op
inline functions for suspend blockers, just so we can get let the
drivers go in (assuming that Greg K-H believes this is still a
problem), but with an automatical removal of N months (N to be
decided, say 9 or 12 or 18 months).

My concern is that if we do that, we will have simply kicked the ball
down the road for N months.  Another approach is to simply merge in
no-op functions and not leave any kind of deprecation schedule.
That's sort of an implicit admission of the fact that we may not reach
consensus on this issue.  Or we could simply ship the patches as-is to
Linus after he gets back from vacation and ask him for a thumbs up or
thumbs down vote, which might settle things once and for all.

How do we go forward from here?

					- Ted
