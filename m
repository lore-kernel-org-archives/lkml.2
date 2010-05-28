Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab0E1On2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:43:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59705 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758181Ab0E1On1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:43:27 -0400
Date: Fri, 28 May 2010 11:43:09 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com, tzanussi@gmail.com,
       Arun Sharma <aruns@google.com>
Subject: Re: [PATCH] perf: make perf report -D print sampled CPU
Message-ID: <20100528144309.GR9874@ghostprotocols.net>
References: <4bff964c.e88cd80a.3106.7d31@mx.google.com>
 <20100528125728.GP9874@ghostprotocols.net>
 <AANLkTin33AdxO_yzRlZUTzoV9JtqaNqfYR2kXhOvke1P@mail.gmail.com>
 <20100528133709.GQ9874@ghostprotocols.net>
 <AANLkTimxlVIhN4NRYMTOmerX7mChalevmLunsZNuKVea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimxlVIhN4NRYMTOmerX7mChalevmLunsZNuKVea@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, May 28, 2010 at 03:44:31PM +0200, Stephane Eranian escreveu:
> On Fri, May 28, 2010 at 3:37 PM, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> > Em Fri, May 28, 2010 at 03:03:15PM +0200, Stephane Eranian escreveu:
> >> On Fri, May 28, 2010 at 2:57 PM, Arnaldo Carvalho de Melo
> >> <acme@infradead.org> wrote:
> >> > Em Fri, May 28, 2010 at 12:08:01PM +0200, Stephane Eranian escreveu:
> >> Fine. I think there needs to be some documenation explaining the structure
> >> of the line here. I had to dig into the code to understand it.
> >
> > Right, this so far is as ad-hoc as it can be :-)
> >
> > One idea that is in my TODO list is to generate some XML format people
> > say that oprofile produces and there is also some other format that a
> > valgrind tool uses that should be supported.

> I think for a lot of people what matter is that the format be easily parseable
> by Python/Perl scripts. XML may be fine too.

Agreed, I mentioned the existing formats because they may be good enough
and would allow us to take advantage of existing tools that process
them.
 
> > I also plan to have it in a spreadsheet TUI widget, allowing lots of
> > navigation gimmicks to help in debugging, like a popup that offers
> > the list of mmaps for the thread where the sample below the cursor
> > happened, etc.

> You may get tons of data. Not sure you could manage interactively.

Right, it wouldn't support all cases, but I'm working on new TUI widgets
that try hard not to create several layers of data structures to browse
the perf.data file, i.e. filtering shouldn't traverse all the entries,
just set variables that will be inspected when we move to a different
page, etc.

- Arnaldo
