Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab1BJSNj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:13:39 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:47744 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752012Ab1BJSNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:13:37 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18JgrhPOnAJih5hW52khTfIOMiGosyNWZyQ/NP20q
	wlJcRSIqtl/jCR
Subject: Re: [tip:perf/core] perf annotate: Fix annotate context lines
 regression
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        tzanussi@gmail.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20110210161537.GA20676@ghostprotocols.net>
References: <new-submission>
	 <tip-d5e3d747007fdb541e57ed72e020ff0b94db3470@git.kernel.org>
	 <1297224378.8035.7.camel@marge.simson.net>
	 <20110209164154.GA15607@ghostprotocols.net>
	 <1297309313.7996.11.camel@marge.simson.net>
	 <20110210121559.GA26094@elte.hu>
	 <1297341811.5512.36.camel@marge.simson.net>
	 <20110210161537.GA20676@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 19:13:29 +0100
Message-ID: <1297361609.5364.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 14:15 -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 10, 2011 at 01:43:31PM +0100, Mike Galbraith escreveu:
> > On Thu, 2011-02-10 at 13:15 +0100, Ingo Molnar wrote:
> > > * Mike Galbraith <efault@gmx.de> wrote:
> > > 
> > > > Initial impression: can I have a pony too? :)
> > > > 
> > > > I like this a lot, great for live rummaging.  One thing that would help with large 
> > > > files maybe - a jump to next spot hotter than N%, but as is is quite nice.
> 
> It already does that if you use TAB/shift-TAB, first one goes to the
> hottest line, next one to the 2nd place, etc, shift-TAB goes the other
> direction.

Cool, exactly what I was thinking.  Intuitive already built in, I just
didn't know it.

> There are some problems with that as on the first snapshot, just after
> parsing the sources, all lines have zero hits, I plan to fix that doing
> something like 'top' does, which is to wait a bit, say 2 seconds
> collecting samples, then show the annotation centered on the hottest
> line so far.

Rock on :)

	-Mike

