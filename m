Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab1DANss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 09:48:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59857 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab1DANsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 09:48:47 -0400
Subject: Re: [RFC PATCH] perf report: add sort by file lines
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
In-Reply-To: <1301662934.2399.2.camel@localhost>
References: <1301391136.14111.98.camel@minggr.sh.intel.com>
	 <1301392457.4859.74.camel@twins> <1301417155.3620.8.camel@localhost>
	 <1301418183.2250.416.camel@laptop> <1301418404.2250.417.camel@laptop>
	 <1301418533.2250.419.camel@laptop>
	 <20110329174556.GC24129@ghostprotocols.net>  <4D92818A.8020405@hitachi.com>
	 <1301561155.14111.288.camel@minggr.sh.intel.com>
	 <1301580117.4859.286.camel@twins>  <1301582056.2271.15.camel@localhost>
	 <1301588922.2250.498.camel@laptop>  <1301589129.2250.499.camel@laptop>
	 <1301662934.2399.2.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 01 Apr 2011 15:48:14 +0200
Message-ID: <1301665694.4859.675.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 21:02 +0800, Lin Ming wrote:
> On Fri, 2011-04-01 at 00:32 +0800, Peter Zijlstra wrote:
> > On Thu, 2011-03-31 at 18:28 +0200, Peter Zijlstra wrote:
> > > 
> > > You could even first build the basic block tree and only follow those
> > > branches that end up covering the region IP is in.
> > 
> > s/tree/directed-graph/ clearly the basic blocks don't form a tree and
> > can contain cycles.
> 
> There may be multiple different paths from the beginning of the function
> to the point we are interested in.
> 
> Any idea how to handle this case?

Any one path should be sufficient I think, C doesn't really have dynamic
typing so whatever path leads you to where you need to be ought to be
type invariant.


