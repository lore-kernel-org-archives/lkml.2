Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab2HOO7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:59:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34858 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab2HOO7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:59:48 -0400
Date: Wed, 15 Aug 2012 11:59:35 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf: Let O= makes handle relative paths
Message-ID: <20120815145935.GI2370@infradead.org>
References: <1344864055.6935.117.camel@gandalf.stny.rr.com>
 <20120813132438.GA18990@aftab.osrc.amd.com>
 <1344867782.6935.119.camel@gandalf.stny.rr.com>
 <20120813142909.GC18990@aftab.osrc.amd.com>
 <20120813180249.GB6840@infradead.org>
 <20120815102722.GB4640@aftab.osrc.amd.com>
 <20120815130634.GE2370@infradead.org>
 <20120815131806.GC4640@aftab.osrc.amd.com>
 <1345041485.31459.89.camel@twins>
 <20120815144255.GB15989@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120815144255.GB15989@aftab.osrc.amd.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 15, 2012 at 04:42:55PM +0200, Borislav Petkov escreveu:
> On Wed, Aug 15, 2012 at 04:38:05PM +0200, Peter Zijlstra wrote:
> > Because you're an idiot and made a typo ;-) Happens to me all the time.
> 
> I'm not an idiot - I'm perfection at its purest! :-)
> 
> > The regular kernel build doesn't create non-existent O= targets either
> > iirc.
> 
> Ok, I see. The kernel needs to protect itself against the people who
> wrote it :-).

Of course! Those are the ultimate kernel killers!

- Arnaldo
