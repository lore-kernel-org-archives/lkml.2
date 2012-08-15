Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2HOOiT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:38:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48765 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab2HOOiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:38:18 -0400
Message-ID: <1345041485.31459.89.camel@twins>
Subject: Re: [PATCH] perf: Let O= makes handle relative paths
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Wed, 15 Aug 2012 16:38:05 +0200
In-Reply-To: <20120815131806.GC4640@aftab.osrc.amd.com>
References: <1344864055.6935.117.camel@gandalf.stny.rr.com>
	 <20120813132438.GA18990@aftab.osrc.amd.com>
	 <1344867782.6935.119.camel@gandalf.stny.rr.com>
	 <20120813142909.GC18990@aftab.osrc.amd.com>
	 <20120813180249.GB6840@infradead.org>
	 <20120815102722.GB4640@aftab.osrc.amd.com>
	 <20120815130634.GE2370@infradead.org>
	 <20120815131806.GC4640@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-15 at 15:18 +0200, Borislav Petkov wrote:
> On Wed, Aug 15, 2012 at 10:06:34AM -0300, Arnaldo Carvalho de Melo wrote:
> > That was the case in the past, but IIRC PeterZ advocated not to and I
> > agreed.
> 
> Maybe you guys need to explain yourselves :) I mean, the dir is not
> present so we're not overwriting anything. And since we say "O=..." on
> the command line, it is actually expected that we really mean it... why
> type it, otherwise?

Because you're an idiot and made a typo ;-) Happens to me all the time.

The regular kernel build doesn't create non-existent O= targets either
iirc. 
