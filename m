Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab0FAMwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:52:45 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:38729 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab0FAMwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:52:43 -0400
Date: Tue, 1 Jun 2010 08:44:40 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: tytso@mit.edu, Alex Buell <alex.buell@munted.org.uk>,
       Mailing Lists - Kernel Developers 
	<linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Article in Phoronix about loss of performance in 2.6.35
 release candidates
Message-ID: <20100601124440.GE8980@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>, tytso@mit.edu,
	Alex Buell <alex.buell@munted.org.uk>,
	Mailing Lists - Kernel Developers <linux-kernel@vger.kernel.org>,
	Eric Paris <eparis@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>
References: <1275347969.29006.5.camel@lithium.local.net>
 <20100601041028.GB4426@thunk.org>
 <AANLkTikRoff0zK-o8W4Wb_MveGibxlOG8mnrQMBtYZOY@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikRoff0zK-o8W4Wb_MveGibxlOG8mnrQMBtYZOY@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090203.4C050102.0050:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 01, 2010 at 08:00:39AM +0300, Pekka Enberg wrote:
> On Tue, Jun 1, 2010 at 7:10 AM,  <tytso@mit.edu> wrote:
> > On Tue, Jun 01, 2010 at 12:19:29AM +0100, Alex Buell wrote:
> >> http://www.phoronix.com/vr.php?view=14976
> >>
> >> Question: Why?
> >
> > One of the theories that has been advanced is that it's simply this
> > problem:
> >
> >        http://lkml.org/lkml/2010/5/22/154
> >
> > If so, it points out how idiotic Phoronix is about not being able to
> > notice udev pegging the CPU at 100% being someone bad for its
> > benchmark runs.  :-)
> >
> > OTOH, this bug has been known for over a week, and it is sort sad that
> > we haven't reverted this patch.  It looks like the conversation has
> > died, but without a fix?
> 
> It's fixed by 1eb2cbb6d5efe129 so the problem doesn't exist for 2.6.35-r1.

When I first read this email, I thought it meant the test was done
on rc1, but reading the article:

	To cut to the chase, between the 22nd and 24th of May there
	looks to be at least one commit (though perhaps multiple based
	upon the different data) within the Linus Torvalds 2.6 Git tree
	that are negatively affecting many different server/desktop
	benchmarks. We waited nearly a week to see if these regressions
	would be organically caught and addressed, but they have not
	been at least of the Linux 2.6 Git state as of 2010-05-26.

I'll give the udev fix a try w/the btrfs tests.

-chris

