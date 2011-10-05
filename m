Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933292Ab1JEIYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:24:33 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36655 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab1JEIYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:24:31 -0400
Subject: Re: [Quilt-dev] [RFC][PATCH v2][QUILT] Add gpg signing to quilt mail
From: Andreas Gruenbacher <andreas.gruenbacher@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: quilt-dev@nongnu.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        John Kacur <jkacur@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 05 Oct 2011 10:23:49 +0200
In-Reply-To: <20111005065309.GA6676@suse.de>
References: <1317750395.18063.11.camel@gandalf.stny.rr.com>
	 <20111004180237.GA15087@suse.de>
	 <1317752148.18063.16.camel@gandalf.stny.rr.com>
	 <20111004182615.GA16224@suse.de>
	 <1317753468.18063.19.camel@gandalf.stny.rr.com>
	 <1317779312.1662.37.camel@schurl.linbit> <20111005065309.GA6676@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1317803067.1623.4.camel@schurl.linbit>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 23:53 -0700, Greg KH wrote:
> "now" meaning which version of quilt?  I still see this on 0.48 if that
> matters.

In the repository (master branch).

> > > > Oh, then there's the issue of quilt not handling ',' in a Signed-off-by
> > > > line as a valid email address name, but I've been living with that one
> > > > for years...
> > 
> > That's not even valid in email addresses.  The proper way would be to
> > double-quote the "display name" which probably contains the comma, but
> > then quilt's edmail script still won't understand it.  Is this a real
> > problem?
> 
> Yes, quoting is the correct thing to do, but that does not usually
> happen in "Signed-off-by:" lines in kernel patches.
> 
> Actually, I think this is even a problem when the name is quoted
> properly, I've had to fix that up in patches by hand.

Yes, proper quoting currently isn't enough.

> And yes, this is a problem, I run into at least 1-2 patches per stable
> kernel release with this issue.  I looked into fixing it and somehow the
> email parsing logic was wierd and I couldn't figure out how to resolve
> it.

Okay, I'll have another look ...

Andreas

