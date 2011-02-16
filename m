Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1BPIar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 03:30:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41256 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab1BPIap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 03:30:45 -0500
Date: Wed, 16 Feb 2011 09:30:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Dan Carpenter <error27@gmail.com>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Dhaval Giani <dhaval.giani@gmail.com>, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [114/115] sched: Remove  some dead code
Message-ID: <20110216083025.GB16529@elte.hu>
References: <20110216014741.GA24678@kroah.com>
 <20110216014705.654816731@clark.kroah.org>
 <20110216073701.GS4384@bicker>
 <1297843004.8874.1.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297843004.8874.1.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Wed, 2011-02-16 at 10:37 +0300, Dan Carpenter wrote:
> > On Tue, Feb 15, 2011 at 05:46:20PM -0800, Greg KH wrote:
> > > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > > 
> > > ------------------
> > > 
> > > 
> > > From: Dan Carpenter <error27@gmail.com>
> > > 
> > > commit 618765801ebc271fe0ba3eca99fcfd62a1f786e1 upstream.
> > > 
> > > This was left over from "7c9414385e sched: Remove USER_SCHED"
> > > 
> > > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > This is just a cleanup patch.  It doesn't really warrant backporting.
> 
> There's no reason to leave the dirt lying about though.

That's not the threshold for -stable backporting though.

A patch is eligible for -stable if and only if it's eligible for sending it to Linus 
via tip:sched/urgent as well: i.e. important bugfix or fresh regression.

Now, a cleanup patch might still be eligible to be sent to Linus if for some reason 
it's absolutely required for a fix - but in general we do not backport them.

The risk to -stable is obvious: instead of having a well-known .32 scheduler we have 
this morphing code that no-one has really tested in that form.

So while i dont mind the series you sent, please lets be *much* more careful with 
-stable backports in the future. Rule #1: if you ever have to ask yourself whether a 
patch is -stable eligible it probably isnt.

Thanks,

	Ingo
