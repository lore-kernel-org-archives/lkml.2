Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0LHKBw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 05:01:52 -0500
Received: from ist.d-labs.de ([213.239.218.44]:40566 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab0LHKBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 05:01:50 -0500
Date: Wed, 8 Dec 2010 11:00:58 +0100
From: Florian Mickler <florian@mickler.org>
To: Martin Steigerwald <Martin@lichtvoll.de>
Newsgroups: gmane.linux.kernel
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: bugs/regressions: report in LKML or in bugzilla?
Message-ID: <20101208110058.15ed7023@schatten.dmk.lab>
In-Reply-To: <201012072204.36581.Martin@lichtvoll.de>
References: <201012071639.58884.Martin@lichtvoll.de>
	<20101207094121.364745f9.randy.dunlap@oracle.com>
	<201012072204.36581.Martin@lichtvoll.de>
X-Newsreader: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010 22:04:30 +0100
Martin Steigerwald <Martin@lichtvoll.de> wrote:

> Am Dienstag 07 Dezember 2010 schrieb Randy Dunlap:
> > On Tue, 7 Dec 2010 16:39:46 +0100 Martin Steigerwald wrote:
> > > [Bug 23642] New: easycap driver fails to compile in 2.6.37-rc3
> > > https://bugzilla.kernel.org/show_bug.cgi?id=23642
> > 
> > That one has received attention.  I commented on it and I have posted
> > a patch that fixes that particular build problem.
> 
> Sorry, I somehow missed that reply. Thanks.

The Bugzilla system did have some hickups in the last months, but seems
stable now.  (knock wood)

 
> > Bugs that are posted to LKML usually are added to the kernel bugzilla
> > by one of the bugzilla maintainers.  They would also select the
> > component, so you could just try that route to see if it works better.
> 
> Or I create a Bugzilla to save bugzilla maintainers some work and post a 
> hint on the mailinglist, too?
> 
> Ciao,

Yes, this would be ok. If you do that, it might be useful to also post a
note in the bugzilla report with a reference to the mailinglist-thread
in case a solutions crops up via mail and somehow doesn't make it into
the bugzilla. That makes it easier to decide what to do with a left-over
bugreport 6 months from now. 

Regards,
Flo
