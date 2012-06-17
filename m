Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab2FQRyN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 13:54:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37691 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757700Ab2FQRyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 13:54:12 -0400
Date: Sun, 17 Jun 2012 18:54:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "ksummit-2012-discuss@lists.linux-foundation.org" 
	<ksummit-2012-discuss@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2012-discuss] [ATTEND] Discussion: role of the
 maintainer?
Message-ID: <20120617175406.GC10241@sirena.org.uk>
References: <1339875074.8267.87.camel@lade.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339875074.8267.87.camel@lade.trondhjem.org>
X-Cookie: "But I don't like Spam!!!!"
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 07:31:19PM +0000, Myklebust, Trond wrote:

> My question is whether or not there might be some value in splitting out
> some of these roles, so that we can assign them to different people, and
> thus help to address the scalability issues that Thomas raised? For
> instance, would it be useful to have a separate 'software maintainer'
> role for dealing with post-merge issues, such as ensuring that bugs and
> regressions get fixed by someone?

I mostly agree with Guenter's comments on this, I think that overall
it's much better to give people permission to do more (which naturally
takes off a bit of the load) and let things flow than to try anything
formal.

> If so, how do we ensure that people get credit for the roles that they
> assume? Should we perhaps add additional entries to the MAINTAINERS file
> for some of these responsibilities?

I do sometimes find myself wishing there were more postive things I
could do to say "X is doing an awesome job, you should pay attention to
them/do things like they do/whatever", doing that and saying things
directly to people is good but it's not as discoverable for new
contributors as it might be.  I'm all out of useful ideas for how to do
that, though.
