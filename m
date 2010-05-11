Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660Ab0EKQAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:00:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:55861 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354Ab0EKQAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:00:11 -0400
Date: Tue, 11 May 2010 12:59:46 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu, Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>, perfmon2-devel@lists.sf.net
Subject: Re: [RFC] perf: perf record sets inherit by default
Message-ID: <20100511155946.GH19192@ghostprotocols.net>
References: <AANLkTinsEANHEicdjOaE6jwUa0bVqH5PBwuGQ3_L59hT@mail.gmail.com>
 <20100511150052.GE19192@ghostprotocols.net>
 <1273590800.1810.19.camel@laptop>
 <20100511155039.GF19192@ghostprotocols.net>
 <1273593131.1810.42.camel@laptop>
 <AANLkTin5a3ghAUzFiQFoWNA1g9v-yFFC7uwyJEQ3zzu0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin5a3ghAUzFiQFoWNA1g9v-yFFC7uwyJEQ3zzu0@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, May 11, 2010 at 05:55:44PM +0200, Stephane Eranian escreveu:
> On Tue, May 11, 2010 at 5:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2010-05-11 at 12:50 -0300, Arnaldo Carvalho de Melo wrote:
> >
> >> Nope, see above.
> >
> > Ah, -p/-t might make sense to default to inherit off indeed.
> >
> >
> I would rather think that -p would inherit but not -t.
> If I attach to a multi-threaded app with -p, I'd like all threads monitored.
> But if I use -t to point to a specific thread within a process, then most
> likely I care only about that thread.

Ok, so fine tuning of the inherit flag is needed, i.e. we need both a
--inherit and a --no-inherit, well, good thing is that I think that the
option parsing stuff we, erm, inherited from git does just that, lemme
check how it works in this case more precisely...

- Arnaldo
