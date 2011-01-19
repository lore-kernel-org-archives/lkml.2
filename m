Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1ASXcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 18:32:35 -0500
Received: from mail.perches.com ([173.55.12.10]:3208 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab1ASXcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 18:32:33 -0500
Subject: Re: [PATCH] vsprintf: Neaten %pK kptr_restrict, save a bit of code
 space
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110119151613.cfbd7bb3.akpm@linux-foundation.org>
References: <1294950072.4114.172.camel@Joe-Laptop>
	 <20110119145024.353ef8a1.akpm@linux-foundation.org>
	 <1295478662.1952.45.camel@Joe-Laptop>
	 <20110119151613.cfbd7bb3.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 15:32:32 -0800
Message-ID: <1295479952.1952.59.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-19 at 15:16 -0800, Andrew Morton wrote:
> On Wed, 19 Jan 2011 15:11:02 -0800
> Joe Perches <joe@perches.com> wrote:
> > On Wed, 2011-01-19 at 14:50 -0800, Andrew Morton wrote:
> > > On Thu, 13 Jan 2011 12:21:12 -0800
> > > Joe Perches <joe@perches.com> wrote:
> > > > If kptr restrictions are on, just set the passed pointer to NULL.
> > > > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> > []
> > > > +		if (!((kptr_restrict == 0) ||
> > > > +		      (kptr_restrict == 1 &&
> > > > +		       has_capability_noaudit(current, CAP_SYSLOG))))
> > > > +			ptr = NULL;
> > > > +		break;
> > > This hurts my brain.   Does it work?
> > Some say mentally challenging puzzles help deter/delay
> > onset of cognitive decline/Alzheimer's.  See: www.dakim.com
> That wasn't the bit which hurt.

Sure.

> You still haven't told me if it works.  How thoroughly was it tested?

Very lightly (x86 only).

It's a logic only change.

cheers, Joe

