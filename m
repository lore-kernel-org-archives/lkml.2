Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab0JROxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:53:44 -0400
Received: from thunk.org ([69.25.196.29]:43314 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598Ab0JROxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:53:43 -0400
Date: Mon, 18 Oct 2010 10:54:00 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Mike Frysinger <vapier@gentoo.org>, Peter Zijlstra <peterz@infradead.org>,
        Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: allow single space before labels
Message-ID: <20101018145400.GD4120@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Mike Frysinger <vapier@gentoo.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
	linux-kernel@vger.kernel.org
References: <1287302737-3507-1-git-send-email-vapier@gentoo.org>
 <1287303678.20968.37.camel@Joe-Laptop>
 <AANLkTimmSRS3eVsW4EZUxnE_rfjeqmmgGnjtWbn3J_nY@mail.gmail.com>
 <1287310889.1998.153.camel@laptop>
 <1287334498.20968.53.camel@Joe-Laptop>
 <1287343839.1998.699.camel@laptop>
 <AANLkTikaxf-Fh9qUxsXNO5=r+SoxbzYXvCjFcHQLcXjy@mail.gmail.com>
 <1287345710.1998.735.camel@laptop>
 <AANLkTimixEGQTYrM7ShodtKeC97e0uPNRhWQn8F+-Nui@mail.gmail.com>
 <20101018143935.GA4120@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018143935.GA4120@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:39:35AM -0400, Ted Ts'o wrote:
> On Sun, Oct 17, 2010 at 04:26:25PM -0400, Mike Frysinger wrote:
> > On Sun, Oct 17, 2010 at 16:01, Peter Zijlstra wrote:
> > > On Sun, 2010-10-17 at 15:49 -0400, Mike Frysinger wrote:
> > >> sounds like a good reason to shut up the new unintended warnings
> > >
> > > I'm failing to see any logic there, old code doesn't generate warnings,
> > > its new code that would, and new code should never have any whitespace
> > > in front of labels.
> > 
> > it's a waste of time to massage code to one person's opinion
> 
> +1
> 
> It's not in CondingStyle; I prefer to outdent labels by one tab stop:

Note that there is absolutely nothing about how labels should be
indented in CodingStyle at all, and I very much resist code
straightjackets being imposed by checkpatch.pl implementors.

Can we please stop this nonsense?

						- Ted

