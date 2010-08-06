Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762099Ab0HFVsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 17:48:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:55166 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697Ab0HFVsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 17:48:36 -0400
Date: Fri, 6 Aug 2010 18:48:09 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "fweisbec@gmail.com" <fweisbec@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 7/9] perf: Export cpumap
Message-ID: <20100806214809.GE13780@ghostprotocols.net>
References: <1281104713-23141-1-git-send-email-bp@amd64.org>
 <1281104713-23141-8-git-send-email-bp@amd64.org>
 <20100806143912.GB13780@ghostprotocols.net>
 <20100806144939.GD21628@aftab>
 <20100806151413.GD13780@ghostprotocols.net>
 <20100806160441.GA3987@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100806160441.GA3987@kryptos.osrc.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Aug 06, 2010 at 06:04:41PM +0200, Borislav Petkov escreveu:
> From: Arnaldo Carvalho de Melo <acme@infradead.org>
> Date: Fri, Aug 06, 2010 at 12:14:13PM -0300
> 
> > > I'm afraid not since earlier patches in the series introduce the
> > > toplevel Makefile that glues all the different tools/lib/* parts
> > > together. However, I could extract the toplevel Makefile parts and
> > > cpumap.c and ctype.c if you really need it now - I've been doing this so
> > > often lately that I could do it with my eyes closed now :o).
> > 
> > :-)
> > 
> > We need to get back at merging that series, so some patch series
> > installments, with say, 3 or 4 patches each, would be great.
> 
> Yeah, I just want to wait first until all the churn on the kernel side
> settles and we have agreed on the perf_event.c part which would also
> determine what needs exporting on the userspace side.
> 
> But if you need stuff exported from perf/util/ for other tools too and
> if you tell me which ones, I could cook up something real soon...

I'll try to do what I once said I would, that is to have a
tools/samples/ (stuff exercising tools/ library interfaces) counterpart
to samples/ (stuff exercising kernel interfaces).

I'll use what you have already posted that applies, tools/Makefile,
trying to solve that -C isssue.

Will shoot for having this merged early next week to avoid breaking the
promise once more 8-)

- Arnaldo
