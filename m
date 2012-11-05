Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535Ab2KEOmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:42:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217Ab2KEOmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:42:53 -0500
Date: Mon, 5 Nov 2012 15:41:22 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCHv2 03/25] perf tests: Add framework for automated
 perf_event_attr tests
Message-ID: <20121105144122.GA6206@krava.brq.redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
 <1351634526-1516-4-git-send-email-jolsa@redhat.com>
 <20121030230120.GA1067@krava.redhat.com>
 <20121031142600.GB28061@ghostprotocols.net>
 <20121031145247.GB1027@krava.brq.redhat.com>
 <87fw4s4ui7.fsf@sejong.aot.lge.com>
 <20121102104052.GC1157@krava.brq.redhat.com>
 <20121105142911.GC3911@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121105142911.GC3911@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 11:29:11AM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Nov 02, 2012 at 11:40:52AM +0100, Jiri Olsa escreveu:
> > On Fri, Nov 02, 2012 at 11:18:56AM +0900, Namhyung Kim wrote:
> > > > +            e = Event(section, parser_items, base_items)
> > > > +            events[section] = e
> > > 
> > > And this too. :)
> > 
> > ok, will try ;)
> 
> Can you provide patches on top of what is in perf/core now?

ok, jirka
