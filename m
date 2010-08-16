Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab0HPP3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:29:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab0HPP3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:29:30 -0400
Date: Mon, 16 Aug 2010 12:29:14 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Don't use brace expansion.
Message-ID: <20100816152914.GC13095@ghostprotocols.net>
References: <20100816124101.1829415C039@msa104.auone-net.jp> <1281967761.17267.6.camel@thorin> <1281969043.1926.1469.camel@laptop> <1281970478.17267.12.camel@thorin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281970478.17267.12.camel@thorin>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Aug 16, 2010 at 04:54:38PM +0200, Bernd Petrovitsch escreveu:
> On Mon, 2010-08-16 at 16:30 +0200, Peter Zijlstra wrote:
> > On Mon, 2010-08-16 at 16:09 +0200, Bernd Petrovitsch wrote:
> > > > -$(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
> > > > -$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui/browsers,scripting-engines}/' 2> /dev/null)

> > > The other solution is to use standard-make features like in
> > > mkdir -p $(foreach d,ui/browsers scripting-engines,$(OUTPUT)util/$(d)/) 2> /dev/null

> > > Is there actually a specific reason for the 
> > > $(shell sh -c '...')
> > > around?
> > > It looks superflous.

> > I think the reason is is that nobody who touched that file really knew
> > make all that well. Your version looks fine to me.

> Ah, the reason is that they are not part of a rule but on the top-level
> (and thus always executed).

So it worked by luck! /me runs :-P

More seriously, so there is a reason for that to be like that and you're
not aware of any other shorter or more convenient way of achieving that
goal, right?

- Arnaldo
